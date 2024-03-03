-------------------------------------------------
-- Wallpaper Widget for Awesome Window Manager
-- Will show a popup with the images and name of the image files in the supplied folder.
-- When a item is selected, the image will be set as the current wallpaper
--
-- @author Wizetux
-- @copyright 2022 Wizetux
-------------------------------------------------

local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")

local wallpaper_widget = {}

local process_rows = {
  layout = wibox.layout.fixed.vertical,
}

local function setWallpaper(file, screen)
  -- for s in screen do
    gears.wallpaper.maximized(file , screen, false)
  -- end
end

local function worker(user_args)

    local args = user_args or {}

    local main_widget = wibox.widget {
        markup = "wallpapers",
        widget = wibox.widget.textbox,
    }

    local popup = awful.popup{
        ontop = true,
        visible = false,
        shape = gears.shape.rounded_rect,
        border_width = 1,
        border_color = beautiful.bg_normal,
        offset = { y = 5 },
        widget = {}
    }

    if (args.directory) then
      awful.spawn.easy_async("ls -1 \"" .. args.directory .. "\"", function (stdout, _, _, _)
        local i = 1
        for file in stdout:gmatch("[^\r\n]+") do
          local fullPath = args.directory .. "/" .. file
          local text_widget = {
            {
              markup = file,
              widget = wibox.widget.textbox
            },
            widget = wibox.container.background
          }

          local widget = wibox.widget {
            {
              image = fullPath,
              resize = true,
              forced_height = 20,
              forced_width = 40,
              widget = wibox.widget.imagebox
            },
            text_widget,
            widget = wibox.layout.fixed.horizontal
          }
          widget:connect_signal("mouse::enter", function(c) c.children[2]:set_bg(beautiful.bg_focus) end)
          widget:connect_signal("mouse::leave", function(c) c.children[2]:set_bg(beautiful.bg_normal) end)
          widget:buttons(
            awful.util.table.join(
              awful.button({}, 1, function()
                setWallpaper(fullPath, popup.screen)
                popup.visible = not popup.visible
              end)
            )
          )
          process_rows[i] = widget
          i = i + 1
        end
        popup:setup {
          process_rows,
          widget = wibox.container.margin
        }
      end)
    end

    main_widget:buttons(
      awful.util.table.join(
        awful.button({}, 1, function()
          if popup.visible then
            popup.visible = not popup.visible
          else
            popup:move_next_to(mouse.current_widget_geometry)
          end
        end)
      )
    )

    wallpaper_widget = wibox.widget {
        main_widget,
        bottom = 2,
        color = "#00000000",
        widget = wibox.container.margin
    }

    return wallpaper_widget
end

return setmetatable(wallpaper_widget, { __call = function(_, ...)
    return worker(...)
end })
