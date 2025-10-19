ROCKSPEC := vim-4-eva-dev-1.rockspec

# Note we must use lua 5.1 to match what neovim bundles
.PHONY: boostrap
bootstrap:
	luarocks init --lua-version=5.1

# Install both regular and test dependencies
.PHONY: deps
deps: bootstrap
	@echo "Installing dependencies..."
	luarocks install --only-deps $(ROCKSPEC)
	@echo "Installing test dependencies..."
	luarocks test --prepare $(ROCKSPEC)

.PHONY: test
test: deps
	eval $$(luarocks path) && luarocks test
