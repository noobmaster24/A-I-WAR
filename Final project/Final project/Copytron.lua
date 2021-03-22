WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200


function love.load()

    

    love.graphics.setDefaultFilter('nearest', 'nearest')


    love.window.setTitle('A - I WAR')

    
    math.randomseed(os.time())

    -- initialize our nice-looking retro text fonts
    smallFont = love.graphics.newFont('font.ttf', 8)
    largeFont = love.graphics.newFont('font.ttf', 16)
    scoreFont = love.graphics.newFont('font.ttf', 32)
    love.graphics.setFont(smallFont)

    -- set up our sound effects; later, we can just index this table and
    -- call each entry's `play` method
    sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
        ['music'] = love.audio.newSource('sounds/music.wav','static'),
        ['copytron'] = love.audio.newSource('sounds/copytron.mp3','static')
        
        
    }
     

    sounds['copytron'] = love.audio.newSource('sounds/copytron.mp3', 'static')
    sounds['music'] = love.audio.newSource('sounds/music.wav', 'static')

    sounds['copytron']:setVolume(0.9)
    sounds['music']:setVolume(0.2)

    sounds['copytron']:play()
    sounds['music']:setLooping(true)
    sounds['music']:play()
    






    
    
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    
    
    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)
    

    -- place a ball in the middle of the screen
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)
    -- initialize score variables
    player1Score = 0
    player2Score = 0


    gameMode = ''

    -- difficulty, side, controls
    difficulty = '' -- 'easy' or 'hard' or 'imp'
    side  = ''      -- 'left' or 'right'
    controls = ''     -- 'ws' for W-S or 'ud' for arrow keys

    -- either going to be 1 or 2; whomever is scored on gets to serve the
    -- following turn
    servingPlayer = 1

    -- player who won the game; not set to a proper value until we reach
    -- that state in the game
    winningPlayer = 0

    gameState = 'menu_mode'

end






function love.resize(w, h)
    push:resize(w, h)
end


function love.update(dt)
    ----- pvc means player .vs. copytron---

    if gameState == 'serve' then

        if servingPlayer == 1 and side == 'left' and gameMode == 'pvc' then
            ball.dx = math.random(140, 200)
            ball.dy = math.random(-50, 50)
         elseif servingPlayer == 2 and side == 'left' and gameMode == 'pvc' then  --changes
            ball.dx = -math.random(140, 200)
            ball.dy = math.random(-50, 50)
            gameState = 'play'
         elseif servingPlayer == 1 and side == 'right' and gameMode == 'pvc'  then
                ball.dx = math.random(140, 200)
                ball.dy = math.random(-50, 50)
                gameState = 'play'
             elseif servingPlayer == 2 and side == 'right' and gameMode == 'pvc' then  --changes
                ball.dx = -math.random(140, 200)
                ball.dy = math.random(-50, 50)
        end
     elseif gameState == 'play' then
        -- detect ball collision with paddles, reversing dx if true and
        -- slightly increasing it, then altering the dy based on the position
        -- at which it collided, then playing a sound effect
        if ball:collides(player1) then
            ball.dx = -ball.dx * 1.03
            ball.x = player1.x + 5

            -- keep velocity going in the same direction, but randomize it
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end

            sounds['paddle_hit']:play()
        end
        if ball:collides(player2) then
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - 4

            -- keep velocity going in the same direction, but randomize it
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end 

            sounds['paddle_hit']:play()
        end

        -- detect upper and lower screen boundary collision, playing a sound
        -- effect and reversing dy if true
        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end

        -- -4 to account for the ball's size
        if ball.y >= VIRTUAL_HEIGHT - 4 then
            ball.y = VIRTUAL_HEIGHT - 4
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end

        -- if we reach the left edge of the screen, go back to serve
        -- and update the score and serving player
        if ball.x < 0 then
            servingPlayer = 1
            player2Score = player2Score + 1
            sounds['score']:play()

            -- if we've reached a score of 10, the game is over; set the
            -- state to done so we can show the victory message
            if player2Score == 10 then
                winningPlayer = 2
                gameState = 'done'
            else
                gameState = 'serve'
                -- places the ball in the middle of the screen, no velocity
                ball:reset()
            end
        end

        -- if we reach the right edge of the screen, go back to serve
        -- and update the score and serving player
        if ball.x > VIRTUAL_WIDTH then
            servingPlayer = 2
            player1Score = player1Score + 1
            sounds['score']:play()

            -- if we've reached a score of 10, the game is over; set the
            -- state to done so we can show the victory message
            if player1Score == 10 then
                winningPlayer = 1
                gameState = 'done'
            else
                gameState = 'serve'
                -- places the ball in the middle of the screen, no velocity
                ball:reset()
            end
        end
    end

    
