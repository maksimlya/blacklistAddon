function InitPlayer(id, guid, name, class, server)
    local self = {};

    self.id = id;
    self.guid = guid;
    self.name = name;
    self.class = class;
    self.server = server;
    self.banned = false;

    return self;
end

local initPlayerFunctions = function(self)
    self.Update = function(parent, idx)
        self:SetParent(parent);
        self:SetPoint("TOP", 0, (-(idx-1) * Constants.UI.TableEntry.Height)-5);
        self.bg:Hide();
        self:Show();
    end

    self.Edit = function(key, value)
        self[key] = value;
        globalDatabase[self.guid][key] = value;
    end
end

function UpdatePlayerToModel(player)
    local self = CreateFrame("Button", player.name..player.id, nil, "TableEntry");
    self:SetID(player.id);
    self:SetWidth(Constants.UI.TableEntry.Width);
    self:SetHeight(Constants.UI.TableEntry.Height);
    self.bg = getglobal(player.name..player.id.."BG");
    self.text = getglobal(player.name..player.id.."Name");
    self.text:SetText(player.name..'-'..player.server);
    self.text:SetTextColor(Constants.ClassColors[player.class][1], Constants.ClassColors[player.class][2], Constants.ClassColors[player.class][3], 1);
    
    self.id = player.id;
    self.guid = player.guid;
    self.name = player.name;
    self.class = player.class;
    self.server = player.server;
    self.banned = player.banned;

    initPlayerFunctions(self);
    
    return self;
end



