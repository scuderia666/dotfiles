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
            floating = true,
            screen = awful.screen.preferred,
            placement = awful.placement.centered + awful.placement.no_offscreen,
        }
    }
    
    ruled.client.append_rule {
        rule_any = {
            class = { "discord", "Waterfox" },
            name = { "Discord", "Waterfox" },
        },
        properties = { floating = false }
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