///////////////////////////////////
//: dno_at_lever_03b
//: Unlock & Open Door, then Close after delay.
//: 30 secs Delay.
/////////////////////////////
//: K9-69 ;o)
/////////////
#include "dno_craggy_inc"
void main() {
	if (!GetIsPC(GetLastUsedBy())) return;
	OpenSomeDoor("dno_AT_002_003c");
}
