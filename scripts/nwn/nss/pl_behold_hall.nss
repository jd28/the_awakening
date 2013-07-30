void main(){

    int nDoor = GetLocalInt(OBJECT_SELF, "CorrectDoor");
    // Only do it once per reset.
    if(nDoor > 0)
        return;

    SetLocalInt(OBJECT_SELF, "CorrectDoor", d6());

}
