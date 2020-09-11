local player = {}

function InitPlayer(id, guid, name, class, server)
    player = CreateFrame("Button", name..id, nil, "TableEntry");

    player:SetID(id);
    player:SetWidth(TableBrowser:GetWidth()-8);
    player:SetHeight(50);
    player.bg = getglobal(name..id.."BG");
    player.text = getglobal(name..id.."Name");
    player.text:SetText(name..'-'..server);

    player.id = id;
    player.guid = guid;
    player.name = name;
    player.class = class;
    player.server = server;
    player.selected = false;

    initPlayerFunctions();

    return player;
end

function initPlayerFunctions()
    player.Update = function(parent, idx)
        player:SetParent(parent);
        player:SetPoint("TOP", 0, -(idx-1)*50);
        player:Show();
    end
end


