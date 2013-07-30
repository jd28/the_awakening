#include "mod_const_inc"

void main(){
    object oPC = GetPCSpeaker();
    object oItem = GetLocalObject(oPC, "ITEM_TALK_TO");
    if(!GetIsObjectValid(oItem)) return;

    int nNumSpells = GetLocalInt(oItem, VAR_BUFF_ROCK_NUM_SPELLS), i;
    if(nNumSpells > 0){
        for (i = 1; i <= nNumSpells; i++){
            DeleteLocalInt(oItem, VAR_BUFF_ROCK_SPELL + IntToString(i));
            DeleteLocalInt(oItem, VAR_BUFF_ROCK_META + IntToString(i));
        }
        DeleteLocalInt(oItem, VAR_BUFF_ROCK_NUM_SPELLS);
        effect eVisual = EffectVisualEffect(VFX_IMP_BREACH);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, OBJECT_SELF);
    }
}
