#include "mod_funcs_inc"

void ApplyPermenatVisualToObject(int nEffect, object oTarget){
    effect eVis = EffectVisualEffect(nEffect);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis, oTarget);
}

void PlaceInit(object oPlace){
    struct IntList il;
    string sEffects = GetLocalInt(oPlace, "place_fx");

    if(sEffects != ""){
        il = GetIntList(sEffects);
        if(il.n0 > 0) ApplyPermenatVisualToObject(il.n0, oPlace);
        if(il.n1 > 0) ApplyPermenatVisualToObject(il.n1, oPlace);
        if(il.n2 > 0) ApplyPermenatVisualToObject(il.n2, oPlace);
        if(il.n3 > 0) ApplyPermenatVisualToObject(il.n3, oPlace);
        if(il.n4 > 0) ApplyPermenatVisualToObject(il.n4, oPlace);
        if(il.n5 > 0) ApplyPermenatVisualToObject(il.n5, oPlace);
    }
}
