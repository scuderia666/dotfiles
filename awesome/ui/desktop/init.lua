local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local filesystem = require("gears.filesystem")

local helpers = require("modules.helpers")
local popup = require("ui.desktop.popup")
local json = require("modules.json")
local rubato = require("modules.rubato")

local data = helpers.readJson(gears.filesystem.get_cache_dir() .. "settings.json")
local inspect = require("modules.inspect")
local dpi = beautiful.xresources.apply_dpi

local desktop_file = gears.filesystem.get_cache_dir() .. "desktop.json"

local icon_path = "/home/satou/.local/share/icons/Papirus/48x48/"
local mime_path = icon_path .. "mimetypes/"
local places_path = icon_path .. "places/"

--local appicons = helpers.readJson(gears.filesystem.get_cache_dir() .. "settings.json").iconTheme .. "/"
--local foldericons =  helpers.readJson(gears.filesystem.get_cache_dir() .. "settings.json").iconTheme .."/places/48"

local grid = wibox.widget {
  forced_num_rows = 8,
  forced_num_cols = 14,
  orientation = "horizontal",
  layout = wibox.layout.grid
}

local manual = wibox.layout {
  layout = wibox.layout.manual
}

local icons = {
  ["lua"] = "lua",
  ["py"] = "python",
  ["rs"] = "rust",
  ["html"] = "html",
  ["c"] = "c",
  ["c++"] = "c++",
  ["js"] = "javascript",
  ["hs"] = "haskell",
  ['go'] = "go",
  ["php"] = "php",
  ["rb"] = "ruby",
  ["md"] = "markdown",
  ["ts"] = "typescript",
  ["scss"] = "sass",
  ["sass"] = "sass",
  ["java"] = "java",
}

local desktopdisplay = wibox {
  visible = true,
  screen = s,
  ontop = false,
  bg = beautiful.base .. "00",
  type = "desktop",
  widget = wibox.widget {
    {
      grid,
      margins = dpi(20),
      widget = wibox.container.margin,
      buttons = {
            awful.button({}, 4, function(t) awful.tag.viewprev(t.screen) end),
            awful.button({}, 5, function(t) awful.tag.viewnext(t.screen) end),

            awful.button({ "Mod4" }, 4, function(t) awful.tag.viewprev(t.screen) end),
            awful.button({ "Mod4" }, 5, function(t) awful.tag.viewnext(t.screen) end)
        },
    },
    manual,
    layout = wibox.layout.stack
  },
}

awful.placement.maximize(desktopdisplay)

local function get_icon()
    local script = filesystem.get_configuration_dir() .. "/scripts/find-icon.py"
end

local function gridindexat(y, x)
  local margin = dpi(30)
  local cellwidth, cellheight = dpi(115), dpi(105)

  local row = math.ceil((y - margin) / cellheight)
  row = math.min(row, 8)
  row = math.max(row, 1)

  local col = math.ceil((x - margin) / cellwidth)
  col = math.min(col, 16)
  col = math.max(col, 1)

  return row, col
end

function get_element_at(x, y)
  local w = grid:get_widgets_at(x, y)
  return w and w[1] or nil
end

