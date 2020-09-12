local selected = -1;
local id = 1;
entries = {};
banned = {};
globalDatabase = {};

local refreshTable = function()
     local idx = 1;
     for i,entry in pairs(entries) do
        entry.Update(TableBrowser, idx);
        idx = idx + 1;
     end
     idx = 1;
     for i,entry in pairs(banned) do
        entry.Update(BlackListBrowser, idx);
        idx = idx + 1;
     end
end

createPlayer = function(guid)
    local locClass, engClass, locRace, engRace, gender, name, server = GetPlayerInfoByGUID(guid);
        
    if server == "" then
        server = GetRealmName();
    end

    local player = InitPlayer(id, guid, name, locClass, server);

    id = id + 1;

    globalDatabase[guid] = player;
end


addPlayer = function(player, where)

    if where == Constants.Models.TableBrowser then
        entries[player.id] = player;
    else if where == Constants.Models.BlackListBrowser then
        banned[player.id] = player
        end
    end
    
    UpdateTables(); 
end

banPlayer = function()
    local entry = entries[selected];
    if entry == nil then
        return
    end
    globalDatabase[entries[selected].guid].banned = true;
    entries[selected] = nil;
    banned[selected] = entry;
    selected = -1;

    UpdateTables();
end

unBanPlayer = function()
    local entry = banned[selected];
    if entry == nil then
        return
    end
    globalDatabase[banned[selected].guid].banned = false;
    banned[selected] = nil;
    entries[selected] = entry;
    selected = -1;

    UpdateTables();
end

local fillTable = function()
    for i,name in ipairs(candidates) do
        addPlayer(name);
    end
end

function UpdateTables()
    refreshTable();
end


function SelectEntry(entry)
    entry.bg:SetColorTexture(1,1,1,0.25);
    entry.bg:Show();

    if entries[selected] then
        entries[selected].bg:Hide();
    end
    if banned[selected] then
        banned[selected].bg:Hide();
    end

    selected = entry.id; 

    -- Enable/Disable add/remove buttons.
    if entries[selected] then
        getglobal("AddButton"):Enable();
        getglobal("RemoveButton"):Disable();
    end
    if banned[selected] then
        getglobal("RemoveButton"):Enable();
        getglobal("AddButton"):Disable();
    end
end

function IsSelected(entry)
    if selected == entry.id then 
        return true 
    else 
        return false
    end
end

function Entered(entry)
    if selected ~= entry.id then
        entry.bg:SetColorTexture(0.7,0.7,0.5,0.15);
    end
    entry.bg:Show();
end
function Left(entry)
   entry.bg:Hide();
end

function getPartyMembers()
    local existingMembers = {};
    for i=1,4,1 do
        if(UnitInParty('party'..i)) then
            existingMembers[i] = UnitGUID('party'..i);
        end
    end
    return existingMembers;
end

local clearTables = function() 
    for i,entry in pairs(entries) do
        entries[i] = nil;
     end
     for i,entry in pairs(banned) do
        banned[i] = nil;
     end
     id = 1;
end

function initTables()

    
    local currentPartyMembers = getPartyMembers();
    
    for i, guid in pairs(currentPartyMembers) do

        if globalDatabase[guid] == nil then
            createPlayer(guid);
        end
        if globalDatabase[guid].banned then
            addPlayer(globalDatabase[guid], Constants.Models.BlackListBrowser);
        else
            addPlayer(globalDatabase[guid], Constants.Models.TableBrowser);
        end
    end
end

function init() 
    clearTables();

    local myGuid = UnitGUID('player');
    if globalDatabase[myGuid] == nil then
        createPlayer(myGuid);
    end
    if globalDatabase[myGuid].banned then
        addPlayer(globalDatabase[myGuid], Constants.Models.BlackListBrowser);
    else
        addPlayer(globalDatabase[myGuid], Constants.Models.TableBrowser);
    end
    
    initTables();
end

init();




