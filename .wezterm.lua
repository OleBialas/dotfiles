local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Launch WSL Ubuntu by default
config.default_domain = 'WSL:Ubuntu'
config.wsl_domains = {
  {
    name = 'WSL:Ubuntu',
    distribution = 'Ubuntu',
    default_cwd = '/home/olebi',
  },
}

-- Font
config.font = wezterm.font_with_fallback {
  { family = 'Fira Code', harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' } },
  'Cascadia Code',
  'Consolas',
}
config.font_size = 11.5
config.line_height = 1.05

-- Color scheme to match nvim onedark
config.color_scheme = 'OneDark (base16)'

-- Window
config.window_background_opacity = 0.95
config.window_decorations = 'RESIZE'
config.window_padding = {
  left = 8,
  right = 8,
  top = 6,
  bottom = 4,
}
config.initial_cols = 120
config.initial_rows = 32

-- Tab bar
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.show_new_tab_button_in_tab_bar = false

-- Scrollback
config.scrollback_lines = 10000

-- Cursor
config.default_cursor_style = 'SteadyBlock'
config.cursor_blink_rate = 0

-- Behavior
config.audible_bell = 'Disabled'
config.check_for_updates = false
config.adjust_window_size_when_changing_font_size = false

-- Keybindings
config.keys = {
  { key = 'c', mods = 'CTRL|SHIFT', action = wezterm.action.CopyTo 'Clipboard' },
  { key = 'v', mods = 'CTRL|SHIFT', action = wezterm.action.PasteFrom 'Clipboard' },
  { key = 't', mods = 'CTRL|SHIFT', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
  { key = 'w', mods = 'CTRL|SHIFT', action = wezterm.action.CloseCurrentTab { confirm = false } },
  { key = 'Tab', mods = 'CTRL', action = wezterm.action.ActivateTabRelative(1) },
  { key = 'Tab', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateTabRelative(-1) },
  { key = 'q', mods = 'CTRL|SHIFT', action = wezterm.action.QuitApplication },
  { key = 'h', mods = 'CTRL|SHIFT|ALT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 'v', mods = 'CTRL|SHIFT|ALT', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
}

-- onedark colors for tab bar
local onedark = {
  bg       = '#282c34',
  bg_dim   = '#21252b',
  fg       = '#abb2bf',
  fg_dim   = '#5c6370',
  blue     = '#61afef',
  green    = '#98c379',
}

wezterm.on('format-tab-title', function(tab)
  local pane = tab.active_pane
  local title = pane.title

  if title:match('wsl') or title:match('zsh') or title:match('bash') then
    local cwd = pane.current_working_dir
    if cwd then
      local path = cwd.file_path or tostring(cwd)
      -- strip trailing slash
      path = path:gsub('[/\\]$', '')
      -- replace home path with ~
      path = path:gsub('.*[/\\]olebi$', '~')
      -- for anything else just show the last component
      if path ~= '~' then
        path = path:match('([^/\\]+)$') or path
      end
      title = path
    else
      title = 'ubuntu'
    end
  end

  local is_active = tab.is_active
  local bg = is_active and onedark.bg or onedark.bg_dim
  local fg = is_active and onedark.blue or onedark.fg_dim
  local sep_fg = is_active and onedark.blue or onedark.fg_dim

  return {
    { Background = { Color = onedark.bg_dim } },
    { Foreground = { Color = sep_fg } },
    { Text = '▎' },
    { Background = { Color = bg } },
    { Foreground = { Color = fg } },
    { Text = ' ' .. title .. ' ' },
    { Background = { Color = onedark.bg_dim } },
    { Foreground = { Color = onedark.bg_dim } },
    { Text = '' },
  }
end)

config.colors = {
  tab_bar = {
    background = onedark.bg_dim,
  },
}

return config
