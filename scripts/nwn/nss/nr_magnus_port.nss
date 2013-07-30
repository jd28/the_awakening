#include "pc_funcs_inc"

void main(){
    object oPC = GetPCSpeaker();
    object oStone = GetItemPossessedBy(oPC, "nr_task_stone");
    int nTask = GetLocalInt(oStone, "Task")+1;
    string sWay = "wp_wiztask_" + IntToString(nTask);

    //SendMessageToPC(oPC, sWay);

    if(nTask == 4){
        if(GetItemPossessedBy(oPC, "nr_magnus_dagger") == OBJECT_INVALID)
            CreateItemOnObject("nr_magnus_dagger", oPC);
    }
    else if(nTask == 5){
        object oDagger = GetItemPossessedBy(oPC,"nr_magnus_dagger");
        if(oDagger != OBJECT_INVALID){
            SetPlotFlag(oDagger, FALSE);
            DestroyObject(oDagger);
        }
    }
    else if(nTask == 100){
        sWay = "wp_wiztask_enter";
    }

    DelayCommand(3.0, JumpSafeToWaypoint(sWay, oPC));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), oPC);
}

