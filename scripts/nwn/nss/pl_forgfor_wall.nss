void main(){
    location lLoc, lLoc2;
    float fShift = 1.0;
    float f = 1.0, height = 7.0;
    object oNode1, oNode2;
    int i;

    for(i = 0; i < 3; i++){
        lLoc = Location(GetArea(OBJECT_SELF), Vector(75.0, 41.0, f), 0.0); //GetLocation(OBJECT_SELF);
        lLoc2 = Location(GetArea(OBJECT_SELF), Vector(75.0, 49.0, f), 0.0); //GetLocation(OBJECT_SELF);
        oNode1 = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLoc, FALSE, "Spawned");
        oNode2 = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLoc2, FALSE, "Spawned");
        ApplyEffectToObject(2, EffectBeam(VFX_BEAM_SILENT_LIGHTNING, oNode1, BODY_NODE_CHEST), oNode2);
        f += fShift;
    }
}
