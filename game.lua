local factorySprites = require("factorySprites")
local map = require("map")



-- global variable that will handle the main character 
mBoi = {}

--[[
    Initialize everything the mBoi (Main character) need to have.
    
    @param {string} pLevel: adjust the position of the mBoi based on the level selected. 
--]]
function loadMBoi(pLevel)
--  pMaxDisplacement, pMaxTime, pJumpDistanceToTravel, pJumpInHowMuchTime
  mBoi = factorySprites.createSprite("mainCharacter",0,0,28,28,{255/255,153/255,51/255,1},10,0.11,60,0.25)

  mBoi.respawn = false -- used to control where the mBoi respawn and to not interfer with the collision system when he respawn, used in the updateMBoi and the function solidTile
  mBoi.win = false -- used to know if the player wins or not (by taking the torch), used in the updatemBoi and the function solidTile

  -- Vision of the mBoi  
  mBoi.vision = {} -- what the mBoi can see
  mBoi.vision.scope = 75 -- the scope of the mBoi 
  mBoi.vision.shift = (mBoi.vision.scope - mBoi.width)/2



  mBoi.vision.x = mBoi.position.x - (mBoi.vision.shift)
  mBoi.vision.y = mBoi.position.y - (mBoi.vision.shift)

  mBoi.dash = {}
  -- effect of the dash
  mBoi.dash.speed = 555 -- max speed of the dash
  -- to limit his number of dash to only 1 
  mBoi.dash.dashed = false 
  mBoi.dash.timeBeforeNextDash = 0.1
  mBoi.dash.currentTimeNextDash = 0
  -- to limit how much dash he is dashing 
  mBoi.dash.isDashing = false -- disable every other control if he is dashing 
  mBoi.dash.duration = 0 -- how much time is he dashing 
  mBoi.dash.maxDuration = 0.1 -- max timer representing how much time he can dash

  -- timer to kill mBoi when he step on a red tile (it has to be not instant)
  mBoi.redTileDeath = {}
  mBoi.redTileDeath.currentTime = 0
  mBoi.redTileDeath.maxTimer = 0.3
  mBoi.redTileDeath.isCollidingBelow = false 

  -- score and gameplay around mBoi
  mBoi.timer = 0 -- it will represent the score of the player, the times he takes to finish each level
  mBoi.death = 0 -- the number of death of the mBoi IN the level

  -- contain all the details about the deathParticle when the mBoi dies 
  mBoi.deathParticle = {}
  mBoi.deathParticle.container = {}
  mBoi.deathParticle.particleLifeTime = 0.3
  mBoi.deathParticle.particleCurrentLifeTime = 0
  mBoi.deathParticle.numberParticle = 60

  -- contain all the details about the jumpParticle when the mBoi dies 
  mBoi.jumpParticle = {}
  mBoi.jumpParticle.container = {}
  mBoi.jumpParticle.particleLifeTime = 0.3
  mBoi.jumpParticle.particleCurrentLifeTime = 0
  mBoi.jumpParticle.numberParticle = 60

  -- contain all the details about the jumpParticle when the mBoi dies 
  mBoi.dashParticle = {}
  mBoi.dashParticle.container = {}
  mBoi.dashParticle.particleLifeTime = 0.3
  mBoi.dashParticle.particleCurrentLifeTime = 0
  mBoi.dashParticle.numberParticle = 60

  mBoi.quad = {}

  -- set up the idle animation 
  mBoi.quad["idle"] = love.graphics.newImage("Sprite/mBoi/idleAnimation.png")
  mBoi.animationSpeed["idle"] = 1/4
  local quadIdleAnimation = {}
  local idleAnimationText = {}
  for i = 1,(mBoi.quad["idle"]:getWidth()/mBoi.width) do
    local text = "idle_"..i
    local quad = love.graphics.newQuad((i-1)*mBoi.width, 0, mBoi.width, mBoi.height, mBoi.quad["idle"]:getWidth(), mBoi.quad["idle"]:getHeight())
    table.insert(quadIdleAnimation,quad)
    table.insert(idleAnimationText,text)
  end

  mBoi.addAnimation(true, quadIdleAnimation, nil, idleAnimationText,"idle")
  mBoi.playAnimation("idle")

  -- set up the jump animation 
  mBoi.quad["jump"] = love.graphics.newImage("Sprite/mBoi/jumpAnimation.png")
  mBoi.animationSpeed["jump"] = 1/6
  local quadJumpAnimation = {}
  local jumpAnimationText = {}
  for i = 1,(mBoi.quad["jump"]:getWidth()/mBoi.width) do
    local text = "jump_"..i
    local quad = love.graphics.newQuad((i-1)*mBoi.width, 0, mBoi.width, mBoi.height, mBoi.quad["jump"]:getWidth(), mBoi.quad["jump"]:getHeight())
    table.insert(quadJumpAnimation, quad)
    table.insert(jumpAnimationText, text)
  end

  mBoi.addAnimation(true, quadJumpAnimation, nil, jumpAnimationText,"jump")

