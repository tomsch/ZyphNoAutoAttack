-- ZyphNoAutoAttack
-- Blockiert Auto-Attack komplett, nur per Macro erlaubt

local ADDON_NAME = "ZyphNoAutoAttack"
local AUTO_ATTACK_SPELL_ID = 6603

-- Saved Variables
ZyphNoAutoAttackDB = ZyphNoAutoAttackDB or {
    enabled = true,
}

local frame = CreateFrame("Frame", "ZyphNoAutoAttackFrame")
local isEnabled = true
local attackAllowed = false -- Wird true wenn per Macro erlaubt
local attackAllowedUntil = 0 -- Zeitstempel bis wann erlaubt

-- Stoppt Auto-Attack wenn nicht explizit erlaubt
local function StopAutoAttackIfNotAllowed()
    if not isEnabled then return end

    -- Prüfe ob Attack per Macro erlaubt wurde
    if attackAllowed and GetTime() < attackAllowedUntil then
        return -- Erlaubt, nicht stoppen
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
        print("|cff00ff00[ZyphNoAutoAttack]|r Geladen - " .. (isEnabled and "Aktiv" or "Deaktiviert"))
        print("|cff00ff00[ZyphNoAutoAttack]|r Benutze |cffffff00/znaa attack|r in Macros zum Angreifen")
    elseif event == "PLAYER_TARGET_CHANGED" then
        C_Timer.After(0.01, StopAutoAttackIfNotAllowed)
        C_Timer.After(0.05, StopAutoAttackIfNotAllowed)
    end
end)

-- OnUpdate: Prüft jeden Frame ob unerlaubter Auto-Attack läuft
local timeSinceLastCheck = 0
frame:SetScript("OnUpdate", function(self, elapsed)
    if not isEnabled then return end

    timeSinceLastCheck = timeSinceLastCheck + elapsed
    if timeSinceLastCheck < 0.05 then return end -- Alle 50ms prüfen
    timeSinceLastCheck = 0

    StopAutoAttackIfNotAllowed()
end)

-- Slash Commands
SLASH_ZYPHNOAUTOATTACK1 = "/znaa"
SLASH_ZYPHNOAUTOATTACK2 = "/zyphnoautoattack"

SlashCmdList["ZYPHNOAUTOATTACK"] = function(msg)
    local cmd = msg:lower():trim()

    if cmd == "attack" then
        -- Erlaube Auto-Attack für 0.5 Sekunden (genug Zeit zum Starten)
        attackAllowed = true
        attackAllowedUntil = GetTime() + 0.5
        StartAttack()
    elseif cmd == "on" then
        ZyphNoAutoAttackDB.enabled = true
        isEnabled = true
        print("|cff00ff00[ZyphNoAutoAttack]|r Aktiviert")
    elseif cmd == "off" then
        ZyphNoAutoAttackDB.enabled = false
        isEnabled = false
        print("|cff00ff00[ZyphNoAutoAttack]|r Deaktiviert")
    elseif cmd == "status" then
        print("|cff00ff00[ZyphNoAutoAttack]|r Status:")
        print("  Aktiv: " .. (isEnabled and "Ja" or "Nein"))
    else
        print("|cff00ff00[ZyphNoAutoAttack]|r Befehle:")
        print("  /znaa attack - Auto-Attack starten (für Macros)")
        print("  /znaa on - Addon aktivieren")
        print("  /znaa off - Addon deaktivieren")
        print("  /znaa status - Status anzeigen")
    end
end
