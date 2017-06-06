# es_freeroam v0.1.3
<a href="https://discord.gg/eNJraMf"><img alt="Discord Status" src="https://discordapp.com/api/guilds/285462938691567627/widget.png"></a>

es_freeroam is a FiveM game mode with a money system.  
The player can receive jobs, survivals, buy buildings, drugs and many more.

 **Note:
This project brings developers together to work on a script that can be used for different types of servers.  
Have some respect for the people that contribute to this project and don't just copy/paste our time and work that we put in this project, instead [contribute](CONTRIBUTING.MD).**

## Changelog
You can find our changelog [here](CHANGELOG.md)

## Requirements
- [Essentialmode](https://github.com/kanersps/fivem-essentialmode)

## Installation
1. [Download](https://github.com/FiveM-Scripts/es_freeroam/archive/master.zip)
2. Extract the folder and rename it to es_freeroam
3. Copy it to your resources folder
4. Change **resource_type 'map' { gameTypes = { fivem = true } }**   
to    
**resource_type 'map' { gameTypes = { es_freeroam = true } }**  
in your fivem-map-skater or fivem-map-hipster resource.lua file.
5. Add - es_freeroam to your AutoStartResources in citmp-server.yml
6. Open **resources/es_freeroam/config.lua** and change your database settings.
7. Add a new column to your users table personalvehicle VARCHAR(60)
8. Restart your server

## Upgrade
Since the last upgrade we integrated the vehicle shop directly in es_freeroam.   
For that reason you need to remove es_vehshop from your citmp-server.yml.   
After that Open **resources/es_freeroam/config.lua** and change your database settings.   

## Contribute
if you are a developer and  would like to contribute any help is welcome!   
The contribution guide can be found [here](CONTRIBUTING.MD).

## Disclaimer
- Everything submitted to the repository must be in source.That meaning any soft of obfuscated files, binary files, passworded files, and/or encrypted files will immediately removed (unless the file is a representation of the latest compiled **compatible AND working version** of which this file must only be binary source and include a virustotal scan).
- DO NOT RENAME a resource. Retain the authenticity of it. Everything is designed the way it is for a reason. Do not go behind someone else and redo what someone took the time and effort to do to make everything work.
- All contributions you make on any of FiveM-Scripts repositories remain your intellectual property, but you hereby do not have any legal rights to take down, or pursue legally/illegaly any individual, group, company, corporation whether it is a public or private entity. You understand that and agree to open sourcing your contribution to contribute to the FiveM community to learn.
- Contributions are made to this repository as a goodness of heart and a record kept of the contributor's contributions history for their work.
- Violating any of the above hereby informs you that you will be removed from this community and branded as a leech.

