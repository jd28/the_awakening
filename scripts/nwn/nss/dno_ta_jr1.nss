///////////////////////////////////
//: dno_ta_jr1
//: Text Appears when Condition is Met.
//: .
/////////////////////////////
//: K9-69 ;o)
/////////////
int StartingConditional()
{
object oPC = GetPCSpeaker();

int nInt;
nInt=GetLocalInt(oPC, "NW_JOURNAL_ENTRYdno_JR1");

if (nInt < 1)
   return FALSE;

return TRUE;
}

