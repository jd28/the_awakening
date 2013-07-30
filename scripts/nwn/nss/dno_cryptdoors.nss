void main()
{
object oDoor = OBJECT_SELF;

DelayCommand(10.0, ActionCloseDoor(oDoor));

DelayCommand(11.0, SetLocked(oDoor, TRUE));


}
