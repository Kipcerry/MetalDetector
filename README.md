This script adds a fully featured metal detector system with battery-based durability, inspired by realistic treasure hunting mechanics.

Players can use a metal detector on sand and grass surfaces to search for hidden items. The detector works using an audio-based proximity system: the closer the player gets to a buried item, the faster and louder the sound becomes.

The metal detector uses item durability as battery power. When the battery runs out, players must insert a new battery item to continue searching. All rewards, chances, values, XP, and progression levels are fully configurable.

A built-in shop system is included for purchasing metal detectors and batteries, with optional map blips.

Features

Realistic metal detector gameplay

Battery-based durability system

Replaceable battery items

Works on sand and grass surfaces

Audio-based proximity detection system

Configurable cooldown between uses

Level & XP progression system

Customizable reward table

Sell found items through a sell menu

Optional metal detector shop with blip

Fully configurable via the Config file

Compatible with ox_inventory

ox_inventory Setup (Required)

This script requires two inventory items to be added to ox_inventory, including included item images:

Metal Detector (with durability enabled)

Battery (used to refill detector durability)

Reward items included in the script must also be added to ox_inventory/data/items.lua.

Example configurations for:

ox_inventory/data/items.lua

ox_inventory/data/shops.lua

are provided in the script files.

⚠️ Make sure to add the provided item images to your ox_inventory/web/images folder.
