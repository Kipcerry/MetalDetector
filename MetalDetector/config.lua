Config = {}

Config.MetalDetectorItem = 'metaldetector'
Config.BateryItem = 'batery'
Config.EnableShop = true -- If true and ox_inventory/data/shops.lua part below is installed the metal detector/batery shops will be spawned
Config.Shops = {
    vector4(-1298.8665, -1378.4515, 3.4886, 108.3720),
}
Config.BlipLabel = 'Metal detector shop'

--Locals
Config.OpenShop = 'Open shop'
Config.YouNeedWait = 'You need to wait '
Config.WaitSeconds = ' seconds before you can start to use the metal detector again'
Config.CurrentLevel = 'Current level: '
Config.CurrentXp = 'Current XP: '
Config.YouNeedXp = 'You still need '
Config.NeedXp = ' XP to level up'
Config.SellAll = 'Sell all your items'
Config.Sell = 'Sell'
Config.For = 'for'
Config.MoneySymbol = '€'
Config.EnterSellAmount = 'Enter how much you wanna sell for '
Config.Amount = 'Amount'
Config.Shop = 'Shop'
Config.SellItems = 'Sell your items'
Config.ToStop = 'To stop'
Config.ToDig = 'To dig'
Config.EnoughBatery = 'Your metal detectors batery percentage is to high for a new batery'
Config.NoBatery = 'Your metal detector is empty fill it with a new batery'
Config.NoMetalDetector = 'You dont have a metal detector'

Config.Rewards = { -- Add own items if you want
    {Item = 'scrapmetal', Chance = 95, Level = 1, Amount = 1, MinReward = 15, MaxReward = 45, AddXP = 1, Icon = 'coins',
        Skill = {{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1}}},

    {Item = 'bronze_coin', Chance = 90, Level = 1, Amount = 1, MinReward = 50, MaxReward = 90, AddXP = 1, Icon = 'coins',
        Skill = {{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1}}},

    {Item = 'silver_coin', Chance = 80, Level = 1, Amount = 1, MinReward = 80, MaxReward = 125, AddXP = 1, Icon = 'coins',
        Skill = {{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1}}},

    {Item = 'gold_coin', Chance = 35, Level = 1, Amount = 1, MinReward = 200, MaxReward = 260, AddXP = 2, Icon = 'coins',
        Skill = {{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1}}},

    {Item = 'silver_ring', Chance = 44, Level = 1, Amount = 1, MinReward = 150, MaxReward = 200, AddXP = 1, Icon = 'ring',
        Skill = {{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1}}},

    {Item = 'gold_chain', Chance = 20, Level = 2, Amount = 1, MinReward = 320, MaxReward = 400, AddXP = 3, Icon = 'link',
        Skill = {{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1}}},

    {Item = 'rusty_screwdriver', Chance = 95, Level = 1, Amount = 1, MinReward = 10, MaxReward = 40, AddXP = 1, Icon = 'screwdriver',
        Skill = {{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1}}},

    {Item = 'old_key', Chance = 95, Level = 1, Amount = 1, MinReward = 5, MaxReward = 25, AddXP = 1, Icon = 'key',
        Skill = {{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1}}},

    {Item = 'scrap_metal', Chance = 60, Level = 1, Amount = 1, MinReward = 120, MaxReward = 180, AddXP = 1, Icon = 'tag',
        Skill = {{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1}}},

    {Item = 'rusty_nail', Chance = 100, Level = 1, Amount = 1, MinReward = 2, MaxReward = 10, AddXP = 1, Icon = 'toolbox',
        Skill = {{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1}}},

    {Item = 'platinum_coin', Chance = 30, Level = 3, Amount = 1, MinReward = 450, MaxReward = 600, AddXP = 4, Icon = 'coins',
        Skill = {{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1}}},

    {Item = 'silver_chain', Chance = 49, Level = 1, Amount = 1, MinReward = 200, MaxReward = 240, AddXP = 2, Icon = 'link',
        Skill = {{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1}}},

    {Item = 'broken_watch', Chance = 95, Level = 1, Amount = 1, MinReward = 40, MaxReward = 90, AddXP = 1, Icon = 'clock',
        Skill = {{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1}}},

    {Item = 'rusted_knife', Chance = 25, Level = 2, Amount = 1, MinReward = 400, MaxReward = 500, AddXP = 3, Icon = 'utensils',
        Skill = {{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1}}},

    {Item = 'old_pistol', Chance = 15, Level = 4, Amount = 1, MinReward = 600, MaxReward = 700, AddXP = 6, Icon = 'gun',
        Skill = {{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1}}},

    {Item = 'lead_chunk', Chance = 13, Level = 4, Amount = 1, MinReward = 800, MaxReward = 950, AddXP = 5, Icon = 'cube',
        Skill = {{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1}}},

    {Item = 'copper_pipe', Chance = 25, Level = 2, Amount = 1, MinReward = 250, MaxReward = 300, AddXP = 2, Icon = 'recycle',
        Skill = {{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1}}},

    {Item = 'antique_key', Chance = 30, Level = 2, Amount = 1, MinReward = 120, MaxReward = 200, AddXP = 2, Icon = 'key',
        Skill = {{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1}}},

    {Item = 'silver_goblet', Chance = 12, Level = 2, Amount = 1, MinReward = 700, MaxReward = 820, AddXP = 3, Icon = 'glass-water',
        Skill = {{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1}}},

    {Item = 'gold_goblet', Chance = 10, Level = 3, Amount = 1, MinReward = 900, MaxReward = 1050, AddXP = 1, Icon = 'whiskey-glass',
        Skill = {{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1}}},

    {Item = 'old_pocket_watch', Chance = 40, Level = 2, Amount = 1, MinReward = 250, MaxReward = 325, AddXP = 2, Icon = 'clock',
        Skill = {{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1}}},

    {Item = 'metal_figurine', Chance = 36, Level = 2, Amount = 1, MinReward = 270, MaxReward = 340, AddXP = 2, Icon = 'palette',
        Skill = {{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1}}},

    {Item = 'bike_frame_piece', Chance = 30, Level = 2, Amount = 1, MinReward = 200, MaxReward = 300, AddXP = 3, Icon = 'bicycle',
        Skill = {{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1}}},

    {Item = 'old_sword', Chance = 10, Level = 3, Amount = 1, MinReward = 900, MaxReward = 1200, AddXP = 4, Icon = 'utensils',
        Skill = {{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1}}},

    {Item = 'treasure_chest', Chance = 5, Level = 5, Amount = 1, MinReward = 5000, MaxReward = 7500, AddXP = 10, Icon = 'gift',
        Skill = {{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1},{areaSize = 70, speedMultiplier = 1}}},
}

