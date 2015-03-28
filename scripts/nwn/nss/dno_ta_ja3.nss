///////////////////////////////////
//: dno_ta_ja3
//: Text Appears when Condition is Met.
//: .
/////////////////////////////
//: K9-69 ;o)
/////////////
int StartingConditional() {
	return GetItemPossessedBy(GetPCSpeaker(), "dno_BT") != OBJECT_INVALID;
}
