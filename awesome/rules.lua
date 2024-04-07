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
            placement = awful.placement.centered + awful.placement.no_offscreen
        }
    }

    ruled.client.append_rule {
        rule_any = {
            name = { "Discord", "Waterfox" },
            class = { "gimp-2.10" }
        },
        except_any = {
            name = { "Discord Updater" },
            type = { "dialog" }
        },
        properties = { floating = false }
    }

    ruled.client.append_rule {
        rule = {
            class = { "Thunar" }
        },
        except = {
            type = "dialog"
        },
        properties = {
            width = 800,
            height = 500,
        }
    }

end)