-- set up the dash animation 
  mBoi.quad["dash"] = love.graphics.newImage("Sprite/mBoi/dashAnimation.png")
  mBoi.animationSpeed["dash"] = 1/3
  local quadDashAnimation = {}
  local dashAnimationText = {}
  for i = 1,(mBoi.quad["dash"]:getWidth()/mBoi.width) do
    local text = "dash_"..i
    local quad = love.graphics.newQuad((i-1)*mBoi.width, 0, mBoi.width, mBoi.height, mBoi.quad["dash"]:getWidth(), mBoi.quad["dash"]:getHeight())
    table.insert(quadDashAnimation, quad)
    table.insert(dashAnimationText, text)
  end

  mBoi.addAnimation(true, quadDashAnimation, nil, dashAnimationText,"dash")

  -- create Particule and insert it in the table listParticule
  mBoi.createParticles = function (pParticleList,minVx,maxVx,minVy,maxVy)
    local currentNumberParticle = #pParticleList.container

    for i=currentNumberParticle,currentNumberParticle + pParticleList.numberParticle do
      local position 
      if mBoi.dash.dashed then
        local y = love.math.random(0,10)
        position = newVector(mBoi.position.x + mBoi.width/2,mBoi.position.y + mBoi.height/2 + y)
      else
        position = newVector(mBoi.position.x + mBoi.width/2,mBoi.position.y + mBoi.height/2)

      end

      local vx = love.math.random(minVx,maxVx)
      local vy = love.math.random(minVy,maxVy)
      local velocity = newVector(vx,vy)
      table.insert(pParticleList.container, {position = position, velocity = velocity,opacity = 1})
    end
  end


  mBoi.deleteParticle = function(pParticleList)
    -- delete all the particle of the particle list of the mBoi when he dies 
    for  i = #pParticleList.container, 1, -1 do
      table.remove(pParticleList.container,i) 
    end 
  end

  -- update the state of each particles 
  mBoi.updateParticle = function(dt,pParticleList)

    -- if particle life time exceed max life time then delete particle and reset particle current life time
    if pParticleList.particleCurrentLifeTime >= pParticleList.particleLifeTime then
      mBoi.deleteParticle(pParticleList)
      pParticleList.particleCurrentLifeTime = 0
    end
    -- update the particle only if there is particle in the list 
    if #pParticleList.container > 0 then
      pParticleList.particleCurrentLifeTime = pParticleList.particleCurrentLifeTime + dt
      -- cap the currentLifeTime of the particle 
      if pParticleList.particleCurrentLifeTime >= pParticleList.particleLifeTime then
        pParticleList.particleCurrentLifeTime = pParticleList.particleLifeTime
      end
      -- update position and opacity of each particles
      for  i = #pParticleList.container, 1, -1 do
        local particle = pParticleList.container[i]
        -- change the addition operation between 2 vectors 
        particle.position = particle.position + (dt*particle.velocity)
        -- at max time of the particle life time, its opacity become = 1 and then 1-1 = 0
        particle.opacity = 1 - (pParticleList.particleCurrentLifeTime/pParticleList.particleLifeTime) 
      end
    end
  end

  -- draw particles when the MC dies 
  mBoi.drawParticle = function (pParticleList)
    if #pParticleList.container > 0 then
      -- draw 60 particles 
      for i=1,#pParticleList.container do
        local particle = pParticleList.container[i]
        if pParticleList == mBoi.dashParticle then
          love.graphics.setColor(255/255,69/255,0/255,particle.opacity)
        else
          love.graphics.setColor(mBoi.color[1],mBoi.color[2],mBoi.color[3],particle.opacity)
        end
        love.graphics.circle("fill", particle.position.x, particle.position.y,5)
        love.graphics.setColor(1,1,1,1)
      end
    end
  end

  -- spawn the MC
  spawnMBoi(pLevel)
end
--[[
    Spawn the mBoi in the good position related to the level 
  
    @param {string} pLevel: adjust the position of the mBoi based on the level selected. 
--]]
function spawnMBoi(pLevel)

  -- stock level in it's string form
  local theLevel = map.translateLevelStringToNum(pLevel)

  -- if you are in situation that the player finish the player when you call the spawnMboi you need to swap level
  -- so you need to load the new level 
  if SCENE.currentScene == "win" then
    map.load(theLevel) -- load  the next level 
    -- and start the music 
    ASSET.sndGame:play()
  end

  if theLevel == "level_1" then
    mBoi.position.x = 100
    mBoi.position.y = SCREENHEIGHT - LEVEL.tilewidth - mBoi.width
  elseif theLevel == "level_2" then
    mBoi.position.x = LEVEL.tilewidth
    mBoi.position.y = SCREENHEIGHT - LEVEL.tilewidth - mBoi.width
  elseif theLevel == "level_3" then
    mBoi.position.x = 100
    mBoi.position.y = SCREENHEIGHT - LEVEL.tilewidth - mBoi.width
  elseif theLevel == "level_4" then
    mBoi.position.x = 100
    mBoi.position.y = SCREENHEIGHT - LEVEL.tilewidth - mBoi.width
  elseif theLevel == "level_5" or theLevel == "level_6" or theLevel == "level_8" then
    mBoi.position.x = 2*LEVEL.tilewidth
    mBoi.position.y = 2*LEVEL.tilewidth - (LEVEL.tilewidth - mBoi.width)
  elseif theLevel == "level_7" then
    mBoi.position.x =  SCREENWIDTH - 4*LEVEL.tilewidth
    mBoi.position.y = 4*LEVEL.tilewidth - (LEVEL.tilewidth - mBoi.width)
  end

  mBoi.jump.canJump = true 

  -- velocity of the mBoi
  mBoi.velocity.currentSpeed.x,mBoi.velocity.currentSpeed.y = 0,0

  mBoi.respawn = false -- used to control where the mBoi respawn and to not interfer with the collision system when he respawn, used in the updateMBoi and the function solidTile
  mBoi.win = false -- used to know if the player wins or not (by taking the torch), used in the updatemBoi and the function solidTile


