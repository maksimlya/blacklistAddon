function InitPlayer(id, guid, name, class, server)
    local self = CreateFrame("Button", name..id, nil, "TableEntry");

    self:SetID(id);
    self:SetWidth(Constants.UI.TableEntry.Width);
    self:SetHeight(Constants.UI.TableEntry.Height);
    self.bg = getglobal(name..id.."BG");
    self.text = getglobal(name..id.."Name");
    self.text:SetText(name..'-'..server);
    self.text:SetTextColor(Constants.ClassColors[class][1], Constants.ClassColors[class][2], Constants.ClassColors[class][3], 1);

    self.id = id;
    self.guid = guid;
    self.name = name;
    self.class = class;
    self.server = server;
    self.banned = false;

   initPlayerFunctions(self);

    return self;
end

function initPlayerFunctions(self)
    self.Update = function(parent, idx)
        self:SetParent(parent);
        self:SetPoint("TOP", 0, (-(idx-1) * Constants.UI.TableEntry.Height)-5);
        self.bg:Hide();
        self:Show();
    end
end


