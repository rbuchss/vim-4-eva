THIS_DIR := $(patsubst %/,%,$(dir $(realpath $(firstword $(MAKEFILE_LIST)))))

include $(THIS_DIR)/../../vendor/container-build-tools/modules.mk

.DEFAULT_GOAL := docker-build

################################################################################
# Docker build defaults
################################################################################

DOCKER_IMAGE_NAME := rbuchss/vim-4-eva-tester-builder
DOCKER_BUILD_TARGET := vim-4-eva-tester-builder

################################################################################
# Docker buildx defaults
################################################################################

DOCKER_BUILD_STRATEGY := buildx
DOCKER_BUILD_PLATFORM := linux/amd64,linux/arm64
DOCKER_BUILDX_BUILDER_NAME := doctor-miles-bennett-dyson

################################################################################
# Docker run defaults
################################################################################

DOCKER_DEBUG_CMD := sh
