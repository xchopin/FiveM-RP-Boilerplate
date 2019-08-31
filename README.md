# FiveM Roleplay Boilerplate

### This is a boilerplate for FiveM Roleplay Server, it might help you to save a lot of time by skipping the development of the same boring stuff. 

<img src='http://image.noelshack.com/fichiers/2017/23/1496767575-previewgta-1.jpg' style='width: 50%; height:auto' alt='preview1'/>

> Warning: This project is not maintained anymore and uses the legacy version of FiveM 

## Requirements
- MySQL or MariaDB
- Windows or Linux Server

## What's included?
- ID Card
- Dirty money (automatic on "illegal recolts", money laundering is also included)
- Admin tools
- _Illegal business (drugs)_
- Phone system (Texts, Contacts, Emergency call, Taxi call)
- Personal menu
- LS Customs
- Driving and weapon license
- Emotes
- Inventory (35 items)
- Foodshops
- Clothing shops
- Gun shops
- Vehicle shops
- Ranks for LSPD
- Jobs (garage + outfit markers)
- Salary
- Bank Account
- Loading Screen
- Whitelist
- Buildings for some jobs (Government, Hospital)
- Transporter
- Realistic earshot (range of 7 meters) 
- Gas Stations
- HUD
- Car health and speed
- Custom cars (Audi, Police, Ferrari, ...)


## How to install it?
### 1. Import `install.sql` into your DBMS (e.g. MySQL)
### 2. Change the credentials of server files
In order to enable all the plugins you have to edit the `server.lua` files and sometimes `settings.lua` in each packages present in the `resources/`directory. 
That means you have to fill the database name, login and password fields to allow a connection to the database. 

#### Example with [resources/jobs/police](https://github.com/xchopin/FiveM-RP-Boilerplate/blob/master/resources/%5Bjobs%5D/police)
In this package you have a file named [server.lua](https://github.com/xchopin/FiveM-RP-Boilerplate/blob/master/resources/%5Bjobs%5D/police/server.lua), at the line 2 you have to add the database credentials.


## Usage (in game)
`K` : Open your personnal menu
`X` : Hands up (you can move)
`N` : Talk
`M` : Vehicle menu

## Jobs
> Whitelisted means you have to add manually the person (from the SQL Database or from admin commands in game)
- Jobless (what a job...)
- Taxi
- Lumberjack
- Miner
- Winegrower
- Trucker
- Paramedics (named CHU) - Whitelisted
- LSPD - Whitelisted
- CIA (named GSPR) - Whitelisted
- Governor - Whitelisted
- Lawyer - Whitelisted
- Judge - Whitelisted
- Ministers - Whitelisted

## Addons used (under license)
 - SimpleBanking
 - Prefecture
 - gb_needs
 - freeroam
 - Paycheck
 - JobSystem
 - EssentialMode
 - es_admin
 - vehshop
 - LSCustoms
 - clothing_shop
 - FiveM-Cops
 - vdk_recolt
 - vdk_call
 - warp
 - paramedics
 - weashop
 - car skins
 
