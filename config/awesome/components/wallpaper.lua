local gears = require("gears")
local awful = require("awful")

local wallpaper = {}

local theme = theme_name
local config = theme_config
local path = theme_dir .. "/wallpapers/"

local favorite = config.favorite_wallpaper

local wallpaperList

local count = 0
local current = 0

function wallpaper:init()
	favorite_exists = getwallpaper(favorite) ~= nil

	if favorite_exists then
		setwallpaper(getwallpaper(favorite))
	else
		rand()
	end
end

function scanDir(directory)
	local i, fileList, popen = 0, {}, io.popen
	for filename in popen([[find "]] ..directory.. [[" -type f]]):lines() do
	    i = i + 1
		fileList[i] = filename
	end
	count = i
	return fileList
end

function wallpaper:next()
	if current == count then
		current = 0
	end
	setwallpaper(wallpaperList[current + 1])
	current = current + 1
end

function wallpaper:rand()
	local number = math.random(1, #wallpaperList)
	setwallpaper(wallpaperList[number])
	current = number
end

function wallpaper:favorite()
	if favorite_exists then
		setwallpaper(getwallpaper(favorite))
	end
end

function wallpaper:refresh()
	wallpaperList = scanDir(path)
end

function getwallpaper(name)
	local wallpaper = path .. name
	if gears.filesystem.file_readable(wallpaper) then
		return wallpaper
	end
	return nil
end

function setwallpaper(wallpaper)
	gears.wallpaper.maximized(wallpaper, s, true)
end

return wallpaper
