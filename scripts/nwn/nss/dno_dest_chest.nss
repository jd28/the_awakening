void main()
{

object oSelf;
object oItem;
location lTarget;
effect eEffect;

oSelf = (OBJECT_SELF);

oItem = GetFirstItemInInventory(oSelf);
    if (oItem != OBJECT_INVALID) return;

lTarget = GetLocation(oSelf);
eEffect = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_EVIL);



ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eEffect, lTarget);

//DelayCommand(0.5,
DestroyObject(oSelf);

//oItem = GetNextItemInInventory(oSelf);
}
