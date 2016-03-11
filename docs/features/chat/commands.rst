Chat Commands
=============

Commands shown in purple can use via chat. They can be typed into any chat channel (party, talk, shout, etc.) and have the same effect in all of them. They are case insensitive.

Commands shown in green must either be sent via tell or targeted with the command targeter or the Feat Player Tool 1.*

!afk
-------------
**Usage:** ``afk [message]``

**Description:** Sets your status to afk and also allows you to set an optional message to inform other players when you might be back.

!unafk
-------------
**Usage:** ``unafk``

**Description:** Removes your afk status.

!anon
-------------
**Usage:** ``anon``

**Description:** Hides your class, experience, area, and party member information from other players using the !playerinfo command.

!unanon
-------------
**Usage:** ``unanon``

**Description:** Removes your anonymous status, allowing other players to see your class, experience, area, and party member information.

!combat
-------------
**Usage:** ``!combat [option]``

**Options:**

* ``offense``
* ``modifiers``
* ``situations``
* ``defense``
* ``equips``

**Description:** Displays relevant information in combat window. Used mostly for debugging info.

!critical
-------------
**Usage:** ``!critical [option]``

**Options:**

* ``1`` - Critical Threat: 18-20, Critical Multiplier: x2
* ``2`` - Critical Threat: 19-20, Critical Multiplier: x3
* ``3`` - Critical Threat: 20, Critical Multiplier: x4

**Description:** Modifies your weapons base critical hit properties.  The command will first look for a weapon in your right hand, if none it will attempt to apply to your gaunts.

* Notes:
  * **Transferring the weapon will reset it to its base critical hit properties!**
  * This command is purchased from the Wandering Spirit.

!d
-------------
**Usage:** ``!d [sides]`` or ``!d [dice] [sides]``

**Description:** Rolls dice.

**Example:** ``!d 100`` rolls a 1d100.  ``!d 2 100`` rolls 2d100.

!debug
-------------
**Usage:** ``!debug [option]``

**Options:**

* ``ab`` - Debug attack bonus
* ``abilities`` - Debug ability scores.
* ``ac`` - Debug armor class.
* ``resist`` - Debug damage resistance
* ``skills`` - Debug skills.
* ``soak`` - Debug damage reduction.
* ``immunities`` - Debug

**Description:** Prints some useful information about your character to the combat log.

!delete
-------
**Usage:** ``!delete`` and ``!delete [cdkey]``

**Description:** Deletes the target character. It will ask for confirmation by repetition of the command combined with the target's public cd key, as shown in the !playerinfo command.  Upon deletion a portion of your characters XP will be deposited in your XP Bank.

!eleswarm
---------
**Usage:** ``eleswarm [elemental damage]``

**Description:** Changes the damage type done by the elemental swarm spell.  Where [elemental damage] is acid, cold, fire, elec, or sonic.

!follow
-------------
**Usage:** ``!follow``

**Description:** Player will follow the targeted character

!help
-----
**Usage:** ``!help``

**Description:** Lists the usable chat commands plus explanation


!ignore
-------
**Usage**: ``!ignore``

**Description:** You will not receive tells from the player you send this command to.


!unignore
---------
**Usage**: ``!unignore``

**Description:** Removes ignore status.


!lfg
----
**Usage:** ``!lfg``

**Description:** Announces that you are looking for a group in shout.

!list
-----
**Usage:** ``!list [command]``

**Commands:**

* ``emotes`` - Lists the usable chat emotes.
* ``commands`` - Lists the usable chat commands.  NOTE: Most likely this list is out of date.
* ``ignored`` - Lists the players you have chosen to ignore.
* ``modes`` - List combat modes usable with the !mode command.

**Description:** Lists information.

!mode
-------------
**Usage:** ``!mode [mode]``

**Modes:**

* ``expertise``
* ``impexpertise``
* ``flurry``
* ``rapidshot``
* ``powerattack``
* ``imppowerattack``
* ``defcast``
* ``none`` - Turns off any of the above combat modes.
* ``xpbank [on|off]`` - Turns xpbank mode on or off.  If you have XP in your bank it allows you to double the XP received from monsters.  Half from the monster, half from your bank.

!opt
-------------
**Usage:** ``!opt [option]``

**Options:**

* ``dragshape [kin|drag]`` - Sets your preferred dragon shape polymorph to a dragon or dragonkin depending on your personal preference.
* ``enhanced [basic|full]`` - Enables basic or full use of PAKs, required for new areas. Only needs to be set once.  The basic setting requires only the TLK and the ta_top_v01.hak.
* ``helm [hide|show]`` - Allows you to hide or show your helmet while equipped in the helmet slot.  Note this works poorly with polymorphing characters.
* ``noblock [on|off]`` - Allows you to not block on other creatures.  I.e. you can pass through them and they through you.
* ``appear off`` - Allows you to turn off the Dragon Disciple or PM appearance change.
* ``anims off`` - Allows you to turn off the animations from fighting styles.

!partyfix
-------------
**Usage:** ``!partyfix``

**Description:** Designed to help ease the buggy NWN party bar.  Use this command and you will be removed from your party and readded in 1 second.

!partyjoin
-------------
**Usage:** ``!partyjoin``

**Description:** You join the party of whoever you target.  If you're already in a party you'll be dropped from it.

!partyroll
----------
**Usage:** ``!partyroll``

**Description:** Does an arranged party loot split roll, if the command giver is the party leade

