local M = {
  custom_index = 1,
}

function M.setup(_)
  -- required for color rich colorschemes to work
  vim.opt.termguicolors = true

  require('vim_4_eva.pack').lazy.register({
    {
      'lush.nvim',
      lazy = true,
    },
    {
      'zombat.nvim',
      colorscheme = 'zombat',
      before = function()
        require('lz.n').trigger_load('lush.nvim')
      end,
    },
    {
      'catppuccin.nvim',
      colorscheme = {
        'catppuccin',
        'catppuccin-frappe',
        'catppuccin-latte',
        'catppuccin-macchiato',
        'catppuccin-mocha',
      },
      after = function()
        -- Optional: setup can be called for customization, works with defaults too
        require('catppuccin').setup({})
      end,
    },
    {
      'kanagawa.nvim',
      colorscheme = {
        'kanagawa',
        'kanagawa-dragon',
        'kanagawa-lotus',
        'kanagawa-wave',
      },
      after = function()
        -- Optional: setup not required if defaults are acceptable
        require('kanagawa').setup({})
      end,
    },
    {
      'tokyonight.nvim',
      colorscheme = {
        'tokyonight',
        'tokyonight-day',
        'tokyonight-moon',
        'tokyonight-night',
        'tokyonight-storm',
      },
      after = function()
        -- Optional: setup not required, but must be called BEFORE colorscheme if customizing
        require('tokyonight').setup({})
      end,
    },
    {
      'rose-pine.nvim',
      colorscheme = {
        'rose-pine',
        'rose-pine-dawn',
        'rose-pine-main',
        'rose-pine-moon',
      },
      after = function()
        -- Optional: setup not required if using defaults
        require('rose-pine').setup({})
      end,
    },
    {
      'nightfox.nvim',
      colorscheme = {
        'carbonfox',
        'dawnfox',
        'dayfox',
        'duskfox',
        'nightfox',
        'nordfox',
        'terafox',
      },
      after = function()
        -- Optional: setup not required if using defaults
        require('nightfox').setup({})
      end,
    },
    {
      'nordic.nvim',
      colorscheme = {
        'nordic',
      },
      after = function()
        -- Optional: setup not required, but recommended for customization
        require('nordic').setup({})
      end,
    },
    {
      'everforest.nvim',
      colorscheme = {
        'everforest',
      },
      after = function()
        -- Optional: setup not required if using defaults
        require('everforest').setup({})
      end,
    },
    {
      'vscode.nvim',
      colorscheme = {
        'vscode',
      },
      after = function()
        -- Optional: setup not required but allows customization
        require('vscode').setup({})
      end,
    },
    {
      'sonokai.nvim',
      colorscheme = {
        'sonokai',
      },
    },
    {
      'cyberdream.nvim',
      colorscheme = {
        'cyberdream',
        'cyberdream-light',
      },
      after = function()
        -- Optional: setup not required but recommended for configuration
        require('cyberdream').setup({})
      end,
    },
    {
      'vim-moonfly-colors',
      colorscheme = {
        'moonfly',
      },
    },
    {
      'dracula.nvim',
      colorscheme = {
        'dracula',
        'dracula-soft',
      },
      after = function()
        -- Optional: setup must be called BEFORE colorscheme if customizing
        require('dracula').setup({})
      end,
    },
    {
      'nord.nvim',
      colorscheme = {
        'nord',
      },
      after = function()
        -- Optional: setup not required if using defaults
        require('nord').setup({})
      end,
    },
    {
      'gruvbox-material',
      colorscheme = {
        'gruvbox-material',
      },
    },
    {
      'material.nvim',
      colorscheme = {
        'material',
        'material-darker',
        'material-deep-ocean',
        'material-lighter',
        'material-oceanic',
        'material-palenight',
      },
      after = function()
        -- Optional: setup not required but recommended for customization
        require('material').setup({})
      end,
    },
    {
      'solarized-osaka.nvim',
      colorscheme = {
        'solarized-osaka',
        'solarized-osaka-day',
      },
      after = function()
        -- Optional: setup must be called BEFORE colorscheme if customizing
        require('solarized-osaka').setup({})
      end,
    },
    {
      'onedarkpro.nvim',
      colorscheme = {
        'onedark',
        'onedark_dark',
        'onedark_vivid',
        'onelight',
        'vaporwave',
      },
      after = function()
        -- Optional: setup not required if using defaults
        require('onedarkpro').setup({})
      end,
    },
    {
      'github-nvim-theme',
      colorscheme = {
        'github_dark',
        'github_dark_colorblind',
        'github_dark_default',
        'github_dark_dimmed',
        'github_dark_high_contrast',
        'github_dark_tritanopia',
        'github_light',
        'github_light_colorblind',
        'github_light_default',
        'github_light_high_contrast',
        'github_light_tritanopia'
      },
      after = function()
        -- Optional: setup not required but allows customization and caching
        require('github-theme').setup({})
      end,
    },
    {
      'oxocarbon.nvim',
      colorscheme = {
        'oxocarbon',
      },
    },
    {
      'melange-nvim',
      colorscheme = {
        'melange',
      },
    },
    {
      'bamboo.nvim',
      colorscheme = {
        'bamboo',
        'bamboo-light',
        'bamboo-multiplex',
        'bamboo-vulgaris',
      },
      after = function()
        -- Required: setup and load must be called for bamboo.nvim
        require('bamboo').setup({})
        require('bamboo').load()
      end,
    },
    {
      'edge',
      colorscheme = {
        'edge',
      },
    },
  })

  vim.keymap.set('n', '<leader>nn', M.custom_cycle_next, { desc = 'Next colorscheme' })
  vim.keymap.set('n', '<leader>pp', M.custom_cycle_prev, { desc = 'Prev colorscheme' })