--  print("old X : "..oldX..", new X : "..mBoi.position.x..", old Y : "..math.floor(oldY)..", new Y : "..mBoi.position.y)
  mBoi.vision.x = mBoi.position.x - (mBoi.vision.shift)
  mBoi.vision.y = mBoi.position.y - (mBoi.vision.shift)

  resetFrameAsset()
end
--[[
    Respawn the MC and reset everything that need to reset
    
    @param {string} pLevel: adjust the position of the mBoi based on the level selected. 

--]]
function respawnMBoi(pLevel)  

  local theLevel = map.translateLevelStringToNum(pLevel)
  -- level 3 has no respawn (no enemies and red tiles)
  if theLevel == "level_1" or theLevel == "level_4" then
    mBoi.position = newVector(100,SCREENHEIGHT - LEVEL.tilewidth - mBoi.width)
  elseif theLevel == "level_2" then
    mBoi.position = newVector(LEVEL.tilewidth,SCREENHEIGHT - LEVEL.tilewidth - mBoi.width)
  elseif theLevel == "level_5" or theLevel == "level_6" or theLevel == "level_8" then
    mBoi.position = newVector(2*LEVEL.tilewidth,2*LEVEL.tilewidth - (LEVEL.tilewidth - mBoi.width))
  elseif theLevel == "level_7" then
    mBoi.position = newVector(SCREENWIDTH - 4*LEVEL.tilewidth,4*LEVEL.tilewidth)
  end
--  print("old X : "..oldX..", new X : "..mBoi.position.x..", old Y : "..math.floor(oldY)..", new Y : "..mBoi.position.y)
  mBoi.vision.x = mBoi.position.x - (mBoi.vision.shift)
  mBoi.vision.y = mBoi.position.y - (mBoi.vision.shift)

  mBoi.death = mBoi.death + 1 -- augment the counter of death of the player 
  -- Reset the velocity of mBoi
  mBoi.velocity.currentSpeed.x,mBoi.velocity.currentSpeed.y = 0,0
  mBoi.respawn = false
  -- reset the dash
  mBoi.dash.dashed = false 
  mBoi.dash.currentTimeNextDash = 0
  ASSET.sndDie:play()

end

--[[
    When the player collide with the torch (it means he finished the level)
--]]
function winMboi()
  mBoi.win = false
  SCENE.currentScene = "win" -- change the scene

  -- stop the current music when he wins 
  ASSET.sndGame:stop()
  ASSET.sndWin:play()
end

--[[
    Load the game 
--]]
function gameLoad(pLevel)
  map.load(pLevel) 
  loadMBoi(CURRENTLEVEL)
end

--[[ 
    Check for solid tiles and apply different effects based on the tile id.
    
    @param {number} pID1,pID2,pID3: the id of the tile where the MC collide, the different id corespond to different hot spot.
--]]
function solidTile(pID1,pID2,pID3)
  -- first verify the tiles that kills the mBoi
  if (pID1 > 1 and pID1 < 6) or (pID2 > 1 and pID2 < 6) or (pID3 > 1 and pID3 < 6) then -- red tile collide 
    -- die when collide belowe with a timer else just die instant 
    if mBoi.redTileDeath.currentTime >= mBoi.redTileDeath.maxTimer or not mBoi.redTileDeath.isCollidingBelow then
      mBoi.respawn = true -- the mBoi need to respawn and the respawn function is called in the update of the mBoi
    end
    return true
    -- white tile, just collide
  elseif pID1 == 1 or pID2 == 1 or pID3 == 1 then
    return true 
    -- the torch, trigger the winning function
  elseif pID1 == 6 or pID2 == 6 or pID3 == 6 then
    mBoi.win = true -- the player touch the torch so he wins,win function is called in the update of the mBoi
  end

end

-- collision of mBoi

--[[ 
    Check collision at the right side of the MC.
    
    @param {number} pX: The X position of the MC.
    @param {number} pY: The Y position of the MC.
    @param {String} pType: If it is a different sprite then the MC or not (nil mean that it is the MC).
    @param {number} dt: delta time.
--]]
function collideRight(pX,pY,pType,dt)
  local collide = false
  for l = 1, #LEVEL.layers do  
    -- verify first if we are on a tilelayer basically only detect collision with tiles, for object it will be different
    -- the environnement collison happen only in the tile layer 
    if LEVEL.layers[l].type == "tilelayer" then  
      -- evaluating the position of the l and column of the hotspot of mBoi
      local id1 = LEVEL:getTileAt((pX + mBoi.width),(pY+5),LEVEL.tilewidth,ASSET.level,l)
      local id2 = LEVEL:getTileAt((pX + mBoi.width),(pY + mBoi.width/2),LEVEL.tilewidth,ASSET.level,l)
      local id3 = LEVEL:getTileAt((pX + mBoi.width),(pY + mBoi.width-5),LEVEL.tilewidth,ASSET.level,l)
      if (id1 ~= nil and id2 ~= nil and id3 ~= nil) and (id1 ~= 0 or id2 ~= 0  or id3 ~= 0) then
        if pType == nil then  
          if id1 > 1 or  id2 > 1 or id3 > 1 then
            -- to let the mBoi die from redTile instant rather than with a timer(only use when mBoi is colliding below with a red tile)
            mBoi.redTileDeath.isCollidingBelow = false
            solidTile(id1,id2,id3)
          else
            collide = solidTile(id1,id2,id3)
          end
        end
      end
    end
  end
  return collide 
