local Auth = exports.plouffe_lib:Get("Auth")
local Utils = exports.plouffe_lib:Get("Utils")
local Callback = exports.plouffe_lib:Get("Callback")
local Uniques = exports.plouffe_lib:Get("Uniques")

local lastPlayerBoost = {}

local playerProfiles = {}
local playersData = {}

local avaiblesRaces = {}

local activeRaces = {}
local lastRacesTick = {}

local boostActive = false

local isCreationAllowed = false

function Races.Start()
    local profilesData = GetResourceKvpString(("playerProfiles"))
    local racesData = GetResourceKvpString("races")    
    local deliverysData = json.decode(LoadResourceFile(GetCurrentResourceName(), "data/delivery.json"))

    Boosts.Wanted = json.decode(LoadResourceFile(GetCurrentResourceName(), "data/wanted.json"))
    Boosts.spawns = json.decode(LoadResourceFile(GetCurrentResourceName(), "data/spawns.json"))

    for k,v in pairs(Boosts.spawns) do
        v.coords = vector3(v.coords.x, v.coords.y, v.coords.z)
    end

    for k,v in pairs(deliverysData) do
        table.insert(Boosts.deliverys, vector3(v.x, v.y, v.z))
    end

    if racesData then
        avaiblesRaces = json.decode(racesData)
    end

    if profilesData then
        playerProfiles = json.decode(profilesData)
    end

    Boosts:GenerateBoosts()

    local players = GetPlayers()

    for k,playerId in pairs(players) do
        playerId = tonumber(playerId)

        local unique = Uniques.Get(playerId)
        if unique then
            Races.OnUnique(playerId,unique)
        end
    end
end

function Races.IsNameValid(name)
    -- Add blacklisted wors @todo
    for k,v in pairs(playerProfiles) do
        if v.name == name then
            return false
        end
    end

    return true
end

function Races.AddRp(playerId, value)
    local unique = Uniques.Get(playerId)

    if not unique then
        return
    end

    playerProfiles[unique].rp += value

    playersData[playerId] = playerProfiles[unique]

    SetResourceKvp("playerProfiles", json.encode(playerProfiles))

    TriggerClientEvent("plouffe_racing:updateProfile", playerId, playersData[playerId])
end
exports("AddRp", Races.AddRp)

function Races.RemoveRp(playerId, value)
    local unique = Uniques.Get(playerId)

    if not unique then
        return
    end

    if not playerProfiles[unique] or playerProfiles[unique].rp < value then
        return false
    end

    playerProfiles[unique].rp -= value

    playersData[playerId] = playerProfiles[unique]

    SetResourceKvp("playerProfiles", json.encode(playerProfiles))

    TriggerClientEvent("plouffe_racing:updateProfile", playerId, playersData[playerId])

    return true
end
exports("RemoveRp", Races.RemoveRp)

function Races.OnHackingTool(auth)
    local playerId = source

    if not Auth:Validate(playerId, auth) then
        return
    end

    if not Races.RemoveRp(playerId, 100) then
        return Utils:Notify(playerId, "Vous n'avez pas asser de rp")
    end

    exports.ox_inventory:AddItem(playerId, "boost_hacking_tool", 1)
end

function Races.OnUnique(playerId,unique)
    playersData[playerId] = playerProfiles[unique] or nil
    if not Boosts.avaibleBoosts[unique] then
        Boosts:CreateBoosts(unique)
    end
end

function Races.RemoveUnique(playerId)
    playersData[playerId] = nil
end

function Races.Load()
    local playerId = source
    local registred, key = Auth:Register(playerId)

    if registred then
        local data = Races:Get()
        data.auth = key

        TriggerClientEvent("plouffe_racing:getConfig",playerId, data)
    else
        TriggerClientEvent("plouffe_racing:getConfig",playerId,nil)
    end
end

function Races:Get()
    local data = {}
    for k,v in pairs(self) do
        if type(v) ~= "function" then
            data[k] = v
        end
    end

    return data
end

function Races.GetNextId()
    local retval = 1

    for k,v in pairs(avaiblesRaces) do
        if v.id >= retval then
            retval = v.id + 1
        end
    end

    return retval
end

