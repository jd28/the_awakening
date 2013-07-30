void main()
{

object oPC = GetPCSpeaker();
    if (!GetIsPC(oPC)) return;

object oSkull = GetItemPossessedBy(oPC, "ms_monkskull");
    if (GetIsObjectValid(oSkull))
{

DestroyObject(oSkull);

CreateItemOnObject("ms_yri_monk_robe", oPC);

SetLocalInt(oPC, "ms_Volran_Kill", 1);

}

return;

}
