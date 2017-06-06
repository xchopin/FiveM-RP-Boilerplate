-- Change your database credentials.
database = {
          host = "127.0.0.1",
          name = "gta5_gamemode_essential",
          username = "root",
          password = ""
        }

-- Configure the coordinates where the player gets spawned when he joins the server (temporarily disabled untill the next release).
spawnCoords = {x= 340.946, y= -1396.73, z= 32.5092}

-- Random skins
skins = {"mp_m_freemode_01"}

require "resources/essentialmode/lib/MySQL"
