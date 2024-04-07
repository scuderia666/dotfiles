local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require("modules.helpers")
local util = require("util")
local hover = util.hover
local rubato = require("modules.rubato")

local brightness_module = require("modules.brightness")
local volume_module = require("modules.volume")

local tasklist_buttons = gears.table.join(
    --[[awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal("request::activate", "tasklist", {raise = true})
        end
    end),]]--
    awful.button({}, 2, function(c)
        c:kill()
    end),
    awful.button({}, 4, function()
        awful.client.focus.byidx(1)
    end),
    awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end)
)

awful.screen.connect_for_each_screen(function(s)
    local screen_height = s.geometry.height

    s.bar = awful.wibar({
        screen = s,
		position = "bottom",
		type = "dock",
		ontop = true,
		visible = true,
		height = dpi(36),
        width = s.geometry.width,
        bg = beautiful.crust,
	})

    local menu = wibox.widget {
        widget = wibox.container.background,
        bg = beautiful.base,
        shape = helpers.rrect(16),
        {
            widget = wibox.container.margin,
            margins = dpi(10),
            {
                widget = wibox.widget.imagebox,
                image = beautiful.images .. "void.svg",
            },
        },
        buttons = {
            awful.button({}, 1, function()
                awesome.emit_signal("menu::toggle")
            end)
        },
    }

    local task = awful.widget.tasklist {
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = tasklist_buttons;
		layout = {
			spacing = dpi(4),
			layout = wibox.layout.fixed.horizontal,
		},
        widget_template = {
            layout = wibox.layout.fixed.vertical,
            spacing = dpi(4),
            {
                widget = wibox.container.margin,
                awful.widget.clienticon,
                id = "icon",
                --forced_height = 32,
                --forced_width = 32,
                margins = 7,
                opacity = 1,
			},
            --[[{
                widget = wibox.container.place
                {
                    widget = wibox.container.background,
                    forced_height = dpi(5),
                    forced_width = dpi(dpi(38) / 2.2),
                    id = "pointer",
                    shape = gears.shape.rounded_rect,
                    bg = beautiful.red,
                },
            },]]--
            
            create_callback = function(self, c, index, objects)

            end,

            update_callback = function(self, c, _, __)
                collectgarbage("collect")

				if c.active then
					self:get_children_by_id("icon")[1].opacity = 1
					--self:get_children_by_id("pointer")[1].forced_width = dpi(dpi(38) / 2.2)
					--self:get_children_by_id("pointer")[1].bg = beautiful.bg
				elseif c.minimized then
					self:get_children_by_id("icon")[1].opacity = 0.55
					--self:get_children_by_id("pointer")[1].forced_width = 6
					--self:get_children_by_id("pointer")[1].bg = beautiful.bg2
				else
					self:get_children_by_id("icon")[1].opacity = 1
					--self:get_children_by_id("pointer")[1].forced_width = 6
					--self:get_children_by_id("pointer")[1].bg = beautiful.bg
				end
            end
        }
	}
    
    local taglist = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        layout = {
            layout = wibox.layout.fixed.horizontal,
            spacing = dpi(8)
        },
        widget_template = {
            id = "background_role",
            shape = helpers.rrect(20),
            forced_height = dpi(8),
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
    
    local tags = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        style = {
            shape = gears.shape.rounded_bar,
        },
        layout = {
            spacing = 10,
            layout = wibox.layout.fixed.horizontal,
        },
        buttons = {
            awful.button({}, 1, function (t)
                t:view_only()
            end),
            awful.button({}, 4, function (t)
                awful.tag.viewprev(t.screen)
            end),
            awful.button({}, 5, function (t)
                awful.tag.viewnext(t.screen)
            end)
        },
        widget_template = {
            {
                markup = '',
                widget = wibox.widget.textbox,
            },
            id = 'background_role',
            forced_height = 7,
            forced_width = 17,
            widget = wibox.container.background,
            create_callback = function (self, tag)
                self.animate = rubato.timed {
                    duration = 0.15,
                    subscribed = function (h)
                        self:get_children_by_id('background_role')[1].forced_width = h
                    end
                }

                self.update = function ()
                    if tag.selected then
                        self.animate.target = 18
                    elseif #tag:clients() > 0 then
                        self.animate.target = 14
                    else
                        self.animate.target = 8
                    end
                end

                self.update()
            end,
            update_callback = function (self)
                self.update()
            end,
        }
    }

    local clock = wibox.widget {
        widget = wibox.widget.textclock,
        format = helpers.colorizeText("%I : %M", "#cdd6f4"),
        font = "Roboto 11",
        align = "center",
        valign = "center",
    }

    local layoutbox = awful.widget.layoutbox {
        screen = s,
        buttons = {
            awful.button({}, 1, function() awful.layout.inc(1) end),
            awful.button({}, 3, function() awful.layout.inc(-1) end),
            awful.button({}, 4, function() awful.layout.inc(-1) end),
            awful.button({}, 5, function() awful.layout.inc(1) end),
        }
    }
    
    local showdesktop = wibox.widget {
        widget = wibox.container.background,
        bg = beautiful.base,
        forced_width = 12,
        forced_height = 4,
        buttons = {
            awful.button({}, 1, function()
                for _, c in ipairs(client.get()) do
                    c.minimized = not c.minimized
                end
            end)
        },
    }

    local seperator = wibox.widget {
        widget = wibox.container.background,
        bg = beautiful.surface2,
        forced_width = 1,
    }

    local volume = wibox.widget {
        widget = wibox.widget.imagebox,
        image = beautiful.images .. "volume.svg",
        buttons = {
            awful.button({}, 4, function(t) volume_module.volume_up() end),
            awful.button({}, 5, function(t) volume_module.volume_down() end)
        },
    }
    
    local brightness = wibox.widget {
        widget = wibox.widget.imagebox,
        image = beautiful.images .. "brightness.svg",
        buttons = {
            awful.button({}, 4, function(t) brightness_module.brightness_up() end),
            awful.button({}, 5, function(t) brightness_module.brightness_down() end)
        },
    }

    s.bar:setup {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        {
            layout = wibox.layout.fixed.horizontal,
            spacing = dpi(6),
            menu,
            task,
        },
        {
            tags,
            halign = "center",
            valign = "center",
            layout = wibox.container.place,
        },
        {
            widget = wibox.container.margin,
            margins = 8,
            {
                layout = wibox.layout.fixed.horizontal,
                spacing = dpi(6),
                wibox.widget.systray,
                seperator,
                --volume,
                --brightness,
                --seperator,
                clock,
            },
        }
    }
end)
