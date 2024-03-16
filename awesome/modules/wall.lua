local awful = require("awful")
local gears = require("gears")
local filesystem = require("gears.filesystem")
local beautiful = require("beautiful")

local wall = {}

wall.wallpapers = filesystem.get_configuration_dir().. "/stuff/wallpapers/"

wall.wallpaperList = {}

wall.count = 0
wall.current = 1

wall.getindexofwall = function(wallpaper)
    for k,v in pairs(wall.wallpaperList) do
        if string.find(v, wallpaper) then
            return k
        end
    end
    return wall.current
end

wall.get_wallpaper = function(name)
	local wallpaper = wall.wallpapers .. name
	if gears.filesystem.file_readable(wallpaper) then
		return wallpaper
	end
	return nil
end

wall.refresh = function()
    local wall_name = nil
    if wall.wallpaperList ~= nil then
        wall_name = wall.wallpaperList[wall.current]
    end

    local directory = wall.wallpapers
    local i, fileList, popen = 0, {}, io.popen
    for filename in popen([[find "]] ..directory.. [[" -type f]]):lines() do
        i = i + 1
        fileList[i] = filename
    end

    wall.count = i

    local index = 1

    if wall_name ~= nil then
        index = wall.getindexofwall(wall_name)
    end

    wall.wallpaperList = fileList

    wall.current = index
end

wall.apply_wallpaper = function(wallpaper)
    if wallpaper == nil then
        return
    end

    for s in screen do
        gears.wallpaper.maximized(wallpaper, s, false)
    end
end

wall.set_wallpaper = function(wallpaper)
    wall.current = wall.getindexofwall(wallpaper)

    wall.update()
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
    wall.apply_wallpaper(wall.wallpaperList[wall.current])
end

wall.rand = function()
	local number = math.random(1, #wall.wallpaperList)
	wall.apply_wallpaper(wall.wallpaperList[number])
	wall.current = number
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
