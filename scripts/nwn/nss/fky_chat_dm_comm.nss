//::////////////////////////////////////////////////////////////////////////:://
//:: SIMTools V3.0 Speech Integration & Management Tools Version 3.0        :://
//:: Created By: FunkySwerve                                                :://
//:: Created On: April 4 2006                                               :://
//:: Last Updated: March 27 2007                                            :://
//:: With Thanks To:                                                        :://
//:: Dumbo - for his amazing plugin                                         :://
//:: Virusman - for Linux versions, and for the reset plugin, and for       :://
//::    his excellent events plugin, without which this update would not    :://
//::    be possible                                                         :://
//:: Dazzle - for his script samples                                        :://
//:: Butch - for the emote wand scripts                                     :://
//:: The DMFI project - for the languages conversions and many of the emotes:://
//:: Lanessar and the players of the Myth Drannor PW - for the new languages:://
//:: The players and DMs of Higher Ground for their input and playtesting   :://
//::////////////////////////////////////////////////////////////////////////:://

#include "fky_chat_inc"

void DoDMArea(struct pl_chat_command pcc){ // "area "
    pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 5);

    pcc.oTarget = VerifyTarget(pcc, AREA_TARGET_OK);
    if (!GetIsObjectValid(pcc.oTarget)) return;

    object oArea = GetArea(pcc.oTarget);

    if (pcc.sCommand == "clean"){
        AreaClean(oArea, pcc.oPC);
        FloatingTextStringOnCreature(C_RED+GetName(oArea)+" has been cleaned!"+C_END, pcc.oPC, FALSE);
    }
    // Spawns
    else if (pcc.sCommand == "spawns on"){
        AreaSpawnsActivate(oArea, pcc.oPC);
    }
    else if (pcc.sCommand == "spawns off"){
        AreaSpawnsDeactivate(oArea, pcc.oPC);
    }
    // Loot
    else if (pcc.sCommand == "loot on"){
        AreaLootActivate(oArea, pcc.oPC);
    }
    else if (pcc.sCommand == "loot off"){
        AreaLootDeactivate(oArea, pcc.oPC);
    }
    // Weather
    else if (pcc.sCommand == "clear"){
        SetWeather(oArea, WEATHER_CLEAR);
        FloatingTextStringOnCreature(C_RED+WEATHER_CHANGE+C_END, pcc.oPC, FALSE);
    }
    else if (pcc.sCommand == "rain"){
        SetWeather(oArea, WEATHER_RAIN);
        FloatingTextStringOnCreature(C_RED+WEATHER_CHANGE+C_END, pcc.oPC, FALSE);
    }
    else if (pcc.sCommand == "defualt"){
        SetWeather(oArea, WEATHER_USE_AREA_SETTINGS);
        FloatingTextStringOnCreature(C_RED+WEATHER_CHANGE+C_END, pcc.oPC, FALSE);
    }
    else if (pcc.sCommand == "snow"){
        SetWeather(oArea, WEATHER_SNOW);
        FloatingTextStringOnCreature(C_RED+WEATHER_CHANGE+C_END, pcc.oPC, FALSE);
    }
    else CommandRedirect(pcc.oPC, 16);
}

void DoDMBan(struct pl_chat_command pcc){
    string  sKey;

    pcc.oTarget = VerifyTarget(pcc);
    if (!GetIsObjectValid(pcc.oTarget)) return;
    if ((VerifyDMKey(pcc.oTarget)) || (VerifyAdminKey(pcc.oTarget)))//these commands may not be used on dms
    {
        FloatingTextStringOnCreature(C_RED+NOBANDM+C_END, pcc.oPC);
        return;
    }

    if (pcc.sCommand == "ban temp"){
        SetLocalInt(pcc.oTarget, "FKY_CHT_BANDM", TRUE);//temp ban em
        SendMessageToPC(pcc.oTarget, C_RED+TEMPBANDM1+C_END);//tell em
        SendMessageToPC(pcc.oPC, C_RED+TEMPBANGEN+ GetName(pcc.oTarget)+TEMPBANDM2+C_END);
    }
    else if (pcc.sCommand == "ban player perm"){
        sKey = GetPCPublicCDKey(pcc.oTarget);
        SetLocalInt(pcc.oTarget, "FKY_CHT_BANPLAYER", TRUE);
        SET("ban:player:"+sKey, "1");

        FloatingTextStringOnCreature(C_RED+PERMABAN1+C_END, pcc.oTarget);//tell em
        AssignCommand(GetModule(), DelayCommand(6.0, BootPlayer(pcc.oTarget)));//boot em
        SendMessageToPC(pcc.oPC, C_RED+PERMABANGEN+ GetName(pcc.oTarget) +PERMABAN2+C_END);
    }
    else if (pcc.sCommand == "ban player temp"){
        SetLocalInt(pcc.oTarget, "FKY_CHT_BANPLAYER", TRUE);//temp ban em
        FloatingTextStringOnCreature(C_RED+TEMPBAN+C_END, pcc.oTarget);//tell em
        AssignCommand(GetModule(), DelayCommand(6.0, BootPlayer(pcc.oTarget)));//boot em
        SendMessageToPC(pcc.oPC, C_RED+TEMPBANGEN+GetName(pcc.oTarget) +TEMPBAN2+C_END);
    }
    else if (pcc.sCommand == "ban shout temp"){
        SetLocalInt(pcc.oTarget, "FKY_CHT_BANSHOUT", TRUE);//temp ban em
        SendMessageToPC(pcc.oTarget, C_RED+TEMPBANSHT+C_END);//tell em
        SendMessageToPC(pcc.oPC, C_RED+TEMPBANGEN+GetName(pcc.oTarget) +TEMPBANSHT2+C_END);
        if (GetLocalString(pcc.oTarget, "FKY_CHT_BANREASON") == "") SetLocalString(pcc.oTarget, "FKY_CHT_BANREASON", BANNEDBY + GetName(pcc.oPC));
    }
    else if (pcc.sCommand == "ban shout perm"){
        sKey = GetPCPublicCDKey(pcc.oTarget);
        SetLocalInt(pcc.oTarget, "FKY_CHT_BANSHOUT", TRUE);//temp ban em
        if (GetLocalString(pcc.oTarget, "FKY_CHT_BANREASON") == "") SetLocalString(pcc.oTarget, "FKY_CHT_BANREASON", BANNEDBY + GetName(pcc.oPC));

        SET("ban:shout:"+sKey, "1");
        SendMessageToPC(pcc.oTarget, C_RED+PERMBANSHT1+C_END);//tell em
        SendMessageToPC(pcc.oPC, C_RED+PERMABANGEN+ GetName(pcc.oTarget) +PERMBANSHT2+C_END);
    }
    else CommandRedirect(pcc.oPC, 16);
}


void DoDMUnban(struct pl_chat_command pcc){
    string sKey;

    if (pcc.sCommand == "unban dm"){
        pcc.oTarget = VerifyTarget(pcc, OBJECT_TARGET);
        if (!GetIsObjectValid(pcc.oTarget)) return;
        DeleteLocalInt(pcc.oTarget, "FKY_CHT_BANDM");
        SendMessageToPC(pcc.oTarget, C_RED+UNBAN1+C_END);
        SendMessageToPC(pcc.oPC, C_RED+UNBANGEN+ GetName(pcc.oTarget) +UNBAN2+C_END);
    }
    else if (pcc.sCommand == "unban shout")
    {
        pcc.oTarget = VerifyTarget(pcc, OBJECT_TARGET);
        if (!GetIsObjectValid(pcc.oTarget)) return;
        sKey = GetPCPublicCDKey(pcc.oTarget);
        DeleteLocalInt(pcc.oTarget, "FKY_CHT_BANSHOUT");
        DeleteLocalString(pcc.oTarget, "FKY_CHT_BANREASON");//delete the reason they were banned and by whom

        DEL("ban:shout:"+sKey);
        SendMessageToPC(pcc.oTarget, C_RED+UNBAN3+C_END);
        SendMessageToPC(pcc.oPC, C_RED+UNBANGEN+ GetName(pcc.oTarget) +UNBAN4+C_END);
    }
}

void DoDMBoot(struct pl_chat_command pcc){
    string  sKey;
    pcc.oTarget = VerifyTarget(pcc);
    if (!GetIsObjectValid(pcc.oTarget)) return;
    if ((VerifyDMKey(pcc.oTarget)) || (VerifyAdminKey(pcc.oTarget)))//these commands may not be used on dms
    {
        FloatingTextStringOnCreature(C_RED+NOBOOTDM+C_END, pcc.oPC);
        return;
    }
    BootPlayer(pcc.oTarget);
    FloatingTextStringOnCreature(C_RED+BOOTED+GetName(pcc.oTarget)+ "!"+C_END, pcc.oPC, FALSE);
}