end

-- all colors
function M.all()
  return vim.fn.getcompletion('', 'color')
end

-- just vim builtin colors
function M.builtin()
  local colors = {}

  for _, name in ipairs(M.all()) do
    -- filter out builtins
    if M.is_builtin(name) then
      table.insert(colors, name)
    end
  end

  return colors
end

-- just custom colors
function M.custom()
  local colors = {}

  for _, name in ipairs(M.all()) do
    -- filter out builtins
    if not M.is_builtin(name) then
      table.insert(colors, name)
    end
  end

  return colors
end

-- helper: is this colorscheme file under $VIMRUNTIME/colors?
function M.is_builtin(name)
  local patterns = {
    'colors/' .. name .. '.vim',
    'colors/' .. name .. '.lua',
  }

  for _, pat in ipairs(patterns) do
    local paths = vim.fn.globpath(vim.env.VIMRUNTIME, pat, true, true)

    if #paths > 0 then
      return true
    end
  end

  return false
end

function M.notify(name)
  local message = string.format('colorscheme: %s', name)

  local patterns = {
    'colors/' .. name .. '.vim',
    'colors/' .. name .. '.lua',
  }

  for _, pat in ipairs(patterns) do
    local paths = vim.fn.globpath(vim.o.runtimepath, pat, true, true)

    if #paths > 0 then
      message = string.format(
        '%s\npaths: %s',
        message,
        vim.inspect(paths)
      )
      break
    end
  end

  local level = vim.log.levels.INFO
  local opts = { title = 'colors' }

  local ok, fidget = pcall(require, 'fidget')

  if ok and fidget.notify then
    fidget.notify(message, level, opts)
  else
    vim.notify(message, level, opts)
  end
end

function M.custom_cycle_next()
  local colors = M.custom()
  M.custom_index = M.custom_index % #colors + 1
  local value = colors[M.custom_index]

  vim.cmd.colorscheme(value)
  vim.g.colors_name = value

  M.notify(vim.g.colors_name)
end

function M.custom_cycle_prev()
  local colors = M.custom()

  M.custom_index = (M.custom_index - 2) % #colors + 1
  local value = colors[M.custom_index]

  vim.cmd.colorscheme(value)
  vim.g.colors_name = value

  M.notify(vim.g.colors_name)
end

function M.random_color(opts)
  opts = opts or { colors = nil }

  local colors = opts.colors or M.all()

  if opts.colors == 'custom' then
    colors = M.custom()
  elseif opts.colors == 'builtin' then
    colors = M.builtin()
  end

  math.randomseed(os.time())

  return colors[math.random(#colors)]
end

return M
