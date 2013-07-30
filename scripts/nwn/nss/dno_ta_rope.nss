///////////////////////////////////
//: dno_ta_rope
//: Text Appears when Condition is Met.
//: .
/////////////////////////////
//: K9-69 ;o)
/////////////
int StartingConditional()
{
object oPC = GetPCSpeaker();

if (GetItemPossessedBy(oPC, "dno_Rope") == OBJECT_INVALID) return FALSE;

return TRUE;
}

