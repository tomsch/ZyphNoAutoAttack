# ZyphNoAutoAttack

World of Warcraft Addon that prevents right-click auto attack while allowing other right-click interactions (NPCs, items, etc.).

## Installation

1. Download or clone this repository
2. Copy the `ZyphNoAutoAttack` folder to your WoW AddOns directory:
   - **Retail:** `World of Warcraft/_retail_/Interface/AddOns/`
   - **Classic:** `World of Warcraft/_classic_/Interface/AddOns/`
3. Restart WoW or `/reload`

## Commands

| Command | Description |
|---------|-------------|
| `/znaa` | Show help |
| `/znaa on` | Enable the addon |
| `/znaa off` | Disable the addon |
| `/znaa combat` | Toggle auto attack permission during combat |
| `/znaa status` | Show current status |

## How it works

The addon cannot block mouse clicks directly (Blizzard protection), but it stops auto attack immediately after it starts - so fast you won't notice. NPC interactions, item usage, and other right-click actions work normally.

## Features

- Stops auto attack instantly after right-clicking enemies
- NPC interactions work normally
- Optional: Allow auto attack while in combat
- Settings are saved between sessions
