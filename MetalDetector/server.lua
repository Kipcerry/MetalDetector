if not lib then return end
ESX = exports["es_extended"]:getSharedObject()


lib.callback.register('MetalDetector:getXP', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local results = MySQL.Sync.fetchAll("SELECT xp FROM `metaldetector` WHERE `identifier` = @identifier", {
        ['@identifier'] = xPlayer.identifier
    })
    if results[1] then
        return results[1].xp
    else
        MySQL.query.await("INSERT INTO metaldetector (identifier) VALUES (?)", { xPlayer.identifier })
        return 0
    end
end)

lib.callback.register('MetalDetector:getRandomSeed', function(source)
    return os.time() + os.clock() * 1000000

end)

lib.callback.register('MetalDetector:SellItem', function(source, Item, Amount, prijs)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(Item, Amount)
    xPlayer.addInventoryItem('money', Amount * prijs)
    return true

end)

lib.callback.register('MetalDetector:tickDurability', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    durability = 100.0
	local slot = exports.ox_inventory:GetSlotIdWithItem(xPlayer.source, Config.MetalDetectorItem)
	local playerItems = exports.ox_inventory:GetInventoryItems(xPlayer.source)
	for k, v in pairs(playerItems) do
		if slot == v.slot then
			durability = v.metadata.durability
		end
	end
	local nieuweDura = durability - math.random(1, 2)

	if nieuweDura > 0 then
		exports.ox_inventory:SetDurability(xPlayer.source, slot, nieuweDura)
        return false
	else
		exports.ox_inventory:SetDurability(xPlayer.source, slot, 0)
		return true
	end

end)

RegisterServerEvent("MetalDetector:setXP")
AddEventHandler("MetalDetector:setXP", function(xp)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.execute('UPDATE metaldetector SET xp = @xp WHERE identifier = @identifier', {
        ["@identifier"] = xPlayer.identifier, 
        ["@xp"] = xp
    }, nil)
end)

RegisterServerEvent("MetalDetector:GiveReward")
AddEventHandler("MetalDetector:GiveReward", function(Item, Amount)
    print(Item)
    print(Amount)
    local xPlayer = ESX.GetPlayerFromId(source)
   xPlayer.addInventoryItem(Item, Amount)
end)