function draw_selector()
  local start_pos = mouse.coords()
  if not mousegrabber.isrunning() then
    local selector = wibox.widget {
      widget = wibox.container.background,
      bg = beautiful.overlay0,
      opacity = 0.4,
      --border_color = "#8f083d",
      --border_width = dpi(4),
      forced_width = 0,
      forced_height = 0,
      x = start_pos.x - mouse.screen.geometry.x,
      y = start_pos.y - mouse.screen.geometry.y,
      visible = true,
    }
    selector.point = { x = start_pos.x - mouse.screen.geometry.x, y = start_pos.y - mouse.screen.geometry.y }
    manual:add(selector)
    mousegrabber.run(function(m)
      if m.buttons[1] then
        selector.visible = true
      end
      if not m.buttons[1] then
        mousegrabber.stop()
        timed = rubato.timed {
            intro = 0.1,
            duration = 0.3,
            easing = rubato.quadratic,
            pos = 0.4,
            subscribed = function(val)
                selector.opacity = val
                if val == 0 then
                  selector.visible = false
                  manual:reset()
                end
            end
        }
        timed.target = 0
      end
      local dx = m.x - start_pos.x
      local dy = m.y - start_pos.y
      local gx, gy = gridindexat(math.abs(dy), math.abs(dx))
      selector.forced_width = math.abs(dx)
      selector.forced_height = math.abs(dy)
      if dx < 0 then
        selector.x = start_pos.x - mouse.screen.geometry.x + dx
        selector.point.x = start_pos.x - mouse.screen.geometry.x + dx
        gx, gy = gridindexat(selector.point.y, selector.point.x)
      end
      if dy < 0 then
        selector.y = start_pos.y - mouse.screen.geometry.y + dy
        selector.point.y = start_pos.y - mouse.screen.geometry.y + dy
        gx, gy = gridindexat(selector.point.y, selector.point.x)
      end
      local w = get_element_at(gx, gy)
      if w then
        w.bg = gears.color('#0ffff088')
        w.border_color = gears.color('#0ffff0')
      end
      return m.buttons[1]
    end, 'left_ptr')
  end
end

