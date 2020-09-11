local selected = -1;
local offset = -5;
local id = 1;
entries = {};
banned = {};
local amountOfCandidates = 1;

local refreshTable = function()
    for i,entry in pairs(entries) do 
        entry:Hide();
     end
     for i,entry in pairs(banned) do 
        entry:Hide();
     end
     local idx = 0;
     for i,entry in pairs(entries) do
        entry:SetPoint("TOP",0,-idx* Constants.UI.TableEntry.Height);
        entry:Show();
        idx = idx + 1;
     end
     idx = 0;
     for i,entry in pairs(banned) do
        entry:SetPoint("TOP",0,-idx* Constants.UI.TableEntry.Height);
        entry:Show();
        idx = idx + 1;
     end

end



addPlayer = function(who)
    local guid = UnitGUID(who);
    local locClass, engClass, locRace, engRace, gender, name, server = GetPlayerInfoByGUID(guid);
        
    if server == "" then
        server = GetRealmName();
    end

    local player = InitPlayer(id, guid, name, locClass, server);

    print(player);

    player.Update(TableBrowser, id);
    entries[id] = player;
    id = id + 1;
end

banPlayer = function()
    local entry = entries[selected];
    if entry == nil then
        return
    end
    entries[selected] = nil;
    banned[selected] = entry;
    selected = -1;
    entry:Hide();
    getglobal(entry:GetName().."BG"):Hide();
    entry:SetParent(BlackListBrowser);
    entry:SetPoint("TOP");
    entry:Show();
    UpdateTable();
end

unBanPlayer = function()
    local entry = banned[selected];
    if entry == nil then
        return
    end
    banned[selected] = nil;
    entries[selected] = entry;
    selected = -1;
    entry:Hide();
    getglobal(entry:GetName().."BG"):Hide();
    entry:SetParent(TableBrowser);
    entry:SetPoint("TOP");
    entry:Show();
    UpdateTable();
end

local fillTable = function()
    for i,name in ipairs(candidates) do
        addPlayer(name);
    end
end

function UpdateTable()
    refreshTable();
end


function SelectEntry(entry)
    getglobal(entry:GetName().."BG"):SetColorTexture(1,1,1,0.25);
    getglobal(entry:GetName().."BG"):Show();

    if entries[selected] then
        getglobal(entries[selected]:GetName().."BG"):Hide();
    end
    if banned[selected] then
        getglobal(banned[selected]:GetName().."BG"):Hide();
    end

    selected = entry:GetID(); 

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
    if selected == entry:GetID() then 
        return true 
    else 
        return false
    end
end

function AddButtonActive()
    if entries[selected] then
        return true
    else 
        return false
    end
end

function RemoveButtonActive()
    if banned[selected] then
        return true
    else 
        return false
    end
end

function Entered(entry)
    if selected ~= entry:GetID() then
        getglobal(entry:GetName().."BG"):SetColorTexture(0.7,0.7,0.5,0.15);
    end
    getglobal(entry:GetName().."BG"):Show();
end
function Left(entry)
    getglobal(entry:GetName().."BG"):Hide();
end

addPlayer('player');
addPlayer('party1');
addPlayer('party2');

-- addCandidate('Joker');
-- addCandidate('Momo');
-- addCandidate('Toto');
-- addCandidate('Soso');

-- fillTable();


