if not lib then return end
ESX = exports["es_extended"]:getSharedObject()
local PedModel = `a_m_m_eastsa_01`

function GetRepInfo(xp) -- Edit this for rep level difference
    if xp < 50 then
        return 1, 50 - xp, xp * 4
    elseif xp < 150 then
        return 2, 150 - xp, xp - 50
    elseif xp < 500 then
        return 3, 500 - xp, (xp - 150) * (100/350)
    elseif xp < 1250 then
        return 4, 1250 - xp, (xp - 500) * (100/750)
    elseif xp < 3000 then
        return 5, 3000 - xp, (xp - 1250) * (100/1750)
    elseif xp < 6000 then
        return 6, 6000 - xp, (xp - 3000) * (100/3000)
    elseif xp < 10000 then
        return 7, 10000 - xp, (xp - 6000) * (100/4000)
    elseif xp < 15500 then
        return 8, 15500 - xp, (xp - 10000) * (100/5500)
    elseif xp < 22500 then
        return 9, 22500 - xp, (xp - 15500) * (100/7000)
    elseif xp < 31000 then
        return 10, 31000 - xp, (xp - 22500) * (100/8500)
    end
  end

Citizen.CreateThread(function()
    if Config.EnableShop then
        for k, v in pairs(Config.Shops) do
            RequestModel(PedModel)
            while not HasModelLoaded(PedModel) do
            Wait(1)
            end
            local Blip = AddBlipForCoord(v.x, v.y, v.z)

            SetBlipSprite (Blip, 587)
            SetBlipDisplay(Blip, 4)
            SetBlipScale  (Blip, 0.8)
            SetBlipColour(Blip, 22)
            SetBlipAsShortRange(Blip, true)

            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName(Config.BlipLabel)
            EndTextCommandSetBlipName(Blip)


            Ped = CreatePed(1, PedModel, v.x, v.y, v.z, v.w, false, true)
            SetPedFleeAttributes(Ped, 2)
            SetBlockingOfNonTemporaryEvents(Ped, true)
            SetPedCanRagdollFromPlayerImpact(Ped, false)
            SetPedDiesWhenInjured(Ped, false)
            FreezeEntityPosition(Ped, true)
            SetEntityInvincible(Ped, true)
            SetPedCanPlayAmbientAnims(Ped, true)
        end
    end
end)

exports.ox_target:addModel(PedModel, {
    {
        name = 'metaldetector',
        icon = 'fa-solid fa-magnifying-glass',
        label = Config.OpenShop,
        canInteract = function()
            if Config.EnableShop then
                for k, v in pairs(Config.Shops) do
                    if #(vector3(v.x, v.y, v.z) - GetEntityCoords(PlayerPedId())) <= 10 then
                        return true
                    end
                end
            end
        end,
        onSelect = function() OpenMetalDetectorMenu() end,
        distance = 3.5
    }
  })



  function OpenMetalDetectorMenu()
    
    local Xp = lib.callback.await('MetalDetector:getXP', false)
    local XpLevel, XpNeeded, Progress = GetRepInfo(Xp)

    lib.registerContext({
    id = 'metal_detector_menu',
    title = Config.BlipLabel,
    options = {
        {
            title = Config.CurrentLevel..XpLevel..'\n'..Config.CurrentXp..Xp,
            icon = 'chart-simple',
            description = Config.YouNeedXp..XpNeeded..Config.NeedXp,
            progress = Progress
        },
        {
            title = Config.Shop,
            icon = 'shop',
            onSelect = function()
                exports.ox_inventory:openInventory('shop', { type = 'MetalDetector' })

            end,
        },
        {
            title = Config.SellItems,
            icon = 'tag',
            onSelect = function()
                OpenSellMenu()
            end,
        },
    }
    })

    lib.showContext('metal_detector_menu')
  end
  
  function OpenSellMenu()
    items = exports.ox_inventory:Items()
    elements = {}
    AllMin = 0
    AllMax = 0
    HasItem = false
    for k, v in pairs(Config.Rewards) do
        Amount = exports.ox_inventory:GetItemCount(v.Item)
        if Amount > 0 then
            HasItem = true
            table.insert(elements, {
                title = items[v.Item].label,
                description = Config.Sell..''..Amount..' '..items[v.Item].label..' '..Config.For..' '..Config.MoneySymbol..''..v.MinReward..' - €'..v.MaxReward..'.',
                icon = v.Icon,
                onSelect = function()
                    
                    Amount = exports.ox_inventory:GetItemCount(v.Item)
                    local input = lib.inputDialog(Amount..' '..items[v.Item].label, {
                        {type = 'number', label = Config.Amount, description = Config.EnterSellAmount..Config.MoneySymbol..v.MinReward..' - €'..v.MaxReward..'.', icon = 'hashtag'},
                    })
                    if input[1] then
                        if input[1] > Amount then
                            input[1] = Amount
                        end
                        local prijs = math.random(v.MinReward, v.MaxReward)
                        local succes = lib.callback.await('MetalDetector:SellItem', false, v.Item, input[1], prijs)
                    end
                end,
            })
            AllMin = AllMin + v.MinReward * Amount
            AllMax = AllMax + v.MaxReward * Amount
        end
    end
    if HasItem then
        table.insert(elements, {
            title = Config.SellAll,
            description = Config.SellAll..' '..Config.For..' '..Config.MoneySymbol..AllMin..' - €'..AllMax..'.',
            icon = 'tags',
            onSelect = function()
                for k, v in pairs(Config.Rewards) do
                    Amount = exports.ox_inventory:GetItemCount(v.Item)
                    if Amount > 0 then
                        local prijs = math.random(v.MinReward, v.MaxReward)
                        local succes = lib.callback.await('MetalDetector:SellItem', false, v.Item, Amount, prijs)
                    end
                end
            end,

        })
    end
    lib.registerContext({
        id = 'metal_detector_sell',
        title = Config.BlipLabel,
        options = elements
    })
    lib.showContext('metal_detector_sell')
  end




  --Detector
  local metaalCoords = {}
  local metaalRadius = 70.0
  local metaalDist = 15.0
  local metaalMax = 20
  local blockTimer = 0
  local metaalDifficulty = 1.5
  


