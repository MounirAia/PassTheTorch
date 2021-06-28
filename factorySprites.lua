require("movement")
-- this file will all the factory of the game like createHero,createEnemy, etc 
local factory = {}
factory.spriteList = {} -- will contain all the sprites needed for the game 
--[[
    Factory function to create a sprite
    
    
    @param {String} pType: The type of the sprite. (ex:enemy, MC, etc.)
    @param {number} pX: The X position of the sprite.
    @param {number} pY: The Y position of the sprite.
    @param {number} pWidth: The width of the sprite.(if not an image)
    @param {number} pHeight: The height of the sprite.(if not an image)
    @param {object} pColor: The color of the sprite. (ex: {1,1,1})
    @param {number} pMaxDisplacement represent the max displacement the sprite will do in horizontal axis before sprite reaching his/here max speed 
    @param {number} pMaxTime the time it takes to reach the maxDisplacement and consequently the max speed
    @param {number} pJumpDistanceToTravel represent the max distance the sprite will travel during his jump
    @param {number} pJumpInHowMuchTime his total jump will last how much time
  
    @return {object} a sprite object.
--]]
function factory.createSprite(pType,pX,pY,pWidth,pHeight,pColor,pMaxDisplacement, pMaxTime, pJumpDistanceToTravel, pJumpInHowMuchTime)
  local mySprite = {}
  mySprite.type = pType
  --CHANGE HERE
  mySprite.position = newVector(pX,pY)

  mySprite.width = pWidth
  mySprite.height = pHeight
  mySprite.color = pColor

  -- horziontal shift 
  mySprite.horizontalShift = 0
  mySprite.scaleX = 1
  mySprite.scaleY = 1

  mySprite.collide = {
    top = false,
    right = false,
    bottom = false,
    left = false
  }
  mySprite.currentAnimation = nil
  mySprite.quad = nil
  mySprite.frame = 1
  mySprite.animationSpeed = {}
  mySprite.animationTimer = nil
  mySprite.animation = {}
  mySprite.image = {} -- Table that will contain the different images for a sprite
  --[[
      This function will load all the image necessary for the sprite.
      
      @param {boolean} pIsQuad: Tell if it is a quad or not.
      @param {object} pQuadList: The quad list. (ex: {quad1,quad2....})
      @param {String} pPathImage: The base image path(if it is not a quad and just an image list). (ex: if the image are in folder /images then you give as an argument 
                                  "/image")
      @param {object) pImgList: The image list(if you don't use quad). (ex: {"car_1", "car_2", "car_3",...})
  --]]
  mySprite.addImage = function(pIsQuad,pQuadList,pPathImage,pImgList)
    -- i need to cut the image before with the quad function 
    if pIsQuad then
      -- the imgList in the quad is created when i cut the quad, with tostring and variable
      for index,value in ipairs(pImgList) do
        local quad = pQuadList[index]
        mySprite.image[value] = quad -- you associate a quad to an image
      end
    else -- if this is not a quad it means that this is a group of image
      local index,value 
      for index, value in ipairs(pImgList) do
        local fileName = pPathImage.."/"..value..".png"
        mySprite.image[value] = love.graphics.newImage(fileName)
      end
    end
  end
  --[[
      Set up the animation and call the addImage function 
      
      @param {boolean} pIsQuad: Tell if it is a quad or not.
      @param {object} pQuadList: The quad list. (ex: {quad1,quad2....})
      @param {String} pPathImage: The base image path(if it is not a quad and just an image list). (ex: if the image are in folder /images then you give as an argument 
                                  "/image")
      @param {object) pImgList: The image list(if you don't use quad). (ex: {"car_1", "car_2", "car_3",...})
      @param {String} pAnimationName: The name of the animation.
  --]]
  mySprite.addAnimation = function(pIsQuad,pQuadList,pPathImage,pImgList,pAnimationName)
    mySprite.addImage(pIsQuad,pQuadList,pPathImage,pImgList) -- so you load the images 
    mySprite.animation[pAnimationName] = pImgList -- so you associate the table you created before to an animation, like that i can acces the name of the frame with number
  end
--[[
      Tell wich animation to play and reset the frame to the first frame of the animation 

      @param {String} pAnimationName: The name of the animation to play.
  --]]
  mySprite.playAnimation = function(pAnimationName)
    mySprite.currentAnimation = pAnimationName
    mySprite.frame = 1
  end


  -- by default the jump do not exist, will be set up if you set an acceleration
  mySprite.jump = nil
  mySprite.acceleration = nil
  mySprite.velocity = nil
  
  --[[
      Set the jump of the sprite
    
      @param {number} pDistanceToTravel: Represent the max distance the sprite will travel during his jump
      @param {number} pHowMuchTime: His total jump will last how much time
    
      @return {object} all the jump attributes needed to make th jump work.
  --]]
  mySprite.setJump = function(pDistanceToTravel,pHowMuchTime)
    local jump = {
      distanceToTravel = pDistanceToTravel,
      inHowMuchTime = pHowMuchTime,
      -- how much time is he currently jump
      currentTime = 0,
      -- can he jump? (grounded or not)
      canJump = true,
      -- is he still falling?
      isFalling = false,
      -- is the jump key released?
      isKeyToJumpReleased = true
    }
    return jump
  end
  --[[
    Set the acceleration of the sprite and in the same time the jump of the value for the jump of the sprite 
    
    @param {number} pMaxDisplacement: Represent the max displacement the sprite will do in horizontal axis before sprite reaching his/here max speed 
    @param {number} pMaxTime: The time it takes to reach the maxDisplacement and consequently the max speed
    @param {number} pJumpDistanceToTravel: Represent the max distance the sprite will travel during his jump
    @param {number} pJumpInHowMuchTime : His total jump will last how much time
    
    @return {object} all the acceleration attributes.
  --]]

  mySprite.setAcceleration = function(pMaxDisplacement, pMaxTime, pJumpDistanceToTravel, pJumpInHowMuchTime)

    local accX = getAcceleration(pMaxDisplacement,pMaxTime,0,false)

    -- have to set the jump to set the gravity
    mySprite.jump = mySprite.setJump(pJumpDistanceToTravel,pJumpInHowMuchTime)
    local initialSpeed = getInitialVelocity(mySprite.jump.distanceToTravel,mySprite.jump.inHowMuchTime,0)
    local accY = getAcceleration(mySprite.jump.distanceToTravel,mySprite.jump.inHowMuchTime,initialSpeed.y,true)
    local acceleration = {
      maxTimeForMaxSpeed = pMaxTime,
      -- gravity is always applied 
      currentAcceleration = newVector(0,accY.y),
      maxAcceleration = newVector(accX.x, accY.y)
    }

    return acceleration
  end
  --[[
      Set the velocity parameters of the sprite and in the same time sets the acceleration of the sprite 
    
      @param {number} pMaxDisplacement: Represent the max displacement the sprite will do in horizontal axis before sprite reaching his/here max speed 
      @param {number} pMaxTime: The time it takes to reach the maxDisplacement and consequently the max speed
      @param {number} pJumpDistanceToTravel: Represent the max distance the sprite will travel during his jump
      @param {number} pJumpInHowMuchTime : His total jump will last how much time
    
      @return {object} all the velocity attributes.
  --]]
  mySprite.setVelocity = function(pMaxDisplacement, pMaxTime, pJumpDistanceToTravel, pJumpInHowMuchTime)
    -- set the acceleration of the sprite before setting his velocity
    mySprite.acceleration = mySprite.setAcceleration(pMaxDisplacement, pMaxTime, pJumpDistanceToTravel, pJumpInHowMuchTime)
    local velocity = {
      currentTimeForMaxSpeed = 0,
      currentSpeed = newVector(0,0),
      maxSpeedInY = getMaxSpeed(mySprite.acceleration.currentAcceleration, mySprite.jump.distanceToTravel, true, mySprite.jump.inHowMuchTime),
      maxSpeedInX = getMaxSpeed(mySprite.acceleration.currentAcceleration, pMaxDisplacement,false)
    }
    return velocity
  end
  -- set the sprite velocity
  mySprite.velocity = mySprite.setVelocity(pMaxDisplacement, pMaxTime, pJumpDistanceToTravel, pJumpInHowMuchTime)

  table.insert(factory.spriteList,mySprite)
  return mySprite
end



return factory
