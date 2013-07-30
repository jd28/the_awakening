void main()
{
    object oPC = GetPCSpeaker();
    // Helm
    int wiz = GetLevelByClass(CLASS_TYPE_WIZARD, oPC);
    int sorc = GetLevelByClass(CLASS_TYPE_SORCERER, oPC);
    string sResref = "nr_magnus3_helm";

    if(wiz > sorc){
        sResref += "2";
    }

    CreateItemOnObject(sResref, oPC);

    // Upgrade Buff Rock
    object oItem = GetFirstItemInInventory(oPC);
    while(oItem != OBJECT_INVALID){
        if(GetTag(oItem) == "pl_buffitisrock"){
            SetLocalInt(oItem, "PL_BUFF_COMBAT", TRUE);
        }
        oItem = GetNextItemInInventory(oPC);
    }

    // Only can do it once...
    object oStone = GetItemPossessedBy(oPC, "nr_task_stone");
    SetLocalInt(oStone, "Task", 99);
}
