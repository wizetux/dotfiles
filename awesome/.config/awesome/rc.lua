-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")
local cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget")
local ram_widget = require("awesome-wm-widgets.ram-widget.ram-widget")
local batteryarc_widget = require("awesome-wm-widgets.batteryarc-widget.batteryarc")
local net_widgets = require("net_widgets")
local wallpaper_widget = require("wallpaper_widget.wallpaper-widget")

function restore_windows_to_desired_screen(new_screen)
    for _, c in ipairs(client.get()) do
       if not (c.desired_screen == nil) and c.desired_screen ~= new_screen.index then
          tag_name = c.first_tag.name
          c:move_to_screen(c.desired_screen)
          tag = awful.tag.find_by_name(c.screen, tag_name)
          if not (tag == nil) then
             c:move_to_tag(tag)
          end
          -- now clear the "desired_screen"
          c.desired_screen = nil
       end
    end
end

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_configuration_dir() .. "mytheme.lua")

-- beautiful.useless_gap = 4
-- beautiful.gap_single_client = true

-- This is used later as the default terminal and editor to run.
terminal = "ghostty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
Alt = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.floating,
  -- awful.layout.suit.tile.left,
  awful.layout.suit.tile.bottom,
  -- awful.layout.suit.tile.top,
  -- awful.layout.suit.fair,
  -- awful.layout.suit.fair.horizontal,
  -- awful.layout.suit.spiral,
  -- awful.layout.suit.spiral.dwindle,
  -- awful.layout.suit.max,
  -- awful.layout.suit.max.fullscreen,
  -- awful.layout.suit.magnifier,
  -- awful.layout.suit.corner.nw,
  -- awful.layout.suit.corner.ne,
  -- awful.layout.suit.corner.sw,
  -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
  { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
  { "manual", terminal .. " -e man awesome" },
  { "edit config", editor_cmd .. " " .. awesome.conffile },
  { "restart", awesome.restart },
  { "quit", function() awesome.quit() end },
}

internetmenu = {
  { "Firefox", "firefox" },
  { "Chromium", "chromium" },
  { "Teams", "chromium --app=\"https://teams.microsoft.com/v2/\" --profile-directory=\"Profile 1\"" },
  { "Signal", "signal-desktop" },
  { "Discord", "discord" },
  { "Insomnia", "insomnia" },
  { "AnyConnect", "/opt/cisco/anyconnect/bin/vpnui" },
}

multimediaMenu = {
  { "Pavucontrol", "pavucontrol" },
  { "Screenshot", "flameshot" },
  { "Nitrogen", "nitrogen /home/wizetux/wallpaper" }
}

gamesMenu = {
  { "MultiMc", "prismlauncher" },
  { "FTB App", "/Minecraft/FTB/ftb-app-linux-1.27.3-x86_64.AppImage" },
  { "Steam", "steam" }
}

keepassMenu = {
  { "Personal", "keepassxc /home/wizetux/personal.kdbx" },
  { "Work", "keepassxc /home/wizetux/accretivetg.kdbx" },
  { "Yubico Authenticator", "/opt/yubico-authenticator/authenticator" }
}

mymainmenu = awful.menu({ items = { 
  { "open terminal", terminal },
  { "Internet", internetmenu },
  { "Multimedia", multimediaMenu },
  { "Games", gamesMenu },
  { "Keepass", keepassMenu },
  { "awesome", myawesomemenu }
}})

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock(' %a %b %d, %I:%M')

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
  awful.button({ }, 1, function(t) t:view_only() end),
  awful.button({ modkey }, 1, function(t)
    if client.focus then
      client.focus:move_to_tag(t)
    end
  end),
  awful.button({ }, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, function(t)
    if client.focus then
      client.focus:toggle_tag(t)
    end
  end),
  awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
  awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
  awful.button({ }, 1, function (c)
    if c == client.focus then
      c.minimized = true
    else
      c:emit_signal(
        "request::activate",
        "tasklist",
        {raise = true}
      )
    end
  end),
  awful.button({ }, 3, function()
    awful.menu.client_list({ theme = { width = 250 } })
  end),
  awful.button({ }, 4, function ()
    awful.client.focus.byidx(1)
  end),
  awful.button({ }, 5, function ()
    awful.client.focus.byidx(-1)
  end)
)