end
--[[ 
    Check collision at the left side of the MC.
    
    @param {number} pX: The X position of the MC.
    @param {number} pY: The Y position of the MC.
    @param {String} pType: If it is a different sprite then the MC or not (nil mean that it is the MC).
    @param {number} dt: delta time.
--]]
function collideLeft(pX,pY,pType,dt)
  local collide = false

  for l = 1, #LEVEL.layers do 
    if LEVEL.layers[l].type == "tilelayer" then
      -- evaluating the position of the l and column of the hotspot of mBoi
      local id1 = LEVEL:getTileAt((pX),(pY+5),LEVEL.tilewidth,ASSET.level,l)
      local id2 = LEVEL:getTileAt((pX),(pY+mBoi.width/2),LEVEL.tilewidth,ASSET.level,l)
      local id3 = LEVEL:getTileAt((pX),(pY + mBoi.width - 5),LEVEL.tilewidth,ASSET.level,l)
      if (id1 ~= nil and id2 ~= nil and id3 ~= nil) and (id1 ~= 0 or id2 ~= 0  or id3 ~= 0) then
        if pType == nil then  
          if id1 > 1 or  id2 > 1 or id3 > 1 then
            mBoi.redTileDeath.isCollidingBelow = false
            solidTile(id1,id2,id3)
          else
            collide = solidTile(id1,id2,id3)
          end
        end
      end
    end
  end
  return collide
end
--[[ 
    Check collision at the bottom side of the MC. (A bit different from the other collision since this one is not instantaneous)
    
    @param {number} pX: The X position of the MC.
    @param {number} pY: The Y position of the MC.
    @param {String} pType: If it is a different sprite then the MC or not (nil mean that it is the MC).
    @param {number} dt: delta time.
--]]
function collideBelow(pX,pY,pType,dt)
  local collide = false
  --update the survival timer of the mBoi in a red tile
  local redTileTimerUpdate = false 
-- i verify multiple spot of the bottom side of the mBoi, then i check if there is a collision for one of these position and if so then return true
  for l = 1,#LEVEL.layers do  
    if LEVEL.layers[l].type == "tilelayer" then
      local id1 = LEVEL:getTileAt((pX),(pY + mBoi.width),LEVEL.tilewidth,ASSET.level,l)
      local id2 = LEVEL:getTileAt((pX + mBoi.width/2),(pY + mBoi.width),LEVEL.tilewidth,ASSET.level,l)
      local id3 = LEVEL:getTileAt((pX + mBoi.width),(pY + mBoi.width),LEVEL.tilewidth,ASSET.level,l)
      if (id1 ~= nil and id2 ~= nil and id3 ~= nil) and (id1 ~= 0 or id2 ~= 0  or id3 ~= 0) then
        if pType == nil then  
          if id1 > 1 or  id2 > 1 or id3 > 1 then
            mBoi.redTileDeath.isCollidingBelow = true
            collide = solidTile(id1,id2,id3)
            --update the survival timer of the mBoi in a red tile
            redTileTimerUpdate = true
          else
            collide = solidTile(id1,id2,id3)
          end
        end
      end
    end  
  end

  if redTileTimerUpdate then
    mBoi.redTileDeath.currentTime = mBoi.redTileDeath.currentTime + dt
  else 

    mBoi.redTileDeath.currentTime = mBoi.redTileDeath.currentTime - dt

    if mBoi.redTileDeath.currentTime <= 0 then
      mBoi.redTileDeath.currentTime = 0
    end


  end

  return collide
end
--[[ 
    Check collision at the top side of the MC.
    
    @param {number} pX: The X position of the MC.
    @param {number} pY: The Y position of the MC.
    @param {String} pType: If it is a different sprite then the MC or not (nil mean that it is the MC).
    @param {number} dt: delta time.
--]]
function collideAbove(pX,pY,pType,dt)
  local collide = false
-- i verify multiple spot of the right side of the mBoi, then i check if there is a collision for one of these position and if so then return true
  for l = 1, #LEVEL.layers do  
    if LEVEL.layers[l].type == "tilelayer" then
      -- evaluating the position of the l and column of the hotspot of mBoi
      local id1 = LEVEL:getTileAt((pX + 1),(pY),LEVEL.tilewidth,ASSET.level,l)
      local id2 = LEVEL:getTileAt((pX + mBoi.width/2),(pY),LEVEL.tilewidth,ASSET.level,l)
      local id3 = LEVEL:getTileAt((pX + mBoi.width - 2),(pY),LEVEL.tilewidth,ASSET.level,l)
      if (id1 ~= nil and id2 ~= nil and id3 ~= nil) and (id1 ~= 0 or id2 ~= 0  or id3 ~= 0) then
        if pType == nil then  
          if id1 > 1 or  id2 > 1 or id3 > 1 then
            mBoi.redTileDeath.isCollidingBelow = false
            collide = solidTile(id1,id2,id3)
          else
            collide = solidTile(id1,id2,id3)
          end
        end
      end
    end
  end
  return collide
