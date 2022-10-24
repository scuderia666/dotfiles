local awful = require("awful")
local beautiful = require("beautiful")

function tablelength(T)
   local count = 0
   for _ in pairs(T) do count = count + 1 end
   return count
end

current=1

themes = {
   "miku"
}
theme = themes[current]
theme_count = tablelength(themes)

themes_dir = dir .. "themes/"

theme_dir = themes_dir .. theme
config_dir = theme_dir .. "/config/"

icon_dir = theme_dir .. "/icons/"
components_dir = "themes." .. theme .. ".components."
widgets_dir = "themes." .. theme .. ".widgets."

function nexttheme()
    local index={}
    for k,v in pairs(themes) do
       index[v]=k
    end
    local val = index[theme]
    if current == theme_count then
        return
    end
    awful.spawn.easy_async_with_shell(dir .. "/config/next-theme.sh " .. current .. " " .. theme_count, false)
    awesome.restart()
end

local theme = require("themes." .. theme)
beautiful.init(theme.theme)
theme.initialize()