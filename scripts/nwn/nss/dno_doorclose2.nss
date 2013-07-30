///////////////////////////////////
//: dno_doorclose2
//: Auto Door Close and Lock.
//: 20 sec & 20 min timers.
/////////////////////////////
//: K9-69 ;o)
/////////////

void main()
{

DelayCommand(20.0,ActionCloseDoor(OBJECT_SELF));
DelayCommand(1200.0, SetLocked(OBJECT_SELF, TRUE));

}
