#include "x0_inc_henai"
#include "pc_funcs_inc"

void main()
{
    object oClicker = GetClickingObject();
    object oTarget = GetTransitionTarget(OBJECT_SELF);
    int nN=1;
    object oOb;
    object oAreaHere = GetArea(oClicker);
    object oAreaTarget = GetArea(oTarget);
    int bDelayedJump=FALSE;
    int bNoMounts=FALSE;
    float fX3_MOUNT_MULTIPLE=GetLocalFloat(GetArea(oClicker),"fX3_MOUNT_MULTIPLE"), fDelay;
    float fX3_DISMOUNT_MULTIPLE=GetLocalFloat(GetArea(oClicker),"fX3_DISMOUNT_MULTIPLE");

    object oBranch = GetItemPossessedBy(oClicker, "pl_branch_life");
    if(oBranch == OBJECT_INVALID){
        ErrorMessage(oClicker, "A magical force prevents you from entering.");
        return;
    }

    SetAreaTransitionBMP(AREA_TRANSITION_RANDOM);

    if (bDelayedJump)
    { // delayed jump
        DelayCommand(fDelay,AssignCommand(oClicker,ClearAllActions()));
        DelayCommand(fDelay+0.1*fX3_MOUNT_MULTIPLE,AssignCommand(oClicker,JumpToObject(oTarget)));
    } // delayed jump
    else
    { // quick jump
        AssignCommand(oClicker,JumpToObject(oTarget));
    } // quick jump
}
