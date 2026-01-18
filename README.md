# ZyphNoAutoAttack

World of Warcraft Addon that completely blocks right-click auto attack. Auto attack can only be started via macros using `/znaa attack`.

## Installation

1. Download or clone this repository
2. Copy the `ZyphNoAutoAttack` folder to your WoW AddOns directory:
   - **Retail:** `World of Warcraft/_retail_/Interface/AddOns/`
   - **Classic:** `World of Warcraft/_classic_/Interface/AddOns/`
3. Restart WoW or `/reload`

## Usage

**Right-click on enemies:** Auto attack is blocked
**Right-click on NPCs:** Works normally
**Start auto attack:** Use `/znaa attack` in a macro

### Example Macro

```
#showtooltip
/znaa attack
```

## Commands

| Command | Description |
|---------|-------------|
| `/znaa` | Show help |
| `/znaa attack` | Start auto attack (use in macros) |
| `/znaa on` | Enable the addon |
| `/znaa off` | Disable the addon |
| `/znaa status` | Show current status |

## How it works

The addon monitors for auto attack every 50ms and stops it immediately unless it was explicitly started via `/znaa attack`. NPC interactions, item usage, and other right-click actions work normally.
