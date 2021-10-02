-- NÃO RETIRE OS CRÉDITOS / NÃO RETIRE OS CRÉDITOS / NÃO RETIRE OS CRÉDITOS / NÃO RETIRE OS CRÉDITOS / NÃO RETIRE OS CRÉDITOS / NÃO RETIRE OS CRÉDITOS
-- TODOS OS DIREITOS AO CRIADOR  'Rutss.Dev'
-- Url 'https://discord.gg/AbjS8gZ'
-- Versão 'vRPEX'
----------------------------------------------------------------------------------------------------------------------
-------------------------------------        VARIÁVEIS        --------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
local domming = false
local facnome = ""
local secondsRemaining = 0
local faccoes = rts.rtsconfig
incircle = false
----------------------------------------------------------------------------------------------------------------------
-------------------------------------        DOMINAR         ---------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
	local rtsoptmzr = 300
		local pos = GetEntityCoords(GetPlayerPed(-1), true)
		for k,v in pairs(faccoes)do
			local pos2 = v.position
			if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < rts.dist)then
			    rtsoptmzr = 4
				if not domming then
					DrawMarker(26, v.position.x, v.position.y, v.position.z - 1, 0, 0, 0, 0, 0, 0, 2.0001, 2.0001, 0.5001, 1555, 0, 0,255, 0, 0, 0,0)
					if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 3.4)then
					    rtsoptmzr = 4
						if (incircle == false) then
							facnome_DisplayHelpText("Pressione ~INPUT_CONTEXT~ para Dominar ~b~" .. v.nomefaccao .. " \n~r~ Cuidado, geral vai ficar ligado!")
						end
						incircle = true
						if (IsControlJustReleased(1, 51)) then
							TriggerServerEvent('rts_dominacao:dom', k)
						end
					elseif(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) > 2)then
					    rtsoptmzr = 4
						incircle = false
					end
				end
			end
		end
		if domming then
			facnome_drawTxt(0.66, 1.44, 1.0,1.0,0.4, "~g~Dominando: ~r~" .. secondsRemaining .. "~g~ segundos restantes", 255, 255, 255, 255)
			local pos2 = faccoes[facnome].position
			local ped = GetPlayerPed(-1)
            if IsEntityDead(ped) then
			TriggerServerEvent('rts_dominacao:morto', facnome)
			elseif (Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) > rts.dist)then
				TriggerServerEvent('rts_dominacao:fugir', facnome)
			end
		end
		Citizen.Wait(rtsoptmzr)
	end
end)
----------------------------------------------------------------------------------------------------------------------
-------------------------------------         ALERTAS        ---------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('rts_dominacao:dominando')
AddEventHandler('rts_dominacao:dominando', function(domm)
	domming = true
	facnome = domm
	secondsRemaining = rts.seconds
end)
RegisterNetEvent('rts_dominacao:fugirlocal')
AddEventHandler('rts_dominacao:fugirlocal', function(domm)
	domming = false
	RemoveBlip(blip)
	TriggerEvent('chatMessage', 'Cidade Alerta', { 0, 0x99, 255 }, "Invasor, Vaza daqui!!!")
	dommingName = ""
	secondsRemaining = 0
	incircle = false
end)
RegisterNetEvent('rts_dominacao:mortolocal')
AddEventHandler('rts_dominacao:mortolocal', function(domm)
	domming = false
	RemoveBlip(blip)
	TriggerEvent('chatMessage', 'Cidade Alerta', { 0, 0x99, 255 }, "A invasão foi cancelada, você perdeu!. Tente a sorte da proxima vez!")
	TriggerServerEvent('rts_dominacao:morto', facnome)
	dommingName = ""
	secondsRemaining = 0
	incircle = false
end)
----------------------------------------------------------------------------------------------------------------------
-------------------------------------         TEMPO          ---------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		if domming then
			Citizen.Wait(1000)
			if(secondsRemaining > 0)then
				secondsRemaining = secondsRemaining - 1
			end
		end
		Citizen.Wait(0)
	end
end)
----------------------------------------------------------------------------------------------------------------------
-------------------------------------         FUNÇÕES        ---------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
function facnome_DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
function facnome_drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
	    SetTextOutline()
	end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end
--[[
NÃO RETIRE OS CRÉDITOS / NÃO RETIRE OS CRÉDITOS / NÃO RETIRE OS CRÉDITOS / NÃO RETIRE OS CRÉDITOS / NÃO RETIRE OS CRÉDITOS / NÃO RETIRE OS CRÉDITOS

TODOS OS DIREITOS AO CRIADOR  'Rutss.Dev'
url 'https://discord.gg/AbjS8gZ'
versão 'VRPEX'

NÃO RETIRE OS CRÉDITOS / NÃO RETIRE OS CRÉDITOS / NÃO RETIRE OS CRÉDITOS / NÃO RETIRE OS CRÉDITOS / NÃO RETIRE OS CRÉDITOS / NÃO RETIRE OS CRÉDITOS
]]