---------------------------------------------------- pvc
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

     check_width = 0
     if difficulty == 'easy' then
        check_width = VIRTUAL_WIDTH/4
     elseif difficulty == 'hard' then
        check_width = VIRTUAL_WIDTH/2
     elseif difficulty == 'imp' then
        check_width = VIRTUAL_WIDTH
     end


     plr = player1          --because error  --side
     plr_n = player2
     if side == 'left' then
         plr = player1
        plr_n = player2
     elseif side == 'right' then
         plr = player2 
         plr_n = player1
     end
     if ((ball.x - plr_n.x)^2)^(0.5)  < check_width then 
        if (plr_n.y > (ball.y + ball.height/2))  then                    -- copytron
            plr_n.dy = -PADDLE_SPEED
         elseif (plr_n.y + plr_n.height < (ball.y + ball.height/2))  then
            plr_n.dy = PADDLE_SPEED
         else
            plr_n.dy = 0
        end
     end

     if love.keyboard.isDown(up_button) then             -- player
        plr.dy = -PADDLE_SPEED
      elseif love.keyboard.isDown(down_button) then
        plr.dy = PADDLE_SPEED
       else
        plr.dy = 0
      end
   
    end

    

    -- update our ball based on its DX and DY only if we're in play state;
    -- scale the velocity by dt so movement is framerate-independent
    if gameState == 'play' then
        ball:update(dt)
    end

    player1:update(dt)
    player2:update(dt)
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

    -- if we press enter during either the start or serve phase, it should
    -- transition to the next appropriate state
    elseif key == 'enter' or key == 'return' then
       
        
        if  (gameMode == 'pvc' and ((side == 'left' and servingPlayer == 1) or (side == 'right' and servingPlayer == 2))) then
            if gameState == 'start' then
              gameState = 'serve'
          elseif gameState == 'serve' then
             gameState = 'play'
         elseif gameState == 'done' then
            -- game is simply in a restart phase here, but will set the serving
            -- player to the opponent of whomever won for fairness!
            gameState = 'serve'
    
    
            ball:reset()

            -- reset scores to 0
            player1Score = 0
            player2Score = 0

            -- decide serving player as the opposite of who won
            if winningPlayer == 1 then
                servingPlayer = 2
            else
                servingPlayer = 1
            end

         end
         elseif  (gameMode == 'pvc') and ((side == 'left' and servingPlayer == 2) or (side == 'right' and servingPlayer == 1)) then
            if gameState == 'start' then
                gameState = 'serve'
            end
            
        end

    end
  
    
    -- the menu where one can choose to play standard PvP, against AI or watch
    if gameState == 'menu_mode' then
        if  key == '1' then
            gameMode = 'pvc'
            gameState = 'menu_diff'
            sounds['music']:play()
    
        end
    
    
    -- choose difficulty of AI opponent
    elseif gameState == 'menu_diff' then 
                  -- the gamestate is mentioned twice to avoid mispresses
        if key == '1'  then
            difficulty = 'easy'
            gameState = 'menu_side'
            sounds['music']:play()
        elseif key == '2' then
            difficulty = 'hard'
            gameState = 'menu_side'
            sounds['music']:play()
        elseif key == '3' then
            difficulty = 'imp'
            gameState = 'menu_side'
            sounds['music']:play()
        end
    
        -- to choose which side your player is on
    elseif gameState == 'menu_side' then
        
        if key == '1' then
            side = 'left'
            gameState = 'menu_ctrl'
            sounds['music']:play()
        elseif key == '2' then
            side = 'right'
            gameState = 'menu_ctrl'
            sounds['music']:play()
        else 
            sounds['music']:play()
        end
        
    
            -- to choose controls
    elseif gameState == 'menu_ctrl' then
        
        if key == '1' then 
            controls = 'ws'
            gameState = 'start'
            sounds['music']:play()
        elseif key == '2' then
            controls = 'ud'
            gameState = 'start'
            sounds['music']:play()
        
        end        
        

    end
end

