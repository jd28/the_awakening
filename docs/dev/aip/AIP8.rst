AIP8 - Musing on the attack roll
================================

:author: leo
:date: 2015-01-03
:status: Exploration

**This is just musing, not anything beyond that.**

In an ideal world (IMHO) NWN would not have a pseudo-turn based system
but would rather mimic those features with attack speed and a global
cooldown.  Given that those things are not possible the following
ideas are somewhat shoehorned in.

### Goals

So, what are some of the goals?

* The system should be simple, easily calculatable, and efficiently implementable.
* Players should be able to hit much more often than not.
* There shouldn't be massive outliers that break the system or are worthless.

### Offense

#### Attack Progression

So to begin, I would leave the classes in their respective attack
progression tiers, but instead of Base Attack Bonus would use a base
chance to hit when attacker level equals defender level on the first
attack.

+------+-----------------+---------------------------+
| Tier | Base Hit Chance | Classes                   |
+======+=================+===========================+
|  1   | 90%             | Fighter, WM, DwD, DD, ... |
+------+-----------------+---------------------------+
|  2   | 75%             | Bard, Monk, Cleric, ...   |
+------+-----------------+---------------------------+
|  3   | 60%             | Wizard, Sorcerer, PM...   |
+------+-----------------+---------------------------+

#### Base Hit Chance

The final Base Hit Chance would be the average of all levels.  Example:

.. code::

  F 30, WM 13, R 17:
  (30 * 90%) + (13 * 90%) + (17 * 75) / 60 = 85.75%

#### Modified Hit Chance

I've chosen for the first pass at this to not included Ability Scores as a modifier.  The
reason being that they already modify and shape the nature of your character.  You might
wonder if that meant you could have a constitution based fighter/wm and
the answer to that would be sure, if you want to give up the benefits of other ability
scores.

**Modifiers**

* Class (i.e. WM, AA)
  * These would have to be somewhat re-gigged potential, but lets say +2% per attack bonus.
* Feats
  * +2% for WF, +4% for EWF
* Attack/Enhancement Bonus
  * +1% per to the 20% cap.
* Level Differential
  * This would then be modified by 2% per the level differential between attacker and defender.
* Modes
  * See the Adjuncts section below.

Modified Chance = Base Chance - ((Defender Level - Attacker Level) * 2%) + AB Bonus +
Class Bonus + Feat Bonus.

Using the example above with a mithril weapon, with EWF.  Example:

.. code::

  85.75% + 8% (AB) + 6% (Feat) + 6% (Class) = 105.75%

Note that the Modified Chance can go above 100%, even tho you can't hit more than 100% of
the time it still affects your following attacks.

#### Iteration penalty.

Didn't think too much about this so I'll just throw out these:

* Non-monk: -10%
* Monk: -5%

### Defense

#### Armor Class

Rather than have armor class be compared to attack bonus.  Armor Class would determine
defensive bonuses dependent on the type of armor worn.

+-------------+----------------------------------+
| Armor       | Benefit                          |
+=============+==================================+
| Light/Robes | AC / X % concealment.            |
+-------------+----------------------------------+
| Heavy       | AC / Y damage resistance.        |
+-------------+----------------------------------+
| Medium      | A combination of Light and Heavy |
+-------------+----------------------------------+

Notes:
* These would stack with effects.
* This might require spell/class changes.
* They would be capped.
* Unlike AB, there would be no obvious means of dealing with AC surpluses.

### Adjuncts

#### Combat Modes.

I believe in normal PnP, a character could chose to how these were applied given
circumstances that were faced.

Imagine a system where you could decided how much AB you gave up for a corresponding
benefit and a corresponding chat command to set them, i.e. `!powerattack 10`

* Power Attack: -1% per +1 Damage, Cap -10% / +10 Damage
* Improved Power Attack: Same as above, but no cap.
* Expertise: -1% per +1 AC, Cap -10% / +10 AC
* Improved Expertise: Same as above, but no cap.
* Dirty Fighting: -1% per 2% Sneak/Death Bonus, Cap: ???

#### Monsters

What about monsters?  Well... monsters are irrelevant, no matter what system is in place
-- as long as it's balanced -- they can be tweaked to do whatever is desired of them.