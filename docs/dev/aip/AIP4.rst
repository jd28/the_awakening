AIP4 - Change critical hit multiplier/threat to % based system
==============================================================

:author: leo
:date: 2015-01-06
:status: Implemented

Rationale
---------

The critical hit multiplier system is very limited in that it can only increase critical hit damage by 100% per multiplier.  Switching to a % based system directly allows more flexibility and is significantly faster since it does not have to re-roll for every multiplier.  It would also allow for the addition of Item Properties and Effects that could increase/decrease critical hit damage bonuses.

The same is true of critical hit threats.  Each increase in critical hit threat range is a 5% increase in DND rules, with a minimum of 0 and a maximum of 100%.

**Stated Goals:**

* No one loses any critical hit damage output.

**Critical Hit Percentages Conversion Table**

+------------+-----------------------------+
| Multiplier | Critical Hit % Damage Bonus |
+============+=============================+
|    x1      |        100%                 |
+------------+-----------------------------+
|    x2      |        200%                 |
+------------+-----------------------------+
|    x3      |        300%                 |
+------------+-----------------------------+
|    x4      |        400%                 |
+------------+-----------------------------+
|    x5      |        500%                 |
+------------+-----------------------------+
|    x6      |        600%                 |
+------------+-----------------------------+
|    x7      |        700%                 |
|    \.\.\.  |        \.\.\.               |
+------------+-----------------------------+

**Critical Threat Percentages  Conversion Table**

Note that a weapons critical hit range is 21 minus Threat.  I.e. a Crit Range for a weapon with a Crit Threat of 3 is 18-20.

+-----------+----------------------+
| Threat    | Critical Hit % Chance|
+===========+======================+
|    1      |        5%            |
+-----------+----------------------+
|    2      |        10%           |
+-----------+----------------------+
|    3      |        15%           |
+-----------+----------------------+
|    4      |        20%           |
+-----------+----------------------+
|    5      |        25%           |
+-----------+----------------------+
|    6      |        30%           |
+-----------+----------------------+
|    7      |        35%           |
+-----------+----------------------+
|    8      |        40%           |
+-----------+----------------------+
|    9      |        45%           |
+-----------+----------------------+
|    10     |        50%           |
+-----------+----------------------+
|    ...    |        ...           |
+-----------+----------------------+

**Notes:**

* This does not change the value of critical multipliers.  It DOES change the overall statistical distribution of critical hit damage.
* Unable to be displayed on character sheet.

**Examples:** These are all basically impossible now.

* A feat/buff could add +20% Critical Hit Damage Bonus.
* A spell/negative buff could decrease Critical Hit Damage Bonus by -15%
* A class could get +1.5% Critical Hit Damage Bonus per level.
* A feat/buff could add +2% Critical Hit Threat.