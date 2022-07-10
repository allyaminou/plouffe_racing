local Utils = exports.plouffe_lib:Get("Utils")
local Callback = exports.plouffe_lib:Get("Callback")
local cache = {races = {}, boosts = {}, currentBoost = nil}
local Time = {}

Time.Ticks = setmetatable({}, {
    __len = function(self)
        local retval = 0

        for k,v in pairs(self) do
            retval += 1
        end

        return retval
    end,

    __newindex = function(self, k , v)
        rawset(self, k, v)

        if #self > 1 then
            return
        end

        CreateThread(function()
            while #self > 0 do
                Wait(0)

                for k,v in pairs(self) do
                    v:Tick()
                end
            end
        end)
    end
})

Time.New = function()
    local This = {}

    This.Index = #Time.Ticks + 1
    This.active = true
    This.Init = GetNetworkTime()
    This.nanoseconds = GetNetworkTime()
    This.milliseconds = 0
    This.seconds = 0
    This.minutes = 0
    This.hours = 0

    function This:GetTotal()
        return {
            string = self:Get(),
            int = (GetNetworkTime() - self.Init)
        }
    end

    function This:Get()
        local str_milliseconds = self.milliseconds < 10 and ("0%s"):format(self.milliseconds) or self.milliseconds
        local str_seconds = self.seconds < 10 and ("0%s"):format(self.seconds) or self.seconds
        local str_minutes = self.minutes < 10 and ("0%s"):format(self.minutes) or self.minutes
        local str_hours = self.hours < 10 and ("0%s"):format(self.hours) or self.hours

        local str = ("%s:%s:%s:%s"):format(str_hours, str_minutes, str_seconds, str_milliseconds)

        return str
    end

    function This:Tick()
        local current = GetNetworkTime()

        self.nanoseconds = (current - self.nanoseconds)

        if self.nanoseconds >= 60000 then
            self.nanoseconds = current

            self.milliseconds += 1
            if self.milliseconds >= 60 then
                self.milliseconds = 0

                self.seconds += 1
                if self.seconds >= 60 then
                    self.seconds = 0

                    self.minutes += 1
                    if self.minutes >= 60 then
                        self.minutes = 0

                        self.hours += 1
                    end
                end
            end
        end
    end

    function This:Add(value)
        self.seconds += value
    end

    function This:Clear()
        Time.Ticks[self.Index] = nil
        self.active = false
        self = nil
    end

    Time.Ticks[This.Index] = This

    return This
end

local minigameActive = false
local minigameResult = nil

local Keys = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}

local frozenEntity = 0
local cachedPlayers = {}

local tires = `prop_offroad_tyres02`
local flag = `prop_beachflag_01`
local bouy = `prop_dock_bouy_3`

local blips = {}

local currentPosition = 0
local isInRace = false

local inVehicle = false
local currentVehicle = 0

function Races:Start()
    -- Races.Ui.LuaClose()
    AddStateBagChangeHandler("racePosition", ("player:%s"):format(GetPlayerServerId(PlayerId())), function(bagName,key,value,reserved,replicated)
        currentPosition = value
    end)

    AddEventHandler("plouffe_lib:inVehicle", function(inside, id)
        inVehicle = inside
        currentVehicle = id
    end)

    AddEventHandler("plouffe_racing:bringback_wanted", self.ReturnWanted)
    AddEventHandler("plouffe_racing:onTool", self.OnHackingTool)
    RegisterNetEvent("plouffe_racing:updateBestTime", self.UpdateBestTime)
    RegisterNetEvent("plouffe_racing:newRace", self.SetupNewRace)
    RegisterNetEvent("plouffe_racing:removeRace", self.RemoveRace)
    RegisterNetEvent("plouffe_racing:start", self.StartNewRace)
    RegisterNetEvent("plouffe_racing:prepare", self.Prepare)
    RegisterNetEvent("plouffe_racing:freeze", self.Freeze)
    RegisterNetEvent("plouffe_racing:updateProfile", self.Ui.UpdateProfile)
    RegisterNetEvent("plouffe_racing:removeWanted", self.Ui.RemoveWanted)

    for k,v in pairs(self.Zones) do
        local isRegistered, reason = exports.plouffe_lib:Register(v)
    end

    Callback:RegisterClientCallback("plouffe_racing:getVehicleProps", Races.GetVehicleProps)