!playerinfo
-----------
**Usage:**

``!playerinfo``

**Description:** Lists the target's Playername, CD Key, Classes, Experience, Experience Needed for Next Level, Area, and Partymembers. If used on yourself it also shows Deity, Subrace, Gold, and Gold + Inventory Value. You may hide all but your Playername and CD Key from other players by using the **!anon** command.

!playerlist
-----------
**Usage:** ``!playerlist``

**Description:** Lists everyone currently on the server and their locatio

!pmshape
--------
**Usage:** ``!pmshape [number]``

**Description:** Change what shape your PM shifts into with the undead feats.  Where <number> is 1 for spectre, 2 for vampire, 3 for risen lord, or 4 for dracolich.

!reequip
--------
**Usage:** ``!reequip``

**Description:** Unequips and reequips all items unless they are undroppable. This to help shifter
who have died while shifted. If you are in combat you won't be able to reequip your armor.

!relog
------
**Usage:** ``!relog``

**Description:** Allows you to quickly join the server at the character screen.  After entering the command a dialog box will show, simply click the Join button and leave the password blank.

!resetdelay
-----------
**Usage:** ``!resetdelay``

**Description:** Votes to delay a reset for 30 minutes.  Only usable when there is 15 minutes or: le
to reset.  Three players must vote.

!qb list
--------
**Usage:**

**Description:**


!qb save
--------
**Usage:** ``qb save [slot] [name] [bar]``

**Description:** Saves one of your quickbars into the specified slot (which must be a
number from 0 to 9). You must specify 1, 2, or 3 for the bar parameter; 1 is the normal quickbar, 2 is the Shift quickbar, and 3 is the Ctrl quickbar.

!qb
----
**Usage:** ``qb [slot]``

**Description:** Restores the specified quickbar. At this time, only spell slots can be restored. In
the future, feats and some other abilities will be restorable as well. It is unlikely item slots can be restored due to technical limitations.

!sb
---
**Usage:**

**Description:** Allows Wizards, Clerics, and Druids to save and restore (the current limit is 3 pe
character, regardless of class) and modify spell books.

``!sb[class:w,c,d] save [name] [slot:1-3]``, where w = wizard, c = cleric, d = druid. Saves your spellbook,  Example: ``!sbw save Undead 1`` entered into the chat bar would save the current wizard spell book under then name "Undead" in spell book slot 1.

``!sb [slot:1-3]`` = Loads one of your spell books Example: ``!sb 1`` would load the spell book saved as "Undead" above.

``!sb list`` = Lists your currently saved spell books.

``!sb[class:w,c,d] empty`` = Removes all spells from your current spell book.  Example: ``!sbw empty`` would remove all memorized spells from your current wizard spell book.

``!sb[class:w,c,d] fill`` = Fills the remaining slots in your spellbook with the last spell selected at each level. Example: ``!sbc fill`` would fill your current cleric spell book with the last memorized spell at each level, so if you have 1 Heal spell memorized in 6th level spells and the rest of the slots were empty, ``!sbc fill`` would fill the rest of the 6th level slots with Heal spells.

!setname
--------
**Usage:** ``!setname [name]``

* Example: To rename item Longsword to Sam's Sword: **!setname Sam's Sword**.
* Allows the speaker to rename one of their items. The command is case-sensitive.

!skillcheck
-------------
* Allows players to roll checks against a specific skill and DC. The command format is !skillcheck (skill#) (DC#) . Example: A DC 20 Discipline Check would be spoken as follows: !skillcheck 3 20 . The result will be displayed in floating text above the player. A list of skill numbers can be called up using the !skillslist command.  NOTE: This might not include all modifiers.

* !skillslist
* Sends a list of the skills and matching skill numbers to the players combat log, for easy reference when using the !skillcheck command to do skill checks.

!summon
-------
**Usage:** ``!summon [command]``

**Commands:**

* ``offense`` - Summon will only do offensive actions.
* ``defense`` - Summon will only do defensive actions.
* ``spells [off|on]`` - Summon should use magic/spells?
* ``clear`` - Clears all settings.
* ``state`` - Sends your summons current settings to the combat log.

**Description:** Modify the AI behavior of your summon.

!time2reset
-----------

**Description:** Sends the time until the next reset.

!wallet
-------
**Usage:** ``!wallet [command]``

**Commands:**

* ``balance`` - Get your bank balance
* ``withdraw [amount]`` - Withdraws some amount of gold.
* ``deposit [amount]`` - Deposits some amount of gold.

**Description:** Access your gold from anywhere.

!wb
---
**Usage:** ``!wb[color]``

**Colors:**

* ``ac`` - Changes weapon visual to acid.
* ``co`` - Changes weapon visual to cold.
* ``el`` - Changes weapon visual to electric.
* ``ev`` - Changes weapon visual to evil.
* ``fi`` - Changes weapon visual to fire.
* ``ho`` - Changes weapon visual to holy.
* ``so`` - Changes weapon visual to sonic.
* ``none`` - Removes weapon visual.

!xpbank
-------

**Description:** Allows players to use their XP Banks. To see how many experience points are in your bank use ``!xpbank``. To withdraw XP use ``!xpbank withdraw [amount]``, e.g. ``!xpbank withdraw 1000`` would take 1000XP from your bank and give it to your current character. XP Banks are shared among all characters under the same player login. Currently the only way to deposit is by deleting a character.

(* Original Version Taken from NWVault posting, original author: FunkySwerve)
