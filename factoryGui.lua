local gui = {}
-- the structure of the code is like that 
-- you have GROUP
-- in the GROUP you have ELEMENTS
-- each ELEMENTS are specific thing, such as BUTTON,PANEL,etc. 


--[[
    Used to create a general element of a gui, some feature that are common to all the elements.
    
    @return {object}: A general element of a gui.
--]]
local function newElement(pX,pY)
  local myElement = {}
  myElement.x = pX
  myElement.y = pY
  myElement.visisble = true

  function myElement:draw()
    print("no element to draw") -- just say that you didn't add a draw function to the element you create 
  end

  function myElement:update()
    
  end
  return myElement
end
--[[
    A group in this gui stores all the gui elements that have things in common, you create a group then you store element in it
    
    @return {object}: A group object that can store diffent element of a gui
--]]
function gui.newGroup()
  local myGroup = {}
  -- store all the element : element,button,pannel
  myGroup.element = {}
  myGroup.visible = true

  --[[
      Used to add an element in the group of element 
      
      @param {object} pElement: The element to add.
  --]]
  function myGroup:addElement(pElement)
    table.insert(self.element,pElement)
  end
  --[[
      Set visible the group of element or not. 
      
      @param {boolean} pVisible: Visible or not.
  --]]
  function myGroup:setVisible(pVisible)
    self.visible = pVisible
  end
  
  --[[
      Used to update all the elements in the group of element 
      
      @param {number} dt: delta time.
  --]]
  function myGroup:update(dt)
    local index,element
    for index,element in ipairs(self.element) do
      element:update(dt) -- you call the update of each elements you have in the group
    end
  end
  --[[
      Used to draw all the elements in the group of element.
      
      @param {boolean} pIsLevel: If you have to draw a number corresponding to each level of the game inside the element (for a panel).
  --]]
  function myGroup:draw(pIsLevel)
    if self.visible then  
      local index,element
      for index,element in ipairs(self.element) do
        element:draw(pIsLevel,index) -- you call the draw of each elements you have in the group
      end
    end
  end

  return myGroup
end
--[[
    Used to create a panel.
    
    @param {number} pX: The X position to check the panel.
    @param {number} pY: The Y position to check the panel.
    @param {number} pWidth: The width of the panel.
    @param {number} pHeight: The height of the panel.
    
    @return {object}: A Panel object.
--]]
function gui.newPanel(pX,pY,pWidth,pHeight)
  local myPanel = newElement(pX,pY)
  myPanel.width = pWidth
  myPanel.height = pHeight
  myPanel.isHover = false  -- proprety that will be used to determine if something is hover the button like the cursor of a mouse
  myPanel.lstEvent = {} -- will stock all the event
  
  
  --[[
      Set an image to the panel (if you want to use sprite)
      
      @param {String} pPathImage: The image path you want to load.
  --]]
  function myPanel:setImage (pPathImage) 
    self.image = love.graphics.newImage(pPathImage)
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
  end
  --[[
      Let you set an event and call this event whenever it needs to be trigered.
      
      @param {String} pEvent: The name of the event.
      @param {function} pFunction: The callback function associated to the event.
  --]]
  function myPanel:setEvent(pEvent,pFunction)
    self.lstEvent[pEvent] = pFunction
  end
  
  --[[
      Let you set visible or not a panel.
      
      @param {boolean} pVisible: The element is visible or not.
  --]]
  function myPanel:setElementVisisble(pVisible)
    self.visible = pVisible
  end
  --[[
      This is the specific update of the panel, it basically check if you hover over the panel or not with the mouse
      
      @param {number} dt: delta time.
  --]]
  function myPanel:updatePanel(dt)
    local mx,my = convertCoordinate(love.mouse.getX(),love.mouse.getY()) 
    if (mx >= self.x) and (mx <= self.x + self.width) and (my >= self.y) and (my <= self.y + self.height) then
      self.isHover = true
      if self.lstEvent["hover"] ~= nil then
        self.lstEvent["hover"]() -- you start the thing you want to do when the mouse is over the panel
      end
    else
      self.isHover = false
    end
  end

  -- overriding the update function with a specific one 
  function myPanel:update(dt)
    self:updatePanel(dt)
  end


  --[[
      Draw the panel.
      @param {boolean} pIsLevel: Do you draw the number of the level inside the panel or not.
      @param {number} pWichLevel: Wich level # to draw.
  --]]
  function myPanel:drawPanel(pIsLevel,pWichLevel) 
    if self.image ~= nil then
      love.graphics.draw(self.image,self.x,self.y)
    else
      love.graphics.rectangle("line",self.x,self.y,self.width,self.height)
      -- this section draw the number associated with the level
      if pIsLevel == true then
        love.graphics.setFont(ASSET.font.game)
        love.graphics.print(pWichLevel , self.x + self.width/2 , self.y + self.height/2)-- draw a number in the middle of the panel
        love.graphics.setFont(ASSET.font.basic)
      end
      
      if self.isHover then
        if self.imgHover ~= nil then
          love.graphics.draw(self.imgHover,self.x,self.y)
        else
          love.graphics.rectangle("fill",self.x,self.y,self.width,self.height)
        end
      end
    end
  end

  function myPanel:draw()
    if self.visible then
      self:drawPanel()
    end
  end
  -- a panel has no update function if is just something that contain something, static object
  return myPanel
