local beautiful = require("beautiful")
local gears = require("gears")
local helpers = require("modules.helpers")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local _images = gears.filesystem.get_configuration_dir() .. "/images"

local colors = {}

colors.bg_color = "#0F0F11"
colors.fg_color = "#ccd0d9"

colors.accent = "#647EA7"
colors.accent_2 = colors.accent .. "66"
colors.accent_3 = "#503232"

--colors.red = "#ff0000"
colors.green = "#00ff00"
colors.blue = "#0000ff"

colors.dbg   = "#1e2030"
colors.nbg   = "#24273a"
colors.lbg   = "#2d3146"
colors.blk   = "#3d4158"
colors.gry   = "#494d64"
colors.wht   = "#939ab7"
colors.dfg   = "#a5adcb"
colors.nfg   = "#cad3f5"
    
colors.red   = "#ed8796"
colors.red_d = "#ba6370"
colors.grn   = "#a6da95"
colors.grn_d = "#88bf80"
colors.ylw   = "#eed49f"
colors.ylw_d = "#dfbf7d"
colors.blu   = "#8aadf4"
colors.blu_d = "#7690c5"
colors.mag   = "#f5bde6"
colors.mag_d = "#dda1cd"
colors.cya   = "#8bd5ca"
colors.cya_d = "#76bbb1"

colors.bg_color = "#0F0F11"
colors.bg_2 = "#1a1a1d"
colors.bg_3 = "#212125"

colors.bg = "#121111"
colors.bg2 = "#191919"
colors.bg3 = "#1b1b1b"
colors.bg4 = "#272727"

colors.fg = "#dfdddd"
colors.fg1 = "#b7b7b7"
colors.fg2 = "#5a5858"
colors.fg3 = "#838383"

colors.ok = "#7D8A6B"
colors.warn = "#caac79"
colors.err = "#AF575B"
colors.pri = "#7D95AE"
colors.dis = "#a07ea7"

beautiful.init(tableMerge(colors,{
    images = _images,

    icofont = "Material Design Icons Desktop",

    scrwidth = 1366,
    scrheight = 768,

    rounded = 8,
    
    taglist_bg = colors.bg_color .. "00",
    taglist_bg_focus = colors.fg_color,
    taglist_fg_focus = colors.accent,
    taglist_bg_urgent = colors.red_color,
    taglist_fg_urgent = colors.red_2,
    taglist_bg_occupied = colors.fg_color .. "80",
    taglist_fg_occupied = colors.fg_color,
    taglist_bg_empty = colors.fg_color .. "1A",
    taglist_fg_empty = colors.fg_color .. "66",
    
    titlebar_bg_normal = colors.bg_color,
    titlebar_bg_focus = colors.bg_color,
    titlebars_enabled = true,
    
    snap_bg = colors.bg_2,
    snap_shape = helpers.rrect(4),
}))