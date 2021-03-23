# A--I WAR

### Video Demo: https://www.youtube.com/watch?v=CLrQPF6p2Xk&t=10s

## Description:

A-I WAR is an nostalgic, intergrate, functional programming system inspired from the classic 1972 game Pong from the Atari
2600 vision. Intergrated with a classic 1983 flim callled WAR GAMES. As well as the background music, the theme song of Knight Rider.

The integration is written in LUA using the Microsoft Visual Studio Code for parsing operations, and it can currently 
open in a software called LOVE 2D .

## Playing with A-I WAR
By executing the A-I WAR game, put all the files(list below) into on big file and then drag the file into the app call LOVE 2D:
- [] Sounds
- [] Ball.lua
- [] class.lua
- [] Copytron.lua
- [] font.ttf
- [] main.lua
- [] Paddle.lua
- [] Push.lua

A-I WAR version 1.0
Hi, I am Talisa and this is my version of Pong with some intergrations made especially for you with love.
from one nerdy video game lover to another.
Press 0 or no to Copytron to exit 

A-I WAR> 
You can evaluate main.lua by writing them after Copytron>:
     
    require 'Copytron'

    push = require 'push'

    Class = require 'class'

    require 'Paddle'

    require 'Ball'
      

You probably noticed that it is easier keeping the files neatly organize as well as  all connected in the main.lua.

## Evaluating external files
These prime files that are with in the main files and functions is the heart of the program. ( List Below)

- push.lua
- class.lua
- Paddle.lua
- Ball.lua
Without these prime files, the program itself would not be able to proceed the following program.

#### Push
     local love11 = love.getVersion() == 11
     local getDPI = love11 and love.window.getDPIScale or love.window.getPixelScale
     local windowUpdateMode = love11 and love.window.updateMode or function(width, height, settings)
     local _, _, flags = love.window.getMode()
     for k, v in pairs(settings) do flags[k] = v end
     love.window.setMode(width, height, flags)
    end

    local push = {
  
    defaults = {
     fullscreen = false,
     resizable = false,
     pixelperfect = false,
     highdpi = true,
     canvas = true,
     stencil = true
     }
  
    }
setmetatable(push, push)

#### Class
class.__index = class
	class.init    = class.init    or class[1] or function() end
	class.include = class.include or include
	class.clone   = class.clone   or clone

	-- constructor call
	return setmetatable(class, {__call = function(c, ...)
		local o = setmetatable({}, c)
		o:init(...)
		return o
	  end})
    end
  
#### Paddle
function Paddle:init(x, y, width, height)
       
     self.x = x
     self.y = y
     self.width = width
     self.height = height
     self.dy = 0
    end

function Paddle:update(dt)
    
    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt)
    
    else
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt)
     end
    end


There are many mathematical functionalities in Pong, many people are familiar with Pong. A simple game but has elegant functions in the program.
That being said this section is barely scraping the surface of what Pong can do.

## A-I WAR Values
 
    There are many value types you will generally interact with, numbers, strings, functions, expressions and environments.

## Numbers

A-I WAR supports integers and decimal numbers valid ranges. 

    if ((ball.x - plr_n.x)^2)^(0.5)  < check_width then 
        if (plr_n.y > (ball.y + ball.height/2))  then                    -- copytron
            plr_n.dy = -PADDLE_SPEED
         elseif (plr_n.y + plr_n.height < (ball.y + ball.height/2))  then
            plr_n.dy = PADDLE_SPEED
         else
            plr_n.dy = 0
        end
     end
     
  local outputCanvas
    for i = 1, #shaders do
      local inputCanvas = i % 2 == 1 and canvas or _tmp.canvas
      outputCanvas = i % 2 == 0 and canvas or _tmp.canvas
      love.graphics.setCanvas(outputCanvas)
      love.graphics.clear()
      love.graphics.setShader(shaders[i])
      love.graphics.draw(inputCanvas)
      love.graphics.setCanvas(inputCanvas)
    end

## Function Names

Here is where we start working with some of LOVE 2D software's more interesting and powerful features, firstly a function is a type. Did you notice that you can't begin to write a function without a Function name at the begin.

    "Löve programs make use of callbacks. Callbacks are Lua functions that you define, and that the engine will call when  something happens. For example, Löve will always call a function love.load() before any others, if you have defined it.  It will also call two callback functions in turn, love.update() and love.draw(), every time your monitor refreshes the  screen (you know that happens typically 60 times a second). Typically, you write your program so that it draws      everything your game needs every monitor frame. Löve clears the screen every time right before calling love.draw(),   therefore if you fail to draw anything in there, you will get a blank screen, even if you drew something earlier."
   For more information I would stongly advice to go to this website https://love2d.org/forums/viewtopic.php?t=84852
    
function love.draw()
    -- begin drawing with push, in our virtual resolution
    push:apply('start')
      
      love.graphics.setColor(0, 255, 0, 250)


function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    -- `key` will be whatever key this callback detected as pressed
    if key == '0' then
        if gameState ~= 'menu_mode' then
         gameState = 'menu_mode'
         ball:reset()
         player1Score = 0
         player2Score = 0
         player1:reset1()
         player2:reset2()
        else
            love.event.quit()
        end

end

## Controls

As you see, A-I WAR has 3 levels:

     if difficulty == 'easy' then
        check_width = VIRTUAL_WIDTH/4
     elseif difficulty == 'hard' then
        check_width = VIRTUAL_WIDTH/2
     elseif difficulty == 'imp' then
        check_width = VIRTUAL_WIDTH
     end
You can pick which keys you wanna play with and choose what side you prefer to be on.

    if gameMode == 'pvc' then   -- boing
        up_button = 'w'     -- because error
        down_button = 's'
     if controls == 'ws' then            -- set controls
        up_button = 'w'
        down_button = 's'
     elseif controls == 'ud' then
        up_button = 'up'
        down_button = 'down'
     end
     
     kf side == 'left' then
         plr = player1
        plr_n = player2
     elseif side == 'right' then
         plr = player2 
         plr_n = player1
     end
## Object of the Game
 
 Defeat an evil computer named Copytron in Pong
 An A.I created by Dwight K.Schrute (from The Office)

## Credits
Cannot express my gratitude enough to Mr. Colton Ogden for his incredible work on the new revise version of Pong. As well as educating others, such as myself, the fundamentals of LUA and LOVE 2D. I also want to express my gratitude to 
Mr. Allan Alcorn, the original mind and creator of Pong.
Knight Rider Main Theme - Stu Phillips

The Stu Phillips Scores: Knight Rider

Writer, Composer: Stu Phillips
Writer, Composer: Glen A. Larson
