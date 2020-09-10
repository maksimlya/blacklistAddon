-- Toggle the UI
SLASH_BAN1 = "/ban"
SlashCmdList.BAN = function()
    MyModMainFrame:Show();
end


local function OnEvent(self, event, arg1, arg2 )
    -- if(arg1 == '!sync') 
    --     print(UnitName('player') .. ' tried to sync ');
    -- end
    local opts = {5,6,7,8}
    if(arg1 == '!sync')
    then
        message(UnitName('player') .. ' tried to sync ');
        print(opts[2]);
    end	
end

local f = CreateFrame("Frame")
f:RegisterEvent("CHAT_MSG_SAY")
f:SetScript("OnEvent", OnEvent)

