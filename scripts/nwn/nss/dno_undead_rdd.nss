void main()
{


object oSelf = OBJECT_SELF;

effect eVis1 = EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR);
effect eVis2 = EffectVisualEffect(VFX_DUR_ICESKIN);
effect eVis3 = EffectVisualEffect(VFX_DUR_PROT_STONESKIN);
effect eVis4 = EffectVisualEffect(VFX_DUR_PROT_GREATER_STONESKIN);
effect eVis5 = EffectVisualEffect(VFX_DUR_DEATH_ARMOR);



int nEffect = d4();
switch(nEffect)
{
case 1:
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis5, oSelf);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis1, oSelf);

   break;

case 2:
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis5, oSelf);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis2, oSelf);

    break;

case 3:
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis5, oSelf);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis3, oSelf);

    break;

case 4:
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis5, oSelf);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis4, oSelf);

    break;
}
 //   ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis5, oSelf);


}
