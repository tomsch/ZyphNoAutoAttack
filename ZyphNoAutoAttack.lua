-- ZyphNoAutoAttack
-- Blockiert Auto-Attack komplett, nur per Macro erlaubt
-- TBC Classic kompatibel

local ADDON_NAME = "ZyphNoAutoAttack"
local AUTO_ATTACK_SPELL_ID = 6603

-- Saved Variables
ZyphNoAutoAttackDB = ZyphNoAutoAttackDB or {
    enabled = true,
}

local frame = CreateFrame("Frame", "ZyphNoAutoAttackFrame")
local isEnabled = true
local attackAllowed = false
local attackAllowedUntil = 0

-- Stoppt Auto-Attack wenn nicht explizit erlaubt
local function StopAutoAttackIfNotAllowed()
    if not isEnabled then return end

    -- Prüfe ob Attack per Macro erlaubt wurde
    if attackAllowed and GetTime() < attackAllowedUntil then
        return
    end

    attackAllowed = false

    if IsCurrentSpell(AUTO_ATTACK_SPELL_ID) then
        StopAttack()
    end
end

-- Event Handler
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_TARGET_CHANGED")

frame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        isEnabled = ZyphNoAutoAttackDB.enabled
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[ZyphNoAutoAttack]|r Geladen - " .. (isEnabled and "Aktiv" or "Deaktiviert"))
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[ZyphNoAutoAttack]|r Benutze |cffffff00/znaa attack|r in Macros zum Angreifen")
    elseif event == "PLAYER_TARGET_CHANGED" then
        StopAutoAttackIfNotAllowed()
    end
end)

-- OnUpdate: Prüft regelmäßig ob unerlaubter Auto-Attack läuft
local timeSinceLastCheck = 0
frame:SetScript("OnUpdate", function(self, elapsed)
    if not isEnabled then return end

    timeSinceLastCheck = timeSinceLastCheck + elapsed
    if timeSinceLastCheck < 0.05 then return end
    timeSinceLastCheck = 0

    StopAutoAttackIfNotAllowed()
end)

-- Slash Commands
SLASH_ZYPHNOAUTOATTACK1 = "/znaa"
SLASH_ZYPHNOAUTOATTACK2 = "/zyphnoautoattack"

SlashCmdList["ZYPHNOAUTOATTACK"] = function(msg)
    local cmd = string.lower(msg or "")
    cmd = string.gsub(cmd, "^%s*(.-)%s*$", "%1") -- trim

    if cmd == "attack" then
        attackAllowed = true
        attackAllowedUntil = GetTime() + 0.5
        StartAttack()
    elseif cmd == "on" then
        ZyphNoAutoAttackDB.enabled = true
        isEnabled = true
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[ZyphNoAutoAttack]|r Aktiviert")
    elseif cmd == "off" then
        ZyphNoAutoAttackDB.enabled = false
        isEnabled = false
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[ZyphNoAutoAttack]|r Deaktiviert")
    elseif cmd == "status" then
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[ZyphNoAutoAttack]|r Status:")
        DEFAULT_CHAT_FRAME:AddMessage("  Aktiv: " .. (isEnabled and "Ja" or "Nein"))
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[ZyphNoAutoAttack]|r Befehle:")
        DEFAULT_CHAT_FRAME:AddMessage("  /znaa attack - Auto-Attack starten (fuer Macros)")
        DEFAULT_CHAT_FRAME:AddMessage("  /znaa on - Addon aktivieren")
        DEFAULT_CHAT_FRAME:AddMessage("  /znaa off - Addon deaktivieren")
        DEFAULT_CHAT_FRAME:AddMessage("  /znaa status - Status anzeigen")
    end
end
