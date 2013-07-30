///////////////////////////////////
//: dno_ta_ja2
//: Text Appears when Condition is Met.
//: .
/////////////////////////////
//: K9-69 ;o)
/////////////
int StartingConditional()
{
object oPC = GetPCSpeaker();

int nInt;
nInt=GetLocalInt(oPC, "NW_JOURNAL_ENTRYdno_JA1");

if (nInt >= 5)
   return FALSE;

return TRUE;
}

