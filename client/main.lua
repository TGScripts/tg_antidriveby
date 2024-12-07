local allowed = false
local commandstate = true
local drivebystate = false

if commandstate then
	RegisterCommand(Config.Command, function(source)
		if IsPedInAnyVehicle(GetPlayerPed(-1)) then
			if drivebystate then
				drivebystate = false
				allowed = false
				tg_shownotification(tg_translate('db_deactivated'))
			else		
				local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
				local isdriver = false
				if GetPedInVehicleSeat(vehicle,-1) == GetPlayerPed(-1) then 
					isdriver = true
					if Config.Debug then
						print('isdriver: '..tostring(isdriver))
					end
				end
				if not isdriver or Config.CanDriverDriveby then
					if Config.Debug then
						print('drivebystate: '..tostring(drivebystate))
					end
					local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
					local speed = GetEntitySpeed(vehicle) * 3.602151
					if speed < (Config.MaxSpeed + Config.Tolerance) then
						drivebystate = true
						allowed = true
						tg_shownotification(tg_translate('db_activated', Config.MaxSpeed))
					else
						tg_shownotification(tg_translate('db_too_fast', Config.MaxSpeed))
					end
				else
					tg_shownotification(tg_translate('db_na_driver'))
				end
			end
		else
			tg_shownotification(tg_translate('db_no_vehicle'))
		end
	end)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if not allowed then
			if IsPedInAnyVehicle(GetPlayerPed(-1)) then
				SetPlayerCanDoDriveBy(PlayerId(), false)
			end
		else
			local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
			local isdriver = false
			if GetPedInVehicleSeat(vehicle,-1) == PlayerPedId() then 
				isdriver = true 
			end
			local speed = GetEntitySpeed(vehicle) * 3.602151
			if speed > (Config.MaxSpeed + Config.Tolerance) then
				allowed = false
				drivebystate = false
				SetPlayerCanDoDriveBy(PlayerId(), false)
				tg_shownotification(tg_translate('db_too_fast', Config.MaxSpeed))
			elseif isdriver and not Config.CanDriverDriveby then
				allowed = false
				drivebystate = false
				SetPlayerCanDoDriveBy(PlayerId(), false)
				tg_shownotification(tg_translate('db_na_driver_wd'))
			else
				SetPlayerCanDoDriveBy(PlayerId(), true)
			end
		end
	end
end)

function tg_shownotification(message)
    local textureDict = "TG_Textures"
    RequestStreamedTextureDict(textureDict, true)

    while not HasStreamedTextureDictLoaded(textureDict) do
        Wait(0)
    end

    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandThefeedPostMessagetext(textureDict, "TG_Logo", false, 0, "TG Anti Driveby Script", "")

    SetStreamedTextureDictAsNoLongerNeeded(textureDict)
end