void DoDMCreate(struct pl_chat_command pcc){
    string  sKey;
    object oNewItem;

    pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 7);
    pcc.oTarget = VerifyTarget(pcc, OBJECT_TARGET, DM_COMMAND_SYMBOL, FALSE);
    if (!GetIsObjectValid(pcc.oTarget)) return;
    oNewItem = CreateItemOnObject(pcc.sCommand, pcc.oTarget);
    if (GetIsObjectValid(oNewItem)){
        if (!GetIsPC(pcc.oTarget)) SetDroppableFlag(oNewItem, TRUE);//set to droppable so creature drops on death
        SendMessageToPC(pcc.oPC, C_RED+CREATE1+ GetName(oNewItem) +CREATE2+ GetName(pcc.oTarget) + "!"+C_END);
    }
    else SendMessageToPC(pcc.oPC, C_RED+CREATE3+C_END);
}

void DoDMChange(struct pl_chat_command pcc){//dm_change <thing> <value>
    string  sKey;
    int nAppear;
    object oStorage;

    pcc.oTarget = VerifyTarget(pcc, OBJECT_TARGET, DM_COMMAND_SYMBOL, FALSE, FALSE);
    if (!GetIsObjectValid(pcc.oTarget)) return;

    pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 7);
    pcc.sOriginal = GetStringRight(pcc.sOriginal, GetStringLength(pcc.sOriginal) - 7);

    if (GetStringLeft(pcc.sCommand, 7) == "appear "){ //dm_change appear <# | base>
        pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 7);

        if(GetObjectType(pcc.oTarget) == OBJECT_TYPE_PLACEABLE){
            if(!VerifyNumber(pcc.oPC, pcc.sCommand)) return;

            SetPlotFlag(pcc.oTarget, FALSE);
            DestroyObject(pcc.oTarget, 1.0f);
            object oPlace = CreateObject(OBJECT_TYPE_PLACEABLE, GetResRef(pcc.oTarget), GetLocation(pcc.oTarget));
            int nReturn = SetPlaceableAppearance(oPlace, StringToInt(pcc.sCommand));
            SetLocalInt(oPlace, "PLACEABLE_APPEARANCE", nReturn + 1);
            //SpeakString(pcc.sCommand +" "+IntToString(nReturn));
            FloatingTextStringOnCreature(C_GREEN+APP_CHANGED+C_END, pcc.oPC);
            return;
        }

        if (GetIsPC(pcc.oTarget)){
            nAppear = GetPersistantInt(pcc.oTarget, "appear");
            if (!nAppear) //if original appearance has not been stored
            {
                nAppear = GetAppearanceType(pcc.oTarget);
                SetLocalInt(pcc.oTarget, "FKY_CHAT_TRUEAPPEAR", nAppear);
                SetPersistantInt(pcc.oTarget, "appear", nAppear);
            }
        }

        if ((VerifyDMKey(pcc.oTarget) || VerifyAdminKey(pcc.oTarget)) && (pcc.oTarget != pcc.oPC))
            FloatingTextStringOnCreature(C_RED+NO_DM_APPEAR+C_END, pcc.oPC);
        else{
            if (pcc.sCommand == "base"){
                if (GetIsPC(pcc.oTarget)) SetCreatureAppearanceType(pcc.oTarget, nAppear);
                else FloatingTextStringOnCreature(C_RED+NO_BASE_NPC+C_END, pcc.oPC);
            }
            else{
                if(!VerifyNumber(pcc.oPC, pcc.sCommand)) return;
                SetCreatureAppearanceType(pcc.oTarget, StringToInt(pcc.sCommand));
                FloatingTextStringOnCreature(C_GREEN+APP_CHANGED+C_END, pcc.oPC);
            }
        }
    }
    else if (GetStringLeft(pcc.sCommand, 5) == "name "){ //dm_change name <name>

        pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 5);
        pcc.sOriginal = GetStringRight(pcc.sOriginal, GetStringLength(pcc.sOriginal) - 5);
        if (GetIsPC(pcc.oTarget)){
            ErrorMessage(pcc.oPC, "You may not use this command on PCs!");
            return;
        }

        SetName(pcc.oTarget,  pcc.sOriginal);
        FloatingTextStringOnCreature(C_GREEN+"Name changed!"+C_END, pcc.oPC);
    }
    else if (GetStringLeft(pcc.sCommand, 5) == "desc "){ //dm_change desc <description>
        pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 5);
        pcc.sOriginal = GetStringRight(pcc.sOriginal, GetStringLength(pcc.sOriginal) - 5);
        if (GetIsPC(pcc.oTarget)){
            ErrorMessage(pcc.oPC, "You may not use this command on PCs!");
            return;
        }

        SetDescription(pcc.oTarget, pcc.sOriginal);
        FloatingTextStringOnCreature(C_GREEN+"Description changed!"+C_END, pcc.oPC);
    }
    else if (GetStringLeft(pcc.sCommand, 5) == "wing "){ //dm_change wing <#>
        if (GetObjectType(pcc.oTarget) != OBJECT_TYPE_CREATURE){
            ErrorMessage(pcc.oPC, "You may only use this on creatures!");
            return;
        }

        pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 5);
        if(!VerifyNumber(pcc.oPC, pcc.sCommand)) return;
        SetCreatureWingType(StringToInt(pcc.sCommand), pcc.oTarget);
        FloatingTextStringOnCreature(C_GREEN+"Wings changed!"+C_END, pcc.oPC);

    }
    else if (GetStringLeft(pcc.sCommand, 5) == "tail "){ //dm_change wing <#>
        if (GetObjectType(pcc.oTarget) != OBJECT_TYPE_CREATURE){
            ErrorMessage(pcc.oPC, "You may only use this on creatures!");
            return;
        }

        pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 5);
        if(!VerifyNumber(pcc.oPC, pcc.sCommand)) return;
        SetCreatureTailType(StringToInt(pcc.sCommand), pcc.oTarget);
        FloatingTextStringOnCreature(C_GREEN+"Tail changed!"+C_END, pcc.oPC);
    }
    else if (GetStringLeft(pcc.sCommand, 11) == "bodycolors "){ //dm_change bodycolors <#|*>  <#|*>  <#|*>  <#|*>
        pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 11);
        //<#|*>  <#|*>  <#|*>  <#|*>
        struct SubString ssColor = GetFirstSubString(pcc.sCommand);
        //Hair
        if(ssColor.first != "*"){
            if(!VerifyNumber(pcc.oPC, ssColor.first)) return;
            SetColor(pcc.oTarget, COLOR_CHANNEL_HAIR, StringToInt(ssColor.first));
        }

        //Skin
        ssColor = GetFirstSubString(ssColor.rest);
        if(ssColor.first != "*"){
            if(!VerifyNumber(pcc.oPC, ssColor.first)) return;
            SetColor(pcc.oTarget, COLOR_CHANNEL_SKIN, StringToInt(ssColor.first));
        }
        //Tatoo1
        ssColor = GetFirstSubString(ssColor.rest);
        if(ssColor.first != "*"){
            if(!VerifyNumber(pcc.oPC, ssColor.first)) return;
            SetColor(pcc.oTarget, COLOR_CHANNEL_TATTOO_1, StringToInt(ssColor.first));
        }
        //Tatoo2
        ssColor = GetFirstSubString(ssColor.rest);
        if(ssColor.first != "*"){
            if(!VerifyNumber(pcc.oPC, ssColor.first)) return;
            SetColor(pcc.oTarget, COLOR_CHANNEL_TATTOO_2, StringToInt(ssColor.first));
        }

        ApplyVisualToObject(VFX_DUR_CUTSCENE_INVISIBILITY, pcc.oTarget, 1.0f);
    }
    else ErrorMessage(pcc.oPC, "Invalid command!");
}

