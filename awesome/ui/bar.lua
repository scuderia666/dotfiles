local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require("modules.helpers")
local util = require("util")
local hover = util.hover

local tasklist_buttons = gears.table.join(
                 awful.button({ }, 1, function (c)
                                          if c == client.focus then
                                              c.minimized = true
                                          else
                                              c:emit_signal(
                                                  "request::activate",
                                                  "tasklist",
                                                  {raise = true}
                                              )
                                          end
                                      end),
                 awful.button({ }, 3, function(c)
                                          c:kill()
                                      end),
                 awful.button({ }, 4, function ()
                                          awful.client.focus.byidx(1)
                                      end),
                 awful.button({ }, 5, function ()
                                          awful.client.focus.byidx(-1)
                                      end))
                                      
return function(s)
    local screen_height = s.geometry.height

    s.bar = awful.wibar({
        screen = s,
		position = "bottom",
		type = "dock",
		ontop = true,
		visible = true,
		height = dpi(46),
        width = s.geometry.width,
        bg = beautiful.bg,
	})

    local menu = wibox.widget {
        widget = wibox.container.background,
        bg = beautiful.bg,
        shape = helpers.rrect(8),
        {
            widget = wibox.container.margin,
            margins = 5,
            {
                widget = wibox.widget.imagebox,
                image = beautiful.images .. "/void.svg",
                buttons = {
                    awful.button({}, 1, function()
                        awesome.emit_signal("menu::toggle")
                    end)
                },
            },
        },
    }
    
    hover.add(menu)

    local tasklist = awful.widget.tasklist({
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        layout = {
            spacing = dpi(6),
            layout = wibox.layout.fixed.horizontal
        },
        buttons = tasklist_buttons,
        style = {
            font = beautiful.font_var,
            bg_normal = beautiful.bg_3,
            bg_focus = beautiful.fg_color .. "26",
            bg_minimize = beautiful.bg_2,
            shape = helpers.rrect(8)
        },
        widget_template = {
            layout = wibox.layout.stack,
            {
                widget = wibox.container.margin,
                margins = dpi(10),
                awful.widget.clienticon
            },
            {
                widget = wibox.container.margin,
                margins = { top = 44 },
                {
                    widget = wibox.container.background,
                    id = "pointer",
                    bg = beautiful.fg_color,
                    shape = gears.shape.rounded_bar,
                    forced_height = dpi(0),
                    forced_width = dpi(20)
                },
            },
            
            update_callback = function(self, c, _, __)
                collectgarbage("collect")

                if c.active then
                    self:get_children_by_id("pointer")[1].bg = beautiful.fg_color
                elseif c.minimized then
                    self:get_children_by_id("pointer")[1].bg = beautiful.fg_color .. "1A"
                else
                    self:get_children_by_id("pointer")[1].bg = beautiful.bg_3
                end
            end,
        },
    })
    
    local taglist = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        layout = { layout = wibox.layout.fixed.horizontal, spacing = dpi(10) },
        widget_template = {
            id = "background_role",
            shape = gears.shape.circle,
            widget = wibox.container.background,

            create_callback = function(self, c3, _)
                if c3.selected then
                    self:get_children_by_id("background_role")[1].forced_width = dpi(15)
                elseif #c3:clients() == 0 then
                    self:get_children_by_id("background_role")[1].forced_width = dpi(9)
                else
                    self:get_children_by_id("background_role")[1].forced_width = dpi(9)
                end
            end,

            update_callback = function(self, c3, _)
                if c3.selected then
                    self:get_children_by_id("background_role")[1].forced_width = dpi(15)
                elseif #c3:clients() == 0 then
                    self:get_children_by_id("background_role")[1].forced_width = dpi(9)
                else
                    self:get_children_by_id("background_role")[1].forced_width = dpi(9)
                end
            end,
        },

        buttons = {
            awful.button({}, 1, function(t) t:view_only() end),
            awful.button({}, 4, function(t) awful.tag.viewprev(t.screen) end),
            awful.button({}, 5, function(t) awful.tag.viewnext(t.screen) end)
        },
    }
    
    local clock = wibox.widget {
        widget = wibox.container.background,
        shape = helpers.rrect(8),
        bg = beautiful.bg,
        {
            widget = wibox.container.margin,
            margins = 4,
            {
                widget = wibox.widget.textclock,
                format = helpers.colorizeText("%I : %M", beautiful.fg_color),
                align = "center",
                valign = "center",
            },
        },
    }
    
    hover.add(clock)

    local layoutbox = awful.widget.layoutbox {
        screen = s,
        buttons = {
            awful.button({ }, 1, function() awful.layout.inc(1) end),
            awful.button({ }, 3, function() awful.layout.inc(-1) end),
            awful.button({ }, 4, function() awful.layout.inc(-1) end),
            awful.button({ }, 5, function() awful.layout.inc(1) end),
        }
    }

    s.bar:setup {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        {
            layout = wibox.layout.fixed.horizontal,
            spacing = dpi(12),
            {
                widget = wibox.container.margin,
                margins = dpi(4),
                menu
            },
            tasklist
        },
        {
            layout = wibox.layout.flex.vertical,
            {
                widget = wibox.container.margin,
                margins = { top = 10, bottom = 4 },
                taglist
            },
            {
                widget = wibox.container.place,
                {
                    widget = wibox.container.margin,
                    margins = { bottom = 4 },
                    layoutbox
                },
            },
        },
        {
            widget = wibox.container.margin,
            margins = dpi(8),
            {
                layout = wibox.layout.fixed.horizontal,
                spacing = dpi(6),
                {
                    widget = wibox.widget.systray
                },
                clock,
            },
        },
    }

    local function hide_bar(c)
		if c.fullscreen or c.maximized then
			c.screen.bar.visible = false
		else
			c.screen.bar.visible = true
		end
	end

	local function show_bar(c)
		if c.fullscreen or c.maximized then
			c.screen.bar.visible = true
		end
	end

    client.connect_signal("property::fullscreen", hide_bar)
	client.connect_signal("request::unmanage", show_bar)
end