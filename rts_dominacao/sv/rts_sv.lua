-- NÃO RETIRE OS CRÉDITOS / NÃO RETIRE OS CRÉDITOS / NÃO RETIRE OS CRÉDITOS / NÃO RETIRE OS CRÉDITOS / NÃO RETIRE OS CRÉDITOS / NÃO RETIRE OS CRÉDITOS
-- TODOS OS DIREITOS AO CRIADOR  'Rutss.Dev'
-- Url 'https://discord.gg/AbjS8gZ'
-- Versão 'vRPEX'
----------------------------------------------------------------------------------------------------------------------
-------------------------------------        VARIÁVEIS       ---------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
local webhook = rts.webhook
local faccoes = rts.rtsconfig
local contador = 0
local dommers = {}
----------------------------------------------------------------------------------------------------------------------
---------------------------------------       DOMINAÇÃO        -------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
RegisterServerEvent('rts_dominacao:dom')
AddEventHandler('rts_dominacao:dom', function(domm)
    local adm = rts.adm
	local seconds = rts.seconds
  	local user_id = vRP.getUserId(source)
  	local player = vRP.getUserSource(user_id)
	local faccao = vRP.getUserGroupByType(user_id,"job")
  	local admin = vRP.getUsersByPermission(rts.perm)
  	if vRP.hasPermission(user_id,rts.permilegal) then
  		if #admin >= adm then
	  		if contador == 0 then
			    if faccoes[domm] then
					local facnome = faccoes[domm]
					local faccao = vRP.getUserGroupByType(user_id,"job")
					TriggerClientEvent('chatMessage', -1, rts.noticia, { 0, 0x99, 255 }, "^1" .. faccao .. " ^7Iniciaram uma dominação em ^1" .. facnome.nomefaccao)
					TriggerClientEvent("Notify",source,"sucesso","Voce começou uma invasão em " .. facnome.nomefaccao .. ", não vai muito pra longe não em!",18000)
					TriggerClientEvent("Notify",source,"aviso","Espere ".. seconds ..  " segundos e receberá o acesso total ao baú desta facção",18000)
          			TriggerClientEvent('rts_dominacao:dominando', player, domm)
					faccoes[domm].lastdommed = os.time()
					dommers[player] = domm
					contador = 71000
					local savedSource = player
					SetTimeout(seconds*60*15, function()
						if (dommers[savedSource]) then
							vRP.addUserGroup(user_id,"dominou")
							TriggerClientEvent('chatMessage', -1, rts.noticia, { 0, 0x99, 255 }, "^1" .. faccao .. "^7 conseguiram dominar ^1" .. facnome.nomefaccao)
							TriggerClientEvent('chatMessage', player, rts.noticia, { 0, 0x99, 255 },"^7".. faccao ..  "^1 tem ".. seconds ..  " segundos de acesso ao Baú antes que o sistema de segurança bloqueie o acesso")
							TriggerClientEvent("Notify",player,"sucesso","" .. faccao .. "conseguiram dominar " .. facnome.nomefaccao,18000)
							TriggerClientEvent("Notify",player,"aviso", "" .. faccao ..  " tem ".. seconds ..  " segundos de acesso ao Baú antes que o sistema de segurança bloqueie o acesso",18000)
						end
					end)				
				SetTimeout(seconds*2*60*15, function()
                vRP.addUserGroup(user_id,"ndominou",10000)
				TriggerClientEvent('chatMessage', player, rts.noticia, { 0, 0x99, 255 }, "O Sistema de defesa Trancou os acessos,^1" .. faccao .." ^7Não tem mais o Dominio do local")
				TriggerClientEvent('chatMessage', -1, rts.noticia, { 0, 0x99, 255 }, "^1" .. faccao .. "^7 Terminaram a dominação")
				TriggerClientEvent("Notify",player,"aviso","O Sistema de defesa Trancou os acessos," .. faccao .." Não tem mais o Dominio do local",18000)
				end)
				end
	  		else
				contagem = string.format("%02.f", math.floor(contador/3600));
				horas = string.format("%02.f", math.floor(contador/3600/rts.temp-1+(rts.temp)));
				minutos = string.format("%02.f", math.floor(contador/60 - (contagem*60)));
				segundos = string.format("%02.f", math.floor(contador - contagem*3600 - minutos *60))
	  			TriggerClientEvent('chatMessage', player, 'Sistema', { 0, 0x99, 255 }, "Aguarde " .. string.format("%.0f", horas) .. " horas " .. string.format("%.0f", minutos) .. " minutos e " .. string.format("%.0f", segundos) .. " segundos para dominar, a cidade ainda não se recuperou da ultima Dominação")
			end
  		else
			TriggerClientEvent('chatMessage', player, 'Sistema', { 0, 0x99, 255 }, "É necessário no minimo ".. rts.adm ..  " Admins em serviço para tentar dominar esta facção.")
			TriggerClientEvent("Notify",source,"negado","É necessário no minimo ".. rts.adm ..  " Admins em serviço para tentar dominar esta facção.",18000)
  		end
  	else
  		TriggerClientEvent("Notify",source,"negado","Não é de nenhuma Facção, Teu lugar não é aqui, VAZA!",18000)
  	end
	local identity = vRP.getUserIdentity(user_id)
	PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
	embeds = {{ 
		     	title = "REGISTRO DE DOMINAÇÃO",
			    thumbnail = {
				url = "https://cdn.discordapp.com/attachments/765217647062286356/819374020053958666/rtsw_comunitty.png"}, 
			fields = {{ 
				name = "**PLAYER INICIOU UMA DOMINAÇÃO:**", 
				value = "Player: "..identity.name.." "..identity.firstname.." \nID: ["..user_id.."] \nFacção: " .. faccao .. ""}}, 
			footer = { 
				text = os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S \nRTS-Comunitty \ndiscord.gg/Ra5yB4CrCG"), 
				icon_url = "https://cdn.discordapp.com/attachments/765217647062286356/819374020053958666/rtsw_comunitty.png"},
			color = 15914080 
		}}
	}), { ['Content-Type'] = 'application/json' })