function Races.SaveNewRace(raceData, auth)
    local playerId = source

    if not Auth:Validate(playerId, auth) then
        return
    end

    local player = exports.ooc_core:getPlayerFromId(playerId)

    local data = raceData

    data.id = Races.GetNextId()

    data.creator = {
        name = player.name,
        identifier = player.identifier
    }

    avaiblesRaces[data.id] = data

    SetResourceKvp("races", json.encode(avaiblesRaces))
end

function Races.GetRaceFromId(id)
    for k,v in pairs(avaiblesRaces) do
        if v.id == id then
            return v
        end
    end
end

function Races.GetCheckPoints(id)
    local checkpoints = {}

    for k,v in pairs(avaiblesRaces) do
        if v.id == id then

            for x,y in pairs(v.checkpoints) do
                checkpoints[x] = y
            end
            break
        end
    end

    return checkpoints
end

function Races.GetRaceTypeValid(data)
    if not data then
        return "laps"
    end

    data = data:lower()

    if data == "sprint" or data == "laps" or data == "drift" then
        return data
    end

    return "laps"
end

function Races.GetVehicleTypeValid(data)
    if not data then
        return "automobile"
    end

    data = data:lower()

    if data == "automobile" or data == "bike" or data == "boat" or data == "plane" then
        return data
    end

    return "automobile"
end