local refreshKeer = 0 
local check = false

function refreshGebieden()
       metaalCoords = {}
       refreshKeer = 0
       check = false
       while #metaalCoords < metaalMax do
        Wait(1)
        
       local randomCoords = getRandomCoords()
       --print(randomCoords)
       if randomCoords == 1 then
        break
       elseif randomCoords == 2 then
       else
        table.insert(metaalCoords, randomCoords)
       end
    end
end

function getRandomCoords()
    local speler = PlayerPedId()
    local spelerCoords = GetEntityCoords(speler)
    check = false
    randomCoords = vector3(spelerCoords.x + math.random(-metaalRadius, metaalRadius), spelerCoords.y + math.random(-metaalRadius, metaalRadius), spelerCoords.z)
    if isOffroadAtCoords(randomCoords.x, randomCoords.y, randomCoords.z) then
        if #metaalCoords > 0 then
            for k, v in pairs(metaalCoords) do
                if #(vector2(v.x, v.y) - vector2(randomCoords.x, randomCoords.y)) >= metaalDist then
                    if #(vector2(v.x, v.y) - vector2(spelerCoords.x, spelerCoords.y)) >= (metaalDist * 2) then
                        check = true
                       -- print(randomCoords)
                        return randomCoords
                    end
                end
            end
        else
            check = true
            return randomCoords
        end
    else
        if not check then
            if refreshKeer > 100 then
                return 1
            end
            refreshKeer = refreshKeer + 1
        end
        return 2
   end
end
 

--[[
Citizen.CreateThread(function()
    while true do
        Wait(1)
        for k, v in pairs(metaalCoords) do 
            DrawMarker(2, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.25, 128, 226, 169, 200, false, false, 2, true, nil, nil, false)
        end
    end
end) ]]

function getClosestTarget(coords)
    closest = vector3(0,0,0)
    closestDist = 500.0
    index = 0
    if #metaalCoords > 0 then
        for k, v in pairs(metaalCoords) do
            if #(vector2(v.x, v.y) - vector2(coords.x, coords.y)) <= closestDist then
                closest = vector3(v.x, v.y, v.z)
                closestDist = #(vector2(v.x, v.y) - vector2(coords.x, coords.y))
                index = k
            end
        end
    end
    return closestDist, k
end


local IsDetector = false
local DidCancelDetector = false
local ScannerAudioDelay = 0.0



local EntityOffsets = {
    ["w_am_digiscanner"] = {
		bone = 18905,
        offset = vector3(0.15, 0.1, 0.0),
        rotation = vector3(270.0, 90.0, 80.0),
	},
    -- cant get the fucking model to be standalone so im replacing the digiscanner
    -- nobody uses it anyways so w/e
    ["w_am_metaldetector"] = {
		bone = 18905,
        offset = vector3(0.15, 0.1, 0.0),
        rotation = vector3(270.0, 90.0, 80.0),
	},
    -- original digiscanner stuff
    -- ["w_am_digiscanner"] = {
	-- 	bone = 57005,
    --     offset = vector3(0.1, 0.1, 0.0),
    --     rotation = vector3(270.0, 90.0, 90.0),
	-- },
}

