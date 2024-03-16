local beautiful = require("beautiful")
local gears = require("gears")
local helpers = require("modules.helpers")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local _images = gears.filesystem.get_configuration_dir() .. "/stuff/images/"

--[[
local settings = require "setup".settings
local themeName = settings.colorscheme
local colors = require("theme.colors." .. themeName)
]]--

local colors = {
    rosewater = "#f5e0dc",
    flamingo = "#f2cdcd",
    pink = "#f5c2e7",
    mauve = "#cba6f7",
    red = "#f38ba8",
    peach = "#fab387",
    yellow = "#f9e2af",
    green = "#a6e3a1",
    teal = "#94e2d5",
    sky = "#89dceb",
    sapphire = "#74c7ec",
    blue = "#89b4fa",
    lavender = "#b4befe",
    text = "#cdd6f4",
    subtext1 = "#bac2de",
    subtext0 = "#a6adc8",
    overlay2 = "#9399b2",
    overlay1 = "#7f849c",
    overlay0 = "#6c7086",
    surface2 = "#585b70",
    surface1 = "#45475a",
    surface0 = "#313244",
    base = "#1e1e2e",
    mantle = "#181825",
    crust = "#11111b"
}

local tokyonight = {
    red = "#f7768e",
    orange = "#ff9e64",
    yellow = "#e0af68",
    green = "#9ece6a",

    teal = "#73daca",
    sky = "#b4f9f8",
    cyan = "#2ac3de",
    blue = "#7dcfff",
    indigo = "#7aa2f7",

    purple = "#bb9af7",

    subtext2 = "#c0caf5",
    subtext1 = "#a9b1d6",
    subtext0 = "#9aa5ce",

    overlay = "#cfc9c2",

    surface1 = "#565f89",
    surface0 = "#414868",

    bg1 = "#24283b",
    bg0 = "#1a1b26",
}

local shore = {
    base = "#23232a"
}

beautiful.init(helpers.tableMerge(colors,{
    images = _images,
    
    font = "Hermit",
    icofont = "Material Design Icons Desktop",

    rounded = 12,
    
    useless_gap = 4,

    taglist_bg_focus = colors.lavender,
    taglist_bg_occupied = colors.surface0,
    taglist_bg_empty = colors.mantle,

    titlebar_bg_normal = colors.mantle,
    titlebar_bg_focus = colors.crust,

    bg_systray = colors.crust,

    border_width = dpi(2),
    border_color_normal = colors.base,
    border_color_active = colors.red,

    snap_bg = colors.base,
    snap_shape = helpers.rrect(4),
}))
