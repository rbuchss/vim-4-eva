THIS_DIR := $(patsubst %/,%,$(dir $(realpath $(firstword $(MAKEFILE_LIST)))))

include $(THIS_DIR)/vendor/container-build-tools/modules.mk

.DEFAULT_GOAL := compose-guards

################################################################################
# Docker defaults
################################################################################

# The builder base image (FROM ${BUILDER_IMAGE_NAME} in Dockerfile) is resolved
# by Docker automatically — pulled from registry if not available locally.
# To build the builder locally instead: make -C test/test_builder docker-build
DOCKER_IMAGE_NAME := rbuchss/vim-4-eva-tester-local
DOCKER_BUILD_TARGET := vim-4-eva-tester-local

DOCKER_USER := kyle-reese
DOCKER_GROUP := skynet-resistance
DOCKER_WORKDIR := /cyberdyne

DOCKER_BUILD_FLAGS := \
  --build-arg USER=$(DOCKER_USER) \
  --build-arg GROUP=$(DOCKER_GROUP) \
  --build-arg WORKDIR=$(DOCKER_WORKDIR)

DOCKER_RUN_FLAGS := \
  -it \
  --rm \
  --cap-drop all \
  --security-opt=no-new-privileges

DOCKER_DEBUG_CMD := sh

################################################################################
# Docker Compose macros
################################################################################

# Compose runner
# Usage: $(call compose-run,COMMAND)
#
# HOME=/tmp, not kyle-reese's home: --user runs as the host uid, which can't write /home/kyle-reese (owned 1000); /tmp is world-writable.
#
# :param $(1): Command to run inside the container
define compose-run
	docker compose run --rm \
		--user "$$(id -u):$$(id -g)" \
		-e HOME=/tmp \
		tester sh -c \
		'git config --global --add safe.directory "$$PWD" && $(1)'
endef

# Compose make test runner
# Usage: $(call compose-make-test,TARGET)
#
# :param $(1): Make target to run inside the container
define compose-make-test
	$(call compose-run,make $(1))
endef

################################################################################
# Docker Compose targets
################################################################################

## Run all guards (test with coverage, lint, format check) via Docker Compose
.PHONY: compose-guards
compose-guards:
	$(call compose-make-test,guards)

## Run tests with luacov coverage via Docker Compose
.PHONY: compose-test
compose-test:
	$(call compose-make-test,test)

## Run tests without coverage via Docker Compose
.PHONY: compose-test-quick
compose-test-quick:
	$(call compose-make-test,test-quick)

## Run vimscript tests with covimerage via Docker Compose
.PHONY: compose-test-vim
compose-test-vim:
	$(call compose-make-test,test-vim)

## Run vimscript tests without coverage via Docker Compose
.PHONY: compose-test-vim-quick
compose-test-vim-quick:
	$(call compose-make-test,test-vim-quick)

## Run selene and vint linters via Docker Compose
.PHONY: compose-lint
compose-lint:
	$(call compose-run,make lint)

## Run selene linter only via Docker Compose
.PHONY: compose-lint-lua
compose-lint-lua:
	$(call compose-run,make lint-lua)

## Run vint linter only via Docker Compose
.PHONY: compose-lint-vim
compose-lint-vim:
	$(call compose-run,make lint-vim)

## Run stylua formatter via Docker Compose
.PHONY: compose-format
compose-format:
	$(call compose-run,make format)

## Run stylua format check via Docker Compose
.PHONY: compose-format-check
compose-format-check:
	$(call compose-run,make format-check)

## Open an interactive shell via Docker Compose
.PHONY: compose-debug
compose-debug:
	$(call compose-run,exec sh)

################################################################################
# GitHub Actions targets
################################################################################

## Run GitHub Actions workflow locally via act (linux/amd64)
.PHONY: act-test
act-test:
	act --container-architecture linux/amd64 workflow_dispatch

################################################################################
# Quality guard targets
################################################################################

## Run all guards: test with coverage, lint, format check
.PHONY: guards
guards: test test-vim lint format-check

################################################################################
# Test targets
################################################################################

## Run vusted tests (with luacov coverage when available, without otherwise)
.PHONY: test
test:
	@if command -v luacov >/dev/null 2>&1; then \
		mkdir -p coverage; \
		vusted --coverage test/ && luacov && \
			mv -f luacov.report.out coverage/luacov.report.out && \
			mv -f luacov.stats.out coverage/luacov.stats.out && \
			$(MAKE) --no-print-directory coverage-pr-report; \
	else \
		echo ""; \
		echo "========================================"; \
		echo "WARNING: luacov not found"; \
		echo "Running tests without coverage"; \
		echo "========================================"; \
		echo ""; \
		vusted test/; \
	fi

## Run vusted tests without coverage
.PHONY: test-quick
test-quick:
	vusted test/

################################################################################
# Vimscript test defaults
################################################################################

THEMIS_VIM ?= nvim
THEMIS_HOME ?= /opt/vim-themis
VIMSCRIPT_TEST_PATH := test/vim/

################################################################################
# Vimscript test targets
################################################################################