local AttachedEntities = {}
local ScannerEntity = nil
local CanDig = false
function AttachEntity(ped, model)
    if EntityOffsets[model] then
        EnsureModel(model)
        local pos = GetEntityCoords(PlayerPedId())
    	local ent = CreateObjectNoOffset(model, pos, 1, 1, 0)
    	AttachEntityToEntity(ent, ped, GetPedBoneIndex(ped, EntityOffsets[model].bone), EntityOffsets[model].offset, EntityOffsets[model].rotation, 1, 1, 0, 0, 2, 1)
        ScannerEntity = ent
        table.insert(AttachedEntities, ent)
    end
end

function CleanupModels()
    for _, ent in next, AttachedEntities do
        DetachEntity(ent, 0, 0)
        DeleteEntity(ent)
    end
    AttachedEntities = {}
    ScannerEntity = nil
end

function Dig()
    IsDetector = false
    local Player = PlayerPedId()
    LocalPlayer.state.invBusy = true

    TaskStartScenarioInPlace(Player, "WORLD_HUMAN_GARDENER_PLANT")
    local Xp = lib.callback.await('MetalDetector:getXP', false)
    Wait(5000)
    local Reward = GetReward(Xp)
    while not Reward do
        Wait(100)
        Reward = GetReward(Xp)
    end
    
    local Success = lib.skillCheck(Reward.Skill, {'e'})
    ClearPedTasks(Player) 
    print(Reward.Item)
    print(Reward.Amount)
    print(Success)
    if Success then
        TriggerServerEvent('MetalDetector:GiveReward', Reward.Item, Reward.Amount)
        TriggerServerEvent('MetalDetector:setXP', Xp + Reward.AddXP)
    else

    end
    LocalPlayer.state.invBusy = false

end



function GetReward(xp)
    local huidigeRewards = {}
    local repLevel = GetRepInfo(xp)
    for k, v in pairs(Config.Rewards) do
        if v.Level <= repLevel then
            table.insert(huidigeRewards, v)
        end
    end
    local Rand = math.random(1, #huidigeRewards)
    local Reward = huidigeRewards[Rand]
    local Chance = math.random(1, 100)
    if Chance <= Reward.Chance then
        return Reward
    else
        return false
    end
end

function StopDetector()
    if not DidCancelDetector then
        if blockTimer < 5 then
            blockTimer = 5
        end
        lib.hideTextUI()
        DidCancelDetector = true
        CleanupModels()
        local ped = PlayerPedId()
        StopEntityAnim(ped, "wood_idle_a", "mini@golfai", true)
        IsDetector = false
        TriggerServerEvent("detector:userStoppeddetector")
    end
end

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        CleanupModels()
        StopDetector()
    end
end)

function StartDetector()
    if not IsDetector then
        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)
        if isOffroadAtCoords(pedCoords.x, pedCoords.y, pedCoords.z) then
            if blockTimer <= 0 then
                blockTimer = 10
                detectorThreads() 
                refreshGebieden()
            else
                ESX.ShowNotification(Config.YouNeed..blockTimer..Config.WaitSeconds)
            end
        end
    end
end

RegisterNetEvent("detector:forceStart")
AddEventHandler("detector:forceStart", function()
    StartDetector()
end)
RegisterNetEvent("detector:forceStop")
AddEventHandler("detector:forceStop", function()
    StopDetector()
end)

RegisterCommand('-metaldetector-dig', function()
    if IsDetector and CanDig then
        Dig()
    end
end, false)

RegisterKeyMapping('-metaldetector-dig', 'Start to dig for materials', 'keyboard', 'e')

RegisterCommand('-metaldetector-stop', function()
    if IsDetector then
        IsDetector = false
    end
end, false)

RegisterKeyMapping('-metaldetector-stop', 'Stop metal detecting', 'keyboard', 'f')

Citizen.CreateThread(function()
    while true do
        Wait(1000)
        if blockTimer > 0 then
            blockTimer = blockTimer - 1
        end
    end
end)