ESX.RegisterUsableItem(Config.MetalDetectorItem, function(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    durability = 100.0
	local slot = exports.ox_inventory:GetSlotIdWithItem(xPlayer.source, Config.MetalDetectorItem)
	local playerItems = exports.ox_inventory:GetInventoryItems(xPlayer.source)
	for k, v in pairs(playerItems) do
		if slot == v.slot then
			durability = v.metadata.durability
		end
	end
    if durability > 5 then
        TriggerClientEvent("detector:forceStart", playerId)
    else
        xPlayer.showNotification(Config.NoBatery)
    end
end)


ESX.RegisterUsableItem(Config.BateryItem, function(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    durability = 100.0
	local slot = exports.ox_inventory:GetSlotIdWithItem(xPlayer.source, Config.MetalDetectorItem)
	local playerItems = exports.ox_inventory:GetInventoryItems(xPlayer.source)
    if slot then
        for k, v in pairs(playerItems) do
            if slot == v.slot then
                durability = v.metadata.durability
            end
        end
        if durability <= 50 then
            xPlayer.removeInventoryItem(Config.BateryItem, 1)
            exports.ox_inventory:SetDurability(xPlayer.source, slot, 100)
        else
            xPlayer.showNotification(Config.EnoughBatery)
        end
    else
        xPlayer.showNotification(Config.NoMetalDetector)
    end
end)
 


--Detector
local DEBUG = false
local function debugLog() end
if DEBUG then debugLog = function(...)
    print(...)
end end

local detector_STATUS = {}
local detector_TARGETS = {}

-- Multiplier for distance to check
-- 1.0 is default, allows ~3m around target
-- 2.0 allows ~1.5m around target
-- 10.0 allows ~0.3m around target
-- Alters all distance checks, so higher means you need to be closer to the target to get a signal
-- Each controller resource can define their own difficulty
local detector_DIFFICULTIES = {}

--[[ Common ]]
function UpdatedetectorTargets(player)
    local targets = {}
    for _, target in next, detector_TARGETS do
        local difficulty = detector_DIFFICULTIES[target.resource] or 1.0
        targets[#targets + 1] = {target.x, target.y, target.z, difficulty}
    end
    debugLog("new targets", json.encode(targets))
    TriggerClientEvent("detector:setTargetPool", player, targets)
end

function InsertdetectorTarget(resource, x, y, z, data)
    detector_TARGETS[#detector_TARGETS + 1] = {resource = resource, data = data, x = x, y = y, z = z}
end

function InsertdetectorTargets(resource, targets)
    for _, target in next, targets do
        InsertdetectorTarget(resource, target.x, target.y, target.z, target.data)
    end
    UpdatedetectorTargets(-1)
end

function RemovedetectorTarget(index)
    local new_targets = {}
    for n, target in next, detector_TARGETS do
        if n ~= index then
            new_targets[#new_targets + 1] = target
        end
    end
    detector_TARGETS = new_targets
    UpdatedetectorTargets(-1)
end

function FindMatchingPickup(x, y, z)
    for index, target in next, detector_TARGETS do
        local dx, dy, dz = target.x, target.y, target.z
        if math.floor(dx) == math.floor(x) and math.floor(dy) == math.floor(y) and math.floor(dz) == math.floor(z) then
            return index
        end
    end
    return nil
end

function HandledetectorPickup(player, index, x, y, z)
    debugLog("pickup", player, "idx", index, "pos", x, y, z)
    local target = detector_TARGETS[index]
    if target then
        local dx, dy, dz = target.x, target.y, target.z
        local resource, data = target.resource, target.data
        if math.floor(dx) == math.floor(x) and math.floor(dy) == math.floor(y) and math.floor(dz) == math.floor(z) then
            debugLog("pickup matches")
            RemovedetectorTarget(index)
            TriggerEvent("detector:onCollected", player, resource, data, x, y, z)
        else
            debugLog("pickup does not match")
            local newMatch = FindMatchingPickup(x, y, z)
            if newMatch then
                HandledetectorPickup(player, newMatch, x, y, z)
            end
        end
    else
        debugLog("target does not exist?")
    end
end

--[[ Export handling ]]

function AdddetectorTarget(x, y, z, data)
    local resource = GetInvokingResource()
    debugLog("adding detector target at", vector3(x, y, z), "with data", data)
    InsertdetectorTarget(resource, x, y, z, data)
end
AddEventHandler("detector:AdddetectorTarget", function(x, y, z, data)
    AdddetectorTarget(x, y, z, data)
end)

function AdddetectorTargets(list)
    local resource = GetInvokingResource()
    debugLog("adding detector targets")
    InsertdetectorTargets(resource, list)
end
AddEventHandler("detector:AdddetectorTargets", function(list)
    AdddetectorTargets(list)
end)




function Stopdetector(player)
    if detector_STATUS[player] then
        debugLog("forcing", player, "to stop")
        TriggerClientEvent("detector:forceStop", player)
    end
end
AddEventHandler("detector:Stopdetector", function(player)
    Stopdetector(player)
end)

function Isdetector(player)
    return detector_STATUS[player] ~= nil
end

function SetDifficulty(modifier)
    local resource = GetInvokingResource()
    detector_DIFFICULTIES[resource] = modifier
end

--[[ Client triggered events ]]

-- When the client stops detector
RegisterServerEvent("detector:userStoppeddetector")
AddEventHandler("detector:userStoppeddetector", function()
    local player = source
    if detector_STATUS[player] then
        local time = GetGameTimer() - detector_STATUS[player]
        detector_STATUS[player] = nil
        TriggerEvent("detector:onStop", player, time)
    end
end)

-- When the client starts detector
RegisterServerEvent("detector:userStarteddetector")
AddEventHandler("detector:userStarteddetector", function()
    local player = source
    if not detector_STATUS[player] then
        detector_STATUS[player] = GetGameTimer()
        TriggerEvent("detector:onStart", player)
    end
end)

-- When the client collects a node
RegisterServerEvent("detector:userCollectedNode")
AddEventHandler("detector:userCollectedNode", function(index, x, y, z)
    local player = source
    if detector_STATUS[player] then
        HandledetectorPickup(player, index, x, y, z)
    end
end)

RegisterServerEvent("detector:userRequestsLocations")
AddEventHandler("detector:userRequestsLocations", function()
    local player = source
    UpdatedetectorTargets(player)
end)