end

--[[
    Bounding box collision, check if 2 objects overlap (used for collision between monster and the MC)
  
    @param {number}: coordinates and dimension of the first object
    @param {number}: coordinates and dimension of the second object
  
    @return true if there is a collision else false
--]]
function boundingBox(pX1,pY1,pWidth1,pHeight1,pX2,pY2,pWidth2,pHeight2)
  local isBox1OnBox2_Xaxis = pX1 < pX2 + pWidth2 and pX2 < pX1 + pWidth1 
  local isBox1OnBox2_Yaxis = pY1 < pY2 + pHeight2 and pY2 < pY1 + pHeight1
  if isBox1OnBox2_Xaxis and isBox1OnBox2_Yaxis then
    return true 
  end
  -- if not on it 
  return false
end
--[[
    To align the sprite in the X axis (tile based). Only used to align the mBoi when he collide (to return to a state where he does not collide) in the X direction

    @param {object} pSprite: The sprite to align. 
--]]
function alignInX(pSprite)
  -- check the collide property of the sprite (right and left)
  if pSprite.collide.right then
    -- you are colliding right
    local column = math.floor(pSprite.position.x/LEVEL.tilewidth) + 1
    pSprite.position.x  = (column - 1)*LEVEL.tilewidth
  else
    -- you are colliding left
    local column = math.floor(pSprite.position.x/LEVEL.tilewidth) + 1
    pSprite.position.x  = (column)*LEVEL.tilewidth
  end
  -- reset the collider 
  pSprite.collide.right = false
  pSprite.collide.left = false
end
--[[
    To align the sprite in the Y axis (tile based). Only used to align the mBoi when he collide (to return to a state where he does not collide) in the Y direction

    @param {object} pSprite: The sprite to align. 
--]]
function alignInY(pSprite)
  if pSprite.collide.top then
    -- you are colliding on top
    local line = math.floor(pSprite.position.y/LEVEL.tileheight) + 1
    pSprite.position.y = (line)*LEVEL.tileheight
  else 
    -- you are colliding below
    local line = math.floor(pSprite.position.y/LEVEL.tileheight)
    pSprite.position.y = (line)*LEVEL.tileheight + (LEVEL.tileheight - pSprite.height)
  end
  -- reset the collider 
  pSprite.collide.top = false
  pSprite.collide.bottom = false
