int StartingConditional()
{
object oPC = GetPCSpeaker();

if (GetItemPossessedBy(oPC, "ms_pole") != OBJECT_INVALID) return FALSE;

return TRUE;
}

