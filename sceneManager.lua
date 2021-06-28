local gui = require("factoryGui")
require("game") -- in the game file, the map file will be called in the game file because i need to manage the map file like a paramater to manage the character movement 

-- Set up the basic menu 
SCENE = {}
SCENE.currentScene = " "
SCENE.menu = "menu"
SCENE.game = "game"

-- otherScene that are not constant


local groupChooseLevel = {} 
--[[
    Load everything needed in relation with the gui of the player where he can choose the level
--]] 
function loadChooseLevel()
  groupChooseLevel = gui.newGroup() -- this table will only contain the button that lead to the level

  -- for each level in the game I will create a button dedicated for him and what it will draw is basically a level with a number on it 
  -- it work for the first 8 levels will update latter now focus on creating levels
  for i = 1, NUMBEROFLEVEL do
    local x = (i - 1)*(SCREENWIDTH/NUMBEROFLEVEL)
    local y = 0
    local width = SCREENWIDTH/NUMBEROFLEVEL
    local height = SCREENWIDTH/NUMBEROFLEVEL
    if NUMBEROFLEVEL > 4 then
      width = SCREENWIDTH/4
      height = SCREENWIDTH/4
      x = ((i-1)%4)*width
      y = (math.floor(i/5))*height
    end

    local element = gui.newButton(x,y,width,height,i) 
    
    -- inner function that just load the good level associated with the good number when the player choose the level he wants to play
    local function startLevel()
      SCENE.currentScene = "game"
      gameLoad("level_"..i) -- load the level
      ASSET.sndGame:stop() -- stop the playing then replay it
      ASSET.sndGame:play()
      ASSET.sndMenu:stop()
    end

    element:setEvent("pressed",startLevel)
    
    groupChooseLevel:addElement(element)
  end

end
-- Load the gui
function guiLoad()
  loadChooseLevel()
end
-- put the current scene to the "menu" scene
function startMenu()
  SCENE.currentScene = "menu"

  ASSET.sndGame:stop()
  ASSET.sndMenu:play()
end
-- put the current scene to the "chooseLevel" scene (player will choose the level he wants to start)
function startChoiceLevel()
  SCENE.currentScene = "chooseLevel"
end

function sceneLoad()
  -- set the default scene to game 
  startMenu()
  guiLoad()  
end

--[[
    Update the Gui of the game based on the current scene.
--]]
function sceneUpdate(dt)
  -- you stop the update of the game when you change scene
  if SCENE.currentScene == "menu" then

  elseif SCENE.currentScene == "chooseLevel" then
    groupChooseLevel:update(dt)
  elseif SCENE.currentScene == "game" then
    gameUpdate(dt)
  end
end

function SCENE.menuDraw ()
  love.graphics.setFont(ASSET.font.menu)
  local text = "Pass The Torch"
  local wText = ASSET.font.menu:getWidth(text)
  local hText = ASSET.font.menu:getHeight(text)
  local x = (SCREENWIDTH/2 - wText/2)
  local y = (SCREENHEIGHT/3 - hText/2)

  local text2 = "Press Space"
  local wText2 = ASSET.font.menu:getWidth(text2)
  local hText2 = ASSET.font.menu:getHeight(text2)
  local x2 = (SCREENWIDTH/2 - wText2/2)
  local y2 = (SCREENHEIGHT/1.5 - hText2/2)

  for c = 1,string.len(text) do

    local character = string.sub(text,c,c)
    local cWidth = ASSET.font.menu:getWidth(character)
    local cHeight = ASSET.font.menu:getHeight(c)
    -- swap color for each letter
    if c%2 ~= 0 then
      love.graphics.setColor(255/255, 95/255, 0)
    else
      love.graphics.setColor(255/255, 205/255, 0)
    end

    love.graphics.print(character,x, y)

    x = x + cWidth
  end
  for c = 1,string.len(text2) do
    local character = string.sub(text2,c,c)
    local cWidth = ASSET.font.menu:getWidth(character)
    local cHeight = ASSET.font.menu:getHeight(c)
    -- swap color for each letter
    if c%2 ~= 0 then
      love.graphics.setColor(255/255, 95/255, 0)
    else
      love.graphics.setColor(255/255, 205/255, 0)
    end

    love.graphics.print(character,x2, y2)

    x2 = x2 + cWidth
  end
end
-- draw the chooseLevel scene, where the player can select the level
function SCENE.chooseLevelDraw()
  groupChooseLevel:draw(true)
end
-- draw the win
function SCENE.drawWin()
  love.graphics.setFont(ASSET.font.win)
  local text = "YOU WIN !!"
  local wText = ASSET.font.win:getWidth(text)
  local hText = ASSET.font.win:getHeight(text)
  local x = (SCREENWIDTH/2 - wText/2)
  local y = (SCREENHEIGHT/3 - hText/2)

  -- the second text depend in which level the user is 
  local text2
  local text3



  if CURRENTLEVEL == NUMBEROFLEVEL then
    text2 = "press Space to return to the menu!"
    text3 = "Your total score with your number of death is: "..((math.floor(mBoi.timer)+(10*mBoi.death))).." seconds"
  else
    text2 = "press Space to go to the next level!"
  end

  local wText2 = ASSET.font.win:getWidth(text2)
  local hText2 = ASSET.font.win:getHeight(text2)
  local x2 = (SCREENWIDTH/2 - wText2/2)
  local y2 = (SCREENHEIGHT/1.5 - hText2/2)

  love.graphics.setColor(255/255, 95/255, 0)

  love.graphics.print(text,x,y)

  love.graphics.print(text2,x2,y2)

  if text3~=nil then
    love.graphics.setFont(ASSET.font.game)
    local wText3 = ASSET.font.game:getWidth(text3)
    local hText3 = ASSET.font.game:getHeight(text3)
    local x3 = (SCREENWIDTH/2 - wText3/2)
    local y3 = ((SCREENHEIGHT/1.2) - hText3/2)
    love.graphics.print(text3,x3,y3)
  end


  love.graphics.setColor(1, 1, 1)
end

function sceneDraw()
  -- if the current scene become the menu you draw the menu over the game
  if SCENE.currentScene == "menu" then
    SCENE.menuDraw()
  elseif SCENE.currentScene == "chooseLevel" then
    SCENE.chooseLevelDraw()
  elseif SCENE.currentScene == "game" or  SCENE.currentScene == "win" then
    -- you always draw the game even if the player wins 
    gameDraw()
    if SCENE.currentScene == "win" then
      SCENE.drawWin()
    end
  end
end
-- input when the player is on the menu
function inputMenu(key)
  if key == "space" then
    startChoiceLevel()
  end
end
-- input when the player finish a level
function inputWin(key)
  if key == "space" then
    if CURRENTLEVEL~= NUMBEROFLEVEL then  

      CURRENTLEVEL = CURRENTLEVEL + 1

      spawnMBoi(CURRENTLEVEL)

      SCENE.currentScene = "game"
    else 
      -- if the player finish the last level he just goes in the menu, when space is pressed 
      SCENE.currentScene = "menu" 
      -- need to remove the mBoi from the main sprite List, because if not the old mBoi sprite will stay on screen 
      removeSpecficSpriteMainList("mainCharacter")
    end
  end

end

function sceneKeypressed(key)
  if SCENE.currentScene == "menu" then
    inputMenu(key)
  elseif SCENE.currentScene == "game" then
    gameKeypressed(key)
  elseif SCENE.currentScene == "win" then
    inputWin(key)
  end
end

function sceneKeyreleased(key)
  if SCENE.currentScene == "game" then
    gameKeyreleased(key)
  end
end
