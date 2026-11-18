################################################################################
# Args
################################################################################

ARG SELENE_VERSION=0.31.0
ARG STYLUA_VERSION=2.6.0
ARG VIM_THEMIS_VERSION=v1.7.0
ARG COVIMERAGE_VERSION=0.2.2
ARG VUSTED_VERSION=2.5.3-1
ARG LUACOV_VERSION=0.17.0-1
ARG VIM_VINT_VERSION=0.3.21
ARG SETUPTOOLS_VERSION=80.9.0

################################################################################
# Rust builder stage - Compiles selene and stylua
################################################################################

# Pin cargo to 1.99: cargo 1.100 installs use the lockfile shipped in the
# crate tarball, and selene's lock pins getrandom 0.2.8, which calls open64
# and does not link on musl. Cargo 1.99 resolves fresh and picks
# getrandom 0.2.17, which links cleanly.
FROM rust:1.99.0-alpine3.24 AS vim-4-eva-rust-builder

ARG SELENE_VERSION
ARG STYLUA_VERSION

RUN apk update && apk add musl-dev

RUN cargo install selene --version "${SELENE_VERSION}"
RUN cargo install stylua --version "${STYLUA_VERSION}"

################################################################################
# Builder stage - Includes all testing and linting dependencies
################################################################################

FROM alpine:3.24 AS vim-4-eva-tester-builder

ARG VIM_THEMIS_VERSION
ARG COVIMERAGE_VERSION
ARG VUSTED_VERSION
ARG LUACOV_VERSION
ARG VIM_VINT_VERSION
ARG SETUPTOOLS_VERSION

RUN apk update

# System packages
RUN apk add vim
RUN apk add neovim
RUN apk add lua5.1 lua5.1-dev luarocks5.1
RUN apk add python3 py3-pip
RUN apk add git
RUN apk add make
RUN apk add jq
RUN apk add bc
RUN apk add bash
RUN apk add gcc musl-dev

# Symlink luarocks5.1 to luarocks for convenience
RUN ln -sf /usr/bin/luarocks-5.1 /usr/bin/luarocks

# pip packages (use break-system-packages since we're in a container)
# vint imports pkg_resources, which python 3.14 on alpine 3.24 no longer
# ships; setuptools' own guidance is to pin below 81 for pkg_resources.
RUN pip3 install --break-system-packages setuptools=="${SETUPTOOLS_VERSION}" vim-vint=="${VIM_VINT_VERSION}" covimerage=="${COVIMERAGE_VERSION}"

# luarocks packages
RUN luarocks install vusted "${VUSTED_VERSION}"
RUN luarocks install luacov "${LUACOV_VERSION}"

# vim-themis test framework
RUN git clone --depth 1 --branch "${VIM_THEMIS_VERSION}" \
  https://github.com/thinca/vim-themis.git /opt/vim-themis
ENV PATH="/opt/vim-themis/bin:${PATH}"

# Copy selene and stylua from rust builder stage
COPY --from=vim-4-eva-rust-builder /usr/local/cargo/bin/selene /usr/local/bin/selene
COPY --from=vim-4-eva-rust-builder /usr/local/cargo/bin/stylua /usr/local/bin/stylua
