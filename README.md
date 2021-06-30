# ArmyData

A rather crude addon that simply keeps track of character information for all your characters in a global table that other addons can acess (like WeakAuras). No one except me will probably ever realistically use this.

There is a slash command to display some gold/currency data. Other than that you will need to write your own WeakAuras or addons to display the information.

Takes into account connected realms, but currnetly there is only data for the the specific realms I happen to play on.

Also assumes that you have Engineering on all characters.

## Slash command: ``/army CurrencyName``

- Currencies are in CamelCase and have any special characters omitted, for example: ``GarrisonResources``, ``EpicureansAward`` or ``CoinsOfAir``
- Displays the characters with the most amount of the given currency on that connected realm and faction
- If you don't specify a currency name, gold will be used instead

## Global table: ``ArmyDB["name-realm"]``

- ``Name`` - Character Name - Example: ``Leo``
- ``Realm`` - Realm Name - Example: ``The Sha'tar``
- ``Faction`` - Faction Name - Example: ``Horde``
- ``Class`` - Class (uppercase, in English) - Example: ``DEATHKNIGHT``
- ``Money`` - Total amount of money (in Copper) - Example: ``124578454`` (12,457 Gold, 84 Silver and 54 Copper)
- ``LootSpec`` - Current Loot Specialization - integer from ``0-4`` with ``0`` being no loot spec
- ``Profession`` - Primary profession that is not Engineering - Example: ``Alchemy``
- ``ProfessionIcon`` - Profession icon texture ID - Example: ``136240`` (Alchemy)
- Most currencies in CamelCase format as integers of current amount, for example: ``GarrisonResources``, ``EpicureansAward`` or ``CoinsOfAir``