void DoDMChangeAppear(struct pl_chat_command pcc){//dm_change
//appear <value>
    string  sKey;
    int nAppear;
    object oStorage;

    pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 14);
    pcc.oTarget = VerifyTarget(pcc, OBJECT_TARGET, DM_COMMAND_SYMBOL, FALSE);
    if (!GetIsObjectValid(pcc.oTarget)) return;
    if (GetIsPC(pcc.oTarget)){
        nAppear = GetLocalInt(pcc.oTarget, "FKY_CHAT_TRUEAPPEAR");
        if (!nAppear) //if original appearance has not been stored
        {
            nAppear = GetAppearanceType(pcc.oTarget);
            SetLocalInt(pcc.oTarget, "FKY_CHAT_TRUEAPPEAR", nAppear);
            SetPersistantInt(pcc.oTarget, "appear", nAppear);
        }
    }
    if ((VerifyDMKey(pcc.oTarget) || VerifyAdminKey(pcc.oTarget))&& (pcc.oTarget != pcc.oPC))
        FloatingTextStringOnCreature(C_RED+NO_DM_APPEAR+C_END, pcc.oPC);
    else{
        if (pcc.sCommand == "base"){
            if (GetIsPC(pcc.oTarget)) SetCreatureAppearanceType(pcc.oTarget, nAppear);
            else FloatingTextStringOnCreature(C_RED+NO_BASE_NPC+C_END, pcc.oPC);
        }
        else{
            if(!VerifyNumber(pcc.oPC, pcc.sCommand)) return;
            SetCreatureAppearanceType(pcc.oTarget, StringToInt(pcc.sCommand));
            FloatingTextStringOnCreature(C_GREEN+APP_CHANGED+C_END, pcc.oPC);
        }
    }
}

void DoDMChangeAppearPerm(struct pl_chat_command pcc){//dm_change_perm appear <value>
    string  sKey;
    int nAppear;
    object oStorage;

    pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 19);
    pcc.oTarget = VerifyTarget(pcc, OBJECT_TARGET, DM_COMMAND_SYMBOL, FALSE);
    if (!GetIsObjectValid(pcc.oTarget)) return;

    if ((VerifyDMKey(pcc.oTarget) || VerifyAdminKey(pcc.oTarget))&& (pcc.oTarget != pcc.oPC))
        FloatingTextStringOnCreature(C_RED+NO_DM_APPEAR+C_END, pcc.oPC);
    else{
        if(!VerifyNumber(pcc.oPC, pcc.sCommand)) return;
        SetCreatureAppearanceType(pcc.oTarget, StringToInt(pcc.sCommand));
        FloatingTextStringOnCreature(C_GREEN+APP_CHANGED+C_END, pcc.oPC);
    }
}

void DoDMFireworks(struct pl_chat_command pcc){
    //Edit Settings here ///////////////////////////////////////////////////////
    float z = 7.5;       //How High the fireworks go before exploding
    //DO NOT EDIT BELOW THIS LINE //////////////////////////////////////////////
    object oArea = GetArea(pcc.oPC), oTarget;

    //Check to see if one is already in progress
    if (GetLocalInt(oArea,"FIREWORKSHOW"))
    {
        //Firework Show is in progress tell user that.
        SendMessageToPC(pcc.oPC,"There is already a firework show in progress");
    }
    else{
        oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", GetLocation(pcc.oPC), FALSE, "FireworksSource");
        SetPlotFlag(oTarget, TRUE);
        ExecuteScript("g_startfireworks", oTarget);
    }
}

void DoDMFreeze(struct pl_chat_command pcc){
    string sUppercase = GetStringUpperCase(pcc.sCommand);

    pcc.oTarget = VerifyTarget(pcc, OBJECT_TARGET, DM_COMMAND_SYMBOL, FALSE);
    if (!GetIsObjectValid(pcc.oTarget)) return;

    if ((!VerifyDMKey(pcc.oTarget)) && (!VerifyAdminKey(pcc.oTarget)))//these commands may not be used on dms
    {
        SetCommandable(FALSE, pcc.oTarget);
        SendMessageToPC(pcc.oTarget, C_RED+FREEZE1+C_END);
        SendMessageToPC(pcc.oPC, C_RED+FREEZE2+ GetName(pcc.oTarget) + "!"+C_END);
    }
    else FloatingTextStringOnCreature(C_RED+FREEZE3+C_END, pcc.oPC);
}

void DoDMFX(struct pl_chat_command pcc){
    string sUppercase = GetStringUpperCase(pcc.sCommand);

    if (GetStringLeft(pcc.sCommand, 3) == "fx "){
        pcc.sCommand = GetStringLowerCase(GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 3));
        pcc.oTarget = VerifyTarget(pcc, OBJECT_TARGET, DM_COMMAND_SYMBOL, FALSE, FALSE);
        if (!GetIsObjectValid(pcc.oTarget)) return;
        AssignCommand(pcc.oPC, DoVFX(pcc.oPC, pcc.sCommand, pcc.oTarget));//assigncommand ensures DM is creator
    }
    else if (GetStringLeft(pcc.sCommand, 7) == "fx_loc "){
        location lLoc =  VerifyLocation(pcc.oPC, sUppercase);
        if (!GetIsObjectValid(GetAreaFromLocation(lLoc))) return;
        pcc.sCommand = GetStringLowerCase(GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 7));
        AssignCommand(pcc.oPC, DoVFX(pcc.oPC, pcc.sCommand, pcc.oTarget, TRUE));//assigncommand ensures DM is creator
    }
    else if (pcc.sCommand == "fx_rem"){
        pcc.oTarget = VerifyTarget(pcc, OBJECT_TARGET, DM_COMMAND_SYMBOL, FALSE, FALSE);
        if (!GetIsObjectValid(pcc.oTarget)) return;
        effect eEffect = GetFirstEffect(pcc.oTarget);
        while (GetIsEffectValid(eEffect)){
            if (((GetEffectType(eEffect) == EFFECT_TYPE_VISUALEFFECT) || (GetEffectType(eEffect) == EFFECT_TYPE_BEAM)) && (GetEffectCreator(eEffect) == pcc.oPC)){
                DelayCommand(0.1, RemoveEffect(pcc.oTarget, eEffect));
            }
            eEffect = GetNextEffect(pcc.oTarget);
        }
    }
    else if (GetStringLeft(pcc.sCommand, 8) == "fx_list_")  // dur, bea, eye, imp, com, fnf
    {
        pcc.sCommand = GetStringLowerCase(GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 8));
        if (pcc.sCommand == "dur" || pcc.sCommand == "bea" || pcc.sCommand == "eye" || pcc.sCommand == "imp" || pcc.sCommand == "com" || pcc.sCommand == "fnf") ListFX(pcc.oPC, pcc.sCommand);
        else CommandRedirect(pcc.oPC, 25);
    }
    else CommandRedirect(pcc.oPC, 25);
}

void DoGetBan(struct pl_chat_command pcc){
    string  sKey;

    if (pcc.sCommand == "getbanlist") GetBanList(pcc.oPC);
    else if (pcc.sCommand == "getbanreason"){
        pcc.oTarget = VerifyTarget(pcc, OBJECT_TARGET);
        if (!GetIsObjectValid(pcc.oTarget)) return;
        sKey = GetLocalString(pcc.oTarget, "FKY_CHT_BANREASON");
        if (sKey == "") SendMessageToPC(pcc.oPC, C_RED+BANREASON1+C_END);
        else SendMessageToPC(pcc.oPC, C_RED+BANREASON2+ sKey + C_END);
    }
    else CommandRedirect(pcc.oPC, 16);
}

