///////////////////////////////////
//: dno_ta_ja3
//: Text Appears when Condition is Met.
//: .
/////////////////////////////
//: K9-69 ;o)
/////////////
int StartingConditional()
{
object oPC = GetPCSpeaker();

if (GetItemPossessedBy(oPC, "dno_BT") == OBJECT_INVALID) return FALSE;

return TRUE;
}

