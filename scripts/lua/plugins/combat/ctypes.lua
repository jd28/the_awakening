local ffi = require 'ffi'

--- Caches combat related information.
-- @table CombatInfo
-- @field offense Offense ctype.
-- @field defense Deffense type
-- @field equips [EQUIP_TYPE_NUM] CombatWeapon ctypes.
-- @field mods [COMBAT_MOD_NUM] CombatMod ctypes.
-- @field mod_situ[SITUATION_NUM] CombatMod ctypes.
-- @field mod_mode CombatMod for mode effects.
-- @field effective_level OBSOLETE
-- @field first_custom_eff OBSOLETE
-- @field fe_mask Favored enemy bitmask.
-- @field training_vs_mask Training Vs bitmask.
-- @field skill_eff [SKILL_NUM] Skill bonuses from effects.
-- @field ability_eff [ABILITY_NUM] Ability bonuses from effects.
-- @field update_flags OBSOLETE

--- Constructor combat_mod_t
-- @table CombatMod
-- @field ab Attack bonus/penalty.
-- @field ac AC bonus/penalty.
-- @field dmd DamageRoll bonus/penalty.
-- @field hp Hitpoint bonus/penalty.

--- Caches some offensive information.
-- @table Offense
-- @field ab_base BAB
-- @field ab_transient Attack bonus effects applied directly to player.
-- @field attacks_on Number of onhand attacks.
-- @field attacks_off Number of offhand attacks.
-- @field offhand_penalty_on Dualwield AB penalty for offhand attack.
-- @field offhand_penalty_off Dualwield AB penalty for offhand attack.
-- @field ranged_type Ranged type. See rangedwpns.2da
-- @field weapon_type Weapon type. See 'Type' column in wpnprops.2da
-- @field damage [20] DamageRoll.  Damage bonus/penalties applied
-- directly to player.
-- @field damage_len Number of DamageRolls in the damage array.

--- Caches some defensive information.
-- @table Defense
-- @field concealment Concealment
-- @field hp_eff Hitpoints from effects.
-- @field hp_max Maximum hitpoints.
-- @field soak Innate soak.
-- @field soak_stack [DAMAGE_POWER_NUM] Stacking soak effects.
-- @field immunity [DAMAGE_INDEX_NUM] Damage immunity.
-- @field immunity_base [DAMAGE_INDEX_NUM] Innate immunity. E,g RDD.
-- @field immunity_misc [IMMUNITY_TYPE_NUM] % Immunity to IMMMUNITY_TYPE_*
-- @field resist [DAMAGE_INDEX_NUM] Innate resistance.
-- @field resist_stack [DAMAGE_INDEX_NUM] Stacking damage resistance.

--- Weapon properties.
-- @table CombatWeapon
-- @field id Item's object id.
-- @field iter Iteration penalty.
-- @field ab_ability AB from ability scores.
-- @field dmg_ability Damage from ability scores.
-- @field ab_mod AB modifier. Eg. from WM.
-- @field transient_ab_mod AB modifer from AttackBonus effects.
-- @field crit_range Critical hit range.  More technically, the threat.
-- @field crit_mult Critical hit multiplier
-- @field power Damage power
-- @field base_dmg_flags Base weapon damage flags.
-- @field base_dmg_roll Base weapon damage roll.
-- @field damage [50] From effects, weapons, etc. [TODO] Reconsider the size.
-- @field damage_len Number of damages used in the above array.

ffi.cdef(string.interp([[
typedef struct CombatMod {
    int32_t ab;
    int32_t ac;
    DamageRoll dmg;
    int32_t hp;
} CombatMod;

typedef struct {
    uint32_t   id;
    int32_t    iter;
    int32_t    ab_ability;
    int32_t    ab_mod;
    int32_t    transient_ab_mod;
    int32_t    power;
    int32_t    dmg_ability;
    float      crit_range;
    float      crit_mult;
    uint32_t   base_dmg_flags;
    DiceRoll   base_dmg_roll;
} CombatWeapon;

typedef struct {
    float         crit_dmg_modifier;
    float         crit_chance_modifier;
    int32_t       ab_transient;
    int32_t       ab_base;
    int32_t       offhand_penalty_on;
    int32_t       offhand_penalty_off;
    int32_t       attacks_on;
    int32_t       attacks_off;
    int32_t       weapon_type;
    int32_t       ranged_type;
    int32_t       damage_len;
    int32_t       damage_equip[50];
    DamageRoll    damage[50];
    float         damge_bonus_modifier;
} Offense;

typedef struct {
    int32_t       concealment;
    int32_t       immunity_misc[${IMMUNITY_TYPE_NUM}];
    /*Saves         saves;*/
} Defense;

typedef struct {
    int32_t       soak;
    int32_t       soak_stack[${DAMAGE_POWER_NUM}];
    int32_t       immunity[${DAMAGE_INDEX_NUM}];
    int32_t       immunity_base[${DAMAGE_INDEX_NUM}];
    int32_t       resist[${DAMAGE_INDEX_NUM}];
    int32_t       resist_stack[${DAMAGE_INDEX_NUM}];
} DamageReduction;

typedef struct {
    int32_t         hp_max;
    int32_t         hp_eff;
    Offense         offense;
    CombatWeapon    equips[${EQUIP_TYPE_NUM}];
    Defense         defense;
    DamageReduction dr;
    CombatMod       mods[${COMBAT_MOD_NUM}];
    CombatMod       mod_situ[${SITUATION_NUM}];
    CombatMod       mod_mode;
    uint32_t        fe_mask;
    uint32_t        training_vs_mask;
} CombatInfo;
]], Rules.GetConstantTable()))

print(ffi.sizeof('CombatInfo'))