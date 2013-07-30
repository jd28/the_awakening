void main()
{
    object oPC = GetPCSpeaker();

    SetLocalInt(oPC, GetTag(OBJECT_SELF), TRUE);
}
