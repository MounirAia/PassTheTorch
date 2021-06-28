--[[
  Create a 2D vector
  
  @param {number} pX: x position in pixel
  @param {number} pY: y psition  in pixel
]]--
function newVector(pX, pY)
  local v = {}
  v.x = pX
  v.y = pY

  local metaTableVector = {}
  --[[
    @override the addition of the object of type vector.
    
    @param {object} v1: Vector object.
    @param {object} v2: Vector object.
    
    @return {object} a new vector.
  --]]
  
  function metaTableVector.__add(v1,v2)
    return newVector(v1.x + v2.x, v1.y + v2.y)
  end
--[[
    @override the substraction of the object of type vector 
    
    @param {object} v1: Vector object.
    @param {object} v2: Vector object.
    
    @return {object} a new vector.
  --]]
  function metaTableVector.__sub(v1,v2)
    return newVector(v1.x - v2.x, v1.y - v2.y)
  end
  --[[
    @override the multiplication of the object of type vector (scalar multiple)
    
    @param {number} k: A scalar multiplier.
    @param {object} v2: Vector object.
    
    @return {object} a new vector.
  --]]
  function metaTableVector.__mul(k,v1)
    return newVector(k*v1.x, k*v1.y)
  end
  -- set the metaTable 
  setmetatable(v,metaTableVector)
--[[
    Get the magnitude of the vector.
    
    @return {number} the magnitude of the vector.
  --]]
  function v.getMagnitude()
    return math.sqrt(v.x^2 + v.y^2)
  end
--[[
    Normalize the vector.
    
    @return {object} the normalized vector.
  --]]  
  function v.getNormalizeVector()
    local mgn = v.magnitude()
    if mgn <= 0 or mgn == nil then
      print("Magnitude is erroneous" , mgn)
    else
      return newVector(v.x/mgn, v.y/mgn)
    end
  end

  return v 
end

--[[
  To get acceleration based on the distance,the time and the initial velocity
  I derived this equation from this one: pS = pV0*pTime + (1/2)*(Acceleration)*(pTime)^2
  
  @param {number} pS: the distance to travel
  @param {number} pTime: the time it takes
  @param {number} pV0: initial velocity
]]--
function getAcceleration(pS,pTime,pV0,pIsInY)
  if pTime ~= 0 then  
    -- you want acceleration in Y or in X
    if pIsInY ~= true then
      -- ACC in X 
      return newVector((2*(pS-pV0*pTime))/(pTime^2),0)
    else
      -- ACC in Y
      return newVector(0,(2*(pS-pV0*pTime))/(pTime^2))
    end
  else
    print("The acceleration can't be computed: Division by 0")
  end
end

--[[
  Calculate the initial velocity of an object based on the distance to travel and the time it takes and the final velocity at the end of the movement 
  I only use it for the vertical axis, that's why it returns only a vector in the vertical axis
  
  @param {number} pS: distance to travel
  @param {number} pTime: times it takes to travel
  @param {number} pV: final velocity
  
  @return {object} A vector object.
]]--
function getInitialVelocity(pS,pTime,pV)
  -- only in the Y axis 
  if pTime~=0 then
    return newVector(0,2*(pS/pTime) - pV)
  else
    print("The initial velocity can't be computed: Division by 0")
  end
end
--[[
    Function that get the max speed of the character based on his max displacement and acceleration 
    
    @param {object} pAcceleration: The acceleration of the character, vector object.
    @param {number} pDisplacement: max distance he will travel by exponetiel movement.
    @param {boolean} pInY: tell if you want the max speed based on the horizontal or vertical length of the acceleration.
    @param {number} pInHowMuchTime: The duration of the whole movement.

    @return {number} the max speed he can reach (a scalar value).
  --]]
function getMaxSpeed(pAcceleration, pDisplacement,pInY,pInHowMuchTime)
  if pInY then  
    -- the max speed in Y axis occur at the begining of the movement 
    local vector = getInitialVelocity(pDisplacement,pInHowMuchTime,0)
    return vector.getMagnitude()

  else

    if pDisplacement*pAcceleration.x >= 0 then
      return math.sqrt(2*pAcceleration.x*pDisplacement)
    else
      print("Max speed is negative and is in X: ")
    end
  end
end



