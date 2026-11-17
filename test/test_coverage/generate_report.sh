#!/usr/bin/env bash

THRESHOLD_ALL="${THRESHOLD_ALL:-80}"
THRESHOLD_NEW="${THRESHOLD_NEW:-90}"
THRESHOLD_MODIFIED="${THRESHOLD_MODIFIED:-0}"

STATUS_OK_SYMBOL=✅
STATUS_NOT_OK_SYMBOL=❌
PASS_SYMBOL=🟢
FAIL_SYMBOL=🔴

function luacov::repo_root {
  git rev-parse --show-toplevel
}

# Resolve luacov report file path.
# Looks for luacov.report.out in the coverage directory or repo root.
function luacov::resolve_report_file {
  local repo_root="${1:?}"

  local coverage_file="${repo_root}/coverage/luacov.report.out"
  if [[ -f "${coverage_file}" ]]; then
    echo "${coverage_file}"
    return 0
  fi

  coverage_file="${repo_root}/luacov.report.out"
  if [[ -f "${coverage_file}" ]]; then
    echo "${coverage_file}"
    return 0
  fi

  return 1
}

# Parse the luacov summary section and extract overall totals.
# Output format: total_lines covered_lines percent_covered
function luacov::parse_summary {
  local report_file="${1:?}"

  awk '
    /^-+$/ { separator_count++ }
    separator_count == 2 && /^Total/ {
      # Total line format: Total  <hits>  <missed>  <coverage>%
      # The luacov summary table has two dash rules: one under the File
      # header, one above the Total line.
      hits = $2
      missed = $3
      gsub(/%/, "", $4)
      coverage = $4
      total = hits + missed
      print total, hits, coverage
    }
  ' "${report_file}"
}

# Parse per-file coverage from the luacov summary section.
# Output format: file_path total_lines covered_lines percent_covered
function luacov::parse_files {
  local report_file="${1:?}"

  awk '
    /^-+$/ { separator_count++ }
    separator_count == 1 && !/^-/ && !/^File/ && !/^Total/ && NF >= 4 {
      # File rows sit between the two dash rules of the luacov summary
      # table: under the File header, above the Total line.
      file = $1
      hits = $2
      missed = $3
      gsub(/%/, "", $4)
      coverage = $4
      total = hits + missed
      print file, total, hits, coverage
    }
  ' "${report_file}"
}

function luacov::get_overall_status {
  local report_file="${1:?}"
  local threshold="${2:-${THRESHOLD_ALL}}"

  local summary
  summary="$(luacov::parse_summary "${report_file}")"

  if [[ -z "${summary}" ]]; then
    echo "${STATUS_NOT_OK_SYMBOL}"
    return
  fi

  local percent_covered
  percent_covered="$(echo "${summary}" | awk '{print $3}')"

  if (( $(echo "${percent_covered} >= ${threshold}" | bc -l) )); then
    echo "${STATUS_OK_SYMBOL}"
  else
    echo "${STATUS_NOT_OK_SYMBOL}"
  fi
}

function luacov::get_overall_report {
  local report_file="${1:?}"
  local threshold="${2:-${THRESHOLD_ALL}}"

  local summary
  summary="$(luacov::parse_summary "${report_file}")"

  if [[ -z "${summary}" ]]; then
    echo "No coverage data available."
    return
  fi

  local total_lines covered_lines percent_covered status_symbol
  total_lines="$(echo "${summary}" | awk '{print $1}')"
  covered_lines="$(echo "${summary}" | awk '{print $2}')"
  percent_covered="$(echo "${summary}" | awk '{print $3}')"

  if (( $(echo "${percent_covered} >= ${threshold}" | bc -l) )); then
    status_symbol="${PASS_SYMBOL}"
  else
    status_symbol="${FAIL_SYMBOL}"
  fi

  cat <<EOF
| Lines | Covered | Coverage | Threshold | Status |
| :---: | :-----: | :------: | :-------: | :----: |
| ${total_lines} | ${covered_lines} | ${percent_covered}% | ${threshold}% | ${status_symbol} |
EOF
}

