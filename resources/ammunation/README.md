# es_weashop

This is the weapon resource based on the vehicle shop from https://github.com/FiveM-Scripts 

======They merged different shops into the gamemode. I will have to update this======

## What does this mod ?
This mod creates a weapon shop in a not so usual place.
The player can buy up to 6 weapons in total. (Can be changed)

*NEW*
Weapons are now stored in the database. When the player spawn ingame, the weapons are giving to the player.

## Changelog (13-4-2017)

- [X] Removed the changes needed in player.lua. Mod is now 100% copy/paste...
- [X] Save all the weapons to the database
- [X] Weapons are given back to the player when he dies or login.
- [X] Getting weapons back from Roberto cost money. The cost is the price of the weapon/100. (Can be changed)

## Installation

1. Extract the folder and rename it to es_weashop
2. Place the folder in your resource folder
3. Add - es_weashop to your citmp-server.yml
4. Change the mysql connection in sv_weashop.lua
5. Run the sql.sql into your database
6. Restart your server
7. Have fun.

## Setup

Changing the limit of weapons : 
Open sv_weashop.lua and change the line :
	local max_number_weapons = 6

Change the cost of withdrawing the weapons :
Open sv_weashop.lua and change the line :
	local cost_ratio = 100

Kindly made by Hoegarden31
