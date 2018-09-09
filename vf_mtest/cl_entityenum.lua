local entityEnumerator = {
    __gc = function(enum)
      if enum.destructor and enum.handle then
        enum.destructor(enum.handle)
      end
      enum.destructor = nil
      enum.handle = nil
    end
}

EntityEnum = {}

--[[ ENTITY ITERATION STUFF ]]

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
        disposeFunc(iter)
        return
        end
        
        local enum = {handle = iter, destructor = disposeFunc}
        setmetatable(enum, entityEnumerator)
        
        local next = true
        repeat
        coroutine.yield(id)
        next, id = moveFunc(iter)
        until not next
        
        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end

function EntityEnum.EnumerateObjects()
return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function EntityEnum.EnumeratePeds()
return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EntityEnum.EnumerateVehicles()
return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EntityEnum.EnumeratePickups()
return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end