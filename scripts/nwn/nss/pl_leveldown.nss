#include "pc_funcs_inc"
#include "pl_pcstyle_inc"
void main(){

    object oPC = OBJECT_SELF;
    int class = GetClassByLevel(oPC, GetHitDice(oPC));
    int level = GetLevelByClass(class, oPC);

    if(class == CLASS_TYPE_FIGHTER){
        if(level == 45 && GetFightingStyle(oPC)){
            SetFightingStyle(oPC, STYLE_INVALID);
            SetPhenoType(PHENOTYPE_NORMAL, oPC);
        }
    }
    else
    if (class == CLASS_TYPE_ASSASSIN){
        if(GetFightingStyle(oPC) == STYLE_ASSASSIN_NINJA
                && !GetMeetsStyleRequirement(oPC, STYLE_ASSASSIN_NINJA)){
            SetFightingStyle(oPC, STYLE_INVALID);
            SetPhenoType(PHENOTYPE_NORMAL, oPC);
        }
    }
    else
    if (class == CLASS_TYPE_PALEMASTER){
        if(level == 40 && GetUndeadStyle(oPC)){
            SetUndeadStyle(oPC, STYLE_INVALID);
            SetCreatureAppearanceType(oPC, GetDefaultAppearance(GetRacialType(oPC)));
            SetLocalInt(oPC, "pc_no_appear_change", 0);
            // TODO - Ensure this is stored somewhere.
        }
    }
    else
    if (class == CLASS_TYPE_MONK){
        if(level == 45 && GetFightingStyle(oPC)){
            SetFightingStyle(oPC, STYLE_INVALID);
            SetPhenoType(PHENOTYPE_NORMAL, oPC);
        }
    }
    else
    if (class == CLASS_TYPE_HARPER){
        if(level == 1){
            ModifySkillRankByLevel (oPC, level, SKILL_LISTEN, -4);
            ModifySkillRankByLevel (oPC, level, SKILL_SPOT,   -4);
            ModifySkillRankByLevel (oPC, level, SKILL_SEARCH, -4);
        }
    }
}