function detectorThreads()
    if IsDetector then return false end
    TriggerServerEvent("detector:userStarteddetector")
    IsDetector = true
    DidCancelDetector = false
    CanDig = false
    lib.showTextUI('[F] - '..Config.ToStop, {
        position = "left-center",
        icon = 'magnifying-glass',
        style = {
            borderRadius = 0,
            backgroundColor = 'rgba(128, 226, 169, 0.8)',
            color = 'white'
        }
    })
    -- detector handler
    local durabilityTick = 0
    CreateThread(function()
        AttachEntity(PlayerPedId(), "w_am_digiscanner")
        durabilityTick = 0
        while IsDetector do
            local ped = PlayerPedId()
            local ply = PlayerId()
            local canProspect = true
            if not IsEntityPlayingAnim(ped, "mini@golfai", "wood_idle_a", 3) then
                PlayAnimUpper(PlayerPedId(), "mini@golfai", "wood_idle_a")
            end

            -- Actions that halt detector animations and scanning
            local restrictedMovement = false
            restrictedMovement = restrictedMovement or IsPedFalling(ped)
            restrictedMovement = restrictedMovement or IsPedJumping(ped)
            restrictedMovement = restrictedMovement or IsPedSprinting(ped)
            restrictedMovement = restrictedMovement or IsPedRunning(ped)
            restrictedMovement = restrictedMovement or IsPlayerFreeAiming(ply)
            restrictedMovement = restrictedMovement or IsPedRagdoll(ped)
            restrictedMovement = restrictedMovement or IsPedInAnyVehicle(ped)
            restrictedMovement = restrictedMovement or IsPedInCover(ped)
            restrictedMovement = restrictedMovement or IsPedInMeleeCombat(ped)

            if restrictedMovement then canProspect = false end
            if canProspect then
                local pos = GetEntityCoords(ped) + vector3(GetEntityForwardX(ped) * 0.75, GetEntityForwardY(ped) * 0.75, -0.75)
                local dist = getClosestTarget(pos)
                local dist = dist * metaalDifficulty
                if dist >= 1.5 and CanDig then
                    lib.hideTextUI()
                    lib.showTextUI('[F] - '..Config.ToStop, {
                        position = "left-center",
                        icon = 'magnifying-glass',
                        style = {
                            borderRadius = 0,
                            backgroundColor = 'rgba(128, 226, 169, 0.8)',
                            color = 'white'
                        }
                    })
                    CanDig = false
                end
                if dist < 1.5 then
                    if not CanDig then
                        lib.hideTextUI()
                        lib.showTextUI('[F] - '..Config.ToStop..' \n [E] - '..Config.ToDig, {
                            position = "left-center",
                            icon = 'trowel',
                            style = {
                                borderRadius = 0,
                                backgroundColor = 'rgba(128, 226, 169, 0.8)',
                                color = 'white'
                            }
                        })
                    end
                    CanDig = true
                    ScannerAudioDelay = 0.15
                elseif dist < 2.0 then
                    ScannerAudioDelay = 0.225
                elseif dist < 3.0 then
                    ScannerAudioDelay = 0.275
                elseif dist < 4.0 then
                    ScannerAudioDelay = 0.325
                elseif dist < 5.0 then
                    ScannerAudioDelay = 0.35
                elseif dist < 6.0 then
                    ScannerAudioDelay = 0.375
                elseif dist < 7.0 then
                    ScannerAudioDelay = 0.4
                elseif dist < 8.0 then
                    ScannerAudioDelay = 0.425
                elseif dist < 9.0 then
                    ScannerAudioDelay = 0.45
                elseif dist < 10.0 then
                    ScannerAudioDelay = 0.5
                elseif dist < 11.0 then
                    ScannerAudioDelay = 0.55
                elseif dist < 12.0 then
                    ScannerAudioDelay = 0.6
                elseif dist < 13.0 then
                    ScannerAudioDelay = 0.65
                elseif dist < 14.0 then
                    ScannerAudioDelay = 0.7
                elseif dist < 15.0 then
                    ScannerAudioDelay = 0.75
                elseif dist < 16.5 then
                    ScannerAudioDelay = 0.85
                elseif dist < 18.0 then
                    ScannerAudioDelay = 0.95
                elseif dist < 19.5 then
                    ScannerAudioDelay = 1.1
                elseif dist < 21.0 then
                    ScannerAudioDelay = 1.2
                elseif dist < 22.5 then
                    ScannerAudioDelay = 1.3
                elseif dist < 24.0 then
                    ScannerAudioDelay = 1.4
                elseif dist < 25.5 then
                    ScannerAudioDelay = 1.5
                elseif dist < 27.0 then
                    ScannerAudioDelay = 1.75
                elseif dist < 28.5 then
                    ScannerAudioDelay = 2.0
                elseif dist < 30.0 then
                    ScannerAudioDelay = 2.25
                elseif dist < 32.5 then
                    ScannerAudioDelay = 2.5
                elseif dist < 35.0 then
                    ScannerAudioDelay = 2.75
                else
                    CanDig = false
                    ScannerAudioDelay = 0.0
                end
                if durabilityTick > 20 then
                    durabilityTick = 0
                    local kapot = lib.callback.await('MetalDetector:tickDurability', false)
                    if kapot then
                        IsDetector = false
                    end
                else
                    durabilityTick = durabilityTick + 1
                end

            end
            
            if not canProspect then
                -- Ped is busy and can't prospect at this time (like falling or w/e)
                StopEntityAnim(ped, "wood_idle_a", "mini@golfai", true)
                scannerScale = 0.0
            end
            if not IsDetector then
                CleanupModels()
                StopEntityAnim(ped, "wood_idle_a", "mini@golfai", true)
                scannerScale = 0.0
            end
            Wait(200)
        end
        StopDetector()
    end)