end

function Races.OnHackingTool()
    if  Utils:IsOnCooldown("OnHackingTool") then
        return
    end

    Utils:Cooldown(5000,"OnHackingTool")

    TriggerServerEvent("plouffe_racing:OnHackingTool", Races.auth)
end

function Races.ReturnWanted()
    if not inVehicle then
        return
    end

    local finished = Utils:ProgressCircle({
        duration = 30000,
        useWhileDead = false,
        canCancel = true,
        position = "bottom",
        disable = {
            move = true,
            car = true,
            combat = true
        }
    })

    if not finished then
       return
    end

    TriggerServerEvent("plouffe_racing:returnWantedVehicle", NetworkGetNetworkIdFromEntity(currentVehicle), Races.auth)
end

function Races.GetVehicleProps(cb,data)
    local vehicle = NetworkGetEntityFromNetworkId(data.netId)
    if not DoesEntityExist(vehicle) then
        return cb(false)
    end

    cb(Utils:GetVehicleProps(vehicle))
end

function Races.UpdateBestTime(raceId, data)
    SendNuiMessage(json.encode({
        type = "updateBestTime",
        id = raceId,
        timeString = data.timeString,
        name = data.name
    }))
end

function Races.Freeze(raceId, players)
    if not Races.active or Races.active and Races.active.id ~= raceId then
        return
    end

    cachedPlayers = players

    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)

    frozenEntity = vehicle ~= 0 and vehicle or ped

    FreezeEntityPosition(frozenEntity, true)
end

function Races.SetupNewRace(data)
    cache.races[data.id] = data

    local coords_1 = data.checkpoints[1].barrel_1
    local coords_2 = data.checkpoints[1].barrel_2

    local _,z_1 = GetGroundZFor_3dCoord(coords_1.x, coords_1.y, coords_1.z + 5, true)
    local _,z_2 = GetGroundZFor_3dCoord(coords_2.x, coords_2.y, coords_2.z + 5, true)

    Races.flag_1 = Utils:CreateProp(flag, vector3(coords_1.x, coords_1.y, z_1))
    Races.flag_2 = Utils:CreateProp(flag, vector3(coords_2.x, coords_2.y, z_2))

    FreezeEntityPosition(Races.flag_1, true)
    FreezeEntityPosition(Races.flag_2, true)

    SendNUIMessage({
        type = "tab",
        addActive = data
    })
end

function Races.RemoveRace(raceId)
    SendNUIMessage({
        type = "tab",
        removeActive = raceId
    })

    DeleteEntity(Races.flag_1)
    DeleteEntity(Races.flag_2)
end

function Races.Join(params)
    Races.RemoveRace(params.raceId)
    TriggerServerEvent("plouffe_racing:join", params.raceId, Races.auth)
end

