-- it need to require a level or a map (something like that)
local world = {}
world.tileSet = nil
world.backgroundImages = {}

-- Global variable to manage the current level
LEVEL = {}
-- global variable that will handle the current level of the player 
CURRENTLEVEL = 1
--[[
    To create a sort of manager of tiled file.
    
    @return {object} An Object that can handle the tiled file object.
--]]
function newLevel(pLevelFile)

  local myLevel = pLevelFile -- will require a file, a level 
  myLevel.rotation = 0
  myLevel.scaleX = 1
  myLevel.scaleY = 1
  myLevel.visible = true


  --[[
      Will be used to get the id of a specific tile depending on the position given. Only used in the second layer, where the things that can collide with the sprites
      are.
  
      @param {number} pX: The X position to check the tile.
      @param {number} pY: The Y position to check the tile.
      @param {number} pTileSize: The tile size to loop through all the tiles.
      @param {number} pLayer: Which layer to search.
      
      @return {number} The Id of the tile.
  --]]
  function myLevel:getTileAt(pX,pY,pTileSize,pQuad,pLayer)
    -- i need to scale the tile size because this function is not called in a way that the scale function in the main draw affect 
    local horizontalPosition = math.floor(pX/(pTileSize*SCALEX)) + 1 -- I do + 1 because the position 0 does not exist, in fact the id 0 (there is no tile associated to it) doesn't exist
    local verticalPosition = math.floor(pY/(pTileSize*SCALEY))
    local idPosition = horizontalPosition + (verticalPosition)*myLevel.width  -- the width and height proprety is in the level file
    -- you can return an id only if you are restricted in the area of the map
    if horizontalPosition > 0 and horizontalPosition <= myLevel.width and verticalPosition >= 0 and verticalPosition < myLevel.height then
      local id = myLevel.layers[pLayer].data[idPosition]
      if id > #pQuad then
        id = self:setFlipedTile(id) -- return the good id 
      end 
      return id -- will return the id of the tile in the specific position, only in the specific layer you want to check, the collide layer for me. I can go through each layer but it will take to much ressource
    else 
      return nil -- there is no tile to collide with, since outside of the map
    end
  end

  --[[
      Set up the tile that are flipped. (Based On TiledEditor)
      
      @param {number} pID: The ID Flipped.
      
      @return {number} The non-flipped ID
  --]]
  function myLevel:setFlipedTile(pID)
    self.rotation = 0 -- you need to reset the rotation for each time you go through this function 
    self.scaleX = 1
    self.scaleY = 1
    local bit31   = 2147483648
    local bit30   = 1073741824
    local bit29   = 536870912
    local flipX   = false
    local flipY   = false
    local flipD   = false
    local realID = pID

    if realID>= bit31 then
      realID = realID - bit31
      flipX = true 
    end

    if realID>= bit30 then
      realID = realID - bit30
      flipY = true 
    end

    if realID>= bit29 then
      realID = realID - bit29
      flipD = true 
    end
    -- treatment of the rotation of the tile 
    if flipX then
      self.rotation = 2*math.pi -- nothing change
      if flipD then
        self.rotation = math.pi/2
      end
      if flipY then
        self.rotation = math.pi
      end
    elseif flipY then
      if flipD then
        self.rotation = (3/2)*(math.pi)
      end

    end

    return realID 
  end

  
  --[[
      Will draw each layers of the map
      The draw is scalable, i dont need to adapt the tile size dimension or anything because there are scaled in main draw function.
      
      @param {number} pTileSize: The size of the tile.
      @param {object} pTileSet: The tileset to use with the quad (if you use quad).
      @param {object} pQuad: The quad to use to draw
      @param {object} pTiles: A set of individual to use (no quad usage).
  --]]
  function myLevel:drawLayer(pTileSize,pTileSet,pQuad,pTiles)
    local index,layer
    local nameQuad = ""
    -- go through each layer
    for index, layer in ipairs (self.layers) do
      local l,c 
      -- you draw only the tilelayer type for the object layer you do something else 
      if layer.type == "tilelayer" then   
        -- go through each line of the map
        for l = 1,layer.height do
          -- go through each column of the map
          for c = 1,layer.width do
            -- if the sprite to draw is a quad or not 
            local isQuad = false 
            
            local positionOfTheTile = (l-1)*layer.width + c -- get the position of the tile 
            local id = layer.data[positionOfTheTile] -- will get the id of the tile in the specific layer since you are going through each layer 
            -- Verify if you use a TileSet or no
            if pTileSet ~= nil then  
              -- if the id is greater then the total of tile possible (of the tileSet) then the tile is fliped
              if id > #pQuad then
                id = self:setFlipedTile(id) -- return the good id 
              end
              -- before you draw check first if the layer is visible or not 
              if layer.visible == true then
                -- you can draw only if the id is greater then 0, because there is no tile assigned to the id 0 and under 0
                if id > 0 then
                  -- you draw each tile centered in there midle, i do that because when i manipulate rotated Tile, the rotation apply well
                  love.graphics.draw(pTileSet, pQuad[id], (c-1)*pTileSize + pTileSize/2 , (l-1)*pTileSize + pTileSize/2, self.rotation, 1, 1, pTileSize/2, pTileSize/2)
                  love.graphics.circle("fill",(c-1)*pTileSize + pTileSize/2 , (l-1)*pTileSize + pTileSize/2,1)
                end
              end
            else
              -- EVERYTHING HAPPENS THERE
              local img
              -- first see if there is something to draw, id id>0
              if id > 0 then 
                -- After check what to draw in function of the id 
                if id < 6 then
                  -- A map tiles
                  isQuad = true
                  nameQuad = "map"
                  pTiles[nameQuad].currentFrame = id                 
                elseif id == 6 then
                  isQuad = true
                  nameQuad = "Torch"
                
                end
              end

              if isQuad then
                img = pTiles[nameQuad].animation[pTiles[nameQuad].currentFrame]
              end
              -- draw if there is something to draw
              if img ~= nil then
                if index==1 then
                  -- invisible layer 
                  local xTile = (c-1)*LEVEL.tilewidth + self.tilewidth/2
                  local yTile = (l-1)*LEVEL.tileheight + self.tileheight/2
                  -- vision of the mBoi
                  local position = math.sqrt(math.pow((mBoi.position.x + mBoi.width/2) - xTile,2) + math.pow((mBoi.position.y + mBoi.width/2) - yTile,2))
                  local opacity = 1 - powerFunctionTween(2,0,0,mBoi.vision.scope,1,position)
                  if opacity<0 then
                    opacity = 0
                  end
                  love.graphics.setColor(1,1,1,opacity)
                  -- if it is quad then you draw the good portion of the image 
                  if isQuad then
                    love.graphics.draw(ASSET.level[nameQuad].image, img, (c-1)*pTileSize, (l-1)*pTileSize, self.rotation, 1, 1)
                  else
                    love.graphics.draw(img, (c-1)*pTileSize, (l-1)*pTileSize, self.rotation, 1, 1)
                  end
                  love.graphics.setColor(1,1,1,1)

                else
                -- else visible layer 
                  if isQuad then
                    love.graphics.draw(ASSET.level[nameQuad].image, img, (c-1)*pTileSize, (l-1)*pTileSize, self.rotation, 1, 1)
                  else
                    love.graphics.draw(img, (c-1)*pTileSize, (l-1)*pTileSize, self.rotation, 1, 1)                  
                  end
                end

              end
            end

          end
        end
        -- the layer of the object 
      elseif layer.type == "objectgroup" then 
        
        -- you draw the triangle layer 
        if layer.name == "Triangle" then  
          local x,y
          -- you go through each objects and you draw the associated sprite with the good type 
          for index, o in ipairs(layer.objects) do
            if o.properties["type"] == "triangle" then
              img = pTiles["triangle"].animation[pTiles["triangle"].currentFrame] -- draw the triangle sprite
              x = o.x 
              y = o.y - o.height -- don't forget that object are drawn 1 tile above theire original height 
            end
            -- draw the specific sprite
            if img ~= nil then
              love.graphics.draw(pTiles["triangle"].image,img, x, y, self.rotation, 1, 1)
              
              
            end
          end
        end
      end
    end
  end

  -- set a specific layer visible or not
  function myLevel:setLayerVisible(pLayer,pVisible)
    self.layers[pLayer].visible = pVisible
  end

  -- set the level visible or not
  function myLevel:setVisible(pVisible) 
    self.visible = pVisible 
  end

  --[[
      Update the element of the map (in this case it only animate the animated tiles)
  --]]
  function myLevel:update(dt)
    -- for the animation of each object 
    for i, tileset in ipairs(self.tilesets) do
      -- only apply animation for tiles that are animated 
      if #tileset.tiles > 0 and tileset.name ~= "arrow" then
        local sprite = ASSET.level[tileset.name]
        tileset.tiles[1].animation[sprite.currentFrame].duration = tileset.tiles[1].animation[sprite.currentFrame].duration - 1000*dt
        if tileset.tiles[1].animation[sprite.currentFrame].duration <= 0 then
          tileset.tiles[1].animation[sprite.currentFrame].duration = 250
          sprite.currentFrame = sprite.currentFrame + 1
        end
        if sprite.currentFrame > #sprite.animation  then
          sprite.currentFrame = 1
        end
      end
    end
  end

  function myLevel:draw(pTileSize,pTileSet,pQuad)
    if self.visible then
      self:drawLayer(pTileSize,pTileSet,pQuad) 
    end  
  end

  return myLevel
end
-- before you load a level you need to setup each quad of the tileSet 
function world.load(pLevel)
  -- load the level file 
  LEVEL = newLevel(require(pLevel))
  CURRENTLEVEL = tonumber(string.sub(pLevel,string.len(pLevel)))
end

function world.update(dt)
  LEVEL:update(dt)
end

function world.draw()
  LEVEL:drawLayer(30,nil,nil,ASSET.level)
end
--[[
  Takes a numerical value of the level and return it in String ex (1-->"level_1")
  
  @return {string}: the level in string value 
]]--
function world.translateLevelStringToNum()
  return "level_"..CURRENTLEVEL
end


return world