end
--[[
    Update of the MC: control,collision, particle and manage if win and respawn.

    @param {number} dt: delta time. 
--]]
function updateMBoi(dt)
  -- if he needs to respawn call the respawn function 
  if mBoi.respawn == true then
    mBoi.createParticles(mBoi.deathParticle,-60,60,-60,60)
    respawnMBoi(CURRENTLEVEL) -- respawn the mBoi, the more useful way to manage the collision after the respawn
  end
  -- update the death particle of the mBoi if there is particle in the list, (when he dies)
  mBoi.updateParticle(dt,mBoi.deathParticle)
  -- update the jump particle of the mBoi if there is particle in the list, (when he dies)
  mBoi.updateParticle(dt,mBoi.jumpParticle)
  -- update the dash particle of the mBoi if there is particle in the list, (when he dies)
  mBoi.updateParticle(dt,mBoi.dashParticle)

  -- if he needs to respawn call the win function
  if mBoi.win == true then
    winMboi()
  end

  local oldX,oldY = mBoi.position.x,mBoi.position.y -- store the old position of mBoi to use it when he collide

  -- update score timer of the mBoi, his score basically
  mBoi.timer = mBoi.timer + dt 

  -- storing how much time the player is pressing the up key, to manage the vertical distance he travel when jumping 
  if love.keyboard.isDown("up") and mBoi.jump.isFalling then
    mBoi.jump.currentTime = mBoi.jump.currentTime + dt
  else
    mBoi.jump.currentTime = 0
  end
  -- you can't move if you are dashing 
  if not mBoi.dash.isDashing then
    -- horizontal movement 
    if love.keyboard.isDown("right","left")then
      -- treshold of the currentTime incrementation, it can go above, imply that speed stay constant after the treshold(max Speed)
      if love.keyboard.isDown("right") and love.keyboard.isDown("left") == false then
        if mBoi.acceleration.currentAcceleration.x < mBoi.acceleration.maxAcceleration.x then
          mBoi.acceleration.currentAcceleration.x = mBoi.acceleration.currentAcceleration.x + mBoi.acceleration.maxAcceleration.x
          mBoi.scaleX = 1
          mBoi.horizontalShift = 0
        end
      elseif love.keyboard.isDown("left") and love.keyboard.isDown("right") == false then
        if mBoi.acceleration.currentAcceleration.x > -mBoi.acceleration.maxAcceleration.x then
          mBoi.acceleration.currentAcceleration.x = mBoi.acceleration.currentAcceleration.x - mBoi.acceleration.maxAcceleration.x
          mBoi.scaleX = -1
          mBoi.horizontalShift = mBoi.width
        end
      end
    else
      mBoi.acceleration.currentAcceleration.x = 0
      mBoi.velocity.currentSpeed.x = 0
    end
  end

  --updating the velocity of the mBoi
  mBoi.velocity.currentSpeed.x = mBoi.velocity.currentSpeed.x + mBoi.acceleration.currentAcceleration.x *dt

  -- controlling the max speed of the character
  if math.abs(mBoi.velocity.currentSpeed.x) >= math.abs(mBoi.acceleration.currentAcceleration.x * (mBoi.acceleration.maxTimeForMaxSpeed)) 
  and not mBoi.dash.isDashing then
    if love.keyboard.isDown("right") then
      mBoi.velocity.currentSpeed.x = mBoi.acceleration.currentAcceleration.x * mBoi.acceleration.maxTimeForMaxSpeed
    elseif love.keyboard.isDown("left") then
      mBoi.velocity.currentSpeed.x = -math.abs(mBoi.acceleration.currentAcceleration.x * mBoi.acceleration.maxTimeForMaxSpeed)
    end
  end

  -- updating the movement of the mBoi
  mBoi.position.x = mBoi.position.x + mBoi.velocity.currentSpeed.x*dt
  mBoi.position.y = mBoi.position.y + mBoi.velocity.currentSpeed.y*dt
  --print("2",mBoi.velocity.currentSpeed.y)

  -- updating the vision scope of the mBoi in function of the position of the mBoi
  mBoi.vision.x,mBoi.vision.y = mBoi.position.x - (mBoi.vision.shift),mBoi.position.y - (mBoi.vision.shift)

  -- colision of the mBoi with the level
  if mBoi.velocity.currentSpeed.x~=0 then
    if mBoi.velocity.currentSpeed.x>0 then
      if collideRight(mBoi.position.x,mBoi.position.y,nil,dt) then
        mBoi.collide.right = true
        alignInX(mBoi) 
      end
    elseif mBoi.velocity.currentSpeed.x<0 then
      if collideLeft(mBoi.position.x,mBoi.position.y,nil,dt) then
        mBoi.collide.left = true
        alignInX(mBoi)
      end
    end
  end

  -- collision above of the mBoi
  if collideAbove(mBoi.position.x,mBoi.position.y,nil,dt) then
    mBoi.collide.top = true
    alignInY(mBoi)

    mBoi.velocity.currentSpeed.y = 0
  end


  -- if speed in Y is different then 0, then the mBoi is necessarly falling
  if mBoi.velocity.currentSpeed.y ~= 0 then
    mBoi.jump.isFalling = true
  end

  --Collision mBoi below him
  if collideBelow(mBoi.position.x,mBoi.position.y,nil,dt) then
    mBoi.jump.canJump = true
    mBoi.jump.isFalling = false
    mBoi.collide.below = true
    -- you can align the MC only if he is not jumping (ascending part first half jump movement)
--    if  not mBoi.jump.isFalling then
    alignInY(mBoi)
--    end


    if mBoi.jump.currentTime >= mBoi.jump.inHowMuchTime/2 or  mBoi.jump.currentTime == 0 then 
      mBoi.velocity.currentSpeed.y = 0 
    end

  else
    local oldSpeedY = mBoi.velocity.currentSpeed.y
    -- apply gravity in the mboi only when he is falling 
    mBoi.velocity.currentSpeed.y = mBoi.velocity.currentSpeed.y - mBoi.acceleration.currentAcceleration.y*dt
    if oldSpeedY <= 0 and mBoi.velocity.currentSpeed.y > 0 then
      mBoi.frame = 3
    end

  end

  -- limit how much time the mc is dashing and manage the reset of the dash
  if mBoi.dash.isDashing then
    mBoi.dash.duration = mBoi.dash.duration + dt
    if mBoi.dash.duration>= mBoi.dash.maxDuration then
      mBoi.dash.isDashing = false
    end
  end

  -- reset the dash of the player only if the time between 2 dash is at least the time set up in the load mboi
  if mBoi.dash.dashed then
    mBoi.dash.currentTimeNextDash = mBoi.dash.currentTimeNextDash + dt
    if mBoi.dash.currentTimeNextDash>= mBoi.dash.timeBeforeNextDash  and not mBoi.jump.isFalling then
      mBoi.dash.dashed = false
    end
  end

  -- check collision mBoi with monster
  if LEVEL.hasEnemy then
    for i,monster in ipairs (LEVEL.layers[3].objects) do
      if boundingBox(mBoi.position.x,mBoi.position.y,mBoi.width,mBoi.height,monster.x,monster.y - monster.height,monster.width,monster.height) then
        mBoi.respawn = true 
      end
    end
  end

  if mBoi.currentAnimation ~= nil then
    -- you can animate the jump only if greater then frame 4 
    if mBoi.currentAnimation ~= "jump" or mBoi.frame > 2 then

      if mBoi.animationTimer == nil then
        mBoi.animationTimer = mBoi.animationSpeed[mBoi.currentAnimation]
      end
      mBoi.animationTimer = mBoi.animationTimer - dt
      if mBoi.animationTimer <= 0 then
        mBoi.frame = mBoi.frame + 1
        mBoi.animationTimer = mBoi.animationSpeed[mBoi.currentAnimation]
      end
      if mBoi.frame > #mBoi.animation[mBoi.currentAnimation] then
        mBoi.frame = 1
        if mBoi.currentAnimation == "jump" or mBoi.currentAnimation == "dash" then
          mBoi.playAnimation("idle")
        end
      end
    end
  end

