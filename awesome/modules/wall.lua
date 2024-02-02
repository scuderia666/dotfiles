local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")

local wall = {}

wall.wallpapers = beautiful.images .. "/wallpapers/"

wall.wallpaperList = {}

wall.count = 0
wall.current = 1

wall.scan_dir = function(directory)
    local i, fileList, popen = 0, {}, io.popen
    for filename in popen([[find "]] ..directory.. [[" -type f]]):lines() do
        i = i + 1
        fileList[i] = filename
    end
    wall.count = i
    return fileList
end

wall.get_wallpaper = function(name)
	local wallpaper = wall.wallpapers .. name
	if gears.filesystem.file_readable(wallpaper) then
		return wallpaper
	end
	return nil
end

wall.set_wallpaper = function(wallpaper)
	gears.wallpaper.maximized(wallpaper, s, true)
end

wall.next = function()
	if wall.current == wall.count then
		wall.current = 1
    else
        wall.current = wall.current + 1
    end
	wall.update()
end

wall.prev = function()
    if wall.current == 1 then
        wall.current = wall.count
    else
        wall.current = wall.current - 1
    end

    wall.update()
end

wall.update = function()
    wall.set_wallpaper(wall.wallpaperList[wall.current])
end

wall.rand = function()
	local number = math.random(1, #wall.wallpaperList)
	wall.set_wallpaper(wall.wallpaperList[number])
	current = number
end

wall.refresh = function()
	wall.wallpaperList = wall.scan_dir(wall.wallpapers)
end

awesome.connect_signal("wallpaper::next", function()
    wall.next()
end)

awesome.connect_signal("wallpaper::prev", function()
    wall.prev()
end)

awesome.connect_signal("wallpaper::rand", function()
    wall.rand()
end)

awesome.connect_signal("wallpaper::refresh", function()
    wall.refresh()
end)

return wall