void DoDMGive(struct pl_chat_command pcc){ // "dm_give <command>"
    string  sStore;
    int nColor;
    object oStorage;

    pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 5);


    pcc.oTarget = VerifyTarget(pcc, OBJECT_TARGET);
    if (!GetIsObjectValid(pcc.oTarget)) return;

    if (GetStringLeft(pcc.sCommand, 3) == "xp "){
        pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 3);
        if(!VerifyNumber(pcc.oPC, pcc.sCommand)) return;
        GiveTakeXP(pcc.oTarget, StringToInt(pcc.sCommand), TRUE, FALSE, pcc.oPC);
    }
    else if (GetStringLeft(pcc.sCommand, 6) == "level "){
        pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 6);
        if(!VerifyNumber(pcc.oPC, pcc.sCommand)) return;
        nColor = StringToInt(pcc.sCommand);
        if (nColor == 1) sStore = XP12;
        else sStore = XP13;
        GiveLevel(pcc.oTarget, pcc.oPC, nColor);
        SendMessageToPC(pcc.oPC, C_RED+XP1+ IntToString(nColor)+sStore+GetName(pcc.oTarget) + "!"+C_END);
    }
    else if (GetStringLeft(pcc.sCommand, 5) == "gold "){
        pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 5);
        if(!VerifyNumber(pcc.oPC, pcc.sCommand)) return;
        nColor = StringToInt(pcc.sCommand);
        GiveGoldToCreature(pcc.oTarget, nColor);
        SendMessageToPC(pcc.oPC, C_GREEN+"You have given "+IntToString(nColor)+"gp to " + GetName(pcc.oTarget) + "!"+C_END);
    }
    else if (GetStringLeft(pcc.sCommand, 9) == "party xp "){
        pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 9);
        if(!VerifyNumber(pcc.oPC, pcc.sCommand)) return;
        oStorage = GetFirstFactionMember(pcc.oTarget);
        nColor = StringToInt(pcc.sCommand);
	GiveTakeXP(pcc.oTarget, nColor, TRUE, TRUE, pcc.oPC);
    }
    else if (GetStringLeft(pcc.sCommand, 12) == "party level "){
        pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 12);
        if(!VerifyNumber(pcc.oPC, pcc.sCommand)) return;
        oStorage = GetFirstFactionMember(pcc.oTarget);
        nColor = StringToInt(pcc.sCommand);
        if (nColor == 1) sStore = XP12;
        else sStore = XP13;
        while (GetIsObjectValid(oStorage)){
            GiveLevel(oStorage, pcc.oPC, nColor, FALSE);//function has built-in message to each, FALSE stops it
            oStorage = GetNextFactionMember(pcc.oTarget);
        }
        SendMessageToPC(pcc.oPC, C_RED+XP1+ IntToString(StringToInt(pcc.sCommand))+sStore+GetName(pcc.oTarget) + XP11+C_END);
    }
    else if (GetStringLeft(pcc.sCommand, 11) == "party gold "){
        pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 11);
        if(!VerifyNumber(pcc.oPC, pcc.sCommand)) return;
        oStorage = GetFirstFactionMember(pcc.oTarget);
        nColor = StringToInt(pcc.sCommand);
        while (GetIsObjectValid(oStorage)){
            nColor = StringToInt(pcc.sCommand);
            oStorage = GetNextFactionMember(pcc.oTarget);
        }
        SendMessageToPC(pcc.oPC, C_GREEN+"You have given "+IntToString(nColor)+"gp to " + GetName(pcc.oTarget) + " and their party!"+C_END);
    }
    else CommandRedirect(pcc.oPC, 19);
}

void DoDMGuild(struct pl_chat_command pcc){ //dm_guild X
    pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 6);
    if(!VerifyNumber(pcc.oPC, pcc.sCommand)) return;

    int nGuild = StringToInt(pcc.sCommand);

    pcc.oTarget = VerifyTarget(pcc, OBJECT_TARGET);
    if (!GetIsObjectValid(pcc.oTarget)) return;

    SetLocalInt(pcc.oTarget, VAR_PC_GUILD, nGuild);

    string sMsg = C_GREEN+"Guild Affiliation Set: ";
    sMsg += GetGuildName(nGuild);
    sMsg += "("+GetGuildAbbreviation(nGuild)+")";
    FloatingTextStringOnCreature(sMsg+C_END, pcc.oPC, FALSE);
}

void DoDMHeal(struct pl_chat_command pcc){
    pcc.oTarget = VerifyTarget(pcc, OBJECT_TARGET, DM_COMMAND_SYMBOL, FALSE, FALSE);
    if (!GetIsObjectValid(pcc.oTarget)) return;

    ModifyCurrentHitPoints(pcc.oTarget, GetMaxHitPoints(pcc.oTarget) - GetCurrentHitPoints(pcc.oTarget));
}

void DoDMHide(struct pl_chat_command pcc){
    string sUppercase = GetStringUpperCase(pcc.sCommand);

    pcc.oTarget = VerifyTarget(pcc, OBJECT_TARGET);
    if (!GetIsObjectValid(pcc.oTarget)) return;
    ExploreAreaForPlayer(GetArea(pcc.oTarget), pcc.oTarget, FALSE);
    FloatingTextStringOnCreature(C_RED+EXPLORE2+C_END, pcc.oPC, FALSE);
}

void DoDMIgnore(struct pl_chat_command pcc){
    if (pcc.sCommand == "ignoredm"){
        if ((DM_PLAYERS_HEAR_DM && VerifyDMKey(pcc.oPC) && (!GetIsDM(pcc.oPC))) || (ADMIN_PLAYERS_HEAR_DM && VerifyAdminKey(pcc.oPC) && (!GetIsDM(pcc.oPC)))){
            SetLocalInt(pcc.oPC, "FKY_CHT_IGNOREDM", TRUE);//they will not receive dm messages
            SendMessageToPC(pcc.oPC, C_RED+IGNORED+C_END);
        }
        else CommandRedirect(pcc.oPC, 11);
    }
    else if (pcc.sCommand == "ignoremeta"){
        if ((DMS_HEAR_META && VerifyDMKey(pcc.oPC) && GetIsDM(pcc.oPC)) ||
        (DM_PLAYERS_HEAR_META && VerifyDMKey(pcc.oPC) && (!GetIsDM(pcc.oPC))) ||
        (ADMIN_DMS_HEAR_META && VerifyAdminKey(pcc.oPC) && GetIsDM(pcc.oPC)) ||
        (ADMIN_PLAYERS_HEAR_META && VerifyAdminKey(pcc.oPC) && (!GetIsDM(pcc.oPC)))){
            SetLocalInt(pcc.oPC, "FKY_CHT_IGNOREMETA", TRUE);//they will not receive dm messages
            SendMessageToPC(pcc.oPC, C_RED+IGNOREM+C_END);
        }
        else CommandRedirect(pcc.oPC, 11);
    }
    else if (pcc.sCommand == "ignoretells"){
        if ((DMS_HEAR_TELLS && VerifyDMKey(pcc.oPC) && GetIsDM(pcc.oPC)) ||
        (DM_PLAYERS_HEAR_TELLS && VerifyDMKey(pcc.oPC) && (!GetIsDM(pcc.oPC))) ||
        (ADMIN_DMS_HEAR_TELLS && VerifyAdminKey(pcc.oPC) && GetIsDM(pcc.oPC)) ||
        (ADMIN_PLAYERS_HEAR_TELLS && VerifyAdminKey(pcc.oPC) && (!GetIsDM(pcc.oPC)))){
            SetLocalInt(pcc.oPC, "FKY_CHT_IGNORETELLS", TRUE);//they will not receive tells
            SendMessageToPC(pcc.oPC, C_RED+IGNORET+C_END);
        }
        else CommandRedirect(pcc.oPC, 11);
    }
    else if (((DM_PLAYERS_HEAR_DM && VerifyDMKey(pcc.oPC) && (!GetIsDM(pcc.oPC))) || (ADMIN_PLAYERS_HEAR_DM && VerifyAdminKey(pcc.oPC) && (!GetIsDM(pcc.oPC)))) ||
    ((DMS_HEAR_META && VerifyDMKey(pcc.oPC) && GetIsDM(pcc.oPC)) || (DM_PLAYERS_HEAR_META && VerifyDMKey(pcc.oPC) && (!GetIsDM(pcc.oPC))) ||
    (ADMIN_DMS_HEAR_META && VerifyAdminKey(pcc.oPC) && GetIsDM(pcc.oPC)) || (ADMIN_PLAYERS_HEAR_META && VerifyAdminKey(pcc.oPC) && (!GetIsDM(pcc.oPC)))) ||
    ((DMS_HEAR_TELLS && VerifyDMKey(pcc.oPC) && GetIsDM(pcc.oPC)) || (DM_PLAYERS_HEAR_TELLS && VerifyDMKey(pcc.oPC) && (!GetIsDM(pcc.oPC))) || (ADMIN_DMS_HEAR_TELLS && VerifyAdminKey(pcc.oPC) && GetIsDM(pcc.oPC)) || (ADMIN_PLAYERS_HEAR_TELLS && VerifyAdminKey(pcc.oPC) && (!GetIsDM(pcc.oPC)))) )
    CommandRedirect(pcc.oPC, 27);
    else CommandRedirect(pcc.oPC, 11);
}

void DoDMInvisC(struct pl_chat_command pcc){
    AssignCommand(GetModule(), DoDMInvis(pcc.oPC));
    SendMessageToPC(pcc.oPC, C_RED+INVIS+C_END);
}

void DoDMInvuln(struct pl_chat_command pcc){
    string sUppercase = GetStringUpperCase(pcc.sCommand);

    pcc.oTarget = VerifyTarget(pcc, OBJECT_TARGET, DM_COMMAND_SYMBOL, FALSE, FALSE);
    if (!GetIsObjectValid(pcc.oTarget)) return;

    SetPlotFlag(pcc.oTarget, TRUE);
    if (pcc.oTarget == pcc.oPC) SendMessageToPC(pcc.oPC, C_RED+INVUL1+C_END);
    else{
        SendMessageToPC(pcc.oPC, C_RED + GetName(pcc.oTarget) +INVUL2+C_END);
        if (GetIsPC(pcc.oPC)) SendMessageToPC(pcc.oTarget, C_RED+INVUL1+C_END);
    }
}

