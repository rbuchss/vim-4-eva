#!/usr/bin/env sh

TESTER_USER="kyle-reese"

# This fixes the git error - fatal: detected dubious ownership in repository
git config --global --add safe.directory "${PWD}"

echo "Args: $*"
echo "PWD: ${PWD}"
echo "COVERAGE_REPORT_BASE_SHA: ${COVERAGE_REPORT_BASE_SHA}"
echo "COVERAGE_REPORT_HEAD_SHA: ${COVERAGE_REPORT_HEAD_SHA}"
echo "COVERAGE_REPORT_OUTPUT: ${COVERAGE_REPORT_OUTPUT}"

target="${1:?}"
with_coverage="${2}"

# Ensure GHA output file is writable by the non-root user
if [ -n "${GITHUB_OUTPUT:-}" ]; then
  chmod a+rw "${GITHUB_OUTPUT}"
fi

# GHA bind-mounts /github/workspace as root; the non-root user needs write
# access for luacov output, test temp files, and git operations.
chown -R "${TESTER_USER}" "${PWD}"

# Build the make command
# NOTE: `make test` includes coverage by default.
# Use `make test-quick` for tests without coverage.
case "${target}:${with_coverage}" in
  test:true) make_cmd='make test' ;;
  test-vim:true) make_cmd='make test-vim' ;;
  *) make_cmd="make '${target}'" ;;
esac

# Drop privileges so permission-based tests work correctly.
# -m preserves environment (GITHUB_OUTPUT, COVERAGE_REPORT_*, PATH).
exec su -m "${TESTER_USER}" -s /bin/sh -c \
  "export HOME='/home/${TESTER_USER}'; git config --global --add safe.directory '${PWD}'; cd '${PWD}'; ${make_cmd}"
