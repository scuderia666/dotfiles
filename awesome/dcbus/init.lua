local awful = require("awful")

awesome.connect_signal("dcbus::notification", function(id, user, message)
	local s = awful.screen.focused()
	s.notif.show(id, user, message)
end)

awful.screen.connect_for_each_screen(function(s)
	notif = require("dcbus.notif")(s)
	s.notif = notif
end)
