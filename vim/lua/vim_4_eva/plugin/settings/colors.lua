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
    },
    {
      'kanagawa.nvim',
      colorscheme = {
        'kanagawa',
        'kanagawa-dragon',
        'kanagawa-lotus',
        'kanagawa-wave',
      },
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
    },
    {
      'rose-pine.nvim',
      colorscheme = {
        'rose-pine',
        'rose-pine-dawn',
        'rose-pine-main',
        'rose-pine-moon',
      },
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
    },
    {
      'nordic.nvim',
      colorscheme = {
        'nordic',
      },
    },
    {
      'everforest.nvim',
      colorscheme = {
        'everforest',
      },
    },
    {
      'vscode.nvim',
      colorscheme = {
        'vscode',
      },
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
    },
    {
      'nord.nvim',
      colorscheme = {
        'nord',
      },
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
    },
    {
      'solarized-osaka.nvim',
      colorscheme = {
        'solarized-osaka',
        'solarized-osaka-day',
      },
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
