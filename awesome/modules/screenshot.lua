-----------------------
-- screenshot script --
-----------------------
-- Uses maim, cat and xclip. I was gonna use awful.screenshot
-- but I ended up giving up because it's buggy as hell.

-- Imports
----------
local awful     = require('awful')
local beautiful = require('beautiful')
local naughty   = require('naughty')

local gears     = require('gears')
local def_image = 
    gears.color.recolor_image(
    gears.filesystem.get_configuration_dir() .. "themes/assets/notification/image.svg",
    beautiful.notification_accent)

-- Screenshot
-------------
local function send_notif(temp_file)
    -- Actions
    ----------
    local ok   = naughty.action { name = "Ok" }

    -- Save to permanent file
    local save = naughty.action { name = "Save" }
    save:connect_signal('invoked', function()
        awful.spawn.easy_async_with_shell("cp " .. temp_file .. " " .. beautiful.screenshot_dir, function()
            naughty.notify {
                icon  = def_image,
                title = "Screenshot",
                text  = "Saved to " .. beautiful.screenshot_dir,
                actions = { ok }
            }
        end)
    end)

    -- Remove temporary file
    local discard = naughty.action { name = "Discard" }
    discard:connect_signal('invoked', function()
        awful.spawn.easy_async_with_shell("rm " .. temp_file, function()
            naughty.notify {
                icon  = def_image,
                title = "Screenshot",
                text  = "Temporary file removed",
                actions = { ok }
            }
        end)
    end)

    awful.spawn.easy_async_with_shell(
        "[ -e '" .. temp_file .. "' ] && echo exists", function(output)
            if output:match('%w+') then
                naughty.notify {
                    icon  = temp_file,
                    title = "Screenshot",
                    text  = "Copied to clipboard!",
                    actions = { save, discard }
                }
            else
                naughty.notify {
                    icon  = def_image,
                    title = "Screenshot",
                    text  = "Cancelled!",
                    actions = { ok }
                }
            end
    end)
end

-- Fullscreen screenshot
awesome.connect_signal("screenshot::fullscreen", function()
    local temp_file = "/tmp/ss-" .. os.date("%Y%m%d-%H%M%S") .. ".png"
    awful.spawn.easy_async_with_shell("maim " .. temp_file, function()
        awful.spawn.with_shell("cat " .. temp_file .. " | xclip -se c -t image/png -i")
        send_notif(temp_file)
    end)
end)

-- Selection screenshot
awesome.connect_signal("screenshot::selection", function()
    local temp_file = "/tmp/ss-" .. os.date("%Y%m%d-%H%M%S") .. ".png"
    awful.spawn.easy_async_with_shell("maim -s " .. temp_file, function()
        awful.spawn.with_shell("cat " .. temp_file .. " | xclip -se c -t image/png -i")
        send_notif(temp_file)
    end)
end)