--[[
    Called each frame after update; is responsible simply for
    drawing all of our game objects and more to the screen.
]]
function love.draw()
    -- begin drawing with push, in our virtual resolution
    push:apply('start')
   
    love.graphics.setColor(0, 255, 0, 250)
    
    
    -- render different things depending on which part of the game we're in
    if gameState == 'start' then
        -- UI messages
        love.graphics.setFont(smallFont)
        love.graphics.printf('Welcome to The Program ',0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to begin!', 0, 20, VIRTUAL_WIDTH, 'center')
     elseif gameState == 'serve' then
        -- UI messages
        if gameMode == 'pvp' then
         love.graphics.setFont(smallFont)
         love.graphics.printf('Player ' .. tostring(servingPlayer) .. "'s serve!", 
            0, 10, VIRTUAL_WIDTH, 'center')
         love.graphics.printf('Press Enter to serve!', 0, 20, VIRTUAL_WIDTH, 'center')
         elseif gameMode == 'pvc' then
            if (side == 'left' and servingPlayer == 1) or (side == 'right' and servingPlayer == 2) then
                love.graphics.setFont(smallFont)
             love.graphics.printf("Player's serve!", 0, 10, VIRTUAL_WIDTH, 'center')
             love.graphics.printf('Press Enter to serve!', 0, 20, VIRTUAL_WIDTH, 'center')
             elseif (side == 'left' and servingPlayer == 2) or (side == 'right' and servingPlayer == 1) then
             love.graphics.setFont(smallFont)
             love.graphics.printf("Copytron's serve",  0, 10, VIRTUAL_WIDTH, 'center')
             love.graphics.printf('Press Enter to serve!', 0, 20, VIRTUAL_WIDTH, 'center')
           end
        end
     elseif gameState == 'play' then
        love.graphics.setFont(smallFont)
        if gameMode == 'pvc' then
         love.graphics.printf('diff: '..difficulty..' side: '..side..' controls: '..controls, 0, 10, VIRTUAL_WIDTH, 'center')
        end
        -- no UI messages to display in play
     elseif gameState == 'done' then
        -- UI messages
        

         if gameMode == 'pvc' then
         if (side == 'left' and winningPlayer == 1) or (side == 'right' and winningPlayer == 2) then
           love.graphics.setFont(largeFont)
         love.graphics.printf("Player wins, Congratulations Human!", 0, 10, VIRTUAL_WIDTH, 'center')
         love.graphics.setFont(smallFont)
         love.graphics.printf('Press Enter to restart', 0, 30, VIRTUAL_WIDTH, 'center')
         elseif (side == 'left' and winningPlayer == 2) or (side == 'right' and winningPlayer == 1) then
         love.graphics.setFont(largeFont)
         love.graphics.printf("Muahaha I won, prepare for world domination!",  0, 10, VIRTUAL_WIDTH, 'center')
         love.graphics.setFont(smallFont)
         love.graphics.printf('Press Enter to restart!', 0, 30, VIRTUAL_WIDTH, 'center')
         end
       end 
       
     elseif gameState == 'menu_mode' then
        love.graphics.setFont(largeFont)
        love.graphics.printf('Hello Human, my name is Copytron. Shall we play a game?',0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('1.YES          0.N0', 0, 50, VIRTUAL_WIDTH, 'center')
        
        
        
     elseif gameState == 'menu_diff' then
        love.graphics.setFont(largeFont)
        love.graphics.printf('Choose a difficulty. Press the corresponding number on your keyboard.',0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('1. Easy \n \n \n 2. Hard \n \n \n 3. Impossible' , 0, 50, VIRTUAL_WIDTH, 'center')

    elseif gameState == 'menu_side' then
        love.graphics.setFont(largeFont)
        love.graphics.printf('Choose a side. Press the corresponding number on your keyboard.',0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(largeFont)
        love.graphics.printf('\t 1. Left \t\t\t\t\t\t\t 2. Right', 0, 125, VIRTUAL_WIDTH, 'left')
    
    elseif gameState == 'menu_ctrl' then
        love.graphics.setFont(largeFont)
        love.graphics.printf('Choose your controls. Press the corresponding number on your keyboard.',0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('1. W-S keys \n \n 2. Arrow keys', 0, 50, VIRTUAL_WIDTH, 'center')
 end

    -- show the score before ball is rendered so it can move over the text
    displayScore()
    if gameState ~= 'menu_mode' and gameState ~= 'menu_diff' and gameState ~= 'menu_side' and gameState ~= 'menu_ctrl' then
     player1:render()
     player2:render()
     ball:render()
    end

    -- display FPS for debugging; simply comment out to remove
    displayFPS()

    -- end our drawing to push
    push:apply('end')
end

--[[
    Simple function for rendering the scores.
]]


function displayScore()
    -- score display
    if gameState ~= 'menu_mode' and gameState ~= 'menu_diff' and gameState ~= 'menu_side' and gameState ~= 'menu_ctrl' then
     love.graphics.setFont(scoreFont)
     love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50,VIRTUAL_HEIGHT / 3)
     love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30,VIRTUAL_HEIGHT / 3)
    end
end




--[[
    Renders the current FPS.
]]
function displayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 5, 5)
end