local function set_wallpaper(s)
  -- Wallpaper
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)
  end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
  -- Wallpaper
  -- set_wallpaper(s)

  -- Each screen has its own tag table.
  awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
  restore_windows_to_desired_screen(s)

  -- Create a promptbox for each screen
  s.mypromptbox = awful.widget.prompt()
  -- Create an imagebox widget which will contain an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  s.mylayoutbox = awful.widget.layoutbox(s)
  s.mylayoutbox:buttons(
    gears.table.join(
      awful.button({ }, 1, function () awful.layout.inc( 1) end),
      awful.button({ }, 3, function () awful.layout.inc(-1) end),
      awful.button({ }, 4, function () awful.layout.inc( 1) end),
      awful.button({ }, 5, function () awful.layout.inc(-1) end)
    )
  )

  -- Create a taglist widget
  s.mytaglist = awful.widget.taglist {
    screen  = s,
    filter  = awful.widget.taglist.filter.all,
    buttons = taglist_buttons
  }

  -- Create a tasklist widget
  s.mytasklist = awful.widget.tasklist {
    screen  = s,
    filter  = awful.widget.tasklist.filter.currenttags,
    buttons = tasklist_buttons
  }

  -- Create the wibox
  s.mywibox = awful.wibar({ position = "bottom", screen = s })

  -- Add widgets to the wibox
  s.mywibox:setup {
    nil,
    s.mytasklist, -- Middle widget
    mytextclock,
    layout = wibox.layout.align.horizontal,
  }

  s.mywibox_top = awful.wibar({ position = "top", screen = s })
  s.mywibox_top:setup {
    layout = wibox.layout.align.horizontal,
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      mylauncher,
      s.mytaglist,
      s.mypromptbox,
    },
    {
      -- Just put in an empty textbox to take up the space
      widget = wibox.widget.textbox,
    },
    { -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      mykeyboardlayout,
      wallpaper_widget({
        directory = "/home/wizetux/wallpaper/"
      }),
      net_widgets.indicator({
        interfaces = {"tun0"},
        timeout = 5,
        hidedisconnected = true,
        skipvpncheck = false
      }),
      cpu_widget(),
      ram_widget(),
      batteryarc_widget({
        show_current_level = true,
        arc_thickness = 1,
      }),
      wibox.widget.systray(),
      s.mylayoutbox,
    },
  }
  end
)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
  awful.button({ }, 3, function () mymainmenu:toggle() end),
  awful.button({ }, 4, awful.tag.viewnext),
  awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
  awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
    {description="show help", group="awesome"}),
  awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
    {description = "view previous", group = "tag"}),
  awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
    {description = "view next", group = "tag"}),
  awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
    {description = "go back", group = "tag"}),
  awful.key( { modkey,           }, "j", 
    function ()
      awful.client.focus.byidx( 1)
    end,
      {description = "focus next by index", group = "client"}
  ),
  awful.key({ modkey,           }, "k",
    function ()
      awful.client.focus.byidx(-1)
    end,
    {description = "focus previous by index", group = "client"}
  ),
  awful.key({ modkey,           }, "w", 
    function () 
      mymainmenu:show() 
    end,
    {description = "show main menu", group = "awesome"}
  ),

  -- Layout manipulation
  awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
  {description = "swap with next client by index", group = "client"}),
  awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
  {description = "swap with previous client by index", group = "client"}),
  awful.key({ modkey }, "o", function () awful.screen.focus_relative( 1) end,
  {description = "focus the next screen", group = "screen"}),
  awful.key({ modkey }, "u", function () awful.screen.focus_relative(-1) end,
  {description = "focus the previous screen", group = "screen"}),
  awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
  {description = "jump to urgent client", group = "client"}),
  awful.key({ modkey,           }, "Tab",
  function ()
    awful.client.focus.history.previous()
    if client.focus then
      client.focus:raise()
    end
  end,
  {description = "go back", group = "client"}),

  -- Standard program
  awful.key({ modkey,           }, "Return", function () awful.spawn(terminal .. " -e tmux-session.sh") end,
  {description = "open a terminal", group = "launcher"}),
  awful.key({ modkey, "Control" }, "r", awesome.restart,
  {description = "reload awesome", group = "awesome"}),
  awful.key({ modkey, "Shift"   }, "q", awesome.quit,
  {description = "quit awesome", group = "awesome"}),
  awful.key({ "Control", Alt }, "l", function () 
    awful.spawn("xscreensaver-command --lock") 
    naughty.notify({ preset = naughty.config.presets.critical,
      title = "Locking screen",
      text = "Screen locked",
      timeout = 5
    })
   end,
  {description = "lock the screen", group = "launcher"}),

  awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
  {description = "increase master width factor", group = "layout"}),
  awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
  {description = "decrease master width factor", group = "layout"}),
  awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
  {description = "increase the number of master clients", group = "layout"}),
  awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
  {description = "decrease the number of master clients", group = "layout"}),
  awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
  {description = "increase the number of columns", group = "layout"}),
  awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
  {description = "decrease the number of columns", group = "layout"}),
  awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
  {description = "select next", group = "layout"}),
  awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
  {description = "select previous", group = "layout"}),

  awful.key({ modkey, "Control" }, "n",
    function ()
      local c = awful.client.restore()
      -- Focus restored client
      if c then
        c:emit_signal(
        "request::activate", "key.unminimize", {raise = true}
        )
      end
    end,
    {description = "restore minimized", group = "client"}),

  -- Prompt
  awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
    {description = "run prompt", group = "launcher"}),

  awful.key({ modkey }, "x",
    function ()
      awful.prompt.run {
        prompt       = "Run Lua code: ",
        textbox      = awful.screen.focused().mypromptbox.widget,
        exe_callback = awful.util.eval,
        history_path = awful.util.get_cache_dir() .. "/history_eval"
      }
    end,
    {description = "lua execute prompt", group = "awesome"}),
  -- Menubar
  awful.key({ modkey }, "p", function() menubar.show() end,
    {description = "show the menubar", group = "launcher"})
)

