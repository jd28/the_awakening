#include "inc_draw2"


void DrawCage3(){
    location lLoc, lLoc2;
    float fShift = 1.0;
    float f = 10.0, height = 7.0;
    object oNode1, oNode2;
    int i;

    for(i = 0; i < 11; i++){
        lLoc = Location(GetArea(OBJECT_SELF), Vector(f, 10.0, 0.0), 0.0); //GetLocation(OBJECT_SELF);
        lLoc2 = Location(GetArea(OBJECT_SELF), Vector(f, 10.0, height), 0.0); //GetLocation(OBJECT_SELF);
        oNode1 = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLoc);
        oNode2 = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLoc2);
        ApplyEffectToObject(2, EffectBeam(VFX_BEAM_FIRE_W_SILENT, oNode1, BODY_NODE_CHEST), oNode2);
        f += fShift;
    }
    f = 10.0;
    for(i = 0; i < 11; i++){
        lLoc = Location(GetArea(OBJECT_SELF), Vector(10.0, f, 0.0), 0.0); //GetLocation(OBJECT_SELF);
        lLoc2 = Location(GetArea(OBJECT_SELF), Vector(10.0, f, height), 0.0); //GetLocation(OBJECT_SELF);
        oNode1 = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLoc);
        oNode2 = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLoc2);
        ApplyEffectToObject(2, EffectBeam(VFX_BEAM_FIRE_W_SILENT, oNode1, BODY_NODE_CHEST), oNode2);
        f += fShift;
    }
    f = 10.0;
    for(i = 0; i < 11; i++){
        lLoc = Location(GetArea(OBJECT_SELF), Vector( f, 20.0, 0.0), 0.0); //GetLocation(OBJECT_SELF);
        lLoc2 = Location(GetArea(OBJECT_SELF), Vector(f, 20.0, height), 0.0); //GetLocation(OBJECT_SELF);
        oNode1 = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLoc);
        oNode2 = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLoc2);
        ApplyEffectToObject(2, EffectBeam(VFX_BEAM_FIRE_W_SILENT, oNode1, BODY_NODE_CHEST), oNode2);
        f += fShift;
    }
    f = 10.0;
    for(i = 0; i < 11; i++){
        lLoc = Location(GetArea(OBJECT_SELF), Vector(20.0, f, 0.0), 0.0); //GetLocation(OBJECT_SELF);
        lLoc2 = Location(GetArea(OBJECT_SELF), Vector(20.0, f, height), 0.0); //GetLocation(OBJECT_SELF);
        oNode1 = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLoc);
        oNode2 = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lLoc2);
        ApplyEffectToObject(2, EffectBeam(VFX_BEAM_FIRE_W_SILENT, oNode1, BODY_NODE_CHEST), oNode2);
        f += fShift;
    }
}

void DrawCage2(){
    location lLoc = Location(GetArea(OBJECT_SELF), Vector(15.0, 15.0, -1.0), 0.0); //GetLocation(OBJECT_SELF);
    PlaceCircle("pl_solwhite_001", lLoc, 5.0, 20);
}

void DrawCage(){
    location lLoc = Location(GetArea(OBJECT_SELF), Vector(15.0, 15.0, -2.5), 0.0); //GetLocation(OBJECT_SELF);
    int i;
    float f = 0.1, shift = 0.2;

    if (GetLocalInt(OBJECT_SELF, "golemcage")){

        DelayCommand(f, BeamIcosahedron(2, VFX_BEAM_FIRE_W_SILENT, lLoc, 5.0, 0.0, "", 12.0));
        f += shift;
        DelayCommand(f, BeamTriacontahedron(2, VFX_BEAM_FIRE_W_SILENT, lLoc, 5.0, 0.0, "", 12.0));
        f += shift;
        DelayCommand(f, BeamIcosahedron(2, VFX_BEAM_FIRE_W_SILENT, lLoc, 5.0, 0.0, "", 12.0));
        f += shift;
        DelayCommand(f, BeamTriacontahedron(2, VFX_BEAM_FIRE_W_SILENT, lLoc, 5.0, 0.0, "", 12.0));

        DeleteLocalInt(OBJECT_SELF, "golemcage");
    }
    else{

        DelayCommand(f, BeamDodecahedron(2, VFX_BEAM_FIRE_W_SILENT, lLoc, 5.0, 0.0, "", 18.0));
        f += shift;
        DelayCommand(f, BeamTriacontahedron(2, VFX_BEAM_FIRE_W_SILENT, lLoc, 5.0, 0.0, "", 12.0));
        f += shift;
        DelayCommand(f, BeamDodecahedron(2, VFX_BEAM_FIRE_W_SILENT, lLoc, 5.0, 0.0, "", 12.0));
        f += shift;
        DelayCommand(f, BeamTriacontahedron(2, VFX_BEAM_FIRE_W_SILENT, lLoc, 5.0, 0.0, "", 12.0));
        f += shift;
        SetLocalInt(OBJECT_SELF, "golemcage", TRUE);
    }
    /**/
}

void main(){
    //SendMessageToPC(GetFirstPC(), "pl_treant_cage : start");
    object oCage = GetFirstObjectInArea(OBJECT_SELF);
    string sTag;

    while (oCage != OBJECT_INVALID){
        sTag = GetTag(oCage);
        if(sTag == "pl_wizorc_cage_control")
            DeleteLocalInt(oCage, "Deactivated");

        if (sTag == "PSC_B_ICOSAHEDRON" || sTag == "PSC_B_DODECAHEDRON" || sTag == "PSC_B_TRIACONTAHEDRON" || sTag == "PSC_X_TEXTMESSAGE")
            GroupDestroyObject(oCage);
        oCage = GetNextObjectInArea(OBJECT_SELF);
    }

    DrawCage();
//    DelayCommand(3.0, DrawCage());
//    DelayCommand(6.0, DrawCage());
//    DelayCommand(9.0, DrawCage());
//    DelayCommand(12.0, DrawCage());
//    DelayCommand(15.0, DrawCage());
}
