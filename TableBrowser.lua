local selected = -1;
local id = 1;
allPlayers = {};
entries = {};
banned = {};

local UpdateTables = function()
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

local createPlayer = function(guid)
    local locClass, engClass, locRace, engRace, gender, name, server = GetPlayerInfoByGUID(guid);
        
    if server == "" then
        server = GetRealmName();
    end

    local mock = InitPlayer(id, guid, name, locClass, server);
    local player = UpdatePlayerToModel(mock);

    id = id + 1;

    globalDatabase[guid] = mock;
    allPlayers[guid] = player;
end


local addPlayer = function(player, where)

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
    allPlayers[entries[selected].guid].Edit('banned', true);
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
    allPlayers[banned[selected].guid].Edit('banned', false);
    banned[selected] = nil;
    entries[selected] = entry;
    selected = -1;

    UpdateTables();
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

-- Background flash on mouse over.
function Entered(entry)
    if selected ~= entry.id then
        entry.bg:SetColorTexture(0.7,0.7,0.5,0.15);
    end
    entry.bg:Show();
end
function Left(entry)
   entry.bg:Hide();
end

-- Returns GUIDs of party members.
local getPartyMembers = function()
    local existingMembers = {};
    for i=1,4,1 do
        if(UnitInParty('party'..i)) then
            existingMembers[i] = UnitGUID('party'..i);
        end
    end
    return existingMembers;
end

-- Wipe tables -- TODO (redunant? performance hit?)
local clearTables = function() 
    for i,entry in pairs(entries) do
        entries[i]:Hide();
        entries[i] = nil;
     end
     for i,entry in pairs(banned) do
        banned[i]:Hide();
        banned[i] = nil;
     end
end

local initTables = function()

    -- Add myself 
    local myGuid = UnitGUID('player');
    if globalDatabase[myGuid] == nil then
        createPlayer(myGuid);
    else if allPlayers[myGuid] == nil then
            allPlayers[myGuid] = UpdatePlayerToModel(globalDatabase[myGuid])
        end
    end
    if allPlayers[myGuid].banned then
        addPlayer(allPlayers[myGuid], Constants.Models.BlackListBrowser);
    else
        addPlayer(allPlayers[myGuid], Constants.Models.TableBrowser);
    end

    -- Add party members
    local currentPartyMembers = getPartyMembers();
    
    for i, guid in pairs(currentPartyMembers) do
        if globalDatabase[guid] == nil then
            createPlayer(guid);
            else if allPlayers[guid] == nil then
                allPlayers[guid] = UpdatePlayerToModel(globalDatabase[guid])
            end
        end
        if allPlayers[guid].banned then
            addPlayer(allPlayers[guid], Constants.Models.BlackListBrowser);
        else
            addPlayer(allPlayers[guid], Constants.Models.TableBrowser);
        end
    end
end


function init() 
    clearTables();
    initTables();
end