void DoDMItem(struct pl_chat_command pcc){
    string sUppercase = GetStringUpperCase(pcc.sCommand);
    object oStorage;
    int nAppear;

    pcc.oTarget = VerifyTarget(pcc, OBJECT_TARGET, DM_COMMAND_SYMBOL, FALSE, FALSE);
    if (!GetIsObjectValid(pcc.oTarget)) return;

    pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 5);
    if (pcc.sCommand == "id"){
        IDAllItems(pcc.oTarget);
        FloatingTextStringOnCreature(C_RED+ITEM_ID+GetName(pcc.oTarget)+ITEM_END+C_END, pcc.oPC, FALSE);
    }
    else if (GetStringLeft(pcc.sCommand, 8) == "destroy "){
        if (((!VerifyDMKey(pcc.oTarget)) && (!VerifyAdminKey(pcc.oTarget))) || (pcc.oTarget == pcc.oPC)){
            pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 8);
            if (pcc.sCommand == "all"){
                DeleteAllItems(pcc.oTarget);
                FloatingTextStringOnCreature(C_RED+ITEM_DESTROY+GetName(pcc.oTarget)+ITEM_END+C_END, pcc.oPC, FALSE);
            }
            else if (pcc.sCommand == "equip"){
                DeleteAllEquippedItems(pcc.oTarget);
                FloatingTextStringOnCreature(C_RED+ITEM_DESTROY+GetName(pcc.oTarget)+ITEM_END3+C_END, pcc.oPC, FALSE);
            }
            else if (pcc.sCommand == "inv"){
                DeleteAllInventory(pcc.oTarget);
                FloatingTextStringOnCreature(C_RED+ITEM_DESTROY+GetName(pcc.oTarget)+ITEM_END2+C_END, pcc.oPC, FALSE);
            }
            else CommandRedirect(pcc.oPC, 17);
        }
        else FloatingTextStringOnCreature(C_RED+NO_OTHER_DM_TARGET+C_END, pcc.oPC, FALSE);
    }
    else CommandRedirect(pcc.oPC, 17);
}

void DoDMJump(struct pl_chat_command pcc){
    string sUppercase = GetStringUpperCase(pcc.sCommand);
    location lLoc =  VerifyLocation(pcc.oPC, sUppercase);

    if (!GetIsObjectValid(GetAreaFromLocation(lLoc))) return;
    DeleteLocalLocation(pcc.oPC, "FKY_CHAT_LOCATION");
    AssignCommand(pcc.oPC, JumpSafeToLocation(lLoc));
}

void DoDMKill(struct pl_chat_command pcc){
    string sUppercase = GetStringUpperCase(pcc.sCommand);

    pcc.oTarget = VerifyTarget(pcc, OBJECT_TARGET, DM_COMMAND_SYMBOL, FALSE);
    if (!GetIsObjectValid(pcc.oTarget)) return;
    if ((!VerifyDMKey(pcc.oTarget)) && (!VerifyAdminKey(pcc.oTarget)))//this command may not be used on dms or admins
    {
        SetPlotFlag(pcc.oTarget, FALSE);
        if(!GetIsPC(pcc.oTarget)){
            AssignCommand(GetModule(), JumpToLimbo(pcc.oTarget));
            DelayCommand(3.0, AssignCommand(GetModule(), DestroyObject(pcc.oTarget)));
        }
        else {
            AssignCommand(GetModule(), ApplyEffectToObject(0, SupernaturalEffect(EffectDeath()), pcc.oTarget));
        }
        SendMessageToPC(pcc.oPC, C_RED + GetName(pcc.oTarget)+KILL1+C_END);
    }
    else FloatingTextStringOnCreature(C_RED+KILL2+C_END, pcc.oPC, FALSE);
}

void DoDMPort(struct pl_chat_command pcc){ // dm_port <party> <location>
    int nText, bParty = FALSE;
    location lLoc;
    object oPortTo = OBJECT_INVALID, oPortee, oStorage;

    pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 5);
    if (GetStringLowerCase(GetStringLeft(pcc.sCommand, 5)) == "party "){
        bParty = TRUE;
        pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 6);
    }

    nText = FindSubString("here hell jail leader there town", pcc.sCommand);
    switch(nText){       //0    5    10   15     22    28
        case -1:
        if (GetStringLowerCase(GetStringLeft(pcc.sCommand, 4)) == "way "){
            pcc.sCommand = GetStringRight(pcc.sOriginal, GetStringLength(pcc.sOriginal) - 9);
            Logger(pcc.oPC, VAR_DEBUG_LOGS, LOGLEVEL_NONE, "Waypoint: %s",pcc.sCommand);
            lLoc = GetLocation(GetWaypointByTag(pcc.sCommand));
        }
        else{
            CommandRedirect(pcc.oPC, 18);
            return;
        }
        break;
        case 0:  oPortTo = pcc.oPC; oPortee = pcc.oTarget; break;
        case 5:  lLoc = GetLocation(GetWaypointByTag(LOCATION_HELL)); break;
        case 10: lLoc = GetLocation(GetWaypointByTag(LOCATION_JAIL)); break;
        case 15: oPortTo = GetFactionLeader(pcc.oTarget); oPortee = pcc.oTarget; break;
        case 22: oPortTo = pcc.oTarget; oPortee = pcc.oPC; break;
        case 28: lLoc = GetLocation(GetWaypointByTag(LOCATION_TOWN)); break;
    }

    pcc.oTarget = VerifyTarget(pcc, OBJECT_TARGET);
    if (!GetIsObjectValid(pcc.oTarget)) return;
    if (((!VerifyDMKey(pcc.oTarget)) && (!VerifyAdminKey(pcc.oTarget))) || (pcc.oTarget == pcc.oPC)){
        if(bParty){
            oStorage = GetFirstFactionMember(pcc.oTarget);
            while (GetIsObjectValid(oStorage)){
                if(GetIsObjectValid(oPortTo) && (oPortTo != oStorage)) AssignCommand(oStorage, JumpSafeToObject(oPortTo));
                else AssignCommand(oStorage, JumpSafeToLocation(lLoc));
                oStorage = GetNextFactionMember(pcc.oTarget);
            }
        }
        else{
            if(GetIsObjectValid(oPortTo) && oPortTo != oPortee) AssignCommand(oPortee, JumpSafeToObject(oPortTo));
            else AssignCommand(pcc.oTarget, JumpSafeToLocation(lLoc));
        }
    }
    else FloatingTextStringOnCreature(C_RED+NO_OTHER_DM_TARGET+C_END, pcc.oPC, FALSE);
}

void DoDMPlace(struct pl_chat_command pcc){ // dm_place <number>
    pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 6);

    if(!VerifyNumber(pcc.oPC, pcc.sCommand)) return;
    int nAppear = StringToInt(pcc.sCommand);

    object oPlace = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", GetLocation(pcc.oPC));
    SetPlaceableAppearance(oPlace, nAppear);
    SetLocalInt(oPlace, "PLACEABLE_APPEARANCE", nAppear + 1);
}

void DoDMRez(struct pl_chat_command pcc){
    pcc.oTarget = VerifyTarget(pcc, OBJECT_TARGET, DM_COMMAND_SYMBOL, FALSE);
    if (!GetIsObjectValid(pcc.oTarget)) return;
    if (((!VerifyDMKey(pcc.oTarget)) && (!VerifyAdminKey(pcc.oTarget))) || (pcc.oTarget == pcc.oPC)){
        ApplyEffectToObject(0, EffectResurrection(), pcc.oTarget);
        ApplyEffectToObject(0, EffectHeal(GetMaxHitPoints(pcc.oTarget)- GetCurrentHitPoints(pcc.oTarget)), pcc.oTarget);
        FloatingTextStringOnCreature(C_RED + GetName(pcc.oTarget)+DMREZ+C_END, pcc.oPC);
    }
    else FloatingTextStringOnCreature(C_RED+NO_OTHER_DM_TARGET+C_END, pcc.oPC, FALSE);
}

void DoDMReset(struct pl_chat_command pcc){ //"reset "
    pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 6);

    if (pcc.sCommand == "start"){
        ResetStart();
        SetLocalInt(GetModule(), "RESETS_DELAYED", 3);
        SendAllMessage(C_RED + GetName(pcc.oPC) + " has activated the server reset."+C_END);
    }
    else if (pcc.sCommand == "delay"){
        ResetDelay();
        SendAllMessage(C_RED + GetName(pcc.oPC) + " has delay the server reset for THIRTY minutes."+C_END);
    }
    else CommandRedirect(pcc.oPC, 19);
}