local function gen()
  local shortcuts = {}
  local folders = {}
  local files = {}
  local entries = {}

  table.insert(entries,
    { icon = places_path .. "trashcan_empty.svg", label = "Trash", exec = "thunar trash:/", type = "general" })

  for entry in io.popen([[ls ~/Desktop | sed '']]):lines() do
    local label = entry
    local exec = nil
    local icon = mime_path .. "text-x-generic.svg"
    local ext = label:match("^.+(%..+)$")

    if ext == ".desktop" then
      for line in io.popen("cat ~/Desktop/" .. entry):lines() do
        if line:match("Name=") and label == entry then
          label = line:gsub("Name=", "")
        end
        if line:match("Exec=") and exec == nil then
          local cmd = line:gsub("Exec=", "")
          exec = cmd
        end
        if line:match("CustomIcon=") then
          icon = line:gsub("CustomIcon=", "")
        elseif line:match("Icon=") then
            icon = icon_path .. "apps/" .. line:gsub("Icon=", "") .. ".svg"
        end
      end
      table.insert(entries, { icon = icon, label = label, exec = exec, type = "shortcut" })
    elseif os.execute("cd ~/Desktop/" .. entry) then
      icon = places_path .. "folder.svg"
      exec = "thunar ~/Desktop/" .. entry
      table.insert(entries, { icon = icon, label = label, exec = exec, type = "folder" })
    elseif os.execute("wc -c < ~/Desktop/" .. entry) then
      icon = mime_path .. "application-x-zerosize.svg"
      exec = "geany ~/Desktop/" .. entry
      if string.match(entry, "%.") then
        local extension = helpers.split(entry, ".")
        extension = extension[#extension]
        if extension == "jpg" or extension == "jpeg" or extension == "tiff" or extension == "png" or extension == "webp" or extension == "svg" then
          if extension == "jpg" then
            icon = mime_path .. "image-jpeg.svg"
          else
            icon = mime_path .. "image-" .. extension .. ".svg"
          end
          exec = "feh ~/Desktop/" .. entry
        elseif extension == "mp4" or extension == "avif" or extension == "webm" or extension == "mkv" or extension == "mov" then
          icon = mime_path .. "media-video.svg"
        elseif extension == "mp3" or extension == "wav" or extension == "flac" or extension == "aiff" then
          icon = mime_path .. "media-audio.svg"
        elseif icons[extension] ~= nil then
          icon = mime_path .. "text-x-" .. icons[extension] .. ".svg"
        end
      end
      table.insert(entries, { icon = icon, label = label, exec = exec, type = "file" })
    else
      exec = "xdg-open ~/Desktop/" .. label
      table.insert(entries, { icon = icon, label = label, exec = exec, type = "file" })
    end
  end
  return entries
end

local function save()
  layout = {}

  for i, widget in ipairs(grid.children) do
    local pos = grid:get_widget_position(widget)

    layout[i] = {
      row = pos.row,
      col = pos.col,
      widget = {
        icon = widget.icon,
        label = widget.label,
        exec = widget.exec,
        type = widget.type,
      }
    }
  end

  local w = assert(io.open(desktop_file, "w"))
  w:write(json.encode(layout, nil, { pretty = true, indent = "	", align_keys = false, array_newline = true }))
  w:close()
end

local function createicon(icon, label, exec, ty)
  local widget = wibox.widget {
    {
      {
        {
          image = icon,
          halign = "center",
          widget = wibox.widget.imagebox
        },
        strategy = "exact",
        width = dpi(50),
        height = dpi(40),
        widget = wibox.container.constraint
      },
      {
        {
          {
            markup = helpers.colorizeText(label, beautiful.text),
            valign = "top",
            font = "terminuss 11",
            align = "center",
            widget = wibox.widget.textbox
          },
          margins = dpi(5),
          widget = wibox.container.margin
        },
        strategy = "max",
        width = dpi(100),
        height = dpi(50),
        widget = wibox.container.constraint
      },
      spacing = dpi(5),
      layout = wibox.layout.fixed.vertical
    },
    icon = icon,
    label = label,
    exec = exec,
    type = ty,
    forced_width = dpi(115),
    forced_height = dpi(105),
    margins = dpi(10),
    widget = wibox.container.margin
  }

  local iconmenu = awful.menu({
    items = {
      { "Open", exec },
      --[[{ "Delete", function()
        awful.spawn.with_shell("rm -rf " .. os.getenv("HOME") .. "/Desktop/" .. label)
      end },]]--
    }
  })

  awesome.connect_signal("iconmenu::hide", function()
    iconmenu:hide()
  end)

  widget:connect_signal("button::press", function(_, _, _, button)
    if not mousegrabber.isrunning() then
      local heldwidget = wibox.widget {
        {
          {
            image = icon,
            opacity = 0.5,
            halign = "center",
            widget = wibox.widget.imagebox
          },
          strategy = "exact",
          width = dpi(50),
          height = dpi(50),
          widget = wibox.container.constraint
        },
        {
          {
            {
              text = label,
              opacity = 0.5,
              valign = "top",
              align = "center",
              widget = wibox.widget.textbox
            },
            margins = dpi(5),
            widget = wibox.container.margin
          },
          strategy = "max",
          width = dpi(100),
          height = dpi(50),
          widget = wibox.container.constraint
        },
        forced_height = dpi(105),
        forced_width = dpi(100),
        spacing = dpi(5),
        visible = false,
        layout = wibox.layout.fixed.vertical
      }

      local startpos = mouse.coords()
      heldwidget.point = { x = startpos.x, y = startpos.y }
      local oldpos = grid:get_widget_position(widget)
      manual:add(heldwidget)

      mousegrabber.run(function(mouse)
        if (math.abs(mouse.x - startpos.x) > 10 or
              math.abs(mouse.y - startpos.y) > 10) and
            mouse.buttons[1] then
          grid:remove(widget)
          heldwidget.visible = true

          manual:move_widget(heldwidget, {
            x = mouse.x - dpi(50),
            y = mouse.y - dpi(50)
          })
        end

        if not mouse.buttons[1] then
          if button == 1 then
            if heldwidget.visible then
              heldwidget.visible = false

              local newrow, newcol = gridindexat(
                mouse.y,
                mouse.x
              )
              if not grid:get_widgets_at(newrow, newcol) then
                grid:add_widget_at(widget, newrow, newcol)
                save()
              else
                local d = helpers.readJson(desktop_file)
                local elem
                for _, j in ipairs(d) do
                  if j.row == newrow and j.col == newcol then
                    elem = j
                    break
                  end
                end
                if elem.widget.exec:find("thunar Desktop") then
                  if exec ~= "Trash" then
                    os.execute("mv ~/Desktop/" .. label .. " ~/Desktop/" .. elem.widget.label .. "/" .. label)
                  end
                elseif elem.widget.exec:find("thunar trash:/") then
                  if exec ~= "Trash" then
                    os.execute("trash ~/Desktop/" .. label)
                  end
                else
                  grid:add_widget_at(widget, oldpos.row, oldpos.col)
                end
              end
            else
              awful.spawn.with_shell(exec)
              manual:reset()
            end
            mousegrabber.stop()
          elseif button == 3 then
            awesome.emit_signal("iconmenu::hide")
            iconmenu:toggle()
            mousegrabber.stop()
          end
        end
        return mouse.buttons[1]
      end, "hand2")
    end
  end)

  return widget
end

local function load()
  if not gears.filesystem.file_readable(desktop_file) then
    local entries = gen()
    for _, entry in ipairs(entries) do
      grid:add(createicon(entry.icon, entry.label, entry.exec, entry.type))
    end
    save()
  else
    local r = assert(io.open(desktop_file, "rb"))
    local t = r:read("*all")
    r:close()

    local layout = json.decode(t)
    for _, entry in ipairs(layout) do
      grid:add_widget_at(createicon(entry.widget.icon, entry.widget.label, entry.widget.exec, entry.type), entry.row, entry.col)
    end
  end

  local awmmenu = {
    { "Restart", awesome.restart }
  }

  local createmenu = {
    { "File", function()
      local filename = "New File"
      local filepath = os.getenv("HOME") .. "/Desktop/" .. filename
      local i = 1
      while gears.filesystem.file_readable(filepath) do
        filename = "New File " .. "(" .. i .. ")"
        filepath = os.getenv("HOME") .. "/Desktop/" .. filename
        i = i + 1
      end
      awful.spawn.with_shell("touch '" .. filepath .. "'")
    end },
    { "Folder", function()
      local foldername = "New Folder"
      local folderpath = os.getenv("HOME") .. "/Desktop/" .. foldername
      local i = 1
      while gears.filesystem.dir_readable(folderpath) do
        foldername = "New Folder " .. "(" .. i .. ")"
        folderpath = os.getenv("HOME") .. "/Desktop/" .. foldername
        i = i + 1
      end
      gears.filesystem.make_directories(folderpath)
    end }
  }

  manual:buttons {
    awful.button({}, 1, function()
      awesome.emit_signal("iconmenu::hide")
      awesome.emit_signal("close::menu")
      draw_selector()
    end),
    awful.button({}, 3, function()
      awesome.emit_signal("iconmenu::hide")
      awesome.emit_signal("toggle::menu")
    end)
  }
end

load()

awesome.connect_signal("signal::desktop", function(type)
  local entries = gen()
  local check = false

  if type == add then
    for _, entry in ipairs(entries) do
      for _, widget in ipairs(grid.children) do
        if entry.label == widget.label then
          check = true
        end
      end
      if check == false then
        grid:add(createicon(entry.icon, entry.label, entry.exec, entry.type))
      end
      check = false
    end
  end

  if type == remove then
    for _, widget in ipairs(grid.children) do
      for _, entry in ipairs(entries) do
        if entry.label == widget.label then
          check = true
        end
      end
      if check == false then
        grid:remove(widget)
      end
      check = false
    end
  end

  save()
end)

local subscribe = [[
   bash -c "
   while (inotifywait -m -e close_write -e delete -e create -e moved_from $HOME/Desktop/ -q) do echo; done
"]]

awful.spawn.easy_async_with_shell(
  "ps x | grep \"inotifywait -m -e close_write -e delete -e create -e moved_from $HOME/Desktop/ -q\" | awk '{print $1}' | xargs kill",
  function()
    awful.spawn.with_line_callback(subscribe, {
      stdout = function(l)
        awesome.emit_signal("signal::desktop")
      end
    })
  end
)
