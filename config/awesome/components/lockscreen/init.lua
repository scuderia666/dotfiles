local gfs = require("gears.filesystem")

local lock_screen = {}

package.cpath = package.cpath .. ";" .. gfs.get_configuration_dir() .. "lib/?.so;"

lock_screen.init = function()
	local pam = require("liblua_pam")
	lock_screen.authenticate = function(password)
		return pam.auth_current_user(password)
	end
	require("components.lockscreen.lock")
end

return lock_screen