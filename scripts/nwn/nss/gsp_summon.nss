////////////////////////////////////////////////////////////////////////////////
// gsp_summon
//
// Spells:
//
// TODO: Item creation...  Monster stats, etc.  Concentration
//
////////////////////////////////////////////////////////////////////////////////
void SummonOthers(struct SpellInfo si);
effect GetSummonEffectI_IX(int nSpellID);
effect GetSummonEffectADI_IX(int nSpellID);

//Allows PC to summon more than 1 summon.
void MultisummonPreSummon(object oPC = OBJECT_SELF);

#include "gsp_func_inc"
#include "mod_funcs_inc"

//Creates the weapon that the creature will be using.
void CreatePersistentBlade(object oCaster, float fDuration)
{
    //Declare major variables
    int nStat = GetIsMagicStatBonus(oCaster) / 2;
    // GZ: Just in case...
    if (nStat >20)
    {
        nStat =20;
    }
    else if (nStat <1)
    {
        nStat = 1;
    }
    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED);
    object oWeapon;
    if (GetIsObjectValid(oSummon))
    {
        //Create item on the creature, epuip it and add properties.
        oWeapon = CreateItemOnObject("NW_WSWDG001", oSummon);
        // GZ: Fix for weapon being dropped when killed
        SetDroppableFlag(oWeapon,FALSE);
        AssignCommand(oSummon, ActionEquipItem(oWeapon, INVENTORY_SLOT_RIGHTHAND));
        // GZ: Check to prevent invalid item properties from being applies
        if (nStat>0)
        {
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyAttackBonus(nStat), oWeapon,fDuration);
        }
        AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1,5),oWeapon,fDuration);
    }
}

void main(){

    struct SpellInfo si = GetSpellInfo();
    if(si.id < 0) return;

    float fDuration = MetaDuration(si, 24, DURATION_IN_HOURS);
    effect eSummon;

    if(si.id >= 174 && si.id <= 182){
        if(GetHasFeat(FEAT_AIR_DOMAIN_POWER, si.caster)) eSummon = GetSummonEffectADI_IX(si.id);
        else eSummon = GetSummonEffectI_IX(si.id);
    }
    else SummonOthers(si);

    //Apply the VFX impact and summon effect
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, si.loc, fDuration);
}

