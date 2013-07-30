///////////////////////////////////
//: dno_doorclose
//: Auto Door Close.
//: 20 sec timer.
/////////////////////////////
//: K9-69 ;o)
/////////////

void main()
{

DelayCommand(20.0,ActionCloseDoor(OBJECT_SELF));
}
