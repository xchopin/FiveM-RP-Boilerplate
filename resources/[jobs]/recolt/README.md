# vdk_recolt

> Resources for FiveM RP allowing user to recolt/treat/sell stuff

## Requirements

- [Essentialmode](https://forum.fivem.net/t/release-essentialmode-base/3665)
- [vdk_inventory](https://forum.fivem.net/t/release-inventory-system-v1-3/14477)
- [Job System](https://forum.fivem.net/t/release-jobs-system-v1-0-and-paycheck-v2-0/14054)

## Installation

- Download the resource here :
- Place the folder `vdk_recolt` to resources folder of FiveM
- Execute `dump.sql` file in your database (will create the tables and the constraints)
- Change your database configuration in `config.lua`
- Populate the `recolt`, `jobs` and `coordinates` tables
- Change the `recoltDistance` and `timeForRecolt` variables in `vdkrecolt.lua` like you want 

## Database explanations !

- **coordinates** : here you put the **x, y, z** coordinate of your field, your treatment place or seller, just the coordinates
- **recolt** : it's a link table between `items`, `jobs` and `coordinates`. In it you add the raw item ID, the treated item ID, the job needed to recolt (**feature not implement yet**), and the ID of the tree position of the field, treatment place and seller.

## Usage

Go to the position of your places in order **(field->treatment->seller)** and appreciate ;)

## For help

Search a minimum with your brain and post **CLEAR and DOCUMENTED** question please ;)

## Notes

It's only my second script so the valuables proposals are always welcome ;)