void SummonOthers(struct SpellInfo si){
    int nEffect;
    int nRoll = d3();
    string sSummon;
    float fDuration, fDelay;

    switch(si.id){
        case SPELL_ANIMATE_DEAD:
        case SPELLABILITY_PM_ANIMATE_DEAD:
            fDuration = MetaDuration(si, 24, DURATION_IN_HOURS);
            nEffect = VFX_FNF_SUMMON_UNDEAD;

            if (si.clevel <= 5)
                nRoll = 1;
            else if ((si.clevel >= 6) && (si.clevel <= 9))
                nRoll = 2;
            else
                nRoll = 3;

            switch (nRoll){
                case 1: sSummon = "NW_S_ZOMBTYRANT"; break;
                case 2: sSummon = "NW_S_SKELWARR";   break;
                case 3: sSummon = "NW_S_SKELCHIEF";  break;
            }
        break;
        case SPELL_CREATE_GREATER_UNDEAD:
            fDuration = MetaDuration(si, 24, DURATION_IN_HOURS);
            nEffect = VFX_FNF_SUMMON_UNDEAD;

            if (si.clevel <= 11)
                nRoll = 1;
            else if ((si.clevel >= 12) && (si.clevel <= 13))
                nRoll = 2;
            else if ((si.clevel >= 14) && (si.clevel <= 15))
                nRoll = 3;
            else if ((si.clevel >= 16))
                nRoll = 4;

            switch (nRoll){
                case 1: sSummon = "NW_S_VAMPIRE";   break;
                case 2: sSummon = "NW_S_DOOMKGHT";   break;
                case 3: sSummon = "NW_S_LICH";   break;
                case 4: sSummon = "NW_S_MUMCLERIC"; break;
            }
        break;
        case SPELL_CREATE_UNDEAD:
            fDuration = MetaDuration(si, 24, DURATION_IN_HOURS);
            nEffect = VFX_FNF_SUMMON_UNDEAD;

            if (si.clevel <= 11)
                nRoll = 1;
            else if ((si.clevel >= 12) && (si.clevel <= 13))
                nRoll = 2;
            else if ((si.clevel >= 14) && (si.clevel <= 15))
                nRoll = 3;
            else if ((si.clevel >= 16))
                nRoll = 4;

            switch (nRoll){
                case 1: sSummon = "NW_S_GHOUL";   break;
                case 2: sSummon = "NW_S_GHAST";   break;
                case 3: sSummon = "NW_S_WIGHT";   break;
                case 4: sSummon = "NW_S_SPECTRE"; break;
            }
        break;
        case SPELLABILITY_BG_CREATEDEAD:
        break;
        case SPELL_GATE:
            if(GetIsObjectValid(si.item) && GetTag(si.item) == "pl_drow_bind_rob"){
                if(!GetHasSpell(SPELL_GATE, si.caster)){
                    ErrorMessage(si.caster, "You must have a Gate spell memorized to use this item!");
                    return;
                }

                DecrementRemainingSpellUses(si.caster, SPELL_GATE);
                sSummon = "pl_drow_demon2";
                fDuration = 60.0;
                nEffect = VFX_FNF_PWKILL;
                fDelay = 3.0;
            }
            else if(GetHasSpellEffect(SPELL_PROTECTION_FROM_EVIL) ||
               GetHasSpellEffect(SPELL_MAGIC_CIRCLE_AGAINST_EVIL) ||
               GetHasSpellEffect(SPELL_HOLY_AURA))
            {
                nEffect = VFX_FNF_SUMMON_GATE;
                sSummon = "NW_S_BALOR";
                fDuration = MetaDuration(si, si.clevel);
                fDelay = 3.0;
            }
            else{ // Not protected, create evil balor.
                ApplyVisualAtLocation(VFX_FNF_SUMMON_GATE, si.loc);
                DelayCommand(fDelay, ObjectToVoid(CreateObject(OBJECT_TYPE_CREATURE, "NW_S_BALOR_EVIL", si.loc)));
                return;
            }
        break;
        case SPELL_MORDENKAINENS_SWORD:
            fDuration = MetaDuration(si, si.clevel);
            nEffect = VFX_FNF_SUMMON_MONSTER_3;
            sSummon = "NW_S_HelmHorr";
        break;
        case SPELL_PLANAR_ALLY:
            fDuration = MetaDuration(si, 24, DURATION_IN_HOURS);
            nEffect = VFX_FNF_SUMMON_UNDEAD;

            //Set the summon effect based on the alignment of the caster
            fDelay = 3.0;
            switch (GetAlignmentGoodEvil(si.caster)){
                case ALIGNMENT_EVIL:
                    sSummon = "NW_S_SUCCUBUS";
                    nEffect = VFX_FNF_SUMMON_GATE;
                break;
                case ALIGNMENT_GOOD:
                    sSummon = "NW_S_CHOUND";
                    nEffect = VFX_FNF_SUMMON_CELESTIAL;
                break;
                case ALIGNMENT_NEUTRAL:
                    sSummon = "NW_S_SLAADGRN";
                    nEffect = VFX_FNF_SUMMON_MONSTER_3;
                break;
            }
        break;
        case SPELL_SUMMON_SHADOW:
        case SPELL_SHADES_SUMMON_SHADOW:
        case SPELL_SHADOW_CONJURATION_SUMMON_SHADOW:
            fDuration = MetaDuration(si, 24, DURATION_IN_HOURS);
            nEffect = VFX_FNF_SUMMON_UNDEAD;

            if (si.clevel <= 7)
                sSummon = "NW_S_SHADOW";
            else if ((si.clevel >= 8) && (si.clevel <= 10))
                sSummon = "NW_S_SHADMASTIF";
            else if ((si.clevel >= 11) && (si.clevel <= 14))
                sSummon = "NW_S_SHFIEND";
            else if ((si.clevel >= 15))
                sSummon = "NW_S_SHADLORD";
        break;
        case SPELL_SHELGARNS_PERSISTENT_BLADE:
            fDuration = MetaDuration(si, (si.clevel / 2) + 1, DURATION_IN_TURNS);
            nEffect = VFX_FNF_SUMMON_MONSTER_1;
            sSummon = "X2_S_FAERIE001";
        break;
    }

    effect eSummon = EffectSummonCreature(sSummon, nEffect, fDelay);
    //Apply the VFX impact and summon effect
    DelayCommand(fDelay, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, si.loc, fDuration));

    if(si.id == SPELL_SHELGARNS_PERSISTENT_BLADE)
        CreatePersistentBlade(si.caster, fDuration);
}