function Races.CreateProps(model)
    if not model then
        return
    end

    local key = 1
    
    repeat
        local data = Races.active.checkpoints[key]
        local valid_1,z_1 = GetGroundZFor_3dCoord(data.barrel_1.x, data.barrel_1.y, data.barrel_1.z + 5, true)
        local valid_2,z_2 = GetGroundZFor_3dCoord(data.barrel_2.x, data.barrel_2.y, data.barrel_2.z + 5, true)

        if not valid_1 or not valid_2 then
            break
        end

        if not Races.active.props[key] then
            if key == 1 then
                Races.active.props[key] = {
                    Utils:CreateProp(flag, vector3(data.barrel_1.x, data.barrel_1.y, z_1)),
                    Utils:CreateProp(flag, vector3(data.barrel_2.x, data.barrel_2.y, z_2)),
                    Utils:CreateProp(model, vector3(data.barrel_1.x, data.barrel_1.y, z_1)),
                    Utils:CreateProp(model, vector3(data.barrel_2.x, data.barrel_2.y, z_2))
                }
            elseif key == #Races.active.checkpoints then
                Races.active.props[key] = {
                    Utils:CreateProp(flag, vector3(data.barrel_1.x, data.barrel_1.y, z_1)),
                    Utils:CreateProp(flag, vector3(data.barrel_2.x, data.barrel_2.y, z_2)),
                    Utils:CreateProp(model, vector3(data.barrel_1.x, data.barrel_1.y, z_1)),
                    Utils:CreateProp(model, vector3(data.barrel_2.x, data.barrel_2.y, z_2))
                }
            else
                Races.active.props[key] = {
                    Utils:CreateProp(model, vector3(data.barrel_1.x, data.barrel_1.y, z_1)),
                    Utils:CreateProp(model, vector3(data.barrel_2.x, data.barrel_2.y, z_2))
                }
            end
        end

        key += 1

        Wait(0)
    until not Races.active.checkpoints[key]
end

function Races.RemoveProps()
    local key = 1

    repeat
        local data = Races.active.checkpoints[key]
        local valid_1,z_1 = GetGroundZFor_3dCoord(data.barrel_1.x, data.barrel_1.y, data.barrel_1.z + 5, true)
        local valid_2,z_2 = GetGroundZFor_3dCoord(data.barrel_2.x, data.barrel_2.y, data.barrel_2.z + 5, true)

        if (not valid_1 or not valid_2) and Races.active.props[key] then
            for k,v in pairs(Races.active.props[key]) do
                DeleteEntity(v)
                Races.active.props[key] = nil
            end
        end

        key += 1

        Wait(0)
    until not Races.active.checkpoints[key]
end

function Races.GetPropModel(model)
    if model == "plane" then
        return nil
    elseif model == "boat" then
        return bouy
    end

    return tires
end

function Races.Prepare(data)
    CreateThread(function()
        isInRace = true
        Races.active = data
        Races.active.props = {}
        local model = Races.GetPropModel(Races.active.vehicle)

        local totalCheckPoints = #Races.active.checkpoints
        local totalLaps = Races.active.laps
        local currentLap = 0
        local currentCheckpoint = 0
        local bestLap = nil

        Races.CreateProps(model)
        Races.CreatBlips()

        SendNuiMessage(json.encode({
            type = "race",
            active = true,

            name = Races.active.name,
            totalLaps = totalLaps,
            position = currentPosition,
            bestLap = "00:00:00:00",

            totalCheckpoints = totalCheckPoints,
            currentCheckpoint = currentCheckpoint,

            currentLap = 0,
            time = "00:00:00:00",
            totalTime = "00:00:00:00"
        }))

        while not Races.active.started do
            Wait(0)
        end

        local totalTime = Time.New()
        local currentTime = Time.New()

        local lastColision = GetGameTimer()

        if Races.active.phasing then
             CreateThread(function()
                while isInRace do
                    for k,v in pairs(cachedPlayers) do
                        local ped = GetPlayerPed(GetPlayerFromServerId(v.playerId))
                        if ped ~= 0 then
                            local pedVehicle = GetVehiclePedIsIn(ped)
                            SetEntityNoCollisionEntity(pedVehicle, currentVehicle, true)
                        end
                    end
                    Wait(0)
                end
            end)
        end

        CreateThread(function()
            while Races.active and isInRace do
                Wait(0)

                if model then
                    local isColision = IsEntityTouchingModel(currentVehicle, model)
                    if isColision and GetGameTimer() - lastColision > 5000 then
                        lastColision = GetGameTimer()
                        totalTime:Add(Races.active.penality)
                        currentTime:Add(Races.active.penality)
                    end
                end

                SendNuiMessage(json.encode({
                    type = "race",

                    totalLaps = totalLaps,
                    position = currentPosition,
                    bestLap = bestLap and bestLap or "00:00:00:00",
                    totalCheckpoints = totalCheckPoints,
                    currentCheckpoint = currentCheckpoint,

                    currentLap = currentLap,
                    time = currentTime:Get(),
                    totalTime = totalTime:Get()
                }))
            end
        end)

        while Races.active and Races.active.laps > 0 and isInRace do
            Wait(0)

            Races.active.laps -= 1

            currentLap += 1
            currentCheckpoint = 0

            for k,v in pairs(Races.active.checkpoints) do
                local coords = vector3(v.coords.x, v.coords.y, v.coords.z)
                local pedCoords = GetEntityCoords(PlayerPedId())

                while #(pedCoords - coords) > v.distance and Races.active and isInRace do
                    local ped = PlayerPedId()
                    pedCoords = GetEntityCoords(ped)
                    Wait(0)
                    if Races.active.vehicle == "plane" then
                        local heading = GetEntityHeading(ped)

                        for k,v in pairs(Races.active.checkpoints) do
                            DrawMarker(6, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, heading, v.distance, v.distance, v.distance, 0, 255, 0, 255, true, false, 2, false)
                        end
                    end
                end

                if not isInRace then
                    break
                end

                currentCheckpoint += 1

                TriggerServerEvent("plouffe_racing:checkpoint", data.id, Races.auth)
    
                Races.CreateProps(model)
                Races.RemoveProps()
            end

            TriggerServerEvent("plouffe_racing:raceFinished", totalTime:GetTotal(), Races.active.id, Races.auth)

            local thisLapTime = GetNetworkTime() - currentTime.Init

            if not bestLap or bestLap and thisLapTime < bestLapTime then
                bestLapTime = thisLapTime
                bestLap = currentTime:Get()
            end

            currentTime:Clear()

            currentTime = Time.New()
        end

        Races.ClearBlips()

        for key,v in pairs(Races.active.props) do
            for x,y in pairs(Races.active.props[key]) do
                DeleteEntity(y)
                Races.active.props[key] = nil
            end
        end

        Races.active = nil
        isInRace = false
        Wait(100)

        totalTime:Clear()
        currentTime:Clear()
    end)
