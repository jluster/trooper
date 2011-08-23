trooper = CreateFrame('Frame', 'trooper')
trooper.current_troopers = {}
local origChatFrame_OnHyperlinkShow = ChatFrame_OnHyperlinkShow;

ChatFrame_OnHyperlinkShow = function(...)
  local chatFrame, link, text, button = ...;
  if string.match(link, "ignore:") then
    local a = string.match(link, "[^:]+:(.*)$")
    rsay("Ignoring ["..a.."]")
    AddIgnore(a)
  else
    return origChatFrame_OnHyperlinkShow(...)
  end
end

trooper:SetScript('OnEvent', function(self, event, ...) self[event](self, ...) end)
trooper:RegisterEvent('ADDON_LOADED')
trooper:RegisterEvent('PARTY_MEMBERS_CHANGED')

function rsay(sentence)
  DEFAULT_CHAT_FRAME:AddMessage("|cFF006699trooper|r: " .. sentence)
end

function trooper:ADDON_LOADED(me)
  if me ~= "trooper" then return end
  rsay("Trooper loaded")
end

function trooper:PARTY_MEMBERS_CHANGED()
  for gi = 1,MAX_PARTY_MEMBERS do
    if (GetPartyMember(gi)) then
      if UnitIsInMyGuild("party"..gi) then return end
      name = GetUnitName("party"..gi, true)
      localizedClass, englishClass = UnitClass("party"..gi);
      player_role = UnitGroupRolesAssigned(Unit);
      self.current_troopers[name] = {
        class = localizedClass,
        role = player_role,
      }
    end
  end
end

SLASH_TROOPER1 = "/trooper"

SlashCmdList["TROOPER"] = function(str)
  local switch, message = str:match("^(%S*)%s*(.-)$");
  local cmd = string.lower(switch)
  local msg = string.lower(message)

  if cmd == "help" then
    rsay("Trooper")
  elseif cmd == "show" then
    rsay("Name, Class, Role")
    for k,v in pairs(trooper.current_troopers) do
      class = v["class"] or ""
      role = v["role"] or ""
      if role == "NONE" then role = "" end
      name = string.gsub(k, " %- ", "-")
      ilink = string.format("  |cffff0000|Hignore:%s|h[ignore]|h|r", name)
      rsay(k.." "..class.." "..role..ilink)
    end
  elseif cmd == "test" then
    trooper.current_troopers["Ogier - Nesingwary"] = {
      class = "Paladin",
      role = "Tank",
    }
  else
    rsay("Trooper can't hear your orders...")
  end
  
end