end
--[[
    Update of the monster (originally they were called triangle, and I kept the name for not changing my code).
    
    @param {object} pTriangle: The monster to update the position.
    @param {number} dt: delta time.
--]]
function updateTriangle(pTriangle, dt)
  -------------------------------------------------------------NEED TO SEE HOW TO DO COLLISION WITH OBJECT .
  local oldX,oldY = pTriangle.x,pTriangle.y
  -- update the speed of the triangle 
  pTriangle.x = pTriangle.x + (pTriangle.properties["vx"])*10*dt

  -- go through the layer that "dictate" the direction of the object movement 
  for i,direction in ipairs (LEVEL.layers[4].objects) do
    local isCollide  
    local collideGap = 1 -- You need to have a gap of between the object and the direction collide,like that the object can't be stuck in texture 
    -- need to take care of what is the direction of the triangle to adjust the collision, like that the object can't be stuck in texture
    if pTriangle.properties["vx"] > 0 then
      isCollide = boundingBox(pTriangle.x + collideGap,pTriangle.y - pTriangle.height,pTriangle.width,pTriangle.height,direction.x,direction.y - direction.height,direction.width,direction.height)
    else
      isCollide = boundingBox(pTriangle.x-collideGap,pTriangle.y - pTriangle.height,pTriangle.width,pTriangle.height,direction.x,direction.y - direction.height,direction.width,direction.height)
    end
    if  isCollide then
      pTriangle.properties["vx"] = -1*(pTriangle.properties["vx"])
    end
  end

end 

--[[
    Update all the sprites (that needs to have a specific update) (Except the MC) on the current level.
    
    @param {number} dt: delta time.
--]]
function updateObject(dt)
  -- call the update of all the specific objects  of the level
  if LEVEL.hasEnemy then
    for i, layers in ipairs (LEVEL.layers)do
      -- check just for the object group type
      if layers.type == "objectgroup" then
        if layers.name == "Triangle" then  
          -- go trough each objects, if you are in this if then the layer is an object layer
          for index, object in ipairs (layers.objects) do
            -- check the specific types of each object to know which specific update you need to call 
            if object.properties["type"] == "triangle" then
              updateTriangle(object,dt)
            end
          end
        end
      end
    end
  end

end

--[[
    Call the update of everything for the game to be runned.
    
    @param {number} dt: delta time.
--]]
function gameUpdate(dt)
  map.update(dt)
  updateObject(dt)
  updateMBoi(dt)
end
--[[
    Draw the score of the player.
--]]
function drawScore()
  love.graphics.setColor(255/255, 95/255, 0)
  love.graphics.setFont(ASSET.font.game)
  love.graphics.print("Timer = "..math.floor(mBoi.timer),0,0)
  love.graphics.print("Death = "..mBoi.death,SCREENWIDTH - 150,0)
  love.graphics.setColor(1,1,1,1)
end
--[[
    Draw the score of the player.
--]]
function gameDraw()
  -- draw the map
  map.draw()
  -- draw Score of the mBoi
  drawScore()

  -- drawing all the sprite of the sprite list, if they have no image set up then it will draw a rectangle 
  local index,sprite
  for index, sprite in ipairs(factorySprites.spriteList) do
    if sprite.quad ~= nil then
      local height = sprite.height*(mBoi.redTileDeath.currentTime/mBoi.redTileDeath.maxTimer)

      local frameName = sprite.animation[sprite.currentAnimation][math.floor(sprite.frame)] -- get the name of the frame
      local img = sprite.image[frameName] -- get the specific cut of the quad for the specific frame 
      -- draw the quad
      love.graphics.draw(sprite.quad[sprite.currentAnimation],img,sprite.position.x + sprite.horizontalShift ,sprite.position.y, 0, sprite.scaleX, sprite.scaleY) 
      love.graphics.setColor(	255/255, 26/255, 0/255,0.7)
      love.graphics.rectangle("fill",sprite.position.x + sprite.horizontalShift ,(sprite.position.y + sprite.height) - height, sprite.width*sprite.scaleX,height)
      love.graphics.setColor(1,1,1,1)

    elseif sprite.quad == nil and #sprite.image > 0 then
      local frameName = sprite.animation[sprite.currentAnimation][math.floor(sprite.frame)]
      local img = sprite.image[frameName]
      love.graphics.draw(img, sprite.position.x, sprite.position.y)
    elseif #sprite.image == 0 then
      love.graphics.setColor(sprite.color)
      love.graphics.rectangle("fill",sprite.position.x,sprite.position.y,sprite.width,sprite.height)
--      love.graphics.circle("fill",sprite.position.x,sprite.position.y,5)
      -- Draw the vision Scope ******************* need to take of this code when real game exist
      if sprite.type == "mainCharacter" then  
        love.graphics.setColor(0,1,0)
--        love.graphics.rectangle("line",mBoi.vision.x,mBoi.vision.y,mBoi.vision.scope,mBoi.vision.scope)
        love.graphics.circle("line",mBoi.position.x + mBoi.width/2 ,mBoi.position.y + mBoi.width/2,mBoi.vision.scope)
      end
      love.graphics.setColor(1,1,1,1)
    end
  end
  -- draw death particle 
  mBoi.drawParticle(mBoi.deathParticle) 
  mBoi.drawParticle(mBoi.jumpParticle)

  mBoi.drawParticle(mBoi.dashParticle)

  