function Races:NewRace(raceId, data)
    if activeRaces[raceId] then
        return
    end

    local laps = tonumber(data.laps) and tonumber(data.laps) > 0 and tonumber(data.laps) or 1
    local phasing = data.phasing and data.phasing == true or false
    local raceType = self.GetRaceTypeValid(data.type)
    local penality = tonumber(data.penality) and tonumber(data.penality) > 0 and tonumber(data.penality) or 0
    local raceDelay = tonumber(data.startDelay) and tonumber(data.startDelay) > 0 and tonumber(data.startDelay) or 5

    local raceData = self.GetRaceFromId(raceId)
    local checkpoints = self.GetCheckPoints(raceId)

    if raceType ~= "sprint" then
        checkpoints[#checkpoints + 1] = checkpoints[1]
    else
        laps = 1
    end

    lastRacesTick[raceId] = os.time()

    activeRaces[raceId] = {
        id = raceId,
        players = {},
        checkpoints = checkpoints,
        laps = laps,
        type = raceType,
        name = raceData.name,
        vehicle = raceData.vehicle,
        phasing = phasing,
        penality = penality,
        timeLeft = raceDelay
    }

    TriggerClientEvent("plouffe_racing:newRace", -1, activeRaces[raceId])

    Races:CreateRaceThread(raceId)
end

function Races.StartRace(raceId, data, auth)
    local playerId = source

    if not Auth:Validate(playerId, auth) then
        return
    end

    Races:NewRace(raceId, data)
end

function Races.NotifyRacers(raceId, message)
    for k,v in pairs(activeRaces[raceId].players) do
        Utils:Notify(v.playerId, message)
    end
end

function Races.TriggerRaceEvent(event,raceId,...)
    for k,v in pairs(activeRaces[raceId].players) do
        TriggerClientEvent(event,v.playerId,...)
    end
end

function Races.IsRaceFinished(raceId)
    if not activeRaces[raceId] then
        return true
    end

    local time = os.time()

    if time - lastRacesTick[raceId] > 60 * 10 or #activeRaces[raceId].players < 1 then
        return true
    end

    for k,v in pairs(activeRaces[raceId].players) do
        if not v.finished then
            return false
        end
    end

    return true
end

function Races:CreateRaceThread(raceId)
    CreateThread(function()
        while activeRaces[raceId] and activeRaces[raceId].timeLeft > 0 do
            activeRaces[raceId].timeLeft -= 1
            Wait(1000)
        end

        if not activeRaces[raceId] or #activeRaces[raceId].players < 1 then
            TriggerClientEvent("plouffe_racing:removeRace", -1, raceId)
            activeRaces[raceId] = nil
            return
        end

        self.TriggerRaceEvent("plouffe_racing:freeze", raceId, raceId, activeRaces[raceId].players)

        local letEmKnow = 10

        while letEmKnow > 0 do
            letEmKnow -= 1
            self.NotifyRacers(raceId, ("Temp restant avant le depart %s secondes"):format(letEmKnow))
            Wait(1000)
        end

        if math.random(1,2) == 1 then
            local alertData = {
                index = 'StreetRace',
                coords = vector3(activeRaces[raceId].checkpoints[1].coords.x, activeRaces[raceId].checkpoints[1].coords.y, activeRaces[raceId].checkpoints[1].coords.z),
                job = {police = true},
                blip = {name = "10-65A", sprite = 9, scale = 1.0, color = 1, radius = 400.0},
                code = "10-65A",
                name = "Course de rue",
                style = 'red',
                fa = "fa-exclamation-triangle"
            }

            exports.plouffe_dispatch:sendAlert(alertData)
        end

        self.TriggerRaceEvent("plouffe_racing:start", raceId, raceId)

        while not self.IsRaceFinished(raceId) do
            Wait(2000)
        end

        self.TriggerRaceEvent("plouffe_racing:clear", raceId, raceId)

        activeRaces[raceId] = nil
    end)
end

function Races.GetPlayerRaceKey(playerId, raceId)
    for k,v in pairs(activeRaces[raceId].players) do
        if v.playerId == playerId then
            return k
        end
    end
end

function Races.GetPosition(playerKey,raceId)
    local position = 1
    local checkpoint = activeRaces[raceId].players[playerKey].checkpoint

    for k,v in pairs(activeRaces[raceId].players) do
        if v.checkpoint > checkpoint then
            position += 1
        end
    end

    return position
end

function Races:PlayerCheckpoint(playerId, raceId)
    if not activeRaces[raceId] then
        return
    end

    local playerKey = self.GetPlayerRaceKey(playerId, raceId)

    activeRaces[raceId].players[playerKey].checkpoint += 1

    if #activeRaces[raceId].checkpoints == activeRaces[raceId].players[playerKey].checkpoint then
        activeRaces[raceId].players[playerKey].finished = true
        -- self.TriggerRaceEvent("plouffe_racing:playerFinished")
    end

    lastRacesTick[raceId] = os.time()

    Player(playerId).state.racePosition = self.GetPosition(playerKey,raceId)
end

function Races.CheckPoint(raceId, auth)
    local playerId = source

    if not Auth:Validate(playerId, auth) then
        return
    end

    Races:PlayerCheckpoint(playerId, raceId)
end

function Races.ValidateVehicleType(playerId, raceId)
    local ped = GetPlayerPed(playerId)
    local vehicle = GetVehiclePedIsIn(ped, false)
    local vehicleType = activeRaces[raceId].vehicle

    if vehicle == 0 then
        if vehicleType == "foot" then
            return true
        end

        return false
    end

    local myVehicleType = GetVehicleType(vehicle)

    if myVehicleType == vehicleType then
        return true
    end

    return false
end

function Races.Join(playerId, raceId)
    if not activeRaces[raceId] then
        return
    end

    if not Races.ValidateVehicleType(playerId, raceId) then
        return Utils:Notify(playerId, "Vous n'avez pas le bon model de vehicule pour cette course")
    end

    activeRaces[raceId].players[#activeRaces[raceId].players + 1] = {
        playerId = playerId,
        racerName = Races.GetRacerName(playerId) or ("Racer %s"):format(playerId),
        checkpoint = 0
    }

    Player(playerId).state.racePosition = 0

    TriggerClientEvent("plouffe_racing:prepare", playerId, activeRaces[raceId])

    return true
end

function Races.GetRacerName(playerId)
    local unique = Uniques.Get(playerId)
    return playersData[unique] and playersData[unique].racerName or "Inconnu"
end

function Races.ShowRaces()
    for k,v in pairs(avaiblesRaces) do
        print(([[

            Nom: %s
            Createur: %s
            Id: %s]]
        ):format(v.name, v.creator.name, v.id))
    end
end
exports("ShowRaces", Races.ShowRaces)

function Races.Delete(id)
    for k,v in pairs(avaiblesRaces) do
        if v.id == id then
            avaiblesRaces[k] = nil
            SetResourceKvp("races", json.encode(avaiblesRaces))
            print(("Race with id of %s deleted"):format(id))
            break
        end
    end
end
exports("Delete", Races.Delete)

function Races.GetLabels()
    local data = {}

    for k,v in pairs(avaiblesRaces) do
        if k ~= "checkpoints" then
            data[#data + 1] = v
        end
    end

    return data
end

function Races.Leave(auth)
    local playerId = source

    if not Auth:Validate(playerId, auth) then
        return
    end

    for raceId, raceData in pairs(activeRaces) do
        for _,playerData in pairs(raceData.players) do
            if playerData.playerId == playerId then
                activeRaces[raceId].players[_] = nil
            end
        end
    end
end

function Races.PlayerFinished(data, raceId, auth)
    local playerId = source

    if not Auth:Validate(playerId, auth) then
        return
    end

    local racerNamer = Races.GetRacerName(playerId)

    if not racerNamer then
        return
    end

    if avaiblesRaces[raceId].bestTime and avaiblesRaces[raceId].bestTime.int < data.int then
        return
    end

    avaiblesRaces[raceId].bestTime = {
        int = data.int,
        timeString = data.string,
        name = racerNamer,
        unique = Uniques.Get(playerId)
    }

    SetResourceKvp("races", json.encode(avaiblesRaces))

    TriggerClientEvent("plouffe_racing:updateBestTime", -1, raceId, avaiblesRaces[raceId].bestTime)
end

function Boosts:NewBoost(id)
    local class
    local randi = math.random(0, 1000)

    if randi >= 990 then
        class = "S+"
    elseif randi >= 970 then
        class = "S"
    elseif randi >= 750 then
        class = "A"
    elseif randi >= 600 then
        class = "B"
    else
        class = "C"
    end

    local this = Boosts.BoostsVehicle[class][math.random(1,#Boosts.BoostsVehicle[class])]
    local boostPrice = math.random(this.boostPrice.min, this.boostPrice.max)
    local scratchPrice = math.random(this.scratchPrice.min, this.scratchPrice.max)
    local value = math.random(this.value.min, this.value.max)

    local data = {
        id = id,
        model = this.model,
        label = this.label,
        class = class,
        boostPrice = boostPrice,
        scratchPrice = scratchPrice,
        value = boostPrice + value
    }

    return data
end

function Boosts:CreateBoosts(unique)
    Boosts.avaibleBoosts[unique] = Boosts.avaibleBoosts[unique] or {}
    for i = 1, 5 do
        Boosts.avaibleBoosts[unique][i] = self:NewBoost(i)
    end
end

function Boosts:GenerateBoosts()
    CreateThread(function()
        while true do
            local players = GetPlayers()
            for k,v in pairs(players) do
                local unique = Uniques.Get(v)
                if unique then
                    self:CreateBoosts(unique)
                end
            end
            self:GenerateWanteds()
            Wait(self.boostIntervall)
        end
    end)
end

function Boosts.StartBoost(playerId, cb, isScratch, id, auth)
    if not Auth:Validate(playerId, auth) then
        return cb(false)
    end

    local unique = Uniques.Get(playerId)

    if lastPlayerBoost[unique] and os.time() - lastPlayerBoost[unique] < (60 * 60) then
        return cb(false), Utils:Notify(playerId, "Vous devez attendre 1 heur entre chaques boost")
    end

    if not playersData[playerId] then
        return cb(false), Utils:Notify(playerId, "Vous avez besoin d'un profile pour avoir accès au boosts")
    end

    local cops = exports.plouffe_society:GetPlayersPerJob("police")

    if not cops or Utils:TableLen(cops) < 2 then
        return cb(false), Utils:Notify(playerId, "Il n'y a pas asser de policier en service présentement")
    end

    if Boosts.activeBoosts then
        return cb(false), Utils:Notify(playerId, "Il y a déjà un boost actif en ce moment")
    end

    if not Boosts.avaibleBoosts[unique][id] then
        return cb(false), Utils:Notify(playerId, "Ce boost n'est plus disponible")
    end

    local price = isScratch and Boosts.avaibleBoosts[unique][id].scratchPrice or Boosts.avaibleBoosts[unique][id].boostPrice

    if not Races.RemoveRp(playerId, price) then
        return cb(false), Utils:Notify(playerId, "Vous n'avez pas asser de rp")
    end

    lastPlayerBoost[unique] = os.time()

    Boosts.activeBoosts = Boosts.avaibleBoosts[unique][id]
    Boosts.avaibleBoosts[unique][id] = nil

    Boosts.activeBoosts.isScratch = isScratch
    Boosts.activeBoosts.owner = unique
    Boosts.activeBoosts.playerId = playerId
    Boosts.activeBoosts.spawn = Boosts.spawns[math.random(1, #Boosts.spawns)]
    Boosts.activeBoosts.delivery = Boosts.deliverys[math.random(1, #Boosts.deliverys)]
    Boosts.activeBoosts.totalHacks = Boosts.Hacks[Boosts.activeBoosts.class]
    Boosts.activeBoosts.currentHacks = 0
    Boosts.activeBoosts.sleep = 5

    CreateThread(Boosts.CreateBoostThread)

    cb(Boosts.activeBoosts)
end

function Boosts.CreateBoostThread()
    boostActive = true

    local color = Boosts.VehicleColours[math.random(1, #Boosts.VehicleColours)]
    local alertData = {
        index = 'boosting',
        job = {police = true},
        blip = {name = "10-99", sprite = 56, scale = 1.0, color = 27},
        code = "10-99",
        name = ("Grand theft auto: %s"):format(Boosts.activeBoosts.class),
        style = 'red',
        fa = "fa-exclamation-triangle",
        model = Boosts.activeBoosts.label,
        color = color.label
    }

    local vehicle
    local wasPlayerInside = false
    local wasCreated = false
    local maxTime = os.time() + (60 * 60 * 1)
    local lastAlert = 0

    while boostActive do
        local currentTime = os.time()
        local sleepTimer = 1000

        if wasCreated then
            if Boosts.activeBoosts.currentHacks < Boosts.activeBoosts.totalHacks then
                if wasPlayerInside and currentTime - lastAlert > Boosts.activeBoosts.sleep then
                    lastAlert = currentTime
                    alertData.coords = GetEntityCoords(vehicle)
                    exports.plouffe_dispatch:sendAlert(alertData)
                elseif not wasPlayerInside then
                    for i = -1, 3 do
                        local ped = GetPedInVehicleSeat(vehicle, i)
                        if DoesEntityExist(ped) then
                            wasPlayerInside = true
                        end
                    end
                end
            else
                if not Boosts.activeBoosts.isScratch then
                    if #(GetEntityCoords(vehicle) - Boosts.activeBoosts.delivery) < 10 then
                        sleepTimer = 10000
                        local players = GetPlayers()
                        local isDone = true
                        local cops = exports.plouffe_society:GetPlayersPerJob("police")
                        local uniquePlayer

                        for k,v in pairs(cops) do
                            if #(GetEntityCoords(GetPlayerPed(k)) - Boosts.activeBoosts.delivery) < 50 then
                                isDone = false
                                break
                            end
                        end

                        for k,v in pairs(players) do
                            if #(GetEntityCoords(GetPlayerPed(v)) - Boosts.activeBoosts.delivery) < 50 then
                                isDone = false
                                break
                            end

                            if not uniquePlayer then
                                local unique = Uniques.Get(v)
                                if unique == Boosts.activeBoosts.owner then
                                    uniquePlayer = v
                                end
                            end
                        end

                        if isDone then
                            Races.AddRp(uniquePlayer, Boosts.activeBoosts.value)
                            Utils:Notify(uniquePlayer, ("Vous avez recu %s rp suite a votre boost réussi"):format(Boosts.activeBoosts.value))
                            DeleteEntity(vehicle)

                            boostActive = false
                        end
                    end
                elseif Boosts.activeBoosts.isScratched then
                    local player = exports.ooc_core:getPlayerFromId(Boosts.activeBoosts.isScratched)
                    local exists = MySQL.query.await("SELECT plate FROM owned_vehicles WHERE plate = ?", {alertData.plate})
                    local netId = Boosts.activeBoosts.netId
                    if exists[1] then
                        alertData.plate = exports.plouffe_garage:CreatePlate()
                        SetVehicleNumberPlateText(vehicle, alertData.plate)
                    end

                    MySQL.query.await("INSERT INTO owned_vehicles (state_id, plate, vehicle, vehiclemodel, garage, is_scratched) VALUES (:state_id, :plate, :vehicle, :vehiclemodel, :garage, :is_scratched)", {
                        state_id = player.state_id,
                        plate = alertData.plate,
                        vehicle = json.encode({
                            model = joaat(Boosts.activeBoosts.model),
                            plate = alertData.plate
                        }),
                        vehiclemodel = Boosts.activeBoosts.model,
                        is_scratched = 1,
                        garage = "sortit"
                    })

                    Callback:ClientCallback(player.playerId, "plouffe_racing:getVehicleProps", 30, function(props)
                        if props then
                            MySQL.update('UPDATE owned_vehicles SET vehicle = ? WHERE plate = ?', {json.encode(props), alertData.plate}, function(affectedRows) end)
                        end
                        Utils:Notify(player.playerId, "Le véhicule vous appartien maintenant")
                    end, {netId = netId})

                    boostActive = false
                end
            end
        else
            if #(GetEntityCoords(GetPlayerPed(Boosts.activeBoosts.playerId)) - Boosts.activeBoosts.spawn.coords) < 100 then
                vehicle, alertData.plate = Boosts.CreateBoostVehicle(color)
                wasCreated = true
            end
        end

        if (wasCreated and not DoesEntityExist(vehicle)) or (currentTime > maxTime) then
            break
        end

        Wait(sleepTimer)
    end

    boostActive = false
    Boosts.activeBoosts = nil
end

function Boosts.FinishedScratching(auth)
    local playerId = source

    if not Auth:Validate(playerId, auth) then
        return cb(false)
    end

    if not Boosts.activeBoosts or (Boosts.activeBoosts and Boosts.activeBoosts.currentHacks < Boosts.activeBoosts.totalHacks) then
        return
    end

    local ped = GetPlayerPed(playerId)
    local pedCoords = GetEntityCoords(ped)
    local vehicleCoords = GetEntityCoords(Boosts.activeBoosts.vehicle)

    if #(pedCoords - vehicleCoords) > 10 then
        return ExecuteCommand(("ban %s -1 Dicks"):format(playerId))
    end

    Boosts.activeBoosts.isScratched = playerId
end

function Boosts.CreateBoostVehicle(color)
    local vehicle = Citizen.InvokeNative(`CREATE_AUTOMOBILE`, joaat(Boosts.activeBoosts.model), Boosts.activeBoosts.spawn.coords.x, Boosts.activeBoosts.spawn.coords.y, Boosts.activeBoosts.spawn.coords.z, Boosts.activeBoosts.spawn.heading)

    SetVehicleColours(vehicle, color.id, color.id)

    local plate = GetVehicleNumberPlateText(vehicle)
    local breakTime = os.time() + 20

    while plate == "" and os.time() < breakTime do
        Wait(1000)
        plate = GetVehicleNumberPlateText(vehicle)
    end

    if plate == "" then
        plate = "Inconnu"
    end

    Boosts.activeBoosts.vehicle = vehicle
    Boosts.activeBoosts.netId = NetworkGetNetworkIdFromEntity(vehicle)

    -- Entity(vehicle).state:Set("isBoost", true, true)

    return vehicle, plate
end

function Races.FinishedHacking(succes, auth)
    local playerId = source

    if not Auth:Validate(playerId, auth) then
        return cb(false)
    end

    if not succes then
        return Utils:ReduceDurability(playerId, 'boost_hacking_tool', 250)
    end

    if Boosts.activeBoosts and Boosts.activeBoosts.currentHacks then
        Boosts.activeBoosts.currentHacks += 1
        Boosts.activeBoosts.sleep += 1
    end

    Utils:Notify(playerId, ("Bon travail, il reste %s hack"):format(Boosts.activeBoosts.totalHacks - Boosts.activeBoosts.currentHacks))
end

function Boosts:GenerateWanteds()
    self.activeWanteds = {}

    for i = 1, 20 do
        self.activeWanteds[i] = self.Wanted[math.random(1, #self.Wanted)]
        self.activeWanteds[i].id = i
    end
end

function Boosts.ReturnWantedVehicle(netId, auth)
    local playerId = source

    if not Auth:Validate(playerId, auth) then
        return
    end

    local ped = GetPlayerPed(playerId)
    local vehicle = GetVehiclePedIsIn(ped)
    if not DoesEntityExist(vehicle) then
        return
    end

    local thisNetId = NetworkGetNetworkIdFromEntity(vehicle)
    if thisNetId ~= netId then
        return
    end

    local thisModel = GetEntityModel(vehicle)
    for k,v in pairs(Boosts.activeWanteds) do
        local model = joaat(v.model)

        if model == thisModel then
            Races.AddRp(playerId, v.value)
            TriggerClientEvent("plouffe_racing:removeWanted", -1, v.id)
            Boosts.activeWanteds[k] = nil
            DeleteEntity(vehicle)
            return
        end
    end

end

Callback:RegisterServerCallback("plouffe_racing:getWanteds", function(playerId, cb, auth)
    if not Auth:Validate(playerId, auth) then
        return cb(false)
    end

    cb(Boosts.activeWanteds)
end)

Callback:RegisterServerCallback("plouffe_racing:canCreate", function(playerId, cb, auth)
    if not Auth:Validate(playerId, auth) then
        return cb(false)
    end

    cb(isCreationAllowed)
end)

Callback:RegisterServerCallback("plouffe_racing:getRaces", function(playerId, cb, auth)
    if not Auth:Validate(playerId, auth) then
        return cb(false)
    end

    cb(Races.GetLabels())
end)

Callback:RegisterServerCallback("plouffe_racing:join", function(playerId, cb, raceId, auth)
    if not Auth:Validate(playerId, auth) then
        return cb(false)
    end

    cb(Races.Join(playerId, raceId))
end)

Callback:RegisterServerCallback("plouffe_racing:getBoosts", function(playerId, cb, auth)
    if not Auth:Validate(playerId, auth) then
        return cb(false)
    end

    local unique = Uniques.Get(playerId)
    cb(Boosts.avaibleBoosts[unique])
end)

Callback:RegisterServerCallback("plouffe_racing:refreshBoosts", function(playerId, cb, auth)
    if not Auth:Validate(playerId, auth) then
        return cb(false)
    end

    local unique = Uniques.Get(playerId)

    if not Races.RemoveRp(playerId, 100) then
        return cb(Boosts.avaibleBoosts[unique]), Utils:Notify(playerId, "Vous avez besoin de 100 rp")
    end

    Boosts:CreateBoosts(unique)

    cb(Boosts.avaibleBoosts[unique])
end)

Callback:RegisterServerCallback("plouffe_racing:getPlayerProfile", function(playerId, cb, auth)
    if not Auth:Validate(playerId, auth) then
        return cb(false)
    end

    cb(playersData[playerId])
end)

Callback:RegisterServerCallback("plouffe_racing:setRacerName", function(playerId, cb, name, auth)
    if not Auth:Validate(playerId, auth) then
        return cb(false)
    end

    if not Races.IsNameValid(name) then
        return cb(false)
    end

    local unique = Uniques.Get(playerId)

    local rp = playerProfiles[unique] and playerProfiles[unique].rp or 0

    playerProfiles[unique] = {
        name = name,
        rp = rp
    }

    playersData[playerId] = playerProfiles[unique]

    SetResourceKvp("playerProfiles", json.encode(playerProfiles))

    cb(playersData[playerId])
end)

Callback:RegisterServerCallback("plouffe_racing:startBoost", Boosts.StartBoost)

Callback:RegisterServerCallback("plouffe_racing:getActiveBoost", function(playerId, cb, auth)
    if not Auth:Validate(playerId, auth) then
        return cb(false)
    end

    cb(Boosts.activeBoosts)
end)

Callback:RegisterServerCallback("plouffe_racing:getBoostGps", function(playerId, cb, auth)
    if not Auth:Validate(playerId, auth) then
        return cb(false)
    end

    local unique = Uniques.Get(playerId)

    if not unique then
        return cb(false)
    end

    if not Boosts.activeBoosts then
        return cb(false)
    end

    if Boosts.activeBoosts.owner ~= unique then
        return cb(false)
    end

    if Boosts.activeBoosts.currentHacks < Boosts.activeBoosts.totalHacks then
        return cb(Boosts.activeBoosts.spawn.coords)
    end

    cb(Boosts.activeBoosts.delivery)
end)

RegisterCommand("isCreationAllowed", function(s,a)
    isCreationAllowed = a[1] and true or false
end, true)