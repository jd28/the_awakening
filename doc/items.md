### How to make items for The Awakening.

There are two ways to go about this: the toolset and the item
generator.

#### Toolset

First you'll need all the haks and the developer module.  From there
it's exactly the same as default NWN toolset item creation.  However,
a number of item properties has (TA) appended, please **always** use
these if they are available for the type you'd like to add.

#### Item Generator

The item generator loads a table from a text file and creates the item
on demand.  This system uses
[Dynamo](https://github.com/jd28/the_awakening/blob/master/doc/dynamo.md),
so the functions listed there can be used in the `properties` list.

An example:

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

You can see all items created so far
[here](https://github.com/jd28/the_awakening/tree/master/scripts/lua/items).

Now if you want to create your own you need to familiarize yourself
with what item property functions are available.  They can be found
[here](http://jd28.github.io/Solstice/modules/itemprop.html#Creation_Functions).
The server also has some custom item property creation functions which
are yet to be documented formally.
Also you need to familiarize yourself with the constants that are
available [here](https://github.com/jd28/the_awakening/blob/develop/doc/Constants.md).

When an item property functions takes a constant parameter, look it up
in the constant document and use which ever constant you want.  If the
function parameter is a number you can also use the `Range` function.
Example: if you wanted change the above item to add 3-6 points of
Animal Empathy.  You could simply change this line:

    SkillModifier(SKILL_ANIMAL_EMPATHY, 6),

to this:

    SkillModifier(SKILL_ANIMAL_EMPATHY, Range(3, 6)),

Then any time this item is generated it will randomly have between 3-6
points of Animal Empathy

A Dynamo example: imagine you want to change the item above to have a 1%
chance that its positive damage immunity is 12% instead of 10%.  All
you'd need to do is change this line:

    DamageImmunity(DAMAGE_INDEX_POSITIVE, 10),

to this:

    Percent {
       1, DamageImmunity(DAMAGE_INDEX_POSITIVE, 12),
       99, DamageImmunity(DAMAGE_INDEX_POSITIVE, 10),
    }
