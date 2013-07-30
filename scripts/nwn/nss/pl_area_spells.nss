// pl_area_spells

#include "area_inc"

struct AreaSpell{
    object oController;
    int nSpell, nDelay, nTargetPC, nTargetCount;
};


void AreaSpellApplyImpact(struct AreaSpell as, object oTarget);
void DoAreaSpell(struct AreaSpell as);

void AreaSpellApplyImpact(struct AreaSpell as, object oTarget){

}

void DoAreaSpell(struct AreaSpell as){
    // If the controller has been cleaned we exit
    if(!GetIsObjectValid(as.oController))
        return;
    DelayCommand(RoundsToSeconds(as.nDelay), DoAreaSpell(as));

    int nPCCount;
    object oTarget;

    if(as.nTargetPC){
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(as.oController));
        while(oTarget != OBJECT_INVALID){
            if(GetIsPC(oTarget))
                nPCCount++;

            oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(as.oController));
        }
    }

    if(Random(as.nTargetCount+nPCCount)+1 <= as.nTargetCount){
        oTarget = GetNearestObjectByTag("area_spell_target", as.oController, Random(as.nTargetCount)+1);
    }
    else{
        oTarget = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, as.oController,
            Random(nPCCount)+1);
    }

    if(as.nSpell >= 0){
        ActionCastSpellAtObject(as.nSpell, oTarget, METAMAGIC_ANY, TRUE);
    }
    else{
        // Custom Impact.
        AreaSpellApplyImpact(as, oTarget);
    }

}

void main(){

    struct AreaSpell as;
    as.oController = OBJECT_SELF;
    as.nSpell = GetLocalInt(as.oController, "area_spell") - 1;
    as.nDelay = GetLocalInt(as.oController, "area_spell_delay");
    if(as.nDelay == 0) as.nDelay = 1;
    as.nTargetPC = GetLocalInt(as.oController, "area_spell_target_pc");

    object oStorage = GetFirstObjectInArea(GetArea(as.oController));

    if(GetTag(oStorage) == "area_spell_target")
        as.nTargetCount++;

    int i = 1;
    while(GetNearestObjectByTag("area_spell_target", oStorage, i) != OBJECT_INVALID){
        i++;
    }
    as.nTargetCount += i - 1;

    Logger(GetFirstPC(), VAR_DEBUG_AREAS, LOGLEVEL_DEBUG, "Area Spell : Area: %s, "+
        "Spell: %s, Delay: %s, Target PCs: %s, Target Count: %s", GetName(GetArea(as.oController)),
        IntToString(as.nSpell), IntToString(as.nDelay), IntToString(as.nTargetPC), IntToString(as.nTargetCount));

    DelayCommand(RoundsToSeconds(1), DoAreaSpell(as));
}