function luacov::get_files_report {
  local report_file="${1:?}"
  local threshold="${2:?}"
  shift 2
  local files=("$@")

  if [[ ${#files[@]} -eq 0 ]]; then
    return 1
  fi

  local repo_root
  repo_root="$(luacov::repo_root)"

  local found=false
  local output=""

  while IFS=' ' read -r file total_lines covered_lines percent_covered; do
    # Normalize file path relative to repo root
    local relative_file="${file#"${repo_root}"/}"

    for filter_file in "${files[@]}"; do
      if [[ "${relative_file}" == "${filter_file}" || "${file}" == *"${filter_file}"* ]]; then
        local status_symbol
        if (( $(echo "${percent_covered} >= ${threshold}" | bc -l) )); then
          status_symbol="${PASS_SYMBOL}"
        else
          status_symbol="${FAIL_SYMBOL}"
        fi

        output+="| ${relative_file} | ${total_lines} | ${covered_lines} | ${percent_covered}% | ${threshold}% | ${status_symbol} |"$'\n'
        found=true
        break
      fi
    done
  done < <(luacov::parse_files "${report_file}")

  if [[ "${found}" == true ]]; then
    cat <<EOF
| File | Lines | Covered | Coverage | Threshold | Status |
| :--- | :---: | :-----: | :------: | :-------: | :----: |
EOF
    printf '%s' "${output}"
    return 0
  fi

  return 1
}

function luacov::get_new_files_report {
  local base_sha="${1:?}"
  local head_sha="${2:?}"
  local report_file="${3:?}"
  local threshold="${4:-${THRESHOLD_NEW}}"

  local file
  local new_files=()

  while IFS='' read -r file; do
    new_files+=("${file}")
  done < <(git diff --name-only --diff-filter=A "${base_sha}" "${head_sha}")

  luacov::get_files_report "${report_file}" "${threshold}" "${new_files[@]}" \
    || echo 'No new covered files...'
}

function luacov::get_modified_files_report {
  local base_sha="${1:?}"
  local head_sha="${2:?}"
  local report_file="${3:?}"
  local threshold="${4:-${THRESHOLD_MODIFIED}}"

  local file
  local modified_files=()

  while IFS='' read -r file; do
    modified_files+=("${file}")
  done < <(git diff --name-only --diff-filter=CMRT "${base_sha}" "${head_sha}")

  luacov::get_files_report "${report_file}" "${threshold}" "${modified_files[@]}" \
    || echo 'No modified covered files...'
}

function luacov::format_pull_request_comment {
  local base_sha="${1:?}"
  local head_sha="${2:?}"
  local current_status="${3:?}"
  local overall_report="${4:?}"
  local new_files_report="${5:?}"
  local modified_files_report="${6:?}"

  local report_base report_head

  report_base="$(git rev-parse --verify "${base_sha}")"
  if [[ "${report_base}" == "${base_sha}" ]]; then
    report_base="${report_base:0:7}"
  else
    report_base="${base_sha}"
  fi

  report_head="$(git rev-parse --verify "${head_sha}")"
  if [[ "${report_head}" == "${head_sha}" ]]; then
    report_head="${report_head:0:7}"
  else
    report_head="${head_sha}"
  fi

  cat <<EOF
# ☂️ Lua Cov
> current status: ${current_status}
## Overall Coverage
${overall_report}
## New Files
${new_files_report}
## Modified Files
${modified_files_report}

> updated for commit range: \`${report_base}..${report_head}\` by 🐢
EOF
}

function luacov::summary {
  local report_file="${1:-}"

  if [[ -z "${report_file}" ]]; then
    report_file="$(luacov::resolve_report_file "$(luacov::repo_root)")"
  fi

  if [[ -z "${report_file}" ]]; then
    >&2 echo "ERROR: luacov.report.out not found. Run 'make compose-test' first."
    return 1
  fi

  local summary
  summary="$(luacov::parse_summary "${report_file}")"

  if [[ -z "${summary}" ]]; then
    echo "No coverage data available."
    return 1
  fi

  local total_lines covered_lines percent_covered
  total_lines="$(echo "${summary}" | awk '{print $1}')"
  covered_lines="$(echo "${summary}" | awk '{print $2}')"
  percent_covered="$(echo "${summary}" | awk '{print $3}')"

  echo "Coverage: ${covered_lines}/${total_lines} lines (${percent_covered}%)"
}

function luacov::all_files {
  local report_file="${1:-}"
  local repo_root

  repo_root="$(luacov::repo_root)"

  if [[ -z "${report_file}" ]]; then
    report_file="$(luacov::resolve_report_file "${repo_root}")"
  fi

  if [[ -z "${report_file}" ]]; then
    >&2 echo "ERROR: luacov.report.out not found. Run 'make compose-test' first."
    return 1
  fi

  while IFS=' ' read -r file _total_lines _covered_lines percent_covered; do
    local relative_file="${file#"${repo_root}"/}"
    printf '%s%%\t%s\n' "${percent_covered}" "${relative_file}"
  done < <(luacov::parse_files "${report_file}")
}

function luacov::generate_pull_request_comment {
  local base_sha="${1:?}"
  local head_sha="${2:?}"
  local coverage_report_output="${3:-/dev/stdout}"
  local report_file="${4:-}"

  if ! git rev-parse --verify "${base_sha}" >/dev/null 2>&1; then
    >&2 echo "ERROR: invalid base ref: '${base_sha}'"
    return 1
  fi

  if ! git rev-parse --verify "${head_sha}" >/dev/null 2>&1; then
    >&2 echo "ERROR: invalid head ref: '${head_sha}'"
    return 1
  fi

  if [[ -z "${report_file}" ]]; then
    report_file="$(luacov::resolve_report_file "$(luacov::repo_root)")"
  fi

  if [[ -z "${report_file}" ]]; then
    >&2 echo "ERROR: luacov.report.out not found. Run 'make compose-test' first."
    return 1
  fi

  local current_status overall_report new_files_report modified_files_report

  current_status="$(luacov::get_overall_status "${report_file}" "${THRESHOLD_ALL}")"
  overall_report="$(luacov::get_overall_report "${report_file}" "${THRESHOLD_ALL}")"

  new_files_report="$(
    luacov::get_new_files_report \
      "${base_sha}" \
      "${head_sha}" \
      "${report_file}" \
      "${THRESHOLD_NEW}"
  )"

  modified_files_report="$(
    luacov::get_modified_files_report \
      "${base_sha}" \
      "${head_sha}" \
      "${report_file}" \
      "${THRESHOLD_MODIFIED}"
  )"

  local coverage_report_temp_output
  coverage_report_temp_output="$(mktemp /tmp/vim-4-eva-coverage-report.XXXXXXXXXX)"

  # A failed staging write fails the report; a failed mktemp fails here too,
  # since the redirect to its empty result cannot be opened.
  if ! luacov::format_pull_request_comment \
    "${base_sha}" \
    "${head_sha}" \
    "${current_status}" \
    "${overall_report}" \
    "${new_files_report}" \
    "${modified_files_report}" \
    >"${coverage_report_temp_output}"; then
    >&2 echo "ERROR: failed to write coverage report to '${coverage_report_temp_output}'"
    rm -f "${coverage_report_temp_output}"
    return 1
  fi

  if [[ "${coverage_report_output}" == 'GITHUB_OUTPUT' ]]; then
    echo "Using GITHUB_OUTPUT: ${GITHUB_OUTPUT}"

    # Note for multiline strings we need to use the following format:
    #
    #   {name}<<{delimiter}
    #   {value}
    #   {delimiter}
    #
    # ref: https://docs.github.com/en/actions/using-workflows/workflow-commands-for-github-actions#multiline-strings

    local github_delimiter
    github_delimiter="$(dd if=/dev/urandom bs=15 count=1 status=none | base64)"

    # We use awk to convert linebreaks into \n literals to pass downstream
    # otherwise we run into quoting issues with github-script bodies.
    cat >>"${GITHUB_OUTPUT}" <<EOF
coverage_report<<${github_delimiter}
$(awk -v ORS='\\n' '1' "${coverage_report_temp_output}")
${github_delimiter}
EOF

    # Cleanup must not mask the write's status; a failed write fails the report.
    local report_status=$?
    rm -f "${coverage_report_temp_output}"
    return "${report_status}"
  fi

  cat "${coverage_report_temp_output}" >"${coverage_report_output}"
  # Cleanup must not mask the write's status; a failed write fails the report.
  local report_status=$?
  rm -f "${coverage_report_temp_output}"
  return "${report_status}"
}

subcommand="${1:?Usage: $0 <summary|files|pull-request> [args...]}"
shift

case "${subcommand}" in
  summary)
    luacov::summary "$@"
    ;;
  files)
    luacov::all_files "$@"
    ;;
  pull-request)
    luacov::generate_pull_request_comment "$@"
    ;;
  *)
    >&2 echo "Unknown subcommand: ${subcommand}"
    >&2 echo "Usage: $0 <summary|files|pull-request> [args...]"
    exit 1
    ;;
esac
