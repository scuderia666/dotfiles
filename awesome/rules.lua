local awful = require("awful")
local beautiful = require("beautiful")
local ruled = require("ruled")

ruled.client.connect_signal("request::rules", function()

    ruled.client.append_rule {
        id = "global",
        rule = {},
        properties = {
            focus               = awful.client.focus.filter,
            raise               = true,
            size_hints_honor    = false,
            screen              = awful.screen.preferred,
            titlebars_enabled   = true,
            placement           = awful.placement.centered + awful.placement.no_overlap + awful.placement.no_offscreen
        }
    }

    ruled.client.append_rule {
        id          = "tasklist_order",
        rule        = {},
        properties  = {},
        callback    = awful.client.setslave
    }

end)