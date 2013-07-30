void main()
{
    string sRes = GetLocalString(OBJECT_SELF, "PL_DEATH_SPAWN");
    if(sRes != "")
        CreateObject(OBJECT_TYPE_CREATURE, sRes, GetLocation(OBJECT_SELF), FALSE, "Spawned");
}
