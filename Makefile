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

# Force init target
.PHONY: bootstrap
bootstrap:
	$(LUAROCKS_INIT)

# Install both regular and test dependencies
lua_modules: $(LUAROCKS_INIT_FILES) $(ROCKSPEC)
	$(LUAROCKS_INSTALL_DEPS)

# Force install deps target
.PHONY: deps
deps: $(LUAROCKS_INIT_FILES)
	$(LUAROCKS_INSTALL_DEPS)

.DEFAULT_GOAL := test
.PHONY: test
test: lua_modules
	luarocks test
