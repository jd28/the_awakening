int StartingConditional()
{
    int class = GetLocalInt(OBJECT_SELF, "Class") - 1;
    int class_level = GetLocalInt(OBJECT_SELF, "ClassLevel");
    if(class_level == 0) class_level = 1;

    SendMessageToPC(GetPCSpeaker(),
        "Class: " + IntToString(class) + "Level: " + IntToString(class) + "GetLevelByClass: " + IntToString(GetLevelByClass(class, GetPCSpeaker())));

    return GetLevelByClass(class, GetPCSpeaker()) >= class_level;
}
