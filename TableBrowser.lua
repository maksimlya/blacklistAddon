selected = -1;
allPlayers = {};
entries = {};
banned = {};
recents = {};
local sortBy = 'name';
local sortDirection = 'asc'

-- Returns GUIDs of party members.
local getPartyMembers = function()
    local existingMembers = {};
    for i=1,4,1 do
        if(UnitInParty('party'..i)) then
            local guid = UnitGUID('party'..i);
            existingMembers[guid] = guid;
        end
    end
    return existingMembers;
end

-- Returns true if the given GUID in party.
local function isInParty(guid)
    local currentPartyMembers = getPartyMembers();
    if currentPartyMembers[guid] == nil then
        return false;
    else 
        return true;
    end
end

local UpdateTables = function()
     local idx = 1;
     for i,entry in pairsByKeys(entries, sortBy, sortDirection) do
        entry.Update(TableBrowser, idx);
        idx = idx + 1;
     end
     idx = 1;
     for i,entry in pairsByKeys(banned, sortBy, sortDirection) do
        entry.Update(BlackListBrowser, idx);
        idx = idx + 1;
     end
     idx = 1;
     for i,entry in pairsByKeys(recents, sortBy, sortDirection) do
        entry.Update(RecentsBrowser, idx);
        idx = idx + 1;
     end
end

local createPlayer = function(guid)
    local locClass, engClass, locRace, engRace, gender, name, server = GetPlayerInfoByGUID(guid);
        
    if server == "" then
        server = GetRealmName();
    end

    local dbPlayer = InitPlayer(guid, name, locClass, server);
    local player = UpdatePlayerToModel(dbPlayer);


    globalDatabase[guid] = dbPlayer;
    allPlayers[guid] = player;
end


local addPlayer = function(player, where)

    if where == Constants.Models.TableBrowser then
        entries[player.guid] = player;
    else if where == Constants.Models.BlackListBrowser then
        banned[player.guid] = player
        end
    end
    
    UpdateTables(); 
end

testForBanned = function()
    local partyMembers = getPartyMembers();
    for i, guid in pairs(partyMembers) do
        print(guid);
        if banned[guid] ~= nil then
            message('Player '..banned[guid].name..' is in your black list!!!');
            PlaySound(SOUNDKIT.READY_CHECK, 'master', true);
        end
    end
end

banPlayer = function()
    local entry = entries[selected];
    if entry == nil then
        entry = recents[selected];
    end
    if entry == nil then
        return;
    end
    
    allPlayers[entry.guid].Edit('banned', true);
    entries[selected] = nil;
    recents[selected] = nil;
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

    if isInParty(entry.guid) then
        entries[selected] = entry;
    else
        recents[selected] = entry;
    end
    
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

    selected = entry.guid; 

    -- Enable/Disable add/remove buttons.
    if entries[selected] or recents[selected] then
        getglobal("AddButton"):Enable();
        getglobal("RemoveButton"):Disable();
    end
    if banned[selected] then
        getglobal("RemoveButton"):Enable();
        getglobal("AddButton"):Disable();
    end
end


function IsSelected(entry)
    if selected == entry.guid then 
        return true 
    else 
        return false
    end
end

-- Background flash on mouse over.
function Entered(entry)
    if selected ~= entry.guid then
        entry.bg:SetColorTexture(0.7,0.7,0.5,0.15);
    end
    entry.bg:Show();
end
function Left(entry)
   entry.bg:Hide();
end

function pairsByKeys (data, field, direction)
    local a = {}
    for guid, player in pairs(data) do table.insert(a, player) end
    table.sort(a, function(v1,v2)
        if direction == 'asc'then
            return v1[field] < v2[field];
        else
            return v1[field] > v2[field];
        end
    end)
     
    local i = 0      -- iterator variable
    local iter = function ()   -- iterator function
      i = i + 1
      if a[i] == nil then return nil
      else return a[i], data[a[i].guid]
      end
    end
    return iter
  end

sortByProp = function(sortProp)
    if sortBy == sortProp then
        if sortDirection == 'asc' then
            sortDirection = 'desc';
        else 
            sortDirection = 'asc';
        end
    else
        sortBy = sortProp;
    end
    UpdateTables();
end


-- Wipe tables -- TODO (redunant? performance hit?)
local clearTables = function() 
    for i,entry in pairs(entries) do
        entry:Hide();
        entry = nil;
     end
     for i,entry in pairs(banned) do
        entry:Hide();
        entry = nil;
     end
end



local initTables = function()
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
    addMocks();
end






-- Testing functions

function addMocks()
    for guid, obj in pairs(globalDatabase) do
        if obj.banned then
            if allPlayers[guid] == nil then
                allPlayers[guid] = UpdatePlayerToModel(globalDatabase[guid]);
            end
            addPlayer(allPlayers[guid], Constants.Models.BlackListBrowser);
        end    
    end
end

function banAll()
    for guid, obj in pairs(globalDatabase) do
        obj.banned = true;
    end
end