void DoDMRest(struct pl_chat_command pcc){
    pcc.oTarget = VerifyTarget(pcc, OBJECT_TARGET, DM_COMMAND_SYMBOL, FALSE);
    if (!GetIsObjectValid(pcc.oTarget)) return;
    if ((!VerifyDMKey(pcc.oTarget)) && (!VerifyAdminKey(pcc.oTarget)) || (pcc.oTarget == pcc.oPC)) ForceRest(pcc.oTarget);
    else FloatingTextStringOnCreature(C_RED+NO_OTHER_DM_TARGET+C_END, pcc.oPC, FALSE);
}

void DoDMReveal(struct pl_chat_command pcc){
    pcc.oTarget = VerifyTarget(pcc, OBJECT_TARGET);
    if (!GetIsObjectValid(pcc.oTarget)) return;
    ExploreAreaForPlayer(GetArea(pcc.oTarget), pcc.oTarget, TRUE);
    FloatingTextStringOnCreature(C_RED+EXPLORE1+C_END, pcc.oPC, FALSE);
}

void DoDMVar(struct pl_chat_command pcc){ //dm_var <mod> <type> <variable name> <set>
    string sVarName, sValue;
    int nTypeLength = -1, nLang;
    int nType = -1, bSet = FALSE;

    pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 4);
    sValue = GetStringRight(pcc.sOriginal, GetStringLength(pcc.sOriginal) - 4);

    if (GetStringLeft(pcc.sCommand, 4) == "mod "){
        pcc.oTarget = GetModule();
        pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 4);
        sValue = GetStringRight(sValue, GetStringLength(sValue) - 4);
    }

    if (GetStringLeft(pcc.sCommand, 4) == "int "){
        nTypeLength = 4;
        nType = VARIABLE_TYPE_INT;
    }
    else if (GetStringLeft(pcc.sCommand, 6) == "float "){
        nTypeLength = 6;
        nType = VARIABLE_TYPE_FLOAT;
    }
    else if (GetStringLeft(pcc.sCommand, 7) == "string "){
        nTypeLength = 7;
        nType = VARIABLE_TYPE_STRING;
    }
    else{
        CommandRedirect(pcc.oPC, 22);
        return;
    }

    pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - nTypeLength);
    sValue = GetStringRight(sValue, GetStringLength(sValue) - nTypeLength);

    nLang = FindSubString(pcc.sCommand, " ");
    if(nLang == -1){ // Get Variable
        sVarName = sValue;
    }
    else{ //Set Variable
        sVarName = GetStringLeft(sValue, nLang);//name of variable
        bSet = TRUE;

        pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand)  - GetStringLength(sVarName)-1);
        sValue = GetStringRight(sValue, GetStringLength(sValue) - GetStringLength(sVarName)-1);     //
    }

    if(pcc.oTarget != GetModule()){
        pcc.oTarget = VerifyTarget(pcc, AREA_TARGET_OK);
        if (!GetIsObjectValid(pcc.oTarget)) return;
    }

    switch (nType){
        case VARIABLE_TYPE_INT: // int
            if(bSet){
                if(!VerifyNumber(pcc.oPC, pcc.sCommand)) return;
                SetLocalInt(pcc.oTarget, sVarName, StringToInt(sValue));
                FloatingTextStringOnCreature(C_GREEN+VARIABLE_SET+C_END, pcc.oPC);
            }
            else{
                FloatingTextStringOnCreature(C_GREEN+VARINT1+sVarName+VARINT2+IntToString(GetLocalInt(pcc.oTarget, sVarName))+C_END, pcc.oPC);
            }
        break;
        case VARIABLE_TYPE_FLOAT: // float
            if(bSet){
                if (TestStringAgainstPattern("*n.*n", pcc.sCommand)){
                    SetLocalFloat(pcc.oTarget, sVarName, StringToFloat(sValue));
                    FloatingTextStringOnCreature(C_GREEN+VARIABLE_SET+C_END, pcc.oPC);
                }
                else FloatingTextStringOnCreature(C_RED+REQUIRES_NUMBER+C_END, pcc.oPC);
            }
            else{
                FloatingTextStringOnCreature(C_GREEN+VARINT3+sVarName+VARINT2+FloatToString(GetLocalFloat(pcc.oTarget, sVarName))+C_END, pcc.oPC);
            }
        break;
        case VARIABLE_TYPE_STRING: // string
            if(bSet){
                SetLocalString(pcc.oTarget, sVarName, sValue);
                FloatingTextStringOnCreature(C_GREEN+VARIABLE_SET+C_END, pcc.oPC);
            }
            else{
                FloatingTextStringOnCreature(C_GREEN+VARINT4+sVarName+VARINT2+GetLocalString(pcc.oTarget, sVarName)+C_END, pcc.oPC);
            }
        break;
    }
}

void DoDMStealth(struct pl_chat_command pcc){
    if (GetLocalInt(pcc.oPC, "FKY_CHAT_DMSTEALTH")){
        DeleteLocalInt(pcc.oPC, "FKY_CHAT_DMSTEALTH");
        SendMessageToPC(pcc.oPC, C_RED+DMSTEALTH4+C_END);
    }
    else{
        SetLocalInt(pcc.oPC, "FKY_CHAT_DMSTEALTH", TRUE);
        SendMessageToPC(pcc.oPC, C_RED+DMSTEALTH3+C_END);
    }
}

void DoDMStore(struct pl_chat_command pcc){ // dm_store <store name>
    pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 6);
    OpenStore(GetObjectByTag(pcc.sCommand), pcc.oPC, -100, 0);
}

void DoDMSpawn(struct pl_chat_command pcc){
    string  sStore, sKey;
    location lLoc;
    object oStorage;

    pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 6);
    int nLang = FindSubString(pcc.sCommand, " ");
    if (nLang == -1){
        lLoc =  VerifyLocation(pcc.oPC, pcc.sOriginal);
        if (!GetIsObjectValid(GetAreaFromLocation(lLoc))) return;
        oStorage = CreateObject(OBJECT_TYPE_CREATURE, pcc.sCommand, lLoc);
		SetLocalInt(oStorage, "DM_SPAWNED", TRUE);
        if (GetIsObjectValid(oStorage)) FloatingTextStringOnCreature(C_GREEN+SPAWNED+C_END, pcc.oPC);
        else FloatingTextStringOnCreature(C_RED+NO_CRITTER_RESREF+C_END, pcc.oPC);
        DeleteLocalLocation(pcc.oPC, "FKY_CHAT_LOCATION");
    }
    else FloatingTextStringOnCreature(C_RED+NO_RESREF_SPACE+C_END, pcc.oPC);
}

