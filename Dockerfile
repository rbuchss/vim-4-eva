################################################################################
# Args
################################################################################

ARG BUILDER_IMAGE_NAME=rbuchss/vim-4-eva-tester-builder
ARG USER=kyle-reese
ARG GROUP=skynet-resistance
ARG WORKDIR=/cyberdyne

################################################################################
# Tester Image - Uses builder image to speed up test image setup
################################################################################

FROM ${BUILDER_IMAGE_NAME} AS vim-4-eva-tester-base

# We need to export any ARG's we want in each stage to make them available
ARG USER
ARG GROUP

RUN addgroup ${GROUP}
RUN adduser \
  --disabled-password \
  --gecos "" \
  --shell /bin/sh \
  --ingroup ${GROUP} \
  ${USER}

################################################################################
# Local docker version
################################################################################

FROM vim-4-eva-tester-base AS vim-4-eva-tester-local

# We need to export any ARG's we want in each stage to make them available
ARG USER
ARG GROUP
ARG WORKDIR

WORKDIR ${WORKDIR}

RUN chown --recursive ${USER}:${GROUP} ${WORKDIR}

USER ${USER}

COPY --chown=${USER}:${GROUP} . .

CMD exec make guards

################################################################################
# Github actions docker version
# Note Github recommends that we do not set USER and WORKDIR:
# ref https://docs.github.com/en/actions/creating-actions/dockerfile-support-for-github-actions
################################################################################

FROM vim-4-eva-tester-base AS vim-4-eva-tester-github-actions

ARG USER
ARG GROUP

# Set working directory for GitHub Actions (even though GH docs recommend not to,
# we need it so the relative ENTRYPOINT below resolves)
WORKDIR /github/workspace

COPY --chown=${USER}:${GROUP} . .

ENTRYPOINT ["./.github/actions/run-make/entrypoint.sh"]
