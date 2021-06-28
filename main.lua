-- to have traces (print in the console) during the exectuion of the program
io.stdout:setvbuf('no')

-- for pixel Art, avoid blurring the sprites  
love.graphics.setDefaultFilter("nearest", "nearest")

-- for debuging
if arg[#arg] == "-debug" then require("mobdebug").start() end


-- global variables that can change only when you change the dimension of the window of the game  
SCALEX = 1 -- scale in the X axis
SCALEY = 1 -- scale in the Y axis
DEFAULTSCREENWIDTH = love.graphics.getWidth() -- THE DEFAULT SCREEN HEIGHT AND SCREEN WIDTH
DEFAULTSCREENHEIGHT = love.graphics.getHeight()
SCREENWIDTH = love.graphics.getWidth()/SCALEX
SCREENHEIGHT = love.graphics.getHeight()/SCALEY
ASSET = {} -- this table will load all the asset that are necessary for the game, and this is global to all the file 

print("ScreenWidth: "..SCREENWIDTH.." ScreenHeight: "..SCREENHEIGHT)

-- need to change the value of this variable when I add or remove a level 
NUMBEROFLEVEL = 8

-- require the sceneManager
require("sceneManager")
--[[
    Load all the necessary data needed to play the game 
--]]
function love.load()
  changeWindowDimension(800,600) -- change the default window size
  loadAsset() -- load the asset of the game before every loading file
  
  sceneLoad()
end

--[[
    Update all the necessary thing to make the game playable (there is other update called inside the scene update and so on)
--]]
function love.update(dt)
  sceneUpdate(dt)
end
--[[
    Draw the game 
--]]
function love.draw()
  -- scale the game in proportion of the screen dimension
  love.graphics.scale(SCALEX,SCALEY)
  sceneDraw()
  love.graphics.scale()
  --draw lines to know where specific sprites are 
--  love.graphics.line(0,569.67,SCREENWIDTH,569.67)
--  love.graphics.line(0,569.67+1,SCREENWIDTH,569.67+1)

end
--[[
    Listen to key when they are pressed 
--]]
function love.keypressed(key)
  sceneKeypressed(key)
end
--[[
    Listen to key when they are released
--]]
function love.keyreleased(key)
  sceneKeyreleased(key)
end


--[[
    Change the dimension of the screen probably on the gui
--]]
function changeWindowDimension(pWidth,pHeight)
  love.window.setMode(pWidth,pHeight)
  SCALEX = pWidth/DEFAULTSCREENWIDTH 
  SCALEY = pHeight/DEFAULTSCREENHEIGHT
  SCREENWIDTH = pWidth/SCALEX
  SCREENHEIGHT = pHeight/SCALEY
end
--[[
    Convert the coordinate relatively of the dimension of the screen (used when you resize the screen)
--]]
function convertCoordinate(pX,pY)
  local x = pX/SCALEX
  local y = pY/SCALEY
  return x,y
end

--[[
    Load all the assets of the game before the game start 
--]]
function loadAsset()
  -- Load the tiles needed for drawing the levels 
  ASSET.level = {}
  
  -- asset invisible for the player
  ASSET.level[5] = love.graphics.newImage("Sprite/object/tile-arrow-right.png") -- right arrow (for inverting velocity of triangle when collide against)
  ASSET.level[6] = love.graphics.newImage("Sprite/object/tile-arrow-left.png") -- left arrow (for inverting velocity of triangle when collide against)
  
  ASSET.level["map"] = {
      image = love.graphics.newImage("Sprite/map/groundTiled.png"),
      currentFrame = 1,
      animation = {}
  }
  for i = 1,5 do
    local quad = love.graphics.newQuad((i-1)*30, 0, 30, 30, ASSET.level["map"].image:getWidth(), ASSET.level["map"].image:getHeight())
    table.insert(ASSET.level["map"].animation,quad)
  end
  
  ASSET.level["Torch"] = {
    image = love.graphics.newImage("Sprite/object/Torch.png"),
    currentFrame = 1,
    animation = {}
  }
  for i =1,4 do
    local quad = love.graphics.newQuad((i-1)*30, 0, 30, 30, ASSET.level["Torch"].image:getWidth(), ASSET.level["Torch"].image:getHeight())
    table.insert(ASSET.level["Torch"].animation,quad)
  end
  -- the enemies 
  ASSET.level["triangle"] = {
    image = love.graphics.newImage("Sprite/ennemies/Enemy.png"),
    currentFrame = 1,
    animation = {}
  }
  for i =1,5 do
    local quad = love.graphics.newQuad((i-1)*30, 0, 30, 30, ASSET.level["triangle"].image:getWidth(), ASSET.level["triangle"].image:getHeight())
    table.insert(ASSET.level["triangle"].animation,quad)
  end
  

  ASSET.font = {}
  ASSET.font.basic = love.graphics.getFont()
  ASSET.font.game = love.graphics.newFont("Fonts/Adventure.otf",25) -- font that will display the timer of the player and his score 
  ASSET.font.win = love.graphics.newFont("Fonts/Adventure.otf",50)
  ASSET.font.menu = love.graphics.newFont("Fonts/Adventure.otf",100)


  -- Load the music
  -- Setting the different audio sources 
  ASSET.sndGame = love.audio.newSource("Music/Funny Horror.mp3","stream")
  ASSET.sndGame:setVolume(0.5)
  ASSET.sndGame:setLooping(true)
  
  ASSET.sndJump = love.audio.newSource("Music/jump.wav","static")
  ASSET.sndJump:setVolume(0.8)
  
  ASSET.sndDie = love.audio.newSource("Music/die.wav","static")
  ASSET.sndDie:setVolume(0.8)

  ASSET.sndMenu = love.audio.newSource("Music/Hidden Fear.mp3","stream")
  ASSET.sndMenu:setVolume(0.7)
  ASSET.sndMenu:setLooping(true)

  -- when the player finish the level, this song plays
  ASSET.sndWin = love.audio.newSource("Music/winingSong.mp3","static")
  
  ASSET.sndDash= love.audio.newSource("Music/dash.wav","static")
  ASSET.sndDash:setVolume(0.8)
  
  
end
--[[
    Reset the current frame of all the assets to be == to 1 (called when you change level)
--]]
function resetFrameAsset()
  for key,value in pairs(ASSET.level) do
    if value.animation ~= nil then
      value.currentFrame = 1
    end
  end
  
end