void DoDMTake(struct pl_chat_command pcc){
    string  sStore;
    int nAppear, nColor;
    object oStorage;

    if (GetStringLeft(pcc.sCommand, 8) == "take xp "){
        pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 8);
        if (TestStringAgainstPattern("*n", pcc.sCommand)){
            nAppear = StringToInt(pcc.sCommand);
            pcc.oTarget = VerifyTarget(pcc, OBJECT_TARGET);
            if (!GetIsObjectValid(pcc.oTarget)) return;
	    GiveTakeXP(pcc.oTarget, -nAppear, TRUE, FALSE, pcc.oPC);
        }
        else FloatingTextStringOnCreature(C_RED+REQUIRES_NUMBER+C_END, pcc.oPC);
    }
    else if (GetStringLeft(pcc.sCommand, 11) == "take level "){
        pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 11);
        pcc.oTarget = VerifyTarget(pcc, OBJECT_TARGET);
        if (!GetIsObjectValid(pcc.oTarget)) return;
        if (TestStringAgainstPattern("*n", pcc.sCommand)) TakeLevel(pcc.oTarget, pcc.oPC, StringToInt(pcc.sCommand));
        else FloatingTextStringOnCreature(C_RED+REQUIRES_NUMBER+C_END, pcc.oPC);
    }
    else if (GetStringLeft(pcc.sCommand, 10) == "take gold "){
        pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 10);
        pcc.oTarget = VerifyTarget(pcc, OBJECT_TARGET);
        if (!GetIsObjectValid(pcc.oTarget)) return;
        if (TestStringAgainstPattern("*n", pcc.sCommand))
            TakeGoldFromCreature(StringToInt(pcc.sCommand), pcc.oTarget, TRUE);
        else FloatingTextStringOnCreature(C_RED+REQUIRES_NUMBER+C_END, pcc.oPC);
    }
    else if (GetStringLeft(pcc.sCommand, 14) == "take party xp "){
        pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 14);
        if (TestStringAgainstPattern("*n", pcc.sCommand))
        {
            pcc.oTarget = VerifyTarget(pcc, OBJECT_TARGET);
            if (!GetIsObjectValid(pcc.oTarget)) return;
	    GiveTakeXP(pcc.oTarget, -nAppear, TRUE, TRUE, pcc.oPC);
        }
        else FloatingTextStringOnCreature(C_RED+REQUIRES_NUMBER+C_END, pcc.oPC);
    }
    else if (GetStringLeft(pcc.sCommand, 17) == "take party level "){
        pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 17);
        if (TestStringAgainstPattern("*n", pcc.sCommand)){
            pcc.oTarget = VerifyTarget(pcc, OBJECT_TARGET);
            if (!GetIsObjectValid(pcc.oTarget)) return;
            oStorage = GetFirstFactionMember(pcc.oTarget);
            nColor = StringToInt(pcc.sCommand);
            if (nColor == 1) sStore = XP14;
            else sStore = XP15;
            while (GetIsObjectValid(oStorage))
            {
                TakeLevel(oStorage, pcc.oPC, nColor, FALSE);//function has built-in message to each, FALSE stops it
                oStorage = GetNextFactionMember(pcc.oTarget);
            }
            SendMessageToPC(pcc.oPC, C_RED+XP8+ IntToString(StringToInt(pcc.sCommand))+sStore+GetName(pcc.oTarget) + XP11+C_END);
        }
        else FloatingTextStringOnCreature(C_RED+REQUIRES_NUMBER+C_END, pcc.oPC);
    }
    else if (GetStringLeft(pcc.sCommand, 16) == "take party gold "){
        pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 16);
        if (TestStringAgainstPattern("*n", pcc.sCommand)){
            pcc.oTarget = VerifyTarget(pcc, OBJECT_TARGET);
            if (!GetIsObjectValid(pcc.oTarget)) return;
            oStorage = GetFirstFactionMember(pcc.oTarget);
            nColor = StringToInt(pcc.sCommand);
            while (GetIsObjectValid(oStorage)){
                TakeGoldFromCreature(nColor, oStorage, TRUE);
                oStorage = GetNextFactionMember(pcc.oTarget);
            }
            //SendMessageToPC(pcc.oPC, C_RED+XP8+ IntToString(StringToInt(pcc.sCommand))+sStore+GetName(pcc.oTarget) + XP11+C_END);
        }
        else FloatingTextStringOnCreature(C_RED+REQUIRES_NUMBER+C_END, pcc.oPC);
    }
    else CommandRedirect(pcc.oPC, 19);
}

void DoDMUnfreeze(struct pl_chat_command pcc){
    pcc.oTarget = VerifyTarget(pcc, OBJECT_TARGET, DM_COMMAND_SYMBOL, FALSE);
    if (!GetIsObjectValid(pcc.oTarget)) return;
    if (!GetCommandable(pcc.oTarget)) SetCommandable(TRUE, pcc.oTarget);
    if (GetIsPC(pcc.oTarget)) SendMessageToPC(pcc.oTarget, C_RED+UNFREEZE1+C_END);
    SendMessageToPC(pcc.oPC, C_RED+UNFREEZE2+ GetName(pcc.oTarget) + "."+C_END);
}

void DoDMUnignore(struct pl_chat_command pcc){
    if (pcc.sCommand == "unignoredm")   //if option
    {
        if ((DM_PLAYERS_HEAR_DM && VerifyDMKey(pcc.oPC) && (!GetIsDM(pcc.oPC))) || (ADMIN_PLAYERS_HEAR_DM && VerifyAdminKey(pcc.oPC) && (!GetIsDM(pcc.oPC))))
        {
            DeleteLocalInt(pcc.oPC, "FKY_CHT_IGNOREDM");
            SendMessageToPC(pcc.oPC, C_RED+UNIGNORED+C_END);
        }
        else CommandRedirect(pcc.oPC, 11);
    }
    else if (pcc.sCommand == "unignoremeta")   //if option
    {
        if ((DMS_HEAR_META && VerifyDMKey(pcc.oPC) && GetIsDM(pcc.oPC)) || (DM_PLAYERS_HEAR_META && VerifyDMKey(pcc.oPC) && (!GetIsDM(pcc.oPC))) || (ADMIN_DMS_HEAR_META && VerifyAdminKey(pcc.oPC) && GetIsDM(pcc.oPC)) || (ADMIN_PLAYERS_HEAR_META && VerifyAdminKey(pcc.oPC) && (!GetIsDM(pcc.oPC))))
        {
            DeleteLocalInt(pcc.oPC, "FKY_CHT_IGNOREMETA");
            SendMessageToPC(pcc.oPC, C_RED+UNIGNOREM+C_END);
        }
        else CommandRedirect(pcc.oPC, 11);
    }
    else if (pcc.sCommand == "unignoretells")//if option
    {
        if ((DMS_HEAR_TELLS && VerifyDMKey(pcc.oPC) && GetIsDM(pcc.oPC)) || (DM_PLAYERS_HEAR_TELLS && VerifyDMKey(pcc.oPC) && (!GetIsDM(pcc.oPC))) || (ADMIN_DMS_HEAR_TELLS && VerifyAdminKey(pcc.oPC) && GetIsDM(pcc.oPC)) || (ADMIN_PLAYERS_HEAR_TELLS && VerifyAdminKey(pcc.oPC) && (!GetIsDM(pcc.oPC))))
        {
            DeleteLocalInt(pcc.oPC, "FKY_CHT_IGNORETELLS");
            SendMessageToPC(pcc.oPC, C_RED+UNIGNORET+C_END);
        }
        else CommandRedirect(pcc.oPC, 11);
    }
    else if ( ((DM_PLAYERS_HEAR_DM && VerifyDMKey(pcc.oPC) && (!GetIsDM(pcc.oPC))) || (ADMIN_PLAYERS_HEAR_DM && VerifyAdminKey(pcc.oPC) && (!GetIsDM(pcc.oPC)))) ||
    ((DMS_HEAR_META && VerifyDMKey(pcc.oPC) && GetIsDM(pcc.oPC)) || (DM_PLAYERS_HEAR_META && VerifyDMKey(pcc.oPC) && (!GetIsDM(pcc.oPC))) || (ADMIN_DMS_HEAR_META && VerifyAdminKey(pcc.oPC) && GetIsDM(pcc.oPC)) || (ADMIN_PLAYERS_HEAR_META && VerifyAdminKey(pcc.oPC) && (!GetIsDM(pcc.oPC)))) ||
    ((DMS_HEAR_TELLS && VerifyDMKey(pcc.oPC) && GetIsDM(pcc.oPC)) || (DM_PLAYERS_HEAR_TELLS && VerifyDMKey(pcc.oPC) && (!GetIsDM(pcc.oPC))) || (ADMIN_DMS_HEAR_TELLS && VerifyAdminKey(pcc.oPC) && GetIsDM(pcc.oPC)) || (ADMIN_PLAYERS_HEAR_TELLS && VerifyAdminKey(pcc.oPC) && (!GetIsDM(pcc.oPC)))) ) CommandRedirect(pcc.oPC, 27);
    else CommandRedirect(pcc.oPC, 11);
}

void DoDMUninvisC(struct pl_chat_command pcc){
    AssignCommand(GetModule(), DoDMUninvis(pcc.oPC));
    SendMessageToPC(pcc.oPC, C_RED+UNINVIS+C_END);
}

void DoDMUninvuln(struct pl_chat_command pcc){

    pcc.oTarget = VerifyTarget(pcc, OBJECT_TARGET, DM_COMMAND_SYMBOL, FALSE, FALSE);
    if (!GetIsObjectValid(pcc.oTarget)) return;
    if ((!VerifyDMKey(pcc.oTarget)) && (!VerifyAdminKey(pcc.oTarget)) || (pcc.oTarget == pcc.oPC)){
        SetPlotFlag(pcc.oTarget, FALSE);
        if (pcc.oTarget == pcc.oPC) SendMessageToPC(pcc.oPC, C_RED+UNINVUL1+C_END);
        else{
            SendMessageToPC(pcc.oPC, C_RED + GetName(pcc.oTarget) +UNINVUL2+C_END);
            if (GetIsPC(pcc.oTarget)) SendMessageToPC(pcc.oTarget, C_RED+UNINVUL1+C_END);
        }
    }
    else FloatingTextStringOnCreature(C_RED+UNINVUL3+C_END, pcc.oPC, FALSE);
}

