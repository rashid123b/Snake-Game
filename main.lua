-- game states
GameStates = {pause='pause', running='running', game_over='game over'}
state = GameStates.running

local snakeX = 20
local snakeY = 20
local appleX = 0
local appleY = 0


tail = {}
length = 0
position = 20

----
apple = {}
apple.x = 400
apple.y = 300
apple.w = 25
apple.h = 25






----

snakeSize = 30
appleSize = 30
local speed = 20

right = false
left = false
up = false
down = false

local snakeDirY = 0
local snakeDirX = 0

function love.load()
  
  sounds = {}
  
  sounds.crunch = love.audio.newSource("sounds/apple_crunch.mp3", "static")
  sounds.over = love.audio.newSource("sounds/gameover.wav", "static")

  
  
  fonts = {}
  
  fonts.old = love.graphics.newFont("fonts/ARCADECLASSIC.TTF", 15)
  
  
  images = {}
   images.snack = love.graphics.newImage("images/apple2.png")
   images.background = love.graphics.newImage("images/background_800x600.png")
  
  
  --crunch = love.audio.newSource("apple_crunch.mp3", "static")
  --background = love.graphics.newImage("background_800x600.png")
  --snack = love.graphics.newImage("apple2.png")

speed = 20
random_apple()

end


function random_apple()
  math.randomseed(os.time())
  appleX = math.random(position - 7)
  appleY = math.random(position - 7)
  
  
  end


function love.keypressed(k)
  
  
  if k == 'escape' then
      love.event.quit()
      end
      
  if k == 'left' or k =='a' then
    left = true
    right = false
    up = false
    down = false
    end
    
  if k == 'right' or k == 'd' then
    right = true
    left = false
    up = false
    down = false
    
    
   end
  
    if k == 'up' or k == 'w' then
    left = false
    right = false
    up = true
    down = false
    end
    
  if k == 'down' or k == 's' then
    right = false
    left = false
    up = false
    down = true
   end
   
   if k == 'p' then
     
    if state == GameStates.running then
      
      
      state = GameStates.pause
      

    else
      state = GameStates.running
    end
   end
   
   if k == 'space' or state == GameStates.game_over then
     restart()
  end
     end
  

function love.draw()
  
  for x=0, love.graphics.getWidth(), images.background:getWidth() do
    for y=0, love.graphics.getWidth(),images.background:getHeight() do
  
 love.graphics.draw(images.background,x,y) --love.graphics.setBackgroundColor(0.1, 0.7, 0.2) -- 127,198,125
  
end
end
  
  
  
  gameDraw()
  
  if state == GameStates.game_over then -- draw Game Over when the state is game_over
     sounds.over:play()
    love.graphics.print("Game Over!", 300, 150, 0, 3)
    love.graphics.print("Press Space to restart", 200, 450, 0, 3, 3)
  end
  
end


function love.update()
  
    if state == GameStates.running then

  speed = speed - 1
  if speed < 0 then
  direction()
  
  if length <= 5 then
      
      speed = 15
      
  elseif length > 5 and length <= 10 then
  
    speed = 10
    
  else 
    speed = 5
    
    end
  
  end
end

end

-- game

function gameDraw()
  
  --love.graphics.setColor(255, 0, 0)
  -- love.graphics.circle("line", appleX*position, appleY*position, 5, 60)
  love.graphics.draw(images.snack,appleX*position, appleY*position)
  
  
  love.graphics.setColor(0, 0, 0) -- draw the snake's head
  love.graphics.rectangle('fill', snakeX*position, snakeY*position,20,20, 10,10)
  
  love.graphics.setColor(0.7, 0.35, 0.4, 1.0) -- draw the snake's tails
  for _, v in ipairs(tail) do
    love.graphics.rectangle('fill', v[1]*position, v[2]*position, position, position, 15, 15)
  end
  
  
 -- love.graphics.setFont(fonts.old)
  love.graphics.setColor(1, 1, 1, 1) -- darw the collected apples text
  love.graphics.print('collected Snacks: '.. length, 10, 10, 0, 1.5) --, 0, 1.5, 1.5)
  
end

function direction()
  
  if right and snakeDirX == 0 then
    snakeDirX = 1
    snakeDirY = 0
    end
  
  if left and snakeDirX == 0 then
    snakeDirX = -1
    snakeDirY = 0
  end
  
    
  if up and snakeDirY == 0 then
    snakeDirX = 0
    snakeDirY = -1
    end
  
  if down and snakeDirY == 0 then
    snakeDirX = 0
    snakeDirY = 1
  end
  
  -------
    
    local oldX = snakeX
    local oldY = snakeY
    
    snakeX = snakeX + snakeDirX
    snakeY = snakeY + snakeDirY
    
     
  
  --------
  
  if snakeX == appleX and snakeY == appleY then
    random_apple()
    
    sounds.crunch:play()

    length = length + 1
        table.insert(tail, {0,0})

    end
  
  
  
  if snakeX < 0 then 
    snakeX = snakeSize + 9
    end
  
  if snakeX > snakeSize + 9 then
    snakeX = 0
    end
  
  if snakeY < 0 then
    snakeY = snakeSize - 1
  end
  
  if snakeY > snakeSize then
      snakeY = 0
      end
    
    
  
  if length > 0 then
    for _, v in ipairs(tail) do 
      local x, y = v[1], v[2] -- following the (c=a, a=b, b=c) logic
      v[1], v[2] = oldX, oldY
      oldX, oldY = x, y
    end
  
  for _, v in ipairs(tail) do
    if snakeX == v[1] and snakeY == v[2] then
      state = GameStates.game_over
    end
    end
  
end

end

 function restart()
   
    tail= {}
    length = 0
   
    snakeX = 20
    snakeY = 20
    
    snakeDirY = 0
    snakeDirX = 0
    
     right = false
     left = false
     up = false 
     down = false
    
    
   random_apple()
   state = GameStates.running
   
 end
 