void main(){
    object oDoor, oPC = GetLastKiller();
    location lDoor;
    int i;

    for(i = 1; i < 9; i++){
        oDoor = GetNearestObjectByTag("ms_door_volran", oPC, i);
        lDoor = GetLocation(oDoor);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_EVIL), lDoor);
        SetLocked(oDoor, FALSE);
    }
}
