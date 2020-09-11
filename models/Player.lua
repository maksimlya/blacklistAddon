local player = {}

function InitPlayer(id, guid, name, class, server)
    player = CreateFrame("Button", name..id, nil, "TableEntry");

    player:SetID(id);
    player:SetWidth(Constants.UI.TableEntry.Width);
    player:SetHeight(Constants.UI.TableEntry.Height);
    player.bg = getglobal(name..id.."BG");
    player.text = getglobal(name..id.."Name");
    player.text:SetText(name..'-'..server);
    player.text:SetTextColor(Constants.ClassColors[class][1], Constants.ClassColors[class][2], Constants.ClassColors[class][3], 1);

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
        player:SetPoint("TOP", 0, (-(idx-1) * Constants.UI.TableEntry.Height)-5);
        player:Show();
    end
end


