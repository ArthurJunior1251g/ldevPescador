-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--( Tunnel )-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module('vrp','lib/Tunnel')
local Proxy = module('vrp','lib/Proxy')
vRP = Proxy.getInterface('vRP')
scriptPescador = {}
Tunnel.bindInterface('ldevPescador',scriptPescador)
pescadorCL = Tunnel.getInterface('ldevPescador')
local randompeixe
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--( Funções )------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function scriptPescador.verificaItens() 
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local quantidadeNecessaria = ldevPescador['Pescaria']['QtdItemIsca']
        local quantidadePlayer = vRP.getInventoryItemAmount(user_id,ldevPescador['Pescaria']['ItemIsca'])
        if vRP.getInventoryItemAmount(user_id,ldevPescador['Pescaria']['ItemVaraDePesca']) >= 1 then
            if vRP.getInventoryItemAmount(user_id,ldevPescador['Pescaria']['ItemIsca']) >= quantidadeNecessaria then
                return true
            else 
                TriggerClientEvent('Notify',source,'aviso',ldevPescador['Notificações']['SemIsca'][1] .. quantidadeNecessaria-quantidadePlayer .. 'x' .. ldevPescador['Notificações']['SemIsca'][2])
                return false
            end
        else 
            TriggerClientEvent('Notify',source,'negado',ldevPescador['Notificações']['SemVara'])
            return false
        end
    end
end

function scriptPescador.verificaRecompensa()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        randompeixe = math.random(#ldevPescador['Pescaria']['ItensPeixes'])
        if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(ldevPescador['Pescaria']['ItensPeixes'][randompeixe])*1 <= vRP.getInventoryMaxWeight(user_id) then
            if vRP.tryGetInventoryItem(user_id,ldevPescador['Pescaria']['ItemIsca'],ldevPescador['Pescaria']['QtdItemIsca'],false) then
                return true
            end
        else
            TriggerClientEvent('Notify',source,'negado',ldevLeiteiro['Notificações']['MochilaCheia'])
            return false
        end
    end
end

function scriptPescador.recebeRecompensa()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then  
        Wait(ldevPescador['Pescaria']['TempoProgresso']*1000)
        vRP.giveInventoryItem(user_id,ldevPescador['Pescaria']['ItensPeixes'][randompeixe],1) 
        randompeixe = nil
    end
end
