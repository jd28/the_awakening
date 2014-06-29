#include "info_inc"
#include "x2_inc_spellhook"

struct SpellInfo {
    int         id, school, class, clevel, slevel, meta, sp, dc;
    object      caster, target, item, area;
    location    loc;
};

struct SpellInfo GetSpellInfo(object oCaster = OBJECT_SELF, int nSpellId=-1, int nSpellClass=-1);

struct SpellInfo GetSpellInfo(object oCaster = OBJECT_SELF, int nSpellId=-1, int nSpellClass=-1){
    struct SpellInfo si;

    si.id = GetSpellId();
    if(!X2PreSpellCastCode()){
        si.id = -1; //Don't run the spell...
        return si;
    }

    si.target = GetSpellTargetObject();
    si.loc = GetSpellTargetLocation();
    si.clevel = GetCasterLevel(oCaster);

    si.school = GetSpellSchool(si.id);
    si.caster = oCaster;
    si.target = GetSpellTargetObject();
    si.item = GetSpellCastItem();
    si.class = GetLastSpellCastClass();

    object oHolder = GetIsObjectValid(si.item) ? si.item : si.caster;
    int pm = GetLevelByClass(CLASS_TYPE_PALEMASTER, oHolder);

    // DC
    si.dc = GetSpellSaveDC();
    si.dc += (si.clevel > 40) ? ((si.clevel - 40) / 4) : 0; // Legendary DC Bonus
    si.dc += GetLocalInt(oHolder, "gsp_mod_dc");
    if(pm >= 40 && si.school == SPELL_SCHOOL_NECROMANCY)
        si.dc += 10;
    
    if(si.dc > 255) si.dc = 255;
    if(si.dc < 0)   si.dc = 1;

    if (nSpellClass >= 0)
        si.class = nSpellClass;
    else if (GetIsObjectValid(si.item) && GetTag(si.item) != "pl_buffitisrock")
        si.class = CLASS_TYPE_INVALID;
    else
        si.class = GetLastSpellCastClass();

    // Pale Masters class level counts +1 per level for Necromancy and +1/2 for all others
    if(si.school == SPELL_SCHOOL_NECROMANCY)
        si.clevel += pm;
    else
        si.clevel += pm / 2;

    si.clevel += (GetLevelByClass(CLASS_TYPE_HARPER, oHolder) / 2);

    if(GetLocalInt(oHolder, "gsp_caster_level") > 0)
        si.clevel = GetLocalInt(oHolder, "gsp_caster_level");

    si.slevel = GetInnateSpellLevel(si.id);
    si.meta = GetMetaMagicFeat();

    if(GetLocalInt(oHolder, "PL_BUFFITIS_META_" + IntToString(si.id)) > 0){
        si.meta = GetLocalInt(oHolder, "PL_BUFFITIS_META_" + IntToString(si.id));
        DeleteLocalInt(oHolder, "PL_BUFFITIS_META_" + IntToString(si.id));
    }
    else if(GetLocalInt(oHolder, "gsp_meta") > si.meta)
        si.meta = GetLocalInt(oHolder, "gsp_meta");

    if (si.meta == METAMAGIC_ANY || si.meta < 0)
        si.meta = METAMAGIC_NONE;

    si.sp = si.clevel;
    if(GetHasFeat(FEAT_EPIC_SPELL_PENETRATION)) si.sp += 6;
    else if(GetHasFeat(FEAT_GREATER_SPELL_PENETRATION)) si.sp += 4;
    else if(GetHasFeat(FEAT_SPELL_PENETRATION)) si.sp += 2;

    if(GetLocalInt(oHolder, "gsp_caster_sp") > 0)
        si.sp = GetLocalInt(oHolder, "gsp_caster_sp");

    Logger(si.caster, VAR_DEBUG_SPELLS, LOGLEVEL_NONE, "Caster: %s, Spell: %s, Target: %s, " +
           "DC: %s, SP: %s, School: %s, Caster Level: %s, Spell Level: %s, Metamagic: %s, " +
           "Item: %s", GetName(si.caster), IntToString(si.id), GetName(si.target),
           IntToString(si.dc), IntToString(si.sp), IntToString(si.school), IntToString(si.clevel),
           IntToString(si.slevel), IntToString(si.meta), GetName(si.item));

    return si;
}

