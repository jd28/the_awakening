int StartingConditional()
{
object oPC = GetPCSpeaker();

if (GetItemPossessedBy(oPC, "dno_Drag_Port1") == OBJECT_INVALID) return FALSE;

return TRUE;
}
