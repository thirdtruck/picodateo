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
  printh "not implemented"
end

menu_x = 0
menu_y = 40
menu_col = 7

script_start = {
  text = "welcome to picodateo",
  options = {
    {
      text = "new game",
      script = {
        text = "hello, new user",
        options = {
          {
            text = "first option",
            script = {
              text = "you've chosen the first option",
              options = {
                { text = "third option" }
              }
            }
          },
          {
            text = "second option",
            script = {
              text = "you've chosen the second option",
              options = {
                { text = "fourth option" }
              }
            }
          }
        }
      }
    }
  }
}

function _init()
  choice = 1
  current_script = script_start
end

function script_update(script)
  if (btnp(key.up)) choice -= 1
  if (btnp(key.down)) choice += 1

  -- wrap around
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

function _draw()
  cls()

  draw_script(current_script)
end
