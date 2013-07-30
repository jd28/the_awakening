//::///////////////////////////////////////////////
//:: Summon Undead
//:: X2_S2_SumUndead
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     The level of the Pale Master determines the
     type of undead that is summoned.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Feb 05, 2003
//:: Updated By: Georg Zoeller, Oct 2003
//:://////////////////////////////////////////////

#include "ws_inc_shifter"
#include "pc_funcs_inc"

void PMUpgradeSummon(object oSelf, string sScript)
{
    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED,oSelf);
    ExecuteScript ( sScript, oSummon);
}

void main(){
    int nCasterLevel = GetLevelByClass(CLASS_TYPE_PALEMASTER,OBJECT_SELF);
    int nDuration = 14 + nCasterLevel;
    object oPC = OBJECT_SELF;
    int    nSpell = GetSpellId();
    object oTarget = GetSpellTargetObject();
    int    nPoly, nWeaponType = BASE_ITEM_GLOVES;

    int nType = GetLocalInt(oPC, "PL_PM_SHAPE");

    switch(nType){
        case 0: //spectre
            if (nCasterLevel >= 25){
                // * Dracolich
                nPoly = 151;
            }
            else if (nCasterLevel >= 20){
                // * Risen Lord
                nWeaponType = BASE_ITEM_SCYTHE;
                nPoly = 75;
            }
            else if (nCasterLevel >= 15){
                // * Vampire
                if (GetGender(OBJECT_SELF) == GENDER_MALE)
                    nPoly = 74;
                else
                    nPoly = 77;
            }
            else if (nCasterLevel >= 10)
            {
                // * Spectre
                nPoly = 76;
            }
            else{
                effect eSummon = EffectSummonCreature("X2_S_WRAITH",VFX_FNF_SUMMON_UNDEAD,0.0f,0);
                ApplyEffectAtLocation(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_FNF_LOS_EVIL_10),GetSpellTargetLocation());
                //Apply the summon visual and summon the two undead.
                //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
                ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), HoursToSeconds(nDuration));

                // * If the character has a special pale master item equipped (variable set via OnEquip)
                // * run a script on the summoned monster.
                string sScript = GetLocalString(OBJECT_SELF,"X2_S_PM_SPECIAL_ITEM");
                if (sScript != "")
                {
                    object oSelf = OBJECT_SELF;
                    DelayCommand(1.0,PMUpgradeSummon(oSelf,sScript));
                }
                return;
            }
        break;
        case 1: //spectre
            nPoly = 76;
        break;
        case 2: //Vampire
            if (GetGender(OBJECT_SELF) == GENDER_MALE)
                nPoly = 74;
            else
                nPoly = 77;
        break;
        case 3: //Risen Lord
            nWeaponType = BASE_ITEM_SCYTHE;
            nPoly = 75;
        break;
        case 4: //Dracolich
            nPoly = 151;
        break;
        default:
            ErrorMessage(oPC, "Unrecognized shape. 1: Spectre; 2: Vampire; " +
                "3. Risen Lord; 4. Dracolich");
            return;
        }

    ApplyPolymorph(OBJECT_SELF, nPoly, nWeaponType);
}


/*
void main()
{
    //Declare major variables
    int nCasterLevel = GetLevelByClass(CLASS_TYPE_PALEMASTER,OBJECT_SELF);
    int nDuration = 14 + nCasterLevel;


    //effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
    effect eSummon;
    //Summon the appropriate creature based on the summoner level
    if (nCasterLevel <= 5)
    {
        //Ghoul
        eSummon = EffectSummonCreature("NW_S_GHOUL",VFX_IMP_HARM,0.0f,0);
    }
    else if (nCasterLevel == 6)
    {
        //Shadow
        eSummon = EffectSummonCreature("NW_S_SHADOW",VFX_IMP_HARM,0.0f,0);
    }
    else if (nCasterLevel == 7)
    {
        //Ghast
        eSummon = EffectSummonCreature("NW_S_GHAST",VFX_IMP_HARM,0.0f,1);
    }
    else if (nCasterLevel == 8)
    {
        //Wight
        eSummon = EffectSummonCreature("NW_S_WIGHT",VFX_FNF_SUMMON_UNDEAD,0.0f,1);
    }
    else if (nCasterLevel >= 9)
    {
        //Wraith
        eSummon = EffectSummonCreature("X2_S_WRAITH",VFX_FNF_SUMMON_UNDEAD,0.0f,1);
    }
    // * Apply the summon visual and summon the two undead.
    // * ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_FNF_LOS_EVIL_10),GetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), HoursToSeconds(nDuration));

    // * If the character has a special pale master item equipped (variable set via OnEquip)
    // * run a script on the summoned monster.
    string sScript = GetLocalString(OBJECT_SELF,"X2_S_PM_SPECIAL_ITEM");
    if (sScript != "")
    {
        object oSelf = OBJECT_SELF;
        DelayCommand(1.0,PMUpgradeSummon(oSelf,sScript));
    }
}
*/
