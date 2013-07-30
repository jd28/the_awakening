void main()
{

object oPC = GetLastUsedBy();

if (!GetIsPC(oPC)) return;

string sSelf = GetTag(OBJECT_SELF);
string sPort = "_ep";
string sDest = "_WP";
string sDoor = "_Door";

effect eImplode = EffectVisualEffect(VFX_FNF_IMPLOSION);

object oExist = GetObjectByTag(sSelf + sPort);
if (GetIsObjectValid(oExist))  return;

object oDoor = GetObjectByTag(sSelf + sDoor);

ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE);

object oTarget;
object oSpawn;
location lTarget;

oTarget = GetWaypointByTag(sSelf + sDest);

lTarget = GetLocation(oTarget);

oSpawn = CreateObject(OBJECT_TYPE_PLACEABLE, sSelf + sPort, lTarget);


int nInt;
nInt = GetObjectType(oTarget);

ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImplode, lTarget);

DelayCommand(18.0, ActionCloseDoor(oDoor));
DelayCommand(19.0, AssignCommand(oDoor, SetLocked(oDoor, TRUE)));

DelayCommand(18.0, ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));
DelayCommand(18.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImplode, lTarget));
DelayCommand(20.0, DestroyObject(oSpawn));
}
