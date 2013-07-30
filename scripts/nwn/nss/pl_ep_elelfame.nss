#include "quest_func_inc"
#include "x2_inc_toollib"

void main(){
    object oPC = GetLastUsedBy();
    effect eEff;

    if(HasItem(oPC, "ep_crystal_air") &&
       HasItem(oPC, "ep_crystal_fire") &&
       HasItem(oPC, "ep_crystal_water") &&
       HasItem(oPC, "ep_crystal_earth"))
    {
        TakeNumItems(oPC, "ep_crystal_air", 1);
        TakeNumItems(oPC, "ep_crystal_earth", 1);
        TakeNumItems(oPC, "ep_crystal_fire", 1);
        TakeNumItems(oPC, "ep_crystal_water", 1);

        //eEff = EffectVisualEffect(498); // Cumbust/Inferno
        //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEff, OBJECT_SELF, 3.0f);
        TLVFXPillar(VFX_IMP_FLAME_M, GetLocation(OBJECT_SELF), 5, 0.1f,0.0f, 2.0f);
        CreateItemOnObject("pl_key_astral", oPC);
        GiveTakeGold(oPC, 10000, TRUE);
        GiveTakeXP(oPC, 1000, TRUE, TRUE);
    }
    else if(HasItem(oPC, "pl_key_astral")){
        SendMessageToPC(oPC, "The fire burns brightly.");
    }
    else{
        SendMessageToPC(oPC, "The fire burns but appears to be slowly dying.");
    }

}
