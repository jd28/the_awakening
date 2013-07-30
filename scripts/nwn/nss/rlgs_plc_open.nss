#include "rlgs_func_inc"

void main(){
    struct rlgs_info ri;
    ri.oContainer = OBJECT_SELF;
    ri.oHolder = GetNearestObjectByTag("rlgs_info");
    ri.oPC = GetLastOpenedBy();
    ri.nClass = -1;

    int nEffect = GetLocalInt(ri.oHolder, "rlgs_effect");

    SetLocalInt(ri.oHolder, "rlgs_no_respawn", 1);

    // Prevent multiple click spawning
    if (GetLocalInt(ri.oHolder, "rlgs_used") == 0){
        SetLocalInt(ri.oHolder, "rlgs_used", GetLocalInt(GetModule(), "MOD_RESET_TIMER"));

        if(GetLocalInt(OBJECT_SELF, "rlgs_delete_inv")){
            object oTrash = GetFirstItemInInventory();
            while(oTrash != OBJECT_INVALID){
                DestroyObject(oTrash);
                oTrash = GetNextItemInInventory();
            }
        }
        DelayCommand(1.0f, RLGSGenerateLoot(ri));

        if(nEffect > 0)
            ApplyVisualToObject(nEffect, ri.oContainer);
    }
}
