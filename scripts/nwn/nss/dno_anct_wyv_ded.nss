void main()
{
    object oKiller = GetLastKiller();
    if (!GetIsObjectValid(oKiller)) return;

    location lKiller = GetLocation(oKiller);

    CreateObject(OBJECT_TYPE_CREATURE, "dno_wyvern_young", lKiller, TRUE);
    CreateObject(OBJECT_TYPE_CREATURE, "dno_wyvern_young", lKiller, TRUE);
    CreateObject(OBJECT_TYPE_CREATURE, "dno_wyvern_young", lKiller, TRUE);
}
