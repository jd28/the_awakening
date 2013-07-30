int StartingConditional()
{
object oPC = GetPCSpeaker();

if (GetItemPossessedBy(oPC, "ms_monkskull") == OBJECT_INVALID) return FALSE;

return TRUE;
}

