int StartingConditional()
{
object oPC = GetPCSpeaker();

if (GetItemPossessedBy(oPC, "dno_Keeper_Gift") != OBJECT_INVALID) return FALSE;

return TRUE;
}
