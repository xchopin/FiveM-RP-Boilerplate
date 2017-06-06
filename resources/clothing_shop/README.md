# FiveM: Clothing Shops addon
> Your clothing shop addon for FiveM.


<img src=http://i.imgur.com/bB1K7ug.jpg>

## Caution: work in progress

## Requirements
- EssentialMode 2.X
- MySQL or MariaDB (_not tested_)

## Features
- Load skin on spawn/death
- Fast loading
- Buy new clothes (it will also updates in the DBMS)
- Blips on the map
- Marker in shops
- Elegant menu
- A lot of accessories
- Choice of the gender
- Legacy function (_in tribute of skin_customization_) for a compatibility with old mods like FiveM_Cops

## ToDo
- Payment
- Remove a cloth
- Setter and getter on each component
- More events for developers

## Getting Started

### 1. Clone the repository
``` bash
$ git clone https://github.com/xchopin/FiveM_ClothingShop.git
```

### 2. Import the SQL file into your DBMS
``` bash
$ mysql> ./install.sql
```

### 3. Create your settings file (and fill the fields)
``` bash
$ cp Server/settings.lua.dist settings.lua
```

### 4. Add the dependency to your .yml


## Gameplay
- In a special menu, press right or left arrow to change the texture
- Press Enter or 'A' (Xbox) to save your choice (it will save in the database)

## API
### Details about components

| Component |      Part    | Prop          | Part |
|----------|:-------------:|:-------------:|:-------------:|
| Face      |    0  | Hats | 0 |
| Mask      |    1  | Glasses | 1 |
| Hair      |    2  | Ears | 2 |
| Gloves    |    3  |
| Pants     |    4  |
| Bags      |    5  |
| Shoes     |    6  |
| Shirts    |    8  |
| Vests     |    9  |
| Jackets   |   11  |


### Server Events

#### Get the skin model of a player
``` lua
 -- Give the client'skin model (gives the value from the DB)
clothing_shop:GetSkin_server
```

#### Save the items of a player
``` lua
-- Updates the DBMS
-- @param item.collection: skin or prop or component
-- @param item.id (check the table), not required if collection == skin
-- @param item.value 
-- @param item.texture_value can be empty if collection == skin

clothing_shop:SaveItem_server({item.collection, item.id}, {values.value, values.texture_value})
```

### Client Events
``` lua
-- Change the gender, might change the name of this one lol
-- @param skin: must be "mp_m_freemode_01" or "mp_m_freemode_01"
clothing_shop:getSkin_client(skin)
``` 
``` lua
-- Set all the items on a player
-- @param items: JSON format, needs all the columns elements

clothing_shop:loadItems_client(items)
```

*More events in the next release*

_Thanks to JCPires for his help on the menu design._
