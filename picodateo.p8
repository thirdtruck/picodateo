pico-8 cartridge // http://www.pico-8.com
version 7
__lua__

-- constants
btn_up = 2
btn_dn = 3
btn_a = 4
btn_b = 5

screen_width=128
screen_height=128

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

function _update()
  scanline_index += 1
  if (scanline_index > screen_height) scanline_index = 0

  if (btnp(btn_up)) choice -= 1
  if (btnp(btn_dn)) choice += 1

  -- Wrap around
  if (choice > #(menu.options)) then
    choice = 1
  elseif (choice < 1) then
    choice = #(menu.options)
  end

  if (btnp(btn_a)) then
    menu.functions[choice]()
  end
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
  line(0, scanline_index-3, screen_width, scanline_index-3)
  line(0, scanline_index+3, screen_width, scanline_index+3)

  color(14)
  line(0, scanline_index-2, screen_width, scanline_index-2)
  line(0, scanline_index-1, screen_width, scanline_index-1)
  line(0, scanline_index+1, screen_width, scanline_index+1)
  line(0, scanline_index+2, screen_width, scanline_index+2)

  color(15)
  line(0, scanline_index, screen_width, scanline_index)
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
