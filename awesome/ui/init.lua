local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local bar = require("ui.bar")

awful.screen.connect_for_each_screen(function(s)
	awful.tag({"1", "2", "3", "4"}, s, awful.layout.layouts[1])

    bar(s)
end)

require("awful.autofocus")
require("ui.better-resize")
require("ui.savefloats")
require("ui.exitscreen")
require("ui.menu")
require("ui.deco")
require("ui.popup")
require("ui.lockscreen")
require("ui.indicator")