end
--[[
    Used to create a panel.
    
    @param {number} pX: The X position to check the panel.
    @param {number} pY: The Y position to check the panel.
    @param {number} pWidth: The width of the panel.
    @param {number} pHeight: The height of the panel.
    @param {number} pLevel: If it is a button to access a level, which level it access.
    
    @return {object}: A Button object.
--]]
function gui.newButton(pX,pY,pWidth,pHeight,pLevel)
  local myButton = gui.newPanel(pX,pY,pWidth,pHeight) -- so basically a button is just a panel but with a specific update 
  myButton.level = pLevel -- exclusively for the level button
  myButton.isPressed = false
  --myButton.wasPressed = false
  myButton.oldPresse = false -- this value will stock the old click of the mouse
  
 --[[
      Set an image to the button (if you want to use sprite)
      
      @param {String} pImgDefault: The image path of the default image of the button.
      @param {String} pImgHover: The image path of the button when it is hovered.
      @param {String} pImgPressed: The image path of the button when it is pressed.
  --]]
  function myButton:setImage(pImgDefault,pImgHover,pImgPressed)
    self.imgDefault = love.graphics.newImage(pImgDefault)
    self.imgHover = love.graphics.newImage(pImgHover)
    self.imgPressed = love.graphics.newImage(pImgPressed)
    self.width = self.imgDefault:getWidth()
    self.height = self.imgDefault:getHeight()
  end
--[[
      The update of the button is the same as the panel update, but with the "potential" pressed event.
      
      @param {number} dt: delta time.
  --]]
  function myButton:updateButton(dt)
    self:updatePanel(dt) -- call the panel update, to keep the hover effect
    
    if self.isHover and not self.oldPresse and love.mouse.isDown(1) then
      self.isPressed = true
      if self.lstEvent["pressed"]~=nil then
        self.lstEvent["pressed"]()
      end
    else
      self.isPressed = false
    end
    self.oldPresse = love.mouse.isDown(1) -- will keep a trace of the old click of the mouse
  end

  function myButton:update(dt)
    self:updateButton(dt)
  end
--[[
      Draw the button.
      
      @param {boolean} pIsLevel: Do you draw the number of the level inside the button or not.
      @param {number} pWichLevel: Wich level # to draw.
  --]]
  function myButton:drawButton(pIsLevel,pWichLevel)
    self:drawPanel(pIsLevel,pWichLevel) -- you always draw the panel
    if self.isHover then
      if self.imgHover ~= nil then
        love.graphics.draw(self.imgHover,self.x,self.y)
      else
        love.graphics.rectangle("fill",self.x,self.y,self.width,self.height)
      end
    end
    if self.isPressed then
      if self.imgPressed ~= nil then
        love.graphics.draw(self.imgPressed,self.x,self.y)
      else
        love.graphics.setColor(1,0,0)
        love.graphics.rectangle("fill",self.x,self.y,self.width,self.height)
        love.graphics.setColor(1,1,1)
      end
    end
  end


  function myButton:draw(pIsLevel,pWichLevel)
    self:drawButton(pIsLevel,pWichLevel)
  end

  return myButton
end


return gui