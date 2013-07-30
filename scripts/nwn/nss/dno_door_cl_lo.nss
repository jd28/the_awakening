///////////////////////////////////
//: dno_door_cl_lo
//: Auto Door Close & Lock.
//: 20 sec timer.
/////////////////////////////
//: K9-69 ;o)
/////////////

void main()
{

DelayCommand(20.0,ActionCloseDoor(OBJECT_SELF));

SetLocked (OBJECT_SELF, TRUE);

}
