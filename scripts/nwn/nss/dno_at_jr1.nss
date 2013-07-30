///////////////////////////////////
//: dno_at_jr1
//: Start Journal Entry for
//: Rogue Task 1.
/////////////////////////////
//: K9-69 ;o)
/////////////
//#include "nw_i0_tool"
//#include "dno_deadly_trap"
#include "quest_func_inc"

void main(){

    object oPC = GetPCSpeaker();
    if (!GetIsPC(oPC)) return;

    QuestAdvance(OBJECT_SELF, oPC);

    object oTarget = GetObjectByTag("dno_Cabinet");
    if (oTarget == OBJECT_INVALID)
        return;

    CreateItemOnObject("dno_rope", oTarget);
    CreateItemOnObject("dno_key_01", oTarget);

    SetLocked(oTarget, TRUE);

    CreateTrapOnObject(TRAP_BASE_TYPE_DEADLY_SPIKE, oTarget);

    SetTrapActive(oTarget, TRUE);
    SetTrapDetectable(oTarget, TRUE);
    SetTrapDisarmable(oTarget, TRUE);
    SetTrapOneShot(oTarget, TRUE);
    SetTrapRecoverable(oTarget, FALSE);
    SetTrapDetectDC(oTarget, 30);
    SetTrapDisarmDC(oTarget, 30);
}

