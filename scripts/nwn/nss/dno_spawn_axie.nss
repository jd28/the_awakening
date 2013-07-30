void ActionCreate(string sCreature, location lLoc)
{
    object oMonster = CreateObject(OBJECT_TYPE_CREATURE, sCreature, lLoc);
    SetLocalInt(oMonster, "Despawn", 1);
}

void main()
{

object oPC = GetLastClosedBy();
        if (!GetIsPC(oPC)) return;

object oBlood = GetItemPossessedBy(OBJECT_SELF, "dno_Axie_Blood");
        if (!GetIsObjectValid(oBlood)) return;

object oBook =  GetItemPossessedBy(OBJECT_SELF, "dno_Axie_Book");
        if (!GetIsObjectValid(oBook)) return;

object oEye =  GetItemPossessedBy(OBJECT_SELF, "dno_Axie_Eye");
        if (!GetIsObjectValid(oEye)) return;


    object oTarget;
    object oSpawn;
    location lTarget;

    oTarget = GetWaypointByTag("dno_WP_Axieros");

    lTarget = GetLocation(oTarget);

    DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_FIRESTORM), lTarget));
    DelayCommand(3.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_FIRESTORM), lTarget));
    DelayCommand(5.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMONDRAGON), lTarget));

    string sCreature = "dno_axieros_1";
    location lLoc = lTarget;

    DelayCommand(6.0, ActionCreate(sCreature, lLoc));

    DestroyObject(oBlood);
    DestroyObject(oBook);
    DestroyObject(oEye);

}
