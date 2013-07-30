void main()
{

object oPC = GetEnteringObject();
    if (!GetIsPC(oPC)) return;

object oKeeperPresent = GetObjectByTag("dno_Chain_Keeper");
    if (GetIsObjectValid(oKeeperPresent)) return;


object oWP = GetWaypointByTag("dno_WP_Keeper");
    if (!GetIsObjectValid(oWP)) return;


location lLoc = GetLocation(oWP);

effect eVis = EffectVisualEffect(VFX_DUR_ICESKIN, FALSE);


object oChain1 = GetObjectByTag("dno_Inv_Chain_1");
object oChain2 = GetObjectByTag("dno_Inv_Chain_2");
object oChain3 = GetObjectByTag("dno_Inv_Chain_3");
object oChain4 = GetObjectByTag("dno_Inv_Chain_4");

object oChain1a = GetObjectByTag("dno_Inv_Chain_1a");
object oChain2a = GetObjectByTag("dno_Inv_Chain_2a");
object oChain3a = GetObjectByTag("dno_Inv_Chain_3a");
object oChain4a = GetObjectByTag("dno_Inv_Chain_4a");

/*
effect eChain1 = EffectBeam(VFX_BEAM_COLD, oChain1, BODY_NODE_CHEST);
effect eChain2 = EffectBeam(VFX_BEAM_COLD, oChain2, BODY_NODE_CHEST);
effect eChain3 = EffectBeam(VFX_BEAM_COLD, oChain3, BODY_NODE_CHEST);
effect eChain4 = EffectBeam(VFX_BEAM_COLD, oChain4, BODY_NODE_CHEST);
*/
object oKeeper = CreateObject(OBJECT_TYPE_PLACEABLE, "dno_chain_keeper", lLoc);


ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis, oKeeper);

/*
ApplyEffectToObject(DURATION_TYPE_PERMANENT, eChain1, oChain1a);
ApplyEffectToObject(DURATION_TYPE_PERMANENT, eChain2, oChain2a);
ApplyEffectToObject(DURATION_TYPE_PERMANENT, eChain3, oChain3a);
ApplyEffectToObject(DURATION_TYPE_PERMANENT, eChain4, oChain4a);
*/

}
