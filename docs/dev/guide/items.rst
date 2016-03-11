.. highlight:: lua

Items
=====

There are two steps that you need to follow to create an item drop for players.  First you need to create the item in the toolset, then create a script for them item generator.

.. warning::

  **Do not** create items and add a bunch of item properties.

If you're creating an item for an NPC, see the Creatures section of the developer guide.

Design
------

* Items need not be the same was what the creature who drops them uses.
* Items should be level appropriate and should not attempt to 'one-up' other items in the same level range.
* Bosses should drop the best gear.
* Items should be designed with some randomization in mind.  A player should be able to go through the same area and get items of varying quality, such that they have an impetus to go back and search for a better version of the same item.
* Items should leave room for potential upgrades.
* The quality of an item should be proportional to its rarity.

Creating an Item
----------------

1. Create them item.  The tag and resref should be identical and should follow our resref naming scheme.
2. Design the item's appearance.
3. Give it whatever name you want.
4. Create an item generator script named ``<resref>.lua``.  See below for how to do that.

Adding Item Properties
----------------------

The item generator loads a table from a text file and creates the item on demand.  This system uses Dynamo_ so the functions listed there can be used in the ``properties`` list.

An example:

.. code::

  resref = "fab_druid_helm"

  -- Properties
  properties = {
    ArmorClass(6),
    AbilityScore(ABILITY_WISDOM, 4),
    AbilityScore(ABILITY_STRENGTH, 3),
    AbilityScore(ABILITY_CHARISMA, 4),
    DamageImmunity(DAMAGE_INDEX_DIVINE, 12),
    DamageImmunity(DAMAGE_INDEX_MAGICAL, 10),
    DamageImmunity(DAMAGE_INDEX_NEGATIVE, 10),
    DamageImmunity(DAMAGE_INDEX_POSITIVE, 10),
    BonusLevelSpell(CLASS_TYPE_DRUID, 6),
    BonusLevelSpell(CLASS_TYPE_DRUID, 7),
    BonusLevelSpell(CLASS_TYPE_DRUID, 7),
    BonusLevelSpell(CLASS_TYPE_DRUID, 8),
    BonusLevelSpell(CLASS_TYPE_DRUID, 8),
    BonusLevelSpell(CLASS_TYPE_DRUID, 9),
    BonusLevelSpell(CLASS_TYPE_DRUID, 9),

    SkillModifier(SKILL_CRAFT_ARMOR, 4),
    SkillModifier(SKILL_CRAFT_WEAPON, 4),
    SkillModifier(SKILL_CONCENTRATION, 6),
    SkillModifier(SKILL_ANIMAL_EMPATHY, 6),
    SkillModifier(SKILL_SPELLCRAFT, 6),
    Regeneration(6),
    TrueSeeing(),
    ImmunityMisc(IMMUNITY_TYPE_MIND_SPELLS),
    SavingThrowVersus(SAVING_THROW_VS_ALL, 3),
  }

You can see all items_ created so far.

Now if you want to create your own you need to familiarize yourself with what `item property functions`_ are available.  The server also has some custom item property creation functions which are yet to be documented formally. Also you need to familiarize yourself with the constants that are available in the developer guide.

When an item property functions takes a constant parameter, look it up in the constant document and use which ever constant you want.  If the function parameter is a number you can also use the ``Range`` function.

Example: if you wanted change the above item to add 3-6 points of
Animal Empathy.  You could simply change this line:

.. code::

    SkillModifier(SKILL_ANIMAL_EMPATHY, 6),

to this:

.. code::

    SkillModifier(SKILL_ANIMAL_EMPATHY, Range(3, 6)),

Then any time this item is generated it will randomly have between 3-6
points of Animal Empathy

A Dynamo example: imagine you want to change the item above to have a 1%
chance that its positive damage immunity is 12% instead of 10%.  All
you'd need to do is change this line:

.. code::

    DamageImmunity(DAMAGE_INDEX_POSITIVE, 10),

to this:

.. code::

    Percent {
       1, DamageImmunity(DAMAGE_INDEX_POSITIVE, 12),
       99, DamageImmunity(DAMAGE_INDEX_POSITIVE, 10),
    }

.. _Dynamo: ../systems/dynamo
.. _items: https://github.com/jd28/the_awakening/tree/master/scripts/lua/items
.. _item property functions: http://solstice.readthedocs.org/en/latest/itemprop.html