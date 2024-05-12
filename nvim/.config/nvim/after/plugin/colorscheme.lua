local utils = require('skink-vim.utils')

_G.theme_state = {
    -- Default theme
    current_theme = 'cyberdream'
}

local function set_theme_state(theme_name)
    _G.theme_state.current_theme = theme_name
end

local function get_theme_state()
    return _G.theme_state.current_theme
end

local function setup_catppuccin()
    require("catppuccin").setup({
        flavour = "latte",
        background = {
            light = "latte",
            dark = "mocha",
        },
        transparent_background = true,
    })
end

local function setup_cyberdream()
    require("cyberdream").setup({
        transparent = true,
        italic_comments = true,
        hide_fillchars = true,
        borderless_telescope = true,
        terminal_colors = true,
    })
end

local function setup_themes(theme_name)
    if theme_name == 'catppuccin-latte' then
        setup_catppuccin()
    elseif theme_name == 'cyberdream' then
        setup_cyberdream()
    end
end

local function load_theme(theme_name)
    local status_ok, _ = pcall(vim.cmd, 'packadd ' .. theme_name)
    if not status_ok then
        print('Error loading ' .. theme_name)
        return
    end
    setup_themes(theme_name)
    vim.cmd('colorscheme ' .. theme_name)
end

local function is_kitty_term()
    return vim.env.TERM == 'xterm-kitty'
end

local function set_kitty_theme(theme_name)
    if is_kitty_term() then
        utils.async_system('kitten themes --reload-in=all ' .. theme_name)
    end
end

local function toggle_theme()
    if get_theme_state() == 'catppuccin-latte' then
        set_kitty_theme('cyberdream')
    else
        set_kitty_theme('catppuccin-latte')
    end
end

local function set_theme_from_kitty()
    if is_kitty_term() then
        local file = io.open(vim.fn.expand('~/.config/kitty/current-theme.conf'), 'r')
        if not file then
            print('Error opening current-theme.conf')
            return
        end

        local theme_name = file:read('*all'):match('name:%s+([%w-]+)')
        if theme_name then
            theme_name = string.lower(theme_name)
            load_theme(theme_name)
            set_theme_state(theme_name)
        end
    end
end

local function on_change(err, _, _)
    if err then
        print('Error setting theme watcher:', err) -- Handle possible errors
    else
        -- kitty takes a while to 'reload' the terminal so this just attempts
        -- to synchronize the change a little, otherwise the vim colors change
        -- before the terminal does and it looks weird
        vim.defer_fn(set_theme_from_kitty, 750)
    end
end


set_theme_from_kitty()

vim.keymap.set('n', '<F6>', toggle_theme, {})
utils.watch_directory(vim.fn.expand('~/.config/kitty'), 'current-theme.conf', on_change)
