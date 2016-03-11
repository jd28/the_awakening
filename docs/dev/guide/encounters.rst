Encounters
==========

General
-------

* Please do not prefix 'enc\_' to the resref/tag/name of the encounter.  It's unecessary and makes things harder to search for.

Spawn Groups
------------

Functions
---------

* ``Spawn``
* ``Chance``
* ``Random``

Settings
--------

All settings can be overriden by the spawn group except `tag`.

* ``tag`` - Encounter tag.  Must be specified.
* ``delay`` - Delay between creatures being spawned.
* ``fallover`` - Maximum number of creatures per spawn point.
* ``policy`` - See Policies below.
* ``distance_hint`` - Spawn point selected will be the first found with a distance greater than or equal to `distance_hint`.


Policies
--------

There are three possible spawn point selection polcies:

* ``POLICY_NONE`` - No policy, spawn point selection is furthest from creature entering encounter.
* ``POLICY_EACH`` - The spawn group is spawned at every spawn
* ``POLICY_RANDOM`` - The spawn group is spawned at a random spawn point.
