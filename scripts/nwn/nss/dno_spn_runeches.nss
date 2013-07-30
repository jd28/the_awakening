void CreateChest1(string sChest1, location lLoc1)
{
    CreateObject(OBJECT_TYPE_PLACEABLE, sChest1, lLoc1);
}

void main()
{

object oPC = GetLastClosedBy();
        if (!GetIsPC(oPC)) return;

object oRune1 = GetItemPossessedBy(OBJECT_SELF, "dno_Axie_Rune");
        if (!GetIsObjectValid(oRune1)) return;

object oRune2 = GetItemPossessedBy(OBJECT_SELF, "dno_Kad_Rune");
        if (!GetIsObjectValid(oRune2)) return;

object oRune3 = GetItemPossessedBy(OBJECT_SELF, "dno_Kersa_Rune");
        if (!GetIsObjectValid(oRune3)) return;

object oRune4 = GetItemPossessedBy(OBJECT_SELF, "dno_Kerso_Rune");
        if (!GetIsObjectValid(oRune4)) return;

object oWP1;
object oChest1;
location lWP1;

oWP1 = GetWaypointByTag("dno_WP_Rune_Chest");

lWP1 = GetLocation(oWP1);

ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_UNDEAD_DRAGON), lWP1);
DelayCommand(1.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_UNDEAD_DRAGON), lWP1));
DelayCommand(3.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_UNDEAD_DRAGON), lWP1));


string sChest1 = "dno_rune_chest";

location lLoc1 = lWP1;

DelayCommand(8.0, CreateChest1(sChest1, lLoc1));

DestroyObject(oRune1);
DestroyObject(oRune2);
DestroyObject(oRune3);
DestroyObject(oRune4);

}
