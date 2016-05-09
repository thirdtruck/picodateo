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

menu_x = 0
menu_y = 40
menu_col = 7

script_start = {
  text = "Welcome to picodateo",
  options = {
    {
      text = "New Game",
      script = {
        text = "Hello, new user",
        options = {
          {
            text = "First option",
            script = {
              text = "You've chosen the first option",
              options = {
                { text = "Third option" }
              }
            }
          },
          {
            text = "Second option",
            script = {
              text = "You've chosen the second option",
              options = {
                { text = "Fourth option" }
              }
            }
          }
        }
      }
    }
  }
}

function _init()
  scanline_index = 0
  choice = 1
  current_script = script_start
end

function scanline_update()
  scanline_index += 1
  if (scanline_index > screen.height) then scanline_index = 0 end
end

function script_update(script)
  if (btnp(key.up)) choice -= 1
  if (btnp(key.down)) choice += 1

  -- Wrap around
  if (choice > #(script.options)) then
    choice = 1
  elseif (choice < 1) then
    choice = #(script.options)
  end

  if (btnp(key.a)) then
    current_script = script.options[choice].script
    choice = 1
  end
end

function _update()
  scanline_update()

  script_update(current_script)
end

function draw_script(script)
  color(7)

  print("", menu_x, menu_y, menu_col)
  print(script.text)
  print("")

  if(script.options ~= nil) then
    i = 1
    while i <= #(script.options) do
      if i == choice then
        print("* "..script.options[i].text)
      else
        print("  "..script.options[i].text)
      end
      i += 1
    end
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

  draw_script(current_script)

  draw_scanline()

  draw_kinky()
end
