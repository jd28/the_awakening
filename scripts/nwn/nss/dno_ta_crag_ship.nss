int StartingConditional()
{
object oPC = GetPCSpeaker();

if (GetXP(oPC) < 6000000) return FALSE;

return TRUE;
}