end

--[[
    Will handle the keypressed when the player is playing the game (not in the menu)
  
    @param {String}: The key that is pressed 
--]]
function gameKeypressed(key)
  --jump code of mBoi
  --he can jump only if its speed in y is equal to 0
  if mBoi.jump.canJump == true then  
    if key == "up" then
      mBoi.jump.canJump = false
      mBoi.velocity.currentSpeed.y = -mBoi.velocity.maxSpeedInY -- apply jump velocity when mboi jump
      mBoi.playAnimation("jump")
      mBoi.frame = 2
      mBoi.createParticles(mBoi.jumpParticle,-60,60,50,50)
      -- Play the snd of jump
      ASSET.sndJump:play()
    end
  end
  if LEVEL.canDash then
    -- if the player can dash and press "d"
    if not mBoi.dash.isDashing and not mBoi.dash.dashed then  
      if key == "d" and love.keyboard.isDown("up","right","down","left") then
        mBoi.dash.isDashing = true
        mBoi.dash.duration = 0
        mBoi.dash.dashed = true 
        mBoi.dash.currentTimeNextDash = 0
      
        ASSET.sndDash:play()

        mBoi.playAnimation("dash")

        local x = 0
        local y = 0
        if love.keyboard.isDown("right") and love.keyboard.isDown("up") then
          x = mBoi.dash.speed/math.sqrt(2)
          y = -mBoi.dash.speed/math.sqrt(2)
          mBoi.createParticles(mBoi.dashParticle,-15,15,40,70)
        elseif love.keyboard.isDown("right") and love.keyboard.isDown("down") then
          x = mBoi.dash.speed/math.sqrt(2)
          y = mBoi.dash.speed/math.sqrt(2)
          mBoi.createParticles(mBoi.dashParticle,-15,15,-70,-40)
        elseif love.keyboard.isDown("left") and love.keyboard.isDown("up") then
          x = -mBoi.dash.speed/math.sqrt(2)
          y = -mBoi.dash.speed/math.sqrt(2)
          mBoi.createParticles(mBoi.dashParticle,-15,15,40,70)

        elseif love.keyboard.isDown("left") and love.keyboard.isDown("down") then
          x = -mBoi.dash.speed/math.sqrt(2)
          y = mBoi.dash.speed/math.sqrt(2)
          mBoi.createParticles(mBoi.dashParticle,-15,15,-70,-40)
        elseif love.keyboard.isDown("right") then
          x = mBoi.dash.speed 
          y = 0
          mBoi.createParticles(mBoi.dashParticle,-100,-40,-10,10)
        elseif love.keyboard.isDown("left") then
          x = -mBoi.dash.speed 
          y = 0
          mBoi.createParticles(mBoi.dashParticle,100,40,-10,10)
        elseif love.keyboard.isDown("up") then
          x = 0
          y = -mBoi.dash.speed
          mBoi.createParticles(mBoi.dashParticle,-15,15,40,70)
        elseif love.keyboard.isDown("down") then
          x = 0
          y = mBoi.dash.speed
          mBoi.createParticles(mBoi.dashParticle,-15,15,-70,-40)
        end
        mBoi.velocity.currentSpeed = newVector(x,y)
      end
    end  
  end
end
--[[
    Will handle the keyreleased when the player is playing the game (not in the menu)
  
    @param {String}: The key that is released 
--]]
function gameKeyreleased(key)
  -- modify the jump height of the mBoi, based on how much time the plaer press the "up" key to jump
  if key == "up" then
    -- you can stop jumping only at the first half of the jump movement 
    if mBoi.jump.currentTime < mBoi.jump.inHowMuchTime/2 then
      -- the factor how much you cut the Y velocity of the mBoi
      local factorYouCutVelY = mBoi.jump.currentTime/(mBoi.jump.inHowMuchTime/2)
      mBoi.velocity.currentSpeed.y = mBoi.velocity.currentSpeed.y*factorYouCutVelY
    end
    mBoi.jump.currentTime = 0
  end


end


--[[
    To remove specific sprite from the main table: "factory.spriteList"
    
    @param {String}: The type of the sprite that I want to remove from the factory list.
--]] 
function removeSpecficSpriteMainList(pType)

  for index,sprite in ipairs(factorySprites.spriteList) do
    if sprite.type == pType then
      table.remove(factorySprites.spriteList,index)
    end
  end

end

--[[
    Power function that allows to tween an effect 
    
    @param {number} P: the power of the function (quad =2, quint = 5, etc)
    @param {number} tX: Horizontal translation (can be seen as delay to the tween, do not start immediatly)
    @param {number} tY: Vertical translation (to start at the position you want)
    @param {number} sX: Horizontal Stretch (to make the tween last longer or quicker)
    @param {number} sY: Vertical Stretch (to make the tween go further or lesser)
    @param {number} position: the current position (or you can see it as a state, of the object)
    @return {number} : what you want to evalutate with the tweening (can be position, or any value that you need to tween based on something else (independent => position))
--]]
function powerFunctionTween(P,tX,tY,sX,sY,position)
  return sY*math.pow((position-tX)/sX,P) + tY
end
