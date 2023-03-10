local allowed = false
local commandstate = true
local drivebystate = false

if commandstate then
	RegisterCommand(Config.Command, function(source)
		if IsPedInAnyVehicle(GetPlayerPed(-1)) then
			if drivebystate then
				drivebystate = false
				allowed = false
				exports["esx_notify"]:Notify("error", 3000, "Driveby deaktiviert.")
			else		
				local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
				local isdriver = false
				if GetPedInVehicleSeat(vehicle,-1) == GetPlayerPed(-1) then 
					isdriver = true
					print(isdriver) 
				end
				if not isdriver or Config.CanDriverDriveby then
					print(drivebystate)
					local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
					local speed = GetEntitySpeed(vehicle) * 3.602151
					if speed < (Config.MaxSpeed + 5) then
						drivebystate = true
						allowed = true
						exports["esx_notify"]:Notify("success", 3000, "Driveby aktiviert. (max. "..Config.MaxSpeed.." km/h).")
					else
						exports["esx_notify"]:Notify("error", 3000, "Du bist zu schnell unterwegs (max. "..Config.MaxSpeed.." km/h).")
					end
				else
					exports["esx_notify"]:Notify("error", 3000, "Als Fahrer kannst du kein Driveby machen.")
				end
			end
		else
			exports["esx_notify"]:Notify("error", 3000, "Du bist in keinem Fahrzeug.")
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
			if speed > (Config.MaxSpeed + 5) then
				allowed = false
				drivebystate = false
				SetPlayerCanDoDriveBy(PlayerId(), false)
				exports["esx_notify"]:Notify("error", 3000, "Du bist zu schnell unterwegs (max. "..Config.MaxSpeed.." km/h) - Driveby deaktiviert.")
			elseif isdriver and not Config.CanDriverDriveby then
				allowed = false
				drivebystate = false
				SetPlayerCanDoDriveBy(PlayerId(), false)
				exports["esx_notify"]:Notify("error", 3000, "Als Fahrer kannst du kein Driveby machen - Driveby deaktiviert.")
			else
				SetPlayerCanDoDriveBy(PlayerId(), true)
			end
		end
	end
end)