clientkeys = gears.table.join(
  awful.key({ }, "XF86AudioMute", 
    function ()
      naughty.notify({ preset = naughty.config.presets.critical,
        title = "Toggling audio mute setting",
        text = "Audio Mute",
        timeout = 5
      })
      awful.util.spawn("/home/wizetux/dotfiles/bash/bin/pulseaudio_mute.sh", false) 
    end,
    {description = "toggle fullscreen", group = "audio"}
  ),
  awful.key({ modkey,           }, "f",
    function (c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end,
    {description = "toggle fullscreen", group = "client"}),
  awful.key({ modkey, "Control"   }, "c",
    function (c)
      c:kill()
    end,
    {description = "close", group = "client"}),
  awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle,
    {description = "toggle floating", group = "client"}),
  awful.key({ modkey, "Control" }, "Return", 
    function (c)
      c:swap(awful.client.getmaster())
    end,
    {description = "move to master", group = "client"}),
  awful.key({ modkey, "Control" }, "o",
    function (c)
      c:move_to_screen()
    end,
    {description = "move to screen", group = "client"}),
  awful.key({ modkey,           }, "t",
    function (c)
      c.ontop = not c.ontop
    end,
    {description = "toggle keep on top", group = "client"}),
  awful.key({ modkey,           }, "n",
    function (c)
      -- The client currently has the input focus, so it cannot be
      -- minimized, since minimized clients can't have the focus.
      c.minimized = true
    end ,
    {description = "minimize", group = "client"}),
  awful.key({ modkey,           }, "m",
    function (c)
      c.maximized = not c.maximized
      c:raise()
    end ,
    {description = "(un)maximize", group = "client"}),
  awful.key({ modkey, "Control" }, "m",
    function (c)
      c.maximized_vertical = not c.maximized_vertical
      c:raise()
    end ,
    {description = "(un)maximize vertically", group = "client"}),
  awful.key({ modkey, "Shift"   }, "m",
    function (c)
      c.maximized_horizontal = not c.maximized_horizontal
      c:raise()
    end ,
    {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
  globalkeys = gears.table.join(globalkeys,
  -- View tag only.
  awful.key({ modkey }, "#" .. i + 9,
  function ()
    local screen = awful.screen.focused()
    local tag = screen.tags[i]
    if tag then
      tag:view_only()
    end
  end,
  {description = "view tag #"..i, group = "tag"}),
  -- Toggle tag display.
  awful.key({ modkey, "Control" }, "#" .. i + 9,
  function ()
    local screen = awful.screen.focused()
    local tag = screen.tags[i]
    if tag then
      awful.tag.viewtoggle(tag)
    end
  end,
  {description = "toggle tag #" .. i, group = "tag"}),
  -- Move client to tag.
  awful.key({ modkey, "Shift" }, "#" .. i + 9,
  function ()
    if client.focus then
      local tag = client.focus.screen.tags[i]
      if tag then
        client.focus:move_to_tag(tag)
      end
    end
  end,
  {description = "move focused client to tag #"..i, group = "tag"}),
  -- Toggle tag on focused client.
  awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
  function ()
    if client.focus then
      local tag = client.focus.screen.tags[i]
      if tag then
        client.focus:toggle_tag(tag)
      end
    end
  end,
  {description = "toggle focused client on tag #" .. i, group = "tag"})
  )
end

  clientbuttons = gears.table.join(
  awful.button({ }, 1,
    function (c)
      c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
  awful.button({ "Mod1" }, 1,
    function (c)
      c:emit_signal("request::activate", "mouse_click", {raise = true})
      awful.mouse.client.move(c)
    end),
  awful.button({ "Mod1" }, 3,
    function (c)
      c:emit_signal("request::activate", "mouse_click", {raise = true})
      awful.mouse.client.resize(c)
    end)
  )

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
  -- All clients will match this rule.
  { 
    rule = { },
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = clientkeys,
      buttons = clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap+awful.placement.no_offscreen,
      size_hints_honor = false
    }
  },

  -- Floating clients.
  {
    rule_any = {
      class = {
        "Blueman-manager",
        "calibre"
      },
      -- Note that the name property shown in xprop might be set slightly after creation of the client
      -- and the name shown there might not match defined rules here.
      name = {
        "Event Tester",  -- xev.
      }
    },
    properties = { floating = true }
  },

  -- Add titlebars to normal clients and dialogs
  {
    rule_any = {
      type = {
        "normal", "dialog"
      }
    },
    properties = {
      titlebars_enabled = true
    }
  },

  {
    rule_any = {
      class = {
        "FTB Presents Direwolf20 1.18",
      }
    },
    properties = {
      floating = true,
      screen = 1,
      tag = "4",
      width = 1800,
      hight = 900,
    }
  },

  -- Elite Dangerous Client
  {
    rule_any = {
      class = {
        "steam_app_359320",
      }
    },
    properties = {
      floating = true,
      screen = 1,
      tag = "4",
    }
  },
  {
    rule_any = {
      class = {
        "steamwebhelper",
        "steam",
      }
    },
    properties = {
      screen = 1,
      tag = "4",
    }
  },
  {
    rule_any = {
      class = {
        "discord", "Signal"
      }
    },
    properties = {
      screen = 1,
      tag = "5",
    }
  },
  {
    rule_any = {
      class = {
        "teams.microsoft.com"
      }
    },
    properties = {
      screen = 1,
      tag = "2",
    }
  },
  -- Fallout 4
  { 
    rule_any = {
      class = {
        "steam_app_377160",
      }
    }, 
    properties = {
      maximized = true,
      fullscreen = true,
    }
  },

-- Set Firefox to always map on the tag named "2" on screen 1.
-- { rule = { class = "Firefox" },
--   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage",
  function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
      -- Prevent clients from being unreachable after screen count changes.
      awful.placement.no_offscreen(c)
    end
  end
)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars",
  function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
      awful.button({ }, 1, function()
        c:emit_signal("request::activate", "titlebar", {raise = true})
        awful.mouse.client.move(c)
      end),
      awful.button({ }, 3, function()
        c:emit_signal("request::activate", "titlebar", {raise = true})
        awful.mouse.client.resize(c)
      end),
      awful.button({ }, 4, function()
        c.minimized = true
      end)
    )

    awful.titlebar(c) : setup {
      { -- Left
        awful.titlebar.widget.iconwidget(c),
        buttons = buttons,
        layout  = wibox.layout.fixed.horizontal
      },
      { -- Middle
        { -- Title
          align  = "center",
          widget = awful.titlebar.widget.titlewidget(c)
        },
        buttons = buttons,
        layout  = wibox.layout.flex.horizontal
      },
      { -- Right
        awful.titlebar.widget.floatingbutton (c),
        awful.titlebar.widget.maximizedbutton(c),
        awful.titlebar.widget.stickybutton   (c),
        awful.titlebar.widget.ontopbutton    (c),
        awful.titlebar.widget.closebutton    (c),
        layout = wibox.layout.fixed.horizontal()
      },
      layout = wibox.layout.align.horizontal
    }
  end
)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
  -- c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

-- Handle screen being removed.
-- We'll look for same tag names and move clients there, but preserve
-- the "desired_screen" so we can move them back when it's connected.
tag.connect_signal("request::screen", function(t)
    local fallback_tag = nil

    -- find tag with same name on any other screen
    for other_screen in screen do
        if other_screen ~= t.screen then
            fallback_tag = awful.tag.find_by_name(other_screen, t.name)
            if fallback_tag ~= nil then
                break
            end
        end
    end

    -- no tag with same name exists, use fallback
    if fallback_tag == nil then
        fallback_tag = awful.tag.find_fallback()
    end

    if not (fallback_tag == nil) then
        clients = t:clients()
        for _, c in ipairs(clients) do
           c:move_to_tag(fallback_tag)
           -- preserve info about which screen the window was originally on, so
           -- we can restore it if the screen is reconnected.
           c.desired_screen = t.screen.index
        end
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
gears.timer.start_new(10, function() collectgarbage("collect") return true end)
-- }}}
