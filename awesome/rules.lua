local awful = require("awful")
local beautiful = require("beautiful")
local ruled = require("ruled")

ruled.client.connect_signal("request::rules", function()

    ruled.client.append_rule {
        id = "global",
        rule = {},
        properties = {
            focus = awful.client.focus.filter,
            raise = true,
            floating = false,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
        }
    }

    ruled.client.append_rule {
        id         = "dialog",
        rule_any   = {
            type  = { "dialog", "splash" },
            name = {"Discord Updater"}
        },
        properties = {
            floating = true,
            ontop = true,
            placement = awful.placement.centered
        }
    }

end)