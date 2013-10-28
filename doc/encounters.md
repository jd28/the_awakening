### Encounters

# Preface
NWN Encounters

# Spawn Groups
There are 4 levels of spawn groups, their meaning is arbitrary.  Only
the `Default` spawn group must be specified.

* Default
* Level1
* Level2
* Level3

# Functions
* `Spawn`
* `Chance`
* `Random`

# Settings
All settings can be overriden by the spawn group except `resref`.

* `resref` - Must be specified.
* `delay` - Delay between creatures being spawned.
* `fallover` - Maximum number of creatures per spawn point.
* `policy` - See Policies below.
* `distance_hint` - Spawn


# Policies
There are four possible spawn point selection polcies:

* `POLICY\_NONE` - No policy, spawn point selection is furthest from
creature entering encounter.
* `POLICY\_EACH` - The spawn group is spawned at every spawn
* `POLICY\_RANDOM` - The spawn group is spawned at a random spawn
point.
* `POLICY\_SPECIFIC` - Explicitly select of spawn.  The spawn point
must be passed when calling `Spawn`.