void DoDMVent(struct pl_chat_command pcc){
    pcc.oTarget = VerifyTarget(pcc, OBJECT_TARGET, DM_COMMAND_SYMBOL, FALSE, FALSE);
    if (!GetIsObjectValid(pcc.oTarget)) return;
    if (!VerifyDMKey(pcc.oTarget) && !VerifyAdminKey(pcc.oTarget))
    {
        SetLocalObject(pcc.oPC, "FKY_CHT_VENTRILO", pcc.oTarget);
        FloatingTextStringOnCreature(C_GREEN+VENTRILO+C_END, pcc.oPC, FALSE);
    }
    else FloatingTextStringOnCreature(C_RED+NO_DM_TARGET+C_END, pcc.oPC, FALSE);
}

void main (){

    struct pl_chat_command pcc;
    pcc.oPC = OBJECT_SELF;
    pcc.oTarget = GetLocalObject(pcc.oPC, "FKY_CHAT_DMSHUNT_TARGET");
    pcc.sCommand = GetLocalString(pcc.oPC, "FKY_CHAT_DMSHUNT_TEXT");

    DeleteLocalObject(pcc.oPC, "FKY_CHAT_DMSHUNT_TARGET");
    DeleteLocalString(pcc.oPC, "FKY_CHAT_DMSHUNT_TEXT");

    Logger(pcc.oPC, "DebugChat", LOGLEVEL_MINIMUM, "User: %s, Command: %s, Target: %s, Area: %s",
        GetName(pcc.oPC), pcc.sCommand, GetName(pcc.oTarget), GetName(GetArea(pcc.oPC)));

    string sSort, sKey, sStore, sData, sRow, sReturn;
    object oNewItem, oStorage;
    effect eEffect;
    int nText, nLang, nAppear, nColor, nRowCount;
    location lLoc;
    //this section is now handled earlier, with the other commands and channels
    /*if (GetStringLowerCase(GetStringLeft(pcc.sCommand, 3)) == "dm_")//dm-only commands using tell targeting
    {
    if (VerifyDMKey(pcc.oPC) || VerifyAdminKey(pcc.oPC))//these commands are for DMs and Admins only
    {*/
    SetLocalString(pcc.oPC, "NWNX!CHAT!SUPRESS", "1");//don't want commands to show in text
    pcc.sOriginal = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 3);
    pcc.sCommand = GetStringLowerCase(GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 3));  //case insensitive
    sSort = GetStringLeft(pcc.sCommand, 1);
    nText = FindSubString("abcdefghijklmnopqrstuvwxyz", sSort);
    switch (nText)
    {
        case -1: CommandRedirect(pcc.oPC, 11); break;
        /*a*/       case 0:
		if (GetStringLeft(pcc.sCommand, 4) == "area" && VerifyAdminKey(pcc.oPC)) DoDMArea(pcc);
        break;
        /*b*/       case 1:
        if (GetStringLeft(pcc.sCommand, 3) == "ban") DoDMBan(pcc);
        else if (pcc.sCommand == "boot") DoDMBoot(pcc);
        else CommandRedirect(pcc.oPC, 11);
        break;
        /*c*/       case 2:
        if (GetStringLeft(pcc.sCommand, 7) == "create ") DoDMCreate(pcc);
        else if (GetStringLeft(pcc.sCommand, 7) == "change ") DoDMChange(pcc);
        else CommandRedirect(pcc.oPC, 11);
        break;
        /*d*/       case 3:
        break;
        /*e*/       case 4:
        break;
        /*f*/       case 5:
        if (pcc.sCommand == "fireworks") DoDMFireworks(pcc);
        else if (pcc.sCommand == "freeze") DoDMFreeze(pcc);
        else if (GetStringLeft(pcc.sCommand, 2) == "fx") DoDMFX(pcc);
        else CommandRedirect(pcc.oPC, 11);
        break;
        /*g*/       case 6:
        if (GetStringLeft(pcc.sCommand, 6) == "getban") DoGetBan(pcc);
        else if (GetStringLeft(pcc.sCommand, 4) == "give") DoDMGive(pcc);
        else if (GetStringLeft(pcc.sCommand, 6) ==  "guild ") DoDMGuild(pcc);
        else CommandRedirect(pcc.oPC, 11);
        break;
        /*h*/       case 7:
        if (pcc.sCommand == "hide") DoDMHide(pcc);
        else if (pcc.sCommand == "heal") DoDMHeal(pcc);
        else if (pcc.sCommand == "help") ListDMHelp(pcc.oPC);
        else CommandRedirect(pcc.oPC, 11);
        break;
        /*i*/       case 8:
        if (GetStringLeft(pcc.sCommand, 6) == "ignore") DoDMIgnore(pcc);
        else if (pcc.sCommand == "invis") DoDMInvisC(pcc);
        else if (pcc.sCommand == "invuln" && VerifyAdminKey(pcc.oPC)) DoDMInvuln(pcc);
        else if (GetStringLeft(pcc.sCommand, 5) == "item " && VerifyAdminKey(pcc.oPC)) DoDMItem(pcc);
        else CommandRedirect(pcc.oPC, 11);
        break;
        /*j*/       case 9:
        if (pcc.sCommand == "jump" && VerifyAdminKey(pcc.oPC)) DoDMJump(pcc);
        else CommandRedirect(pcc.oPC, 11);
        break;
        /*k*/       case 10:
        if (pcc.sCommand == "kill" && VerifyAdminKey(pcc.oPC)) DoDMKill(pcc);
		else CommandRedirect(pcc.oPC, 11);
        break;
        /*l*/       case 11:
        if (pcc.sCommand == "listcommands") ListDMCommands(pcc.oPC);
        else CommandRedirect(pcc.oPC, 11);
        break;
        /*m*/       case 12:
        break;
        /*n*/       case 13:
        break;
        /*o*/       case 14:
        break;
        /*p*/       case 15:
        if (GetStringLowerCase(GetStringLeft(pcc.sCommand, 6)) == "place ") DoDMPlace(pcc);
        else if (GetStringLowerCase(GetStringLeft(pcc.sCommand, 5)) == "port ") DoDMPort(pcc);
        else CommandRedirect(pcc.oPC, 11);
        break;
        /*q*/       case 16:
        break;

        /*r*/       case 17:
        if (pcc.sCommand == "rez" && VerifyAdminKey(pcc.oPC)) DoDMRez(pcc);
        else if (GetStringLeft(pcc.sCommand, 6) == "reset ") DoDMReset(pcc);
        else if (pcc.sCommand == "rest") DoDMRest(pcc);
        else if (pcc.sCommand == "reveal") DoDMReveal(pcc);
        else CommandRedirect(pcc.oPC, 11);
        break;
        /*s*/       case 18:
		if (GetStringLeft(pcc.sCommand, 6) == "spawn ") DoDMSpawn(pcc);
        else if (pcc.sCommand == "stealth") DoDMStealth(pcc);
        else if (GetStringLeft(pcc.sCommand, 6) == "store ") DoDMStore(pcc);
        else CommandRedirect(pcc.oPC, 11);
        break;
        /*t*/       case 19:
        if (GetStringLeft(pcc.sCommand, 4) == "take") DoDMTake(pcc);
        else CommandRedirect(pcc.oPC, 11);
        break;
        /*u*/       case 20:
        if (GetStringLeft(pcc.sCommand, 5) == "unban") DoDMUnban(pcc);
        else if (GetStringLeft(pcc.sCommand, 3) == "unb") CommandRedirect(pcc.oPC, 16);
        else if (pcc.sCommand == "unfreeze") DoDMUnfreeze(pcc);
        else if (GetStringLeft(pcc.sCommand, 3) == "unf") CommandRedirect(pcc.oPC, 15);
        else if (GetStringLeft(pcc.sCommand, 4) == "unig") DoDMUnignore(pcc);
        else if (pcc.sCommand == "uninvis") DoDMUninvisC(pcc);
        else if (pcc.sCommand == "uninvuln" && VerifyAdminKey(pcc.oPC)) DoDMUninvuln(pcc);
        else if (GetStringLeft(pcc.sCommand, 4) == "unin") CommandRedirect(pcc.oPC, 15);
        else CommandRedirect(pcc.oPC, 11);
        break;
        /*v*/       case 21:
        if(GetStringLeft(pcc.sCommand, 4) == "var ") DoDMVar(pcc);
        else if (pcc.sCommand == "vent") DoDMVent(pcc);
        else if (GetStringLeft(pcc.sCommand, 3) == "ve") CommandRedirect(pcc.oPC, 26);
        else CommandRedirect(pcc.oPC, 11);
        break;
        /*w*/       case 22:
        break;
        /*x*/       case 23:
        break;
        /*y*/       case 24:
        break;
        /*z*/       case 25:
        break;
    }
}