--Add to ox_inventory/data/shops.lua

--[[
    MetalDetector = {
		name = 'Metal detector',
		inventory = {
			{ name = 'metaldetector', price = 1250, },
			{ name = 'batery', price = 15, },
		}
	}, 
]]
	
-- Add to ox_inventory/data/item.lua
--[[
    ['metaldetector'] = {
		label = 'Metaldetector',
		durability = 100.0,
		weight = 1360,
		stack = false,
	},
	['batery'] = {
		label = 'Batery',
		weight = 50,
	},
    --MetalRewards
	['rusty_coin'] = {
		label = 'Rusty Coin',
		weight = 50,
	},

	['silver_coin'] = {
		label = 'Silver Coin',
		weight = 120,
	},

	['gold_coin'] = {
		label = 'Gold Coin',
		weight = 190,
	},

	['silver_ring'] = {
		label = 'Silver Ring',
		weight = 150,
	},

	['gold_chain'] = {
		label = 'Gold Chain',
		weight = 200,
	},

	['rusty_screwdriver'] = {
		label = 'Rusty Screwdriver',
		weight = 250,
	},

	['old_key'] = {
		label = 'Old Key',
		weight = 90,
	},

	['treasure_chest'] = {
		label = 'Treasure Chest',
		weight = 1500,
		stack = false,
	},

	['scrap_metal'] = {
		label = 'Scrap Metal',
		weight = 300,
	},

	['rusty_nail'] = {
		label = 'Rusty Nail',
		weight = 20,
	},

	['broken_watch'] = {
		label = 'Broken Watch',
		weight = 180,
	},

	['bronze_coin'] = {
		label = 'Bronze Coin',
		weight = 100,
	},

	['platinum_coin'] = {
		label = 'Platinum Coin',
		weight = 210,
	},

	['silver_chain'] = {
		label = 'Silver Chain',
		weight = 180,
	},

	['rusted_knife'] = {
		label = 'Rusted Knife',
		weight = 220,
	},

	['old_pistol'] = {
		label = 'Old Pistol',
		weight = 700,
		stack = false,
	},

	['lead_chunk'] = {
		label = 'Chunk of Lead',
		weight = 400,
	},

	['copper_pipe'] = {
		label = 'Copper Pipe',
		weight = 350,
	},

	['antique_key'] = {
		label = 'Antique Key',
		weight = 95,
	},

	['silver_goblet'] = {
		label = 'Silver Goblet',
		weight = 500,
	},

	['gold_goblet'] = {
		label = 'Gold Goblet',
		weight = 600,
	},

	['old_pocket_watch'] = {
		label = 'Old Pocket Watch',
		weight = 190,
	},

	['metal_figurine'] = {
		label = 'Metal Figurine',
		weight = 450,
	},

	['bike_frame_piece'] = {
		label = 'Piece of a Bike Frame',
		weight = 500,
		stack = false,
	},

	['old_sword'] = {
		label = 'Old Sword',
		weight = 1800,
		stack = false,
	},
]]

