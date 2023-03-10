local label = 
[[

     ___      .__   __. .___________. __                 _______  .______       __  ____    ____  _______ .______   ____    ____ 
    /   \     |  \ |  | |           ||  |               |       \ |   _  \     |  | \   \  /   / |   ____||   _  \  \   \  /   / 
   /  ^  \    |   \|  | `---|  |----`|  |     ______    |  .--.  ||  |_)  |    |  |  \   \/   /  |  |__   |  |_)  |  \   \/   /  
  /  /_\  \   |  . `  |     |  |     |  |    |______|   |  |  |  ||      /     |  |   \      /   |   __|  |   _  <    \_    _/   
 /  _____  \  |  |\   |     |  |     |  |               |  '--'  ||  |\  \----.|  |    \    /    |  |____ |  |_)  |     |  |     
/__/     \__\ |__| \__|     |__|     |__|               |_______/ | _| `._____||__|     \__/     |_______||______/      |__|     
                                                                                                                      
                                            Made by Tiger (Lets_Tiger#4159)
]]

function GetCurrentVersion()
	return GetResourceMetadata( GetCurrentResourceName(), "version" )
end

Citizen.CreateThread( function()
    updatePath = "/LetsTiger/tg_antidriveby"
    resourceName = "Anti-Driveby Script ("..GetCurrentResourceName()..")"
    
    function checkVersion(err,responseText, headers)
        curVersion = GetResourceMetadata(GetCurrentResourceName(), "version")
        newVersion = tonumber(responseText)

        if curVersion ~= responseText and tonumber(curVersion) < tonumber(responseText) then
            rio = true
            responseText = responseText
            curVersion = curVersion
            updatePath = updatePath
        elseif tonumber(curVersion) > tonumber(responseText) then
            svs = true
        else
            utd = true
        end
    end
    
    PerformHttpRequest("https://raw.githubusercontent.com"..updatePath.."/master/version", checkVersion, "GET")
end)

function Resourcestart()
    print("\n")

    print( label )

    if rio then
        print(" ^0[^1ERROR^0] "..resourceName.." ist veraltet! Bitte updaten: https://github.com/LetsTiger/tg_antidriveby/")
        print(" ^0[^5INFO^0] Deine Version: [^1"..curVersion.."^0]")
        print(" ^0[^5INFO^0] Neuste Version: [^3"..newVersion.."^0]")
    elseif svs then
        print(" ^0[^1ERROR^0] Irgendwie hast du ein paar Versionen vom "..resourceName.." übersprungen oder Github ist offline, wenn Github noch online ist bitte die neueste Version herunterladen.")
        print(" ^0[^5INFO^0] Deine Version: [^1"..curVersion.."^0]")
        print(" ^0[^5INFO^0] Neuste Version: [^3"..newVersion.."^0]")
    elseif utd then
        print(" ^0[^5INFO^0] Du hast die aktuellste Version vom "..resourceName..", viel Spaß!")
        print(" ^0[^5INFO^0] Deine Version: [^2"..curVersion.."^0]")
        print(" ^0[^5INFO^0] Neuste Version: [^2"..newVersion.."^0]")
    else
        print(" ^0[^1ERROR^0] Es ist etwas schiefgelaufen bitte kontaktiere den Ersteller!")
    end

    print("")
    print("\n")
end

CreateThread(function()
    Citizen.Wait(2100)
    Resourcestart()
end)