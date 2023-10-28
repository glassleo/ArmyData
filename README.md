# ArmyData

A simple addon that keeps track of character data for you. All data is stored in a global table [``ArmyDB``) which can be accessed by other addons like WeakAuras.

The addon also keeps track of and provides useful output for:
- Gold: ``/army``
- Currencies and some currency-like items: ``/army Timewarped Badge`` (case sensitive)
- Mythic Keystones: ``/army m+``
- Weekly Dragonflight profession knowledge: ``/army weekly``

---

### Additional Commands
- ``/army delete Name-Realm Name`` – Deletes all data for a specific character (name is case sensitive)
- ``/army audit`` – WIP audit window

---

## ``ArmyDB`` table

Each character has its own table stored as ``ArmyDB["Name-Real Name"]``

Here are some of the keys available:
- ``Name`` – Character name (example: ``Gorgina``)
- ``Realm`` – Realm name (example: ``The Sha'tar``)
- ``Faction`` – Faction (example: ``Horde``)
- ``Class`` - Class (example: ``DEMONHUNTER``)
- ``Money`` – Amount of money in copper (example: ``160432158`` representing 16,043 gold, 21 silver and 58 copper)
- ``Specialization`` – Current loot specialization (example: ``1``)
- ``Profession`` – First profession learned that is not Engineering (example: ``Jewelcrafting``)
- ``Covenant`` – Shadowlands Covenant ID (example: ``1``)
- ``Renown`` – Shadowlands Covenant Renown level (example: ``80``)
- ``KeystoneMap`` – Current M+ Map ID (example: ``245`` for Freehold)
- ``KeystoneLevel`` – Current M+ Key Level (example: ``20``)
- ``Currencies`` – Table with currency data
- ``Items`` – Table with item data
- ``RenewedProtoDrake`` – Chosen Renewed Proto-Drake scale color (example: ``2`` for blue)
- ``RenewedProtoDrakeTransformation`` – Chosen Renewed Proto-Drake transformation (example: ``1`` for no transformation)
- ``Ìmp`` – Chosen Imp color
- ``ImpStyle`` – Chosen Imp style
- ``Moonkin`` – Chsoen Moonkin Form feather color
- ``MoonkinTransformation`` – Chosen Moonkin Form full transformation