end)
----------------------------------------------------------------------------------------------------------------------
-------------------------------------         WEBHOOK         --------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end
----------------------------------------------------------------------------------------------------------------------
-------------------------------------         NOTICIAS         ---------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
RegisterServerEvent('rts_dominacao:fugir')
AddEventHandler('rts_dominacao:fugir', function(domm)
	if(dommers[source])then
		TriggerClientEvent('rts_dominacao:fugirlocal', source)
		dommers[source] = nil
		local user_id = vRP.getUserId(source)
		local faccao = vRP.getUserGroupByType(user_id,"job")
		TriggerClientEvent('chatMessage', -1, rts.noticia, { 0, 0x99, 255 }, "A Facção ^1" .. faccao .. " ^7fugiu da dominação em ^1" .. faccoes[domm].nomefaccao .. " .")
	end
end)
RegisterServerEvent('rts_dominacao:morto')
AddEventHandler('rts_dominacao:morto', function(domm)
	if(dommers[source])then
		TriggerClientEvent('rts_dominacao:mortolocal', source)
		dommers[source] = nil
		TriggerClientEvent('chatMessage', -1, rts.noticia, { 0, 0x99, 255 }, "Invasor Morreu enquanto tentava dominar ^2" .. faccoes[domm].nomefaccao .. ", ^7a Dominação foi cancelada.")
	end
end)
----------------------------------------------------------------------------------------------------------------------
-------------------------------------         FUNÇÕES        ---------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
function get3DDistance(x1, y1, z1, x2, y2, z2)
	return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2) + math.pow(z1 - z2, 2))
end
Citizen.CreateThread(function()
	while true do
		Wait(1000)
		if contador > 0 then
			contador=contador-1
		end
	end
end)
print('^2RTS_DOMINACAO ^7Criado por ^1Rutss [Dev] ^7| ^4Marcos .Rutss#5346 ')
--[[
NÃO RETIRE OS CRÉDITOS / NÃO RETIRE OS CRÉDITOS / NÃO RETIRE OS CRÉDITOS / NÃO RETIRE OS CRÉDITOS / NÃO RETIRE OS CRÉDITOS / NÃO RETIRE OS CRÉDITOS

TODOS OS DIREITOS AO CRIADOR  'Rutss.Dev'
url 'https://discord.gg/AbjS8gZ'
versão 'VRPEX'

NÃO RETIRE OS CRÉDITOS / NÃO RETIRE OS CRÉDITOS / NÃO RETIRE OS CRÉDITOS / NÃO RETIRE OS CRÉDITOS / NÃO RETIRE OS CRÉDITOS / NÃO RETIRE OS CRÉDITOS
]]