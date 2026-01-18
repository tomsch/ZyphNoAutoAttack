-- ZyphNoAutoAttack
-- Verhindert Auto-Attack durch Rechtsklick, erlaubt aber NPC-Interaktionen

local ADDON_NAME = "ZyphNoAutoAttack"
local AUTO_ATTACK_SPELL_ID = 6603

-- Saved Variables (für spätere Einstellungen)
ZyphNoAutoAttackDB = ZyphNoAutoAttackDB or {
    enabled = true,
    allowInCombat = false, -- Wenn true, wird Auto-Attack im Kampf erlaubt
}

local frame = CreateFrame("Frame", "ZyphNoAutoAttackFrame")
local isEnabled = true

-- Stoppt Auto-Attack wenn aktiv
local function StopAutoAttackIfActive()
    if not isEnabled then return end
    if ZyphNoAutoAttackDB.allowInCombat and UnitAffectingCombat("player") then return end

    if IsCurrentSpell(AUTO_ATTACK_SPELL_ID) then
        StopAttack()
    end
end

-- Event Handler
frame:RegisterEvent("PLAYER_TARGET_CHANGED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")

frame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        -- Lade gespeicherte Einstellungen
        isEnabled = ZyphNoAutoAttackDB.enabled
        print("|cff00ff00[ZyphNoAutoAttack]|r Geladen - " .. (isEnabled and "Aktiv" or "Deaktiviert"))
    elseif event == "PLAYER_TARGET_CHANGED" then
        -- Kleine Verzögerung damit Auto-Attack registriert wird
        C_Timer.After(0.01, StopAutoAttackIfActive)
        C_Timer.After(0.05, StopAutoAttackIfActive) -- Sicherheits-Check
    end
end)

-- Slash Commands
SLASH_ZYPHNOAUTOATTACK1 = "/znaa"
SLASH_ZYPHNOAUTOATTACK2 = "/zyphnoautoattack"

SlashCmdList["ZYPHNOAUTOATTACK"] = function(msg)
    local cmd = msg:lower():trim()

    if cmd == "on" then
        ZyphNoAutoAttackDB.enabled = true
        isEnabled = true
        print("|cff00ff00[ZyphNoAutoAttack]|r Aktiviert")
    elseif cmd == "off" then
        ZyphNoAutoAttackDB.enabled = false
        isEnabled = false
        print("|cff00ff00[ZyphNoAutoAttack]|r Deaktiviert")
    elseif cmd == "combat" then
        ZyphNoAutoAttackDB.allowInCombat = not ZyphNoAutoAttackDB.allowInCombat
        if ZyphNoAutoAttackDB.allowInCombat then
            print("|cff00ff00[ZyphNoAutoAttack]|r Auto-Attack im Kampf erlaubt")
        else
            print("|cff00ff00[ZyphNoAutoAttack]|r Auto-Attack im Kampf blockiert")
        end
    elseif cmd == "status" then
        print("|cff00ff00[ZyphNoAutoAttack]|r Status:")
        print("  Aktiv: " .. (isEnabled and "Ja" or "Nein"))
        print("  Im Kampf erlaubt: " .. (ZyphNoAutoAttackDB.allowInCombat and "Ja" or "Nein"))
    else
        print("|cff00ff00[ZyphNoAutoAttack]|r Befehle:")
        print("  /znaa on - Aktivieren")
        print("  /znaa off - Deaktivieren")
        print("  /znaa combat - Auto-Attack im Kampf umschalten")
        print("  /znaa status - Status anzeigen")
    end
end
