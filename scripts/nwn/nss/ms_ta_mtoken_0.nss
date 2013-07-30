int StartingConditional()
{
object oPC = GetPCSpeaker();

if (GetItemPossessedBy(oPC, "ms_monktoken") != OBJECT_INVALID) return FALSE;

return TRUE;
}

