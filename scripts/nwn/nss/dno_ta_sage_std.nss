int StartingConditional()
{
object oPC = GetPCSpeaker();

if (GetItemPossessedBy(oPC, "dno_Craggy_Pass") == OBJECT_INVALID) return FALSE;

return TRUE;
}