end

function Races.StartNewRace(raceId)
    if Races.active and Races.active.id == raceId then
        Races.active.started = true
        FreezeEntityPosition(frozenEntity, false)
    end

    SendNUIMessage({
        type = "tab",
        removeActive = raceId
    })

    DeleteEntity(Races.flag_1)
    DeleteEntity(Races.flag_2)
end

function Races.CreatBlips()
    for k,v in pairs(Races.active.checkpoints) do
        local blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
        SetBlipSprite(blip, 1)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.6)
        SetBlipAsShortRange(blip, true)
        SetBlipColour(blip, 26)
        ShowNumberOnBlip(blip, k)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(("Checkpoint: %s"):format(k))
        EndTextCommandSetBlipName(blip)
        blips[k] = blip
    end
end

function Races.ClearBlips()
    for k,v in pairs(blips) do
        RemoveBlip(v)
    end
    blips = {}
end

function Races.GetCurrentModel()
    local vehicle = GetVehiclePedIsIn(PlayerPedId())
    local model = GetEntityModel(vehicle)

    if IsThisModelABike(model) then
        return "bike"
    elseif IsThisModelABoat(model) or IsThisModelAJetski(model) then
        return "boat"
    elseif IsThisModelACar(model) then
        return "automobile"
    elseif IsThisModelAPlane(model) then
        return "plane"
    end

    return "automobile"
end

function Races.Creator:Menu()
    local data = exports.ooc_dialog:Open({
        rows = {
            {
                id = 0, 
                txt = ("Nom de la course")
            }
        }
    })

    local name = data and tostring(data[1].input)

    return name
end

function Races.Creator:NewTires(index)
    local model = Races.GetPropModel(Races.GetCurrentModel())

    if not model then
        return
    end

    if index then
        self.props[index] = {
            self.barrel_1,
            self.barrel_2
        }
    end

    self.barrel_1 = Utils:CreateProp(model, vector3(0,0,0))
    self.barrel_2 = Utils:CreateProp(model, vector3(0,0,0))

    SetEntityCollision(self.barrel_1, false, false)
    SetEntityCollision(self.barrel_2, false, false)
