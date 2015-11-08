Creatures
=========

The following document explains how to create creatures for the awakening.

Toolset
-------

* Creatures that don't use parts based appearances should not have any other
  items than creature skins, creature weapons, or weapons (if they show when equipped).
* If you use the level up wizard please make sure that the creature
  does not have any unnecessary feats/spells.
* Creatures should not be designed as player characters.  They should be designed only to
  meet the challange requirements that you set.
* The items that you do give them should have NO item properties, excepting weapons which
  may have non-damage item properties.
* Naming conventions: Only use first name, never last.  Do not add any non characters the the
  creature's name such the palette will no longer be in alphabetical order.

The palette orginization is as follows:

* Custom:

  * Special:

    * Custom 1 : Hostiles A-F
    * Custom 2 : Hostiles G-L
    * Custom 3 : Hostiles M-R
    * Custom 4 : Hostiles S-Z
    * Custom 5 : Commoners/Defenders/Merchants/Non-hostiles

  * Tutorial: Summons

There are no circumstances under which these should be different.

Dynamo
------

Creature Table
~~~~~~~~~~~~~~

The following fields are mandatory.

resref
  The creature's resref as created in the toolset.

The following fields are optional.

* **appearance** - An appearances.2da constant, or a Dynamo function that contains
  appearances.2da constants.

Instance Tables
~~~~~~~~~~~~~~~

The following fields are optional.

* **effects** - A list of effects to be applied on spawn.
* **hp** - Maximum hitpoint override.