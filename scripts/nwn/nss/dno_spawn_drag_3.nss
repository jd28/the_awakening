void ActionCreate(string sCreature, location lLoc)
{
    CreateObject(OBJECT_TYPE_CREATURE, sCreature, lLoc);
}

void main()
{

object oPC = GetLastClosedBy();
        if (!GetIsPC(oPC)) return;

object oSelf = OBJECT_SELF;

object oBook = GetItemPossessedBy(OBJECT_SELF, "dno_Drag_3_Book");
        if (!GetIsObjectValid(oBook)) return;


object oTarget;
object oSpawn;
location lTarget;
location lSelf;

oTarget = GetWaypointByTag("dno_WP_KersaDrag");

lTarget = GetLocation(oTarget);
lSelf = GetLocation(oSelf);

string sCreature = "dno_kersa_drag_1";
location lLoc = lTarget;

DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMONDRAGON), lSelf));
DelayCommand(3.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMONDRAGON), lSelf));
DelayCommand(4.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMONDRAGON), lSelf));

DelayCommand(8.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMONDRAGON), lLoc));
DelayCommand(8.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_FIRESTORM), lLoc));
DelayCommand(8.0, ActionCreate(sCreature, lLoc));

DestroyObject(oBook);

}
