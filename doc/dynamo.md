# What is Dynamo?

Dynamo is a system for creating a tree of potential outcomes in a variety
of scenarios, namely, encounters, item generation, loot spawning.  The
system is designed such that outcomes can be arbitrarily composed.

## Outcomes
An outcome is either a function from the list below or a value
dependent on the system using Dynamo.  In the encounter system the
outcome value would be an spawn or a list of spawns, in the item
generator an item property or a list of item properties, etc.

## Levels
Dynamo allows the creation of multiple levels of outcomes.  Currently
it supports upto 4 levels: Default, Level1, Level2, Level3.  The
meaning of these are abitrary and are dependent on the particular
system that is using them.  For example, in the encounter system the
different levels might indicate spawns for larger party sizes.

## Functions
Most of the following functions are themselves outcomes.  And so can
be composed together.

### Chance
A % chance that an outcome occurs.

Syntax:
```
Chance(integer, outcome)
```

Example: An item that had a 30% chance of granting +6 to strength.
```lua
Chance(30, AbilityScore(ABILITY_STRENGTH, 6))
```

### Rotate
Rotates through a list of outcomes in turn.

Example: An encounter which will spawn a drow matron, then a drow
weaponmaster in turn.
```lua
Rotate { Spawn("pl_drow_h1_matro"),
         Spawn("pl_drow_h4_wm") }
```

### Every
A series of integer-outcome pairs.  The count resets after the largest integer in the list of pairs is reached.

Syntax:
```
Every { integer, outcome, ...}
```

Example: Every 4th time the encounter is triggered a drow matron will spawn.
```
Every { 4, Spawn("pl_drow_h1_matro") }
```
----

### If
A series of function-outcome pairs.  The first pair is the if clause
and the rest are elseif clauses.  The first function that returns true will result in an outcome.  There is no final else clause, in
order to simulate an else clause nest the `If` in an `Or` function.  The argument passed to the function is dependent on the particular system.  For example, the encounter system might
pass in the object that caused the encounter to trigger.

Syntax:
```
If { function, outcome, ... }
```

Example: Say an item is being generated for a particular player.  We have a function that returns true if the player is greater than level 50 and one that returns true if the player is greater than 40th level.  If the first pair is true the item will have death magic immunity or if the second is true the item will have immunity to knockdown.
```lua
If { level_gt_50, ImmunityMisc(IMMUNITY_TYPE_DEATH),
     level_gt_40, ImmunityMisc(IMMUNITY_TYPE_KNOCKDOWN)
```

----

### Random
A list of outcomes that will be selected at random and evenly weighted.

Syntax:
```
Random(outcome, ...)
```

Example: Randomly spawn a drow matron OR a drow weaponmaster.
```lua
Random { Spawn("pl_drow_h1_matro"),
         Spawn("pl_drow_h4_wm") }
```

----

### Percent
A list of integer-outcome pairs.  The integers when summed must
equal 100.

Example: An encounter in which there is a 10% chance a drow matron
will spawn, a 60% chance that a drow matron and a drow weaponmaster
will spawn, and a 30% chance that only a drow weaponmaster will spawn.
```lua
Percent {
   10, Spawn("pl_drow_h1_matro"),
   60, { Spawn("pl_drow_h1_matro")
         Spawn("pl_drow_h4_wm") },
   30, Spawn("pl_drow_h4_wm")
}
```

----

## Or
A list of potential outcomes of which the first successful will be
selected.  Thus this is only valuable when used to compose functions
that potentially won't produce a value.  Note that the order matters
`Or` will go through the list of outcomes until it finds one that
succeeds.

Example: Every 4 times the encounter is triggered a drow matron will
spawn, all other times the encounter is triggered a drow weaponmaster
will spawn.  If the order of these were reversed a drow weaponmaster
would _always_ spawn.
```lua
Or {
    Every {
        4, Spawn("pl_drow_h1_matro")
    },
    Spawn("pl_drow_h4_wm"),
}
```

----

## Range
A function that creates a range of potential values which can be
substituted for an other integer value.

Syntax:
```
Range(integer, integer)
```

Example: Add +3-6 strength to an item.
```lua
AbilityScore(ABILITY_STRENGTH, Range(3, 6))
```
----
