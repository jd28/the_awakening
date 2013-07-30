#include"dno_func_chained"
void main()
{

object oKeeper = GetObjectByTag("dno_Chain_Keeper");
object oStatue1 = GetObjectByTag("dno_Inv_Statue_1");
object oSound = GetObjectByTag("dno_Flame_Sound");
object oWP = GetWaypointByTag("dno_WP_Keeper");

object oChain1 = GetObjectByTag("dno_Inv_Chain_1");
object oChain2 = GetObjectByTag("dno_Inv_Chain_2");
object oChain3 = GetObjectByTag("dno_Inv_Chain_3");
object oChain4 = GetObjectByTag("dno_Inv_Chain_4");

object oChain1a = GetObjectByTag("dno_Inv_Chain_1a");
object oChain2a = GetObjectByTag("dno_Inv_Chain_2a");
object oChain3a = GetObjectByTag("dno_Inv_Chain_3a");
object oChain4a = GetObjectByTag("dno_Inv_Chain_4a");
object oKeeperDoor = GetObjectByTag("dno_Keeper_Door");
object oExist;

location lStatue1 = GetLocation(oStatue1);
location lWP= GetLocation(oWP);

effect eFlame = EffectVisualEffect(VFX_IMP_MIRV_FLAME);
effect eIce = EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION);
effect eFire = EffectBeam(VFX_BEAM_FIRE, oChain1, BODY_NODE_CHEST);

    ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);

    DelayCommand(3.0, SoundObjectPlay(oSound));
DelayCommand(3.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFlame, oStatue1));
    DelayCommand(3.5, SoundObjectPlay(oSound));
DelayCommand(3.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFlame, oStatue1));
    DelayCommand(4.0, SoundObjectPlay(oSound));
DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFlame, oStatue1));
    DelayCommand(4.5, SoundObjectPlay(oSound));
DelayCommand(4.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFlame, oStatue1));

string sFlame = "dno_axie_flame";
location lFlame = lStatue1;

    DelayCommand(6.0, CreateFlame(sFlame, lFlame));

DelayCommand(7.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFire, oChain1a));

int nInt;
nInt = GetLocalInt(oKeeper, "dno_chains");
    if (nInt < 4)
{
nInt += 1;

SetLocalInt(oKeeper, "dno_chains", nInt);
}
    if (nInt == 4)
{
    oExist = GetObjectByTag("dno_Secret_Drag");
    if (GetIsObjectValid(oExist)) return;

string sDragon = "dno_secret_drag";
location lDragon = lWP;


    DelayCommand(10.5,  DestroyObject(oChain1a));
    DelayCommand(10.5,  DestroyObject(oChain2a));
    DelayCommand(10.5,  DestroyObject(oChain3a));
    DelayCommand(10.5,  DestroyObject(oChain4a));

    DelayCommand(11.0,  DestroyObject(GetObjectByTag("dno_Axie_Flame")));
    DelayCommand(11.0,  DestroyObject(GetObjectByTag("dno_Kad_Flame")));
    DelayCommand(11.0,  DestroyObject(GetObjectByTag("dno_Kersa_Flame")));
    DelayCommand(11.0,  DestroyObject(GetObjectByTag("dno_Kerso_Flame")));
    DelayCommand(11.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eIce, lWP));

    DelayCommand(11.0, DestroyObject(oKeeper));
    DelayCommand(11.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eIce, lWP));
    DelayCommand(12.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eIce, lWP));

    DelayCommand(12.0, CreateDraggy(sDragon, lDragon));

object oWPK = oWP;

    DelayCommand(13.0, DestroyObject(oWPK));
}

    SetUseableFlag(OBJECT_SELF, FALSE);
    SetLocked(oKeeperDoor, FALSE);
}
