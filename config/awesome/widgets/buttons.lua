local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")

local box = require("lib.dockbox")

local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

buttons = {}

buttons.widget = wibox {
	visible = false,
	ontop = true,
	width = 100,
	height = awful.screen.focused().geometry.height/2
}

awful.placement.right(buttons.widget, { margins = {bottom = dpi(100)}})

local poweroff = box(beautiful.fg_normal, beautiful.fg_focus, "襤", function() awful.spawn("poweroff") end)
local reboot = box(beautiful.fg_normal, beautiful.fg_focus, "ﰇ", function() awful.spawn("reboot") end)
local logout = box(beautiful.fg_normal, beautiful.fg_focus, "﫼", awesome.quit)

buttons.widget : setup {
	{
        nil,
        {
            nil, 
            {
                poweroff,
                reboot, 
                logout,
                spacing = dpi(8),
                layout = wibox.layout.fixed.vertical
            }, 
            nil,
            expand = "none",
            layout = wibox.layout.align.horizontal
        },
        nil, 
        expand = "none", 
        layout = wibox.layout.align.vertical
    }, 
    forced_width = dpi(64),
    widget = wibox.container.background, 
}

awesome.connect_signal(
	'module::buttons:toggle',
	function()
		buttons.toggle()
	end
)

function buttons.toggle()
    buttons.widget.visible = not buttons.widget.visible
end

return buttons
