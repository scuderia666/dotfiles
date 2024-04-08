local awful = require("awful")
local naughty = require("naughty")
local ruled = require("ruled")

awesome.connect_signal("dcbus::notification", function(id, user, message)
	--local s = awful.screen.focused()
	--s.notif.show(id, user, message)

	local text = user .. ": " .. message
	
	naughty.notify({
		title = "Discord",
		text = text
	})
end)

awful.screen.connect_for_each_screen(function(s)
	notif = require("dcbus.notif")(s)
	s.notif = notif
end)

naughty.connect_signal("request::display", function(n)
	if n.title == "Discord" then
		require("dcbus.notif3")(n)
	else
		require("dcbus.notif2")(n)
	end
end)

ruled.notification.connect_signal("request::rules", function() 
	ruled.notification.append_rule {
		rule = {},
		properties = {
			screen = awful.screen.focused(),
			implicit_timeout = 5,
		}
	}
end)
