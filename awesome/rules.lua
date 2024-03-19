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
            maximized = false,
            floating = false,
            screen = awful.screen.preferred,
            placement = awful.placement.centered + awful.placement.no_offscreen,
        }
    }

    ruled.client.append_rule {
        rule_any = {
            role = { "Popup" },
            type = { "dialog" },
            class = { "Viewnior", "lite-xl", "mpv" },
        },
        properties = { floating = true }
    }

    ruled.client.append_rule {
        rule_any = {
            name = { "Discord Updater" }
        },
        properties = {
            floating = true,
            ontop = true
        }
    }

    ruled.client.append_rule {
        rule_any = {
            class = { "Alacritty", "Thunar" }
        },
        except = {
            type = "dialog"
        },
        properties = {
            floating = true,
            width = 800,
            height = 500,
        }
    }

end)
