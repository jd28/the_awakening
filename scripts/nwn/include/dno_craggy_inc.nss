#include "mod_funcs_inc"
#include "nw_i0_tool"

void CreateFlame(string sFlame, location lFlame) {
    CreateObject(OBJECT_TYPE_PLACEABLE, sFlame, lFlame);
}

void DestroyChain(object oChain) {
    DestroyObject(oChain);
}

void CreateDraggy(string sDragon, location lDragon) {
    CreateObject(OBJECT_TYPE_CREATURE, sDragon, lDragon);
}

void DestroyWP(object oWPK) {
    DestroyObject(oWPK);
}

void SpawnDragon(object oPC, string item, string waypoint, string creature) {
	if (!GetIsPC(oPC)) return;

	object oBook = GetItemPossessedBy(OBJECT_SELF, item);
	if (!GetIsObjectValid(oBook)) return;

	location lSelf = GetLocation(OBJECT_SELF);
	location lLoc = GetLocation(GetWaypointByTag(waypoint));
	effect vfx = EffectVisualEffect(VFX_FNF_SUMMONDRAGON);

	DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, vfx, lSelf));
	DelayCommand(3.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, vfx, lSelf));
	DelayCommand(4.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, vfx, lSelf));

	DelayCommand(8.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, vfx, lLoc));
	DelayCommand(8.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_FIRESTORM), lLoc));
	DelayCommand(8.0, ObjectToVoid(CreateObject(OBJECT_TYPE_CREATURE, creature, lLoc)));

	DestroyObject(oBook);
}

void PrisonWatch(string statue, string flame) {
	object oKeeper = GetObjectByTag("dno_Chain_Keeper");
	object oStatue = GetObjectByTag(statue);
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

	location lWP = GetLocation(oWP);

	effect eFlame = EffectVisualEffect(VFX_IMP_MIRV_FLAME);
	effect eIce = EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION);
	effect eFire = EffectBeam(VFX_BEAM_FIRE, oChain3, BODY_NODE_CHEST);

    ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);

    DelayCommand(3.0, SoundObjectPlay(oSound));
	DelayCommand(3.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFlame, oStatue));
    DelayCommand(3.5, SoundObjectPlay(oSound));
	DelayCommand(3.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFlame, oStatue));
    DelayCommand(4.0, SoundObjectPlay(oSound));
	DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFlame, oStatue));
    DelayCommand(4.5, SoundObjectPlay(oSound));
	DelayCommand(4.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFlame, oStatue));
    DelayCommand(6.0, CreateFlame(flame, GetLocation(oStatue)));
	DelayCommand(7.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFire, oChain3a));

	int nInt = GetLocalInt(oKeeper, "dno_chains");
    if (nInt < 4) {
		IncrementLocalInt(oKeeper, "dno_chains");
	}
    else if (nInt == 4) {
		oExist = GetObjectByTag("dno_Secret_Drag");
		if (GetIsObjectValid(oExist)) return;

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
		DelayCommand(12.0, CreateDraggy("dno_secret_drag", lWP));
		DelayCommand(13.0, DestroyObject(oWP));
	}

    SetUseableFlag(OBJECT_SELF, FALSE);
    SetLocked(oKeeperDoor, FALSE);
}

void CraggyLight(string eye, string light) {
	object oPC = GetLastClosedBy();
	if (!GetIsPC(oPC)) return;
	if (GetIsObjectValid(GetItemPossessedBy(OBJECT_SELF, eye)))
		return;

	DestroyObject(GetObjectByTag(light), 0.5);
}

void ActionCreate(string sCreature, location lLoc) {
    object oMonster = CreateObject(OBJECT_TYPE_CREATURE, sCreature, lLoc);
    SetLocalInt(oMonster, "Despawn", 1);
}

void SpawnBoss(string blood, string book, string eye, string wp, string creature) {
	object oPC = GetLastClosedBy();
	if (!GetIsPC(oPC)) return;

	object oBlood = GetItemPossessedBy(OBJECT_SELF, blood);
	if (!GetIsObjectValid(oBlood)) return;

	object oBook =  GetItemPossessedBy(OBJECT_SELF, book);
	if (!GetIsObjectValid(oBook)) return;

	object oEye =  GetItemPossessedBy(OBJECT_SELF, eye);
	if (!GetIsObjectValid(oEye)) return;

	location lTarget = GetLocation(GetWaypointByTag(wp));

	DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_FIRESTORM), lTarget));
	DelayCommand(3.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_FIRESTORM), lTarget));
	DelayCommand(5.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMONDRAGON), lTarget));
	DelayCommand(6.0, ActionCreate(creature, lTarget));

	DestroyObject(oBlood);
	DestroyObject(oBook);
	DestroyObject(oEye);
}

void OpenSomeDoor(string tag) {
	object oD1 = GetObjectByTag(tag);
	ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE);
	SetLocked(oD1, FALSE);
	AssignCommand(oD1, ActionOpenDoor(oD1));
	DelayCommand(30.0, ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));
	DelayCommand(30.0, AssignCommand(oD1, ActionCloseDoor(oD1)));
	DelayCommand(30.0, AssignCommand(oD1, SetLocked(oD1, TRUE)));
}
