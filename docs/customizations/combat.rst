Combat
======

The core change to the combat system has been to remove d20 dice rolls.  That is, rather than ``attacker attribute + 1d20`` vs ``target attribute``, ``attacker attribute`` vs ``target attribute`` are compared directly and the difference between them (and perhaps some other factors) determines the outcome.  As such, this isn't really a radical departure from, or a criticism of, DnD rules.

To give an example of the kind of situation this system hopes to avoid, imagine two characters: a strength based PC with 60AC and a dexterity based PC with 80AC.  For an NPC to have a 10% chance of hitting 80AC it would need a 61AB, which means the 60AC PC will be pulverized.  One can imagine other circumstances where a 20+ point gap in attributes between characters presents two radically different levels of difficulty.

It would be fair to ask, why not just make sure there isn't a 20+ point gap rather than change the rules?  It's true that some of the changes and decisions we've made (Legendary Levels, class changes, etc) have compounded the problem.  Honestly, I just think it's too constraining.

If you're confused about some of the following changes: don't worry.  The underlying structure of DnD remains the same.  There is still an attack bonus, saves, etc and the higher they are the more effective they will likely be.

-------------------------------------------------------------------------------

Attack Roll
-----------

The attack roll has essentially be replaced: it no longer uses a 1d20 die roll, there is no concept of fail on one or success on 20.

In practice it's not significantly different than PnP attack roll, in that the higher your AC is the less likely you are to be hit and the higher your AB is the more likely it is that you will hit.

The major difference is the inclusion of a level difference parameter, which gives a better/worse chance of hitting depending on the attacker's level vs the target's level.

Variables
~~~~~~~~~

  ab
    Attack Bonus
  ac
    Armor Class
  al
    Attacker Level
  tl
    Target Level
  hc
    Hit Chance

Formula
~~~~~~~

.. code::

  hc = 80 + ((ab - ac) / 1.5) + ((al - tl) * 1.5)

.. note::

  This formula is subject to change.

-------------------------------------------------------------------------------

Critical Hits
-------------

Critical hit chance and damage have been converted to percentage based systems so that class, weapon, item properties, and potentially spells/class abilities can modify them.

-------------------------------------------------------------------------------

Damage Reduction
----------------

Immunity
  As default.

Resistance
  Resists now stack with one another as well as the damage resistance feats.

Soak
  In addition to soak enhancement soaks now have a material type coinciding with weapon materials.  E.g. ``Damage Reduction (Mithril) 30/+7`` would give the 30/+7 soak versus magical and normal weapons, the enhancement only factors when the material is equal or greater.  So to completely pierce it would require a +7 Mithril weapon.

  Soaks can stack with one another.  In determining the amount soaked all damage reduction effects, item properties, and class traits are added together when the material type and enhancement bonus of the attacker's weapon greater than or equal to the soak material type and enhancement bonus.

  In the case of innate soaks, i.e. Dwarven Defender and Barbarian, these are applicable to any and all weapons.

-------------------------------------------------------------------------------

Saves
-----

The basic structure of saves will be determined by ``Difficult Class`` vs ``Saving Throw``.  The meaning of the check will depend on the context in which it is used.  E,g. in a save versus death scenario there might be a base 5% chance of death and a formula like ``5% + (DC-Save) * 1%``.

-------------------------------------------------------------------------------

Spells
------

A number of spells will be changed to reflect the new save system.

Spell Resistance
~~~~~~~~~~~~~~~~

Feedback
--------

Some combat feedback messages have been modified to be a bit more compact.  This means log readers will like not work.