## Run themis vimscript tests (with covimerage when available, without otherwise)
.PHONY: test-vim
test-vim:
	@if command -v covimerage >/dev/null 2>&1; then \
		mkdir -p coverage; \
		VIM_PROFILE_FILE=coverage/vim-profile.txt \
		THEMIS_VIM=$(THEMIS_VIM) THEMIS_HOME=$(THEMIS_HOME) \
			themis --reporter tap $(VIMSCRIPT_TEST_PATH) && \
		covimerage write_coverage coverage/vim-profile.txt \
			--data-file coverage/.coverage_covimerage \
			--source vim/ && \
		covimerage report \
			--data-file coverage/.coverage_covimerage; \
	else \
		echo ""; \
		echo "========================================"; \
		echo "WARNING: covimerage not found"; \
		echo "Running vimscript tests without coverage"; \
		echo "========================================"; \
		echo ""; \
		THEMIS_VIM=$(THEMIS_VIM) THEMIS_HOME=$(THEMIS_HOME) \
			themis --reporter tap $(VIMSCRIPT_TEST_PATH); \
	fi

## Run themis vimscript tests without coverage
.PHONY: test-vim-quick
test-vim-quick:
	THEMIS_VIM=$(THEMIS_VIM) THEMIS_HOME=$(THEMIS_HOME) \
		themis --reporter tap $(VIMSCRIPT_TEST_PATH)

################################################################################
# Coverage defaults
################################################################################

# The PR coverage report needs a resolvable base ref; on a fresh clone without
# a fetched origin/main, point COVERAGE_REPORT_BASE_SHA at any local ref.
COVERAGE_REPORT_BASE_SHA ?= origin/main
COVERAGE_REPORT_HEAD_SHA ?= HEAD
COVERAGE_REPORT_OUTPUT ?= /dev/stdout

################################################################################
# Coverage targets
################################################################################

## Generate a pull request coverage diff report
.PHONY: coverage-pr-report
coverage-pr-report:
	@[ -n "$(COVERAGE_REPORT_BASE_SHA)" ] && [ -n "$(COVERAGE_REPORT_HEAD_SHA)" ] \
		&& $(THIS_DIR)/test/test_coverage/generate_report.sh \
			pull-request \
			"$(COVERAGE_REPORT_BASE_SHA)" \
			"$(COVERAGE_REPORT_HEAD_SHA)" \
			"$(COVERAGE_REPORT_OUTPUT)"

## Print coverage summary
.PHONY: coverage-summary
coverage-summary:
	@$(THIS_DIR)/test/test_coverage/generate_report.sh summary

## Print per-file coverage breakdown
.PHONY: coverage-files
coverage-files:
	@$(THIS_DIR)/test/test_coverage/generate_report.sh files

################################################################################
# Lint defaults
################################################################################

# Lua files to lint (tracked files under vim/lua/)
LINTED_LUA_PATHS := vim/lua/

# Vim files to lint (tracked vimscript under vim/, excluding the pack/ submodules)
LINTED_VIM_PATHS := \
  vim/ale_linters/ \
  vim/autoload/ \
  vim/colors/ \
  vim/ftdetect/ \
  vim/ftplugin/ \
  vim/os/ \
  vim/plugin/ \
  vim/syntax/

# vint's bundled parser (vim-vint 0.3.21, last release 2019) can't parse
# default function arguments, which statusline.vim uses. Both vim and nvim
# source the file fine; drop the exclusion when vint learns the syntax.
VINT_SKIPPED_VIM_FILES := vim/autoload/vim_4_eva/statusline.vim

################################################################################
# Lint targets
################################################################################

## Run selene and vint on all source files
.PHONY: lint
lint: lint-lua lint-vim

## Run selene on Lua files
.PHONY: lint-lua
lint-lua:
	selene $(LINTED_LUA_PATHS)

## Run vint on Vim files
.PHONY: lint-vim
lint-vim:
	vint $$(git ls-files -- $(LINTED_VIM_PATHS) | grep '\.vim$$' | grep -vxF '$(VINT_SKIPPED_VIM_FILES)')

## List Lua files to be linted
.PHONY: linted-lua-files
linted-lua-files:
	git ls-files -- $(LINTED_LUA_PATHS)

## List Vim files to be linted
.PHONY: linted-vim-files
linted-vim-files:
	git ls-files -- $(LINTED_VIM_PATHS) | grep '\.vim$$' | grep -vxF '$(VINT_SKIPPED_VIM_FILES)'

################################################################################
# Format targets
################################################################################

## Format Lua files with stylua
.PHONY: format
format:
	stylua $(LINTED_LUA_PATHS)

## Check Lua file formatting (no changes)
.PHONY: format-check
format-check:
	stylua --check $(LINTED_LUA_PATHS)

################################################################################
# Luarocks targets
################################################################################

ROCKSPEC := vim-4-eva-dev-1.rockspec
LUAROCKS_INIT_FILES := .luarocks luarocks lua

# Note we must use lua 5.1 to match what neovim bundles
LUAROCKS_INIT := luarocks init --lua-version=5.1

define LUAROCKS_INSTALL_DEPS
@test -d lua_modules || $(LUAROCKS_INIT)
@echo "Installing dependencies..."
luarocks install --only-deps $(ROCKSPEC)
@echo "Installing test dependencies..."
luarocks test --prepare $(ROCKSPEC)
@touch lua_modules
endef

$(LUAROCKS_INIT_FILES) &:
	$(LUAROCKS_INIT)

## Initialize luarocks environment
.PHONY: bootstrap
bootstrap:
	$(LUAROCKS_INIT)

# Install both regular and test dependencies
lua_modules: $(LUAROCKS_INIT_FILES) $(ROCKSPEC)
	$(LUAROCKS_INSTALL_DEPS)

## Install luarocks dependencies
.PHONY: deps
deps: $(LUAROCKS_INIT_FILES)
	$(LUAROCKS_INSTALL_DEPS)
