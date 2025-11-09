local NoNPC = {}
NoNPC.npcsRemoved = 0
NoNPC.vehiclesRemoved = 0
NoNPC.startTime = GetGameTimer()

-- Main thread to permanently disable NPC spawning
Citizen.CreateThread(function()
    while true do
        -- Completely disable all NPC spawning systems
        SetPedDensityMultiplierThisFrame(0.0)
        SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
        SetRandomVehicleDensityMultiplierThisFrame(0.0)
        SetParkedVehicleDensityMultiplierThisFrame(0.0)
        
        -- Disable police completely
        SetCreateRandomCops(false)
        SetCreateRandomCopsNotOnScenarios(false)
        SetCreateRandomCopsOnScenarios(false)
        SetPoliceIgnorePlayer(PlayerId(), true)
        SetDispatchCopsForPlayer(PlayerId(), false)
        
        -- Disable ambient events that spawn NPCs
        SetAmbientVehicleRangeMultiplierThisFrame(0.0)
        SetAmbientPedRangeMultiplierThisFrame(0.0)
        
        -- More aggressive NPC prevention
        SetGarbageTrucks(false)
        SetRandomBoats(false)
        
        Citizen.Wait(0)
    end
end)

-- Aggressive NPC removal thread
Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        -- Remove nearby peds
        RemoveNearbyPeds(playerCoords)
        
        -- Remove nearby vehicles  
        RemoveNearbyVehicles(playerCoords)
        
        -- Wait based on aggressive mode setting
        Citizen.Wait(Config.AggressiveMode.checkInterval)
    end
end)

-- Function to aggressively remove nearby peds
function RemoveNearbyPeds(playerCoords)
    local peds = GetGamePool('CPed')
    
    for _, ped in ipairs(peds) do
        if DoesEntityExist(ped) and ped ~= PlayerPedId() then
            local pedCoords = GetEntityCoords(ped)
            local distance = #(playerCoords - pedCoords)
            
            -- Remove peds within configured distance
            if distance < Config.AggressiveMode.removalDistance then
                local pedModel = GetEntityModel(ped)
                local modelName = GetEntityArchetypeName(ped)
                
                -- Remove ALL peds that aren't players
                if not IsPedAPlayer(ped) then
                    SetEntityAsMissionEntity(ped, true, true)
                    DeleteEntity(ped)
                    NoNPC.npcsRemoved = NoNPC.npcsRemoved + 1
                    
                    if Config.Debug then
                      --  print("[AutoNoNPC] Removed ped: " .. (modelName or "unknown"))
                    end
                end
            end
        end
    end
end

-- Function to aggressively remove nearby vehicles
function RemoveNearbyVehicles(playerCoords)
    local vehicles = GetGamePool('CVehicle')
    
    for _, vehicle in ipairs(vehicles) do
        if DoesEntityExist(vehicle) then
            local vehicleCoords = GetEntityCoords(vehicle)
            local distance = #(playerCoords - vehicleCoords)
            
            -- Remove vehicles within configured distance
            if distance < Config.AggressiveMode.removalDistance then
                local driver = GetPedInVehicleSeat(vehicle, -1)
                
                -- Remove vehicle if no driver or driver is NPC
                if driver == 0 or (DoesEntityExist(driver) and not IsPedAPlayer(driver)) then
                    -- First remove any NPCs in the vehicle
                    for i = -1, 6 do -- Check all seats
                        local seatPed = GetPedInVehicleSeat(vehicle, i)
                        if seatPed ~= 0 and DoesEntityExist(seatPed) and not IsPedAPlayer(seatPed) then
                            SetEntityAsMissionEntity(seatPed, true, true)
                            DeleteEntity(seatPed)
                        end
                    end
                    
                    -- Then remove the vehicle
                    SetEntityAsMissionEntity(vehicle, true, true)
                    DeleteEntity(vehicle)
                    NoNPC.vehiclesRemoved = NoNPC.vehiclesRemoved + 1
                    
                    if Config.Debug then
                        local modelName = GetEntityArchetypeName(vehicle)
                     --   print("[AutoNoNPC] Removed vehicle: " .. (modelName or "unknown"))
                    end
                end
            end
        end
    end
end

-- Additional thread for area clearing (more aggressive)
Citizen.CreateThread(function()
    while true do
        local playerCoords = GetEntityCoords(PlayerPedId())
        
        -- Clear area around player of all peds and vehicles
        ClearAreaOfPeds(playerCoords.x, playerCoords.y, playerCoords.z, 100.0, 0)
        ClearAreaOfVehicles(playerCoords.x, playerCoords.y, playerCoords.z, 100.0, false, false, false, false, false, 0)
        
        Citizen.Wait(10000) -- Clear area every 10 seconds
    end
end)

-- Prevent NPCs from targeting player
Citizen.CreateThread(function()
    while true do
        SetPlayerWantedLevel(PlayerId(), 0, false)
        SetPlayerWantedLevelNow(PlayerId(), false)
        SetPlayerWantedLevelNoDrop(PlayerId(), 0, false)
        Citizen.Wait(1000)
    end
end)

-- Resource start message
Citizen.CreateThread(function()
    Citizen.Wait(5000)
  --  print("==========================================")
   -- print("[AutoNoNPC] System ACTIVATED")
   -- print("[AutoNoNPC] All NPCs and traffic disabled")
   -- print("[AutoNoNPC] No toggle commands available")
   -- print("[AutoNoNPC] System is permanently ON")
   -- print("==========================================")
end)

-- Debug information (optional)
if Config.Debug then
    Citizen.CreateThread(function()
        local lastNPCs = 0
        local lastVehicles = 0
        
        while true do
            -- Only log if numbers changed
            if lastNPCs ~= NoNPC.npcsRemoved or lastVehicles ~= NoNPC.vehiclesRemoved then
                --print(string.format("[AutoNoNPC] Total Removed - NPCs: %d, Vehicles: %d", 
               --     NoNPC.npcsRemoved, NoNPC.vehiclesRemoved))
                
                lastNPCs = NoNPC.npcsRemoved
                lastVehicles = NoNPC.vehiclesRemoved
            end
            
            Citizen.Wait(5000)
        end
    end)
end

-- Reset game settings when resource stops (safety measure)
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        -- Re-enable NPC spawning (safety)
        SetPedDensityMultiplierThisFrame(1.0)
        SetScenarioPedDensityMultiplierThisFrame(1.0, 1.0)
        SetRandomVehicleDensityMultiplierThisFrame(1.0)
        SetParkedVehicleDensityMultiplierThisFrame(1.0)
        SetCreateRandomCops(true)
        
        --print("[AutoNoNPC] System deactivated - NPC spawning re-enabled")
    end
end)