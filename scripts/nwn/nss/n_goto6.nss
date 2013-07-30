//ActionTaken script
void main()
{
    //Desired floor
    SetLocalInt(OBJECT_SELF, "GoToFloor", 6);
    ExecuteScript("n_hb_elevator", OBJECT_SELF);
}

