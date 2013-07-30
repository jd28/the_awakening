#include "pc_funcs_inc"
#include "gsp_func_inc"

void main (){
    object oPC = GetLastUsedBy();
    if(!GetLocalInt(oPC, "pl_xmas_santa")
       || !GetLocalInt(oPC, "pl_xmas_santa")) {
        ErrorMessage(oPC, "You have not killed Santa or Mrs Claus.");
        return;
    }

    object ring = GetItemPossessedBy(oPC, "pl_iceelf_ring");
    object ice = GetItemPossessedBy(oPC, "ep_crystal_water");

    if(ring == OBJECT_INVALID || ice == OBJECT_INVALID) {
        ErrorMessage(oPC, "You don't have an Ice ring and/or Water Bowl.");
        return;
    }

    ApplyVisualAtLocation(VFX_FNF_STRIKE_HOLY, GetLocation(OBJECT_SELF));
    DestroyObject(ring);
    DestroyObject(ice);
    CreateItemOnObject("ms_ringofchristm", oPC);
}