effect GetSummonEffectADI_IX(int nSpellID){
    int nFNF_Effect;
    int nRoll = d3();
    string sSummon;

    if(nSpellID == SPELL_SUMMON_CREATURE_I){
        nFNF_Effect = VFX_FNF_SUMMON_MONSTER_1;
        sSummon = "NW_S_BOARDIRE";
    }
    else if(nSpellID == SPELL_SUMMON_CREATURE_II){
        nFNF_Effect = VFX_FNF_SUMMON_MONSTER_1;
        sSummon = "NW_S_WOLFDIRE";
    }
        else if(nSpellID == SPELL_SUMMON_CREATURE_III){
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_1;
            sSummon = "NW_S_SPIDDIRE";
        }
        else if(nSpellID == SPELL_SUMMON_CREATURE_IV){
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_2;
            sSummon = "NW_S_beardire";
        }
        else if(nSpellID == SPELL_SUMMON_CREATURE_V){
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_2;
            sSummon = "NW_S_diretiger";
        }
        else if(nSpellID == SPELL_SUMMON_CREATURE_VI){
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_3;
            switch (nRoll){
                case 1: sSummon = "NW_S_AIRHUGE";   break;
                case 2: sSummon = "NW_S_WATERHUGE"; break;
                case 3: sSummon = "NW_S_FIREHUGE";  break;
            }
        }
        else if(nSpellID == SPELL_SUMMON_CREATURE_VII){
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_3;
            switch (nRoll){
                case 1: sSummon = "NW_S_AIRGREAT";   break;
                case 2: sSummon = "NW_S_WATERGREAT"; break;
                case 3: sSummon = "NW_S_FIREGREAT";  break;
            }
        }
        else if(nSpellID == SPELL_SUMMON_CREATURE_VIII){
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_3;
            switch (nRoll){
                case 1: sSummon = "NW_S_AIRELDER";   break;
                case 2: sSummon = "NW_S_WATERELDER"; break;
                case 3: sSummon = "NW_S_FIREELDER";  break;
            }
        }
        else if(nSpellID == SPELL_SUMMON_CREATURE_IX){
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_3;
            switch (nRoll){
                case 1: sSummon = "NW_S_AIRELDER";   break;
                case 2: sSummon = "NW_S_WATERELDER"; break;
                case 3: sSummon = "NW_S_FIREELDER";  break;
            }
        }
    return EffectSummonCreature(sSummon, nFNF_Effect);
}

effect GetSummonEffectI_IX(int nSpellID){
    int nFNF_Effect;
    int nRoll = d3();
    string sSummon;


    if(nSpellID == SPELL_SUMMON_CREATURE_I){
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_1;
            sSummon = "NW_S_badgerdire";
        }
        else if(nSpellID == SPELL_SUMMON_CREATURE_II)
        {
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_1;
            sSummon = "NW_S_BOARDIRE";
        }
        else if(nSpellID == SPELL_SUMMON_CREATURE_III)
        {
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_1;
            sSummon = "NW_S_WOLFDIRE";
        }
        else if(nSpellID == SPELL_SUMMON_CREATURE_IV)
        {
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_2;
            sSummon = "NW_S_SPIDDIRE";
        }
        else if(nSpellID == SPELL_SUMMON_CREATURE_V)
        {
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_2;
            sSummon = "NW_S_beardire";
        }
        else if(nSpellID == SPELL_SUMMON_CREATURE_VI)
        {
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_2;
            sSummon = "NW_S_diretiger";
        }
        else if(nSpellID == SPELL_SUMMON_CREATURE_VII)
        {
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_3;
            switch (nRoll){
                case 1: sSummon = "NW_S_AIRHUGE";   break;
                case 2: sSummon = "NW_S_WATERHUGE"; break;
                case 3: sSummon = "NW_S_FIREHUGE";  break;
            }
        }
        else if(nSpellID == SPELL_SUMMON_CREATURE_VIII){
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_3;
            switch (nRoll){
                case 1: sSummon = "NW_S_AIRGREAT";   break;
                case 2: sSummon = "NW_S_WATERGREAT"; break;
                case 3: sSummon = "NW_S_FIREGREAT";  break;
            }
        }
        else if(nSpellID == SPELL_SUMMON_CREATURE_IX){
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_3;
            switch (nRoll){
                case 1: sSummon = "NW_S_AIRELDER";   break;
                case 2: sSummon = "NW_S_WATERELDER"; break;
                case 3: sSummon = "NW_S_FIREELDER";  break;
            }
        }
    return EffectSummonCreature(sSummon, nFNF_Effect);
}

//  Original Author: PRC.
void MultisummonPreSummon(object oPC = OBJECT_SELF){
    int i=1;
    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED,oPC,i);
    while(GetIsObjectValid(oSummon)){
        AssignCommand(oSummon,SetIsDestroyable(FALSE,FALSE,FALSE));
        AssignCommand(oSummon,DelayCommand(6.0,SetIsDestroyable(TRUE,FALSE,FALSE)));
        oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC,++i);
    }
}
