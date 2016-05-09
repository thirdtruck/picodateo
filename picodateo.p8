pico-8 cartridge // http://www.pico-8.com
version 7
__lua__

-- constants
key = {
  left = 0,
  right = 1,
  up = 2,
  down = 3,
  a = 4,
  b = 5
}

screen = {
  width = 128,
  height = 128
}

function not_implemented()
  printh "Not implemented"
end

start_menu = {}
start_menu.index = 1
start_menu.options = {
  "new",
  "load",
  "settings"
}
start_menu.functions = {
  not_implemented,
  not_implemented,
  function () go_to_menu(settings_menu) end
}

settings_menu = {}
settings_menu.index = 2
settings_menu.options = {
  "back"
}
settings_menu.functions = {
  function () go_to_menu(start_menu) end
}

menus = {}
menus[1] = start_menu
menus[2] = settings_menu

menu_x = 0
menu_y = 40
menu_col = 7

function _init()
  scanline_index = 0
  go_to_menu(start_menu)
end

function go_to_menu(new_menu)
  menu = menus[new_menu.index]
  menu_index = new_menu.index
  choice = 1
end

function scanline_update()
  scanline_index += 1
  if (scanline_index > screen.height) then scanline_index = 0 end
end

function menu_update()
  if (btnp(key.up)) choice -= 1
  if (btnp(key.down)) choice += 1

  -- Wrap around
  if (choice > #(menu.options)) then
    choice = 1
  elseif (choice < 1) then
    choice = #(menu.options)
  end

  if (btnp(key.a)) then
    menu.functions[choice]()
  end
end

function _update()
  scanline_update()

  menu_update()
end

function draw_menu()
  color(7)

  print("", menu_x, menu_y, menu_col)

  i = 1
  while i <= #(menu.options) do
    if i == choice then
      print("* "..menu.options[i])
    else
      print("  "..menu.options[i])
    end
    i += 1
  end
end

function draw_scanline()
  color(2)
  line(0, scanline_index-3, screen.width, scanline_index-3)
  line(0, scanline_index+3, screen.width, scanline_index+3)

  color(14)
  line(0, scanline_index-2, screen.width, scanline_index-2)
  line(0, scanline_index-1, screen.width, scanline_index-1)
  line(0, scanline_index+1, screen.width, scanline_index+1)
  line(0, scanline_index+2, screen.width, scanline_index+2)

  color(15)
  line(0, scanline_index, screen.width, scanline_index)
end

-- Flash a word over the first menu option when the scanline passes over it.
function draw_kinky()
  if ((scanline_index > menu_y - 2) and (scanline_index < menu_y + 2)) then
    color(0)
    print("  kinky", menu_x, menu_y, menu_col)
  end
end

function _draw()
  cls()

  draw_menu()

  draw_scanline()

  draw_kinky()
end
