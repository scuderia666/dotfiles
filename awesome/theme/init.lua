local beautiful = require("beautiful")
local gears = require("gears")
local helpers = require("modules.helpers")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local _images = gears.filesystem.get_configuration_dir() .. "/images"

local settings = require "setup".settings

local themeName = settings.colorscheme
local colors = require("theme.colors." .. themeName)

colors.blue = colors.pri
colors.yellow = colors.warn
colors.green = colors.ok
colors.red = colors.err
colors.magenta = colors.dis

beautiful.init(helpers.tableMerge(colors,{
    images = _images,
    
    font = "Hermit",
    icofont = "Material Design Icons Desktop",

    rounded = 12,
    
    useless_gap = 4,
    
    taglist_bg = "#0d0f18",
    taglist_bg_focus = "#86aaec",
    taglist_bg_occupied = "#262831",
    taglist_bg_empty = "#151720",

    titlebar_bg_normal = colors.bg,
    titlebar_bg_focus = colors.bg,
    titlebars_enabled = true,

    border_width = dpi(4),
    border_color_normal = colors.bg,
    border_color_active = colors.red,

    snap_bg = colors.bg,
    snap_shape = helpers.rrect(4),
}))