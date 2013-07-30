int StartingConditional()
{
object oPC = GetPCSpeaker();

if ((GetLevelByClass(CLASS_TYPE_MONK, oPC)!=0))
return FALSE;

return TRUE;
}
