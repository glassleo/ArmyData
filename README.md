# ArmyData

A simple addon that keeps track of character data for you. All data is stored in a global table (``ArmyDB``) which can be accessed by other addons like WeakAuras.

The addon also keeps track of and provides useful output for:
- Gold: ``/army``
- Currencies and some currency-like items: ``/army Timewarped Badge`` (case sensitive)
- Mythic Keystones: ``/army m+``
- Weekly Dragonflight profession knowledge: ``/army weekly``

Almost all relevant currencies are stored. In addition the following items are also stored:
- Primal Spirit, Blood of Sargeras, Expulsom, Hydrocore, Titalcore, Breath of Bwonsamdi, Sanguicell
- Coin of Ancestry, Trial of Style Token
- Mark of Honor
- Polished Pet Charm, Shiny Pet Charm
- Genesis Mote
- Sandworn Relic
- Dreamsurge Coalescence

---

### Screenshots
![Screenshot 2023-10-28 at 16 53 35](https://github.com/glassleo/ArmyData/assets/9146240/88f31a90-061e-476e-8320-990ac11e80a2)
![Screenshot 2023-10-28 at 16 58 16](https://github.com/glassleo/ArmyData/assets/9146240/30ae44bc-074b-489c-809b-a9ab12182a56)
![Screenshot 2023-10-28 at 17 01 05](https://github.com/glassleo/ArmyData/assets/9146240/81235e44-d28a-4b4a-a35b-0c66e67e9afb)

---

### Additional Commands
- ``/army weeklyreset``– Wipes all saved Mythic Keystone data, which can be useful after the weekly reset if you don't want to relog all your characters
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
- ``Imp`` – Chosen Imp color
- ``ImpStyle`` – Chosen Imp style
- ``Moonkin`` – Chsoen Moonkin Form feather color
- ``MoonkinTransformation`` – Chosen Moonkin Form full transformation
