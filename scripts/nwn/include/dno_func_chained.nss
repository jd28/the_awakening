void CreateFlame(string sFlame, location lFlame)
{
    CreateObject(OBJECT_TYPE_PLACEABLE, sFlame, lFlame);
}

void DestroyChain(object oChain)
{
    DestroyObject(oChain);
}

void CreateDraggy(string sDragon, location lDragon)
{
    CreateObject(OBJECT_TYPE_CREATURE, sDragon, lDragon);
}

void DestroyWP(object oWPK)
{
    DestroyObject(oWPK);
}


