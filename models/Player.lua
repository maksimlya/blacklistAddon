local id = 1;

function InitPlayer(guid, name, class, server)
    local self = {};

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

function UpdatePlayerToModel(dbPlayer)
    local self = CreateFrame("Button", dbPlayer.name..id, nil, "TableEntry");
    self:SetID(id);
    self:SetWidth(Constants.UI.TableEntry.Width);
    self:SetHeight(Constants.UI.TableEntry.Height);
    self.bg = getglobal(dbPlayer.name..id.."BG");
    self.text = getglobal(dbPlayer.name..id.."Name");
    self.text:SetText(dbPlayer.name..'-'..dbPlayer.server);
    self.text:SetTextColor(Constants.ClassColors[dbPlayer.class][1], Constants.ClassColors[dbPlayer.class][2], Constants.ClassColors[dbPlayer.class][3], 1);
    
    self.id = id;
    self.guid = dbPlayer.guid;
    self.name = dbPlayer.name;
    self.class = dbPlayer.class;
    self.server = dbPlayer.server;
    self.banned = dbPlayer.banned;

    initPlayerFunctions(self);
    
    id = id + 1;
    return self;
end