end

function Races.Creator:Save()
    self.active = false
    TriggerServerEvent("plouffe_racing:saveRace", self.raceData, Races.auth)
end

function Races.Creator:Create(name)
    self.ped = PlayerPedId()
    self.pedCoords = GetEntityCoords(ped)
    self.barrelDistance = 2.0
    self.props = {}

    local isPlane = Races.GetPropModel(Races.GetCurrentModel()) == nil

    self:NewTires()

    self.active = true
    self.raceData = {
        name = name,
        checkpoints = {},
        vehicle = Races.GetCurrentModel()
    }

    SendNuiMessage(json.encode({
        type = "creator",
        active = true,
        raceName = self.raceData.name,
        checkpoints = #self.raceData.checkpoints,
        tireDistance = self.barrelDistance
    }))

    while self.active do
        Wait(0)

        SendNuiMessage(json.encode({
            checkpoints = #self.raceData.checkpoints,
            tireDistance = self.barrelDistance
        }))

        if isPlane then
            local ped = PlayerPedId()
            local pedCoords = GetEntityCoords(ped)
            local heading = GetEntityHeading(ped)

            DrawMarker(6, pedCoords.x, pedCoords.y, pedCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, heading, self.barrelDistance, self.barrelDistance, self.barrelDistance, 0, 255, 0, 255, true, false, 2, false)

            for k,v in pairs(self.raceData.checkpoints) do
                DrawMarker(6, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, heading, v.distance, v.distance, v.distance, 0, 255, 0, 255, true, false, 2, false)
            end
        else
            local off_1 = GetOffsetFromEntityInWorldCoords(self.ped, self.barrelDistance, 0.0, 0.0)
            local off_2 = GetOffsetFromEntityInWorldCoords(self.ped, - self.barrelDistance, 0.0, 0.0)

            local _,z_1 = GetGroundZFor_3dCoord(off_1.x, off_1.y, off_1.z, true)
            local _,z_2 = GetGroundZFor_3dCoord(off_2.x, off_2.y, off_2.z, true)

            SetEntityCoords(self.barrel_1, off_1.x, off_1.y, z_1)
            SetEntityCoords(self.barrel_2, off_2.x, off_2.y, z_2)
        end

        if IsControlJustReleased(0, Keys['LEFT']) or IsDisabledControlJustReleased(0, Keys['LEFT']) then
            self.barrelDistance = self.barrelDistance - 1 > 1.0 and self.barrelDistance - 1 or 1.0
        end

        if IsControlJustReleased(0, Keys['RIGHT']) or IsDisabledControlJustReleased(0, Keys['RIGHT']) then
            local max = not isPlane and 15.0 or 30.0
            self.barrelDistance = self.barrelDistance + 1 < max and self.barrelDistance + 1 or max
        end

        if IsControlJustReleased(0, Keys['9']) or IsDisabledControlJustReleased(0, Keys['9']) then
            self.raceData.checkpoints[#self.raceData.checkpoints + 1] = {
                coords = GetEntityCoords(self.ped),
                barrel_1 = GetEntityCoords(self.barrel_1),
                barrel_2 = GetEntityCoords(self.barrel_2),
                distance = self.barrelDistance
            }

            Utils:Notify("Checkpoint ajouter")

            self:NewTires(#self.raceData.checkpoints)
        end

        if IsControlJustReleased(0, Keys['8']) or IsDisabledControlJustReleased(0, Keys['8']) then

            if self.props[#self.raceData.checkpoints] then
                for k,v in pairs(self.props[#self.raceData.checkpoints]) do
                    DeleteEntity(v)
                end
            end

            self.raceData.checkpoints[#self.raceData.checkpoints] = nil

            Utils:Notify("Checkpoint retirer")
        end

        if IsControlJustReleased(0, Keys["K"]) or IsDisabledControlJustReleased(0, Keys["K"]) then
            if #self.raceData.checkpoints >= 2 then
                self:Save()
            else
                Utils:Notify("Il doit y avoir au moins 2 checkpoints")
            end
        end

        if IsControlJustReleased(0, Keys["7"]) or IsDisabledControlJustReleased(0, Keys["7"]) then
            self.active = false
            Utils:Notify("Création annuler")
        end
    end

    SendNuiMessage(json.encode({
        type = "creator",
        active = false
    }))

    DeleteEntity(self.barrel_1)
    DeleteEntity(self.barrel_2)

    for k,v in pairs(self.props) do
        DeleteEntity(v[1])
        DeleteEntity(v[2])
    end
end

function Races.Creator.TryCreate()
    local isAllowed = Callback:Sync("plouffe_racing:canCreate", Races.auth)

    if not isAllowed then
        return
    end

    local name = Races.Creator:Menu()

    if not name then
        return
    end

    Races.Creator:Create(name)
end
exports("Create", Races.Creator.TryCreate)

function Races.Ui.Creator(data)
    local isAllowed = Callback:Sync("plouffe_racing:canCreate", Races.auth)

    if not isAllowed then
        return
    end

    Races.Creator:Create(data.name)
end
RegisterNUICallback("raceCreator", Races.Ui.Creator)

function Races.Ui.Close(cb)
    Utils:StopAnim()
    Races.Ui.active = false
    SetNuiFocus(false, false)
end
RegisterNUICallback("close", Races.Ui.Close)

function Races.Ui.Open()
    local profile = Callback:Sync("plouffe_racing:getPlayerProfile", Races.auth)

    Utils:PlayAnim(-1,'amb@world_human_seat_wall_tablet@female@base','base',49,2.0,2.0,-1,true,true,false,{
        model = 'bkr_prop_fakeid_tablet_01a',
        bone = 28422,
        off1 = 0.06,
        off2 = 0.01,
        off3 = 0.05,
        rot1 = 90.0,
        rot2 = 90.0,
        rot3 = 0.0,
    })

    Races.Ui.active = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "tab",
        show = true,
        profile = profile
    })
end
exports("openui", Races.Ui.Open)

function Races.Ui.LuaClose()
    Races.Ui.active = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "tab",
        show = false
    })
    Utils:StopAnim()
end

function Races.Ui.GetRaces(data, cb)
    cache.races = Callback:Sync("plouffe_racing:getRaces", Races.auth)
    cb(cache.races)
end
RegisterNUICallback("getRaces", Races.Ui.GetRaces)

function Races.Ui.StartNew(data, cb)
    if not cache.races[data.id] then
        return
    end

    local pedCoords = GetEntityCoords(PlayerPedId())
    local raceCoords = vector3(cache.races[data.id].checkpoints[1].coords.x, cache.races[data.id].checkpoints[1].coords.y, cache.races[data.id].checkpoints[1].coords.z)
    local distance = #(raceCoords - pedCoords)

    if distance > 30 then
        Utils:Notify("Vous etes trop loin de la course, gps placé.")
        SetNewWaypoint(raceCoords.x, raceCoords.y)
        return cb(false)
    end

    cb(true)
    TriggerServerEvent("plouffe_racing:startRace", data.id, data, Races.auth)
end
RegisterNUICallback("startRace", Races.Ui.StartNew)

function Races.Ui.LeaveRace()
    if not isInRace then
        return
    end
    isInRace = nil
    TriggerServerEvent('plouffe_racing:leaverace', Races.auth)
end
RegisterNUICallback("leaveRace", Races.Ui.LeaveRace)

function Races.Ui.Join(data)
    if Races.active then
        return
    end

    local pedCoords = GetEntityCoords(PlayerPedId())
    local raceCoords = vector3(cache.races[data.id].checkpoints[1].coords.x, cache.races[data.id].checkpoints[1].coords.y, cache.races[data.id].checkpoints[1].coords.z)
    local distance = #(raceCoords - pedCoords)

    if distance > 30 then
        Utils:Notify("Vous etes trop loin de la course, gps placé.")
        SetNewWaypoint(raceCoords.x, raceCoords.y)
        return
    end

    local joined = Callback:Sync("plouffe_racing:join", data.id, Races.auth)

    if not joined then
        return
    end

    Races.RemoveRace(data.id)
end
RegisterNUICallback("joinRace", Races.Ui.Join)

function Races.Ui.GetBoosts(data, cb)
    cache.boosts = Callback:Sync("plouffe_racing:getBoosts", Races.auth)
    cb(cache.boosts)
end
RegisterNUICallback("getBoosts", Races.Ui.GetBoosts)

function Races.Ui.RefreshBoosts(data, cb)
    if  Utils:IsOnCooldown("plouffe_racing:refreshBoosts") then
        return cb(cache.boosts)
    end

    Utils:Cooldown(5000,"plouffe_racing:refreshBoosts")

    cache.boosts = Callback:Sync("plouffe_racing:refreshBoosts", Races.auth)
    cb(cache.boosts)
end
RegisterNUICallback("refreshBoosts", Races.Ui.RefreshBoosts)

function Races.Ui.StartBoost(data, cb)
    local boostData = Callback:Sync("plouffe_racing:startBoost", false, data.id, Races.auth)
    if boostData then
        SetNewWaypoint(boostData.spawn.coords.x, boostData.spawn.coords.y)
    end
    cb(boostData)
end
RegisterNUICallback("startBoost", Races.Ui.StartBoost)

function Races.Ui.StartScratch(data, cb)
    local boostData = Callback:Sync("plouffe_racing:startBoost", true, data.id, Races.auth)
    if boostData then
        SetNewWaypoint(boostData.spawn.coords.x, boostData.spawn.coords.y)
    end
    cb(boostData)
end
RegisterNUICallback("startScratch", Races.Ui.StartScratch)

function Races.Ui.SetRacerName(data,cb)
    local isValid = Callback:Sync("plouffe_racing:setRacerName", data.name, Races.auth)
    cb(isValid)
end
RegisterNUICallback("setRacerName", Races.Ui.SetRacerName)

function Races.Ui.SetBoostGps(data)
    if  Utils:IsOnCooldown("plouffe_racing:getBoostGps") then
        return
    end

    Utils:Cooldown(5000,"plouffe_racing:getBoostGps")

    local coords = Callback:Sync("plouffe_racing:getBoostGps", Races.auth)
    if not coords then
        return Utils:Notify("Vous n'avez pas de boost actif")
    end

    Utils:Notify("Gps placé.")
    SetNewWaypoint(coords.x, coords.y)
end
RegisterNUICallback("setBoostGps", Races.Ui.SetBoostGps)

function Races.Ui.UpdateProfile(value)
    SendNuiMessage(json.encode({
        type = "tab",
        profile = value
    }))
end

function Races.Ui.RemoveWanted(id)
    SendNuiMessage(json.encode({
        type = "wanted",
        remove = id
    }))
end

function Races.Ui.GetActiveWanteds(data,cb)
    local data = Callback:Sync("plouffe_racing:getWanteds", Races.auth)
    cb(data)
end
RegisterNUICallback("getActiveWanteds", Races.Ui.GetActiveWanteds)

function Races.Hacking:NewSolution(class)
    local possibilities = {}
    local strings = self.strings.numbers
    local max = 250
    local update = 12

    if class == "S+" then
        strings = self.strings.hieroglyphs
        update = 5
    elseif class == "S" then
        strings = self.strings.hieroglyphs
        update = 6
    elseif class == "A" then
        strings = self.strings.symbols
        update = 8
    elseif class =="B" then
        strings = self.strings.alphabet
        update = 10
    end

    local solution = ("%s%s%s %s%s%s"):format(
        strings[(math.random(1,#strings))],
        strings[(math.random(1,#strings))],
        strings[(math.random(1,#strings))],
        strings[(math.random(1,#strings))],
        strings[(math.random(1,#strings))],
        strings[(math.random(1,#strings))]
    )

    max -= 7

    table.insert(possibilities, solution)

    repeat
        table.insert(possibilities,("%s%s%s %s%s%s"):format(
            strings[(math.random(1,#strings))],
            strings[(math.random(1,#strings))],
            strings[(math.random(1,#strings))],
            strings[(math.random(1,#strings))],
            strings[(math.random(1,#strings))],
            strings[(math.random(1,#strings))]
        ))
        max -= 7
    until max <= 0

    return solution, possibilities, update
end

function Races.Hacking:New(class, maxTimer)
    self.active = true
    SetNuiFocus(true, true)

    minigameResult = promise.new()

    local time = (maxTimer or 30)
    local data = {
        type = "hacking",
        new = true,
        time = time,
    }

    data.solution, data.possibilities, data.update = self:NewSolution(class)

    self.current = data

    SendNUIMessage(data)

    CreateThread(function()
        while time > 0 and self.active do
            Wait(1000)
            time -= 1

            SendNUIMessage({
                type = "hacking",
                time = time
            })
        end

        Wait(100)

        if self.active then
            SendNUIMessage({
                type = "hacking",
                cancel = true
            })
            minigameResult:resolve(false)
            Races.Hacking.active = false
            SetNuiFocus(false, false)
        end
    end)

    return Citizen.Await(minigameResult)
end

function Races.Hacking.Clicked(data)
    if not Races.Hacking.active then
        return
    end

    Races.Hacking.active = false
    SetNuiFocus(false, false)
    minigameResult:resolve(Races.Hacking.current.solution == data.clicked)
end
RegisterNUICallback("minigameClicked", Races.Hacking.Clicked)

RegisterNUICallback("minigameClose", function()
    Races.Hacking.active = false
    SetNuiFocus(false, false)
    if minigameResult then
        minigameResult:resolve(false)
    end
end)

function Races.Hacking.TryHacking()
    if Utils:IsOnCooldown("plouffe_racing:getActiveBoost") or minigameActive then
        return Utils:Notify("Attendez un peux, calmez vous, RELAX BRU")
    end

    Utils:Cooldown(15000,"plouffe_racing:getActiveBoost")

    if not inVehicle then
        return
    end

    local data = Callback:Sync("plouffe_racing:getActiveBoost", Races.auth)
    if not data then
        return
    end

    local netId = NetworkGetNetworkIdFromEntity(currentVehicle)
    if not data.netId or data.netId ~= netId then
        return
    end

    Utils:PlayAnim(-1,'amb@world_human_seat_wall_tablet@female@base','base',49,2.0,2.0,-1,true,true,false,{
        model = 'bkr_prop_fakeid_tablet_01a',
        bone = 28422,
        off1 = 0.06,
        off2 = 0.01,
        off3 = 0.05,
        rot1 = 90.0,
        rot2 = 90.0,
        rot3 = 0.0,
    })
    minigameActive = true
    local succes = Races.Hacking:New(data.class)

    TriggerServerEvent("plouffe_racing:finishedHacking", succes, Races.auth)

    Utils:StopAnim()

    Wait(1000)

    minigameActive = false
end
exports("TryHacking", Races.Hacking.TryHacking)

function Races.Scratch()
    local vehicle = Utils:GetVehicleInFront()

    if not vehicle then
        return Utils:Notify("Aucun véhicule trouver #BabyRage")
    end

    local finished = Utils:ProgressCircle({
        duration = 60000,
        useWhileDead = false,
        canCancel = true,
        position = "bottom",
        disable = {
            move = true,
            car = true,
            combat = true
        },
        anim = {
            scenario = 'WORLD_HUMAN_WELDING'
        }
    })

    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    local vehicleCoords = GetEntityCoords(vehicle)

    if not finished then
        return
    elseif #(pedCoords - vehicleCoords) > 9 then
        return Utils:Notify("Le véhicule est trop loin de vous")
    end

    TriggerServerEvent("plouffe_racing:finishedScratching", Races.auth)
end

function Races.TryScratch()
    for k,v in pairs(Races.Zones) do
        if exports.plouffe_lib:IsInZone(k) then
            return Races.Scratch()
        end
    end
end
exports("TryScratch", Races.TryScratch)