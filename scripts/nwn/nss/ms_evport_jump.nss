void main()
{

object oPC = GetLastUsedBy();
    if (!GetIsPC(oPC)) return;

string sSelf = GetTag(OBJECT_SELF);
string sDest = "_DST";

int iLCV = GetLawChaosValue(oPC);      //:Current Law Chaos Value
int iGEV = GetGoodEvilValue(oPC);      //:Current Good Evil Value
int iAV = ((iLCV + iGEV) /2);          //:Alignment Value
int iCHpV = GetCurrentHitPoints(oPC);  //:Current Hitpoint Value
int iDV = ((iCHpV * iAV) /100);        //:Damage Value

effect eNeg = EffectDamageImmunityDecrease(DAMAGE_TYPE_MAGICAL, 20);
effect eDam = EffectDamage(iDV, DAMAGE_TYPE_NEGATIVE, DAMAGE_POWER_ENERGY);
effect eHarm = EffectLinkEffects(eNeg, eDam);

object oTarget;
location lTarget;
oTarget = GetWaypointByTag(sSelf + sDest);
lTarget = GetLocation(oTarget);

if (GetAreaFromLocation(lTarget)==OBJECT_INVALID) return;

AssignCommand(oPC, ClearAllActions());
DelayCommand(2.5, FloatingTextStringOnCreature("The power of the gate rends your body and threatens to corrupt your mind.", oPC));
DelayCommand(2.0, AssignCommand(oPC, ActionJumpToLocation(lTarget)));

int nInt;
nInt = GetObjectType(oTarget);

effect eRing = EffectVisualEffect(VFX_IMP_EVIL_HELP);
effect eLight = EffectVisualEffect(VFX_IMP_HARM);
effect eGib = EffectVisualEffect(VFX_COM_CHUNK_RED_LARGE);

ApplyEffectToObject(DURATION_TYPE_INSTANT, eRing, oTarget);
DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eRing, oPC));
DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLight, oPC));
DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eRing, oPC));
DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eGib, oPC));
DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHarm, oPC, 300.0f));

if (iAV >= 3)
{
DelayCommand(3.0, AdjustAlignment(oPC, ALIGNMENT_EVIL, 3, FALSE));
DelayCommand(3.0, AdjustAlignment(oPC, ALIGNMENT_CHAOTIC, 3, FALSE));


}
return;
}
