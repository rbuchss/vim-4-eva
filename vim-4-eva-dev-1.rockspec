rockspec_format = "3.0"
package = "vim-4-eva"
version = "dev-1"

source = {
  url = "git+https://github.com/rbuchss/vim-4-eva.git"
}

description = {
  summary = "My personal neovim configuration",
  homepage = "https://github.com/rbuchss/vim-4-eva",
  license = "MIT"
}

dependencies = {
  "lua >= 5.1, < 5.2",
}

test_dependencies = {
  "vusted >= 2.5.3",
}

test = {
  type = "command",
  command = "eval $(luarocks path) && vusted test/"
}