end



function EnsureModel(model)
    if not IsModelInCdimage(model) then
    else
        if not HasModelLoaded(model) then
            RequestModel(model)
        	while not HasModelLoaded(model) do
        		Wait(0)
        	end
    	end
	end
end

local previousAnim = nil
function StopAnim(ped)
    if previousAnim then
        StopEntityAnim(ped, previousAnim[2], previousAnim[1], true)
        previousAnim = nil
    end
end
function PlayAnimFlags(ped, dict, anim, flags)
    StopAnim(ped)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end
    local len = GetAnimDuration(dict, anim)
    TaskPlayAnim(ped, dict, anim, 1.0, -1.0, len, flags, 1, 0, 0, 0)
    previousAnim = {dict, anim}
end

function PlayAnimUpper(ped, dict, anim)
    PlayAnimFlags(ped, dict, anim, 49)
end
function PlayAnim(ped, dict, anim)
    PlayAnimFlags(ped, dict, anim, 0)
end

Citizen.CreateThread(function()
    while true do
        Wait(1)
        if IsDetector then
            if ScannerAudioDelay > 0.1 then
                Wait(ScannerAudioDelay * 1000) 
                local ped = PlayerPedId()
                local pos = GetEntityCoords(ped) + vector3(GetEntityForwardX(ped) * 0.75, GetEntityForwardY(ped) * 0.75, -0.75)
                if isOffroadAtCoords(pos.x, pos.y, pos.z) then
                    PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0)
                    PlaySoundFrontend(-1, "BOATS_PLANES_HELIS_BOOM", "MP_LOBBY_SOUNDS", 0)
                end
            else
                Wait(1000)
            end
        else
            Wait(1000)
        end
    end
end)



local offroadMaterials = {
    [282940568] = "Gras",
    [-461750719] = "Modder",
    [-1595148316] = "Zand",
    [510490462] = "Zand",
    [-1286696947] = "Gras",
    [509508168] = "Zand",
    [1] = "Zand",
    [1] = "Zand",
    [1] = "Zand",
    [1] = "Zand",
    [1] = "Zand",
}

function isOffroadAtCoords(x, y, z)
    -- Start een geavanceerde raycast naar de grond
    local shapeTest = StartExpensiveSynchronousShapeTestLosProbe(x, y, z + 20.0, x, y, z - 50.0, 1, 0, 7)
    local retval, hit, endCoords, surfaceNormal, materialHash, entityHit = GetShapeTestResultIncludingMaterial(shapeTest)
    -- Debug: Laat zien of de raycast een hit had
    if hit == 1 then
        if offroadMaterials[materialHash] then
            return true
        else
            return false
        end
    else
    end

    return false
end


RegisterCommand('doff', function()
x = GetEntityCoords(PlayerPedId()).x
y = GetEntityCoords(PlayerPedId()).y
z = GetEntityCoords(PlayerPedId()).z
    local shapeTest = StartExpensiveSynchronousShapeTestLosProbe(x, y, z + 20.0, x, y, z - 50.0, 1, 0, 7)
    local retval, hit, endCoords, surfaceNormal, materialHash, entityHit = GetShapeTestResultIncludingMaterial(shapeTest)
    -- Debug: Laat zien of de raycast een hit had
    print(materialHash)
    print(offroadMaterials[materialHash])
end, false)