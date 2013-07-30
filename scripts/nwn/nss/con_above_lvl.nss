// con_above_lvl

int StartingConditional(){

    int nLevel = GetLocalInt(OBJECT_SELF, "con_level");

    return GetHitDice(GetPCSpeaker()) > nLevel;
}
