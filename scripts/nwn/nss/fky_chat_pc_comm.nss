#include "fky_chat_inc"
#include "pl_sub_inc"
#include "x3_inc_string"
#include "pl_pcstyle_inc"

void RollDie(object oPlayer, int nDie)
{
    int nRoll;
    string sDie;
    switch (nDie)
    {
        case 4: nRoll = d4(); sDie = "D4"; break;
        case 6: nRoll = d6(); sDie = "D6"; break;
        case 8: nRoll = d8(); sDie = "D8"; break;
        case 10: nRoll = d10(); sDie = "D10"; break;
        case 12: nRoll = d12(); sDie = "D12"; break;
        case 20: nRoll = d20(); sDie = "D20"; break;
        case 100: nRoll = d100(); sDie = "D100"; break;
    }
    string sName = GetName(oPlayer);
    string sRoll = IntToString(nRoll);
    AssignCommand(oPlayer, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID,3.0,3.0));
    DelayCommand(2.0,AssignCommand(oPlayer, SpeakString(ESCAPE_STRING+C_WHITE+sName+ROLL1+C_END+C_GREEN+sDie+C_END+C_WHITE+ROLL2+C_END+C_BLUE+sRoll+C_END+"]")));
    if(nRoll == nDie)
    {
        DelayCommand(3.5,AssignCommand(oPlayer, SpeakString(ESCAPE_STRING+C_BLUE+ROLLGOOD+C_END)));
        DelayCommand(3.5,AssignCommand(oPlayer,ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY1,1.0,0.0)));
        DelayCommand(3.5,PlayVoiceChat(VOICE_CHAT_CHEER,oPlayer));
    }
}
void DoPartyRoll(object oPlayer)
{
    object oLeader = GetFactionLeader(oPlayer);
    object oPartymember;
    int nRoll, nInt, nNumberItemsInArray, nNumBase, nTopRoller;
    int nCount = 0;
    string sInt, sBase, sNumBase, sLine, sRoll, sName;
    string sMessage = "";
    if (oPlayer == oLeader)//only leader can roll
    {
        oPartymember = GetFirstFactionMember(oPlayer);
        //oPartymember = GetFirstItemInInventory(oPlayer);
        while (GetIsObjectValid(oPartymember))//generate the 'array'
        {
            nCount++;//get number in party
            nRoll = Random(100);
            sRoll = IntToString(nRoll);
            if (GetStringLength(sRoll) == 1) sRoll = "0" + sRoll;//ensure that string length is consistent
            sInt = IntToString(nCount);
            SetLocalString(oPlayer, "PRMember"+sInt, sRoll+GetName(oPartymember));
            oPartymember = GetNextFactionMember(oPlayer);
            //oPartymember = GetNextItemInInventory(oPlayer);
        }
        nNumberItemsInArray = nCount;
        for (nInt = 1; nInt <= nCount; nInt++) //once through for each member of the party
        {
            //find the highest number
            nTopRoller = GetHighestItemFromArray(oPlayer, nNumberItemsInArray);
            //add it to the string along with their name
            sBase = GetLocalString(oPlayer, "PRMember"+IntToString(nTopRoller));
            nNumBase = StringToInt(GetStringLeft(sBase, 2));
            nNumBase++;//add 1 to simulate 1 to 100 roll instead of 0 to 99
            sNumBase = IntToString(nNumBase);
            sName = GetStringRight(sBase, (GetStringLength(sBase) - 2));
            //sLine = sName + " rolled a " + sNumBase + ".\n";
            sLine = C_WHITE+sName+ROLL1+C_END+C_GREEN+"D100"+C_END+C_WHITE+ROLL2+C_END+C_BLUE+sNumBase+C_END+C_WHITE+"].\n";
            sMessage += sLine;
            //delete that array entry, no need to pack it
            DeleteLocalString(oPlayer, "PRMember"+IntToString(nTopRoller));
        }
        //Send the final message to the party
        AssignCommand(oPlayer, SpeakString(ESCAPE_STRING+sMessage));
        oPartymember = GetFirstFactionMember(oPlayer);
        while (GetIsObjectValid(oPartymember))
        {
            SendMessageToPC(oPartymember, sMessage);
            oPartymember = GetNextFactionMember(oPlayer);
        }
    }
}



void DoAFK(struct pl_chat_command pcc){ // afk <message>
    pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 4);
    SetLocalInt(pcc.oPC, "FKY_CHAT_AFK", 1);
    SetLocalString(pcc.oPC, "FKY_CHAT_AFK_MSG", pcc.sCommand);
    SendServerMessage(pcc.oPC, "[AFK] " + GetName(pcc.oPC) + " is AFK: " + pcc.sCommand);
}

void DoAnon(struct pl_chat_command pcc){
    SetLocalInt(pcc.oPC, "FKY_CHAT_ANON", 1);
    SendMessageToPC(pcc.oPC, C_RED+ANON+C_END);
}
void DoCDKey(struct pl_chat_command pcc){ // !cdkey <action>
    pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 6);
    if(pcc.oPC != OBJECT_SELF)
        return;

    if(pcc.sCommand == "add"){
        SET("cdkey:add:"+GetPCPlayerName(pcc.oPC), "1", 24*60*60);
        SendChatLogMessage(pcc.oPC, C_GREEN+"Please relog using the CDKEY that you would like to add to this login name!  You have 24 hours before this expires."+C_END + "\n", pcc.oPC, 5);
    }
    else if(pcc.sCommand == "delete"){
        ErrorMessage(pcc.oPC, "Unimplemented!");
    }
    else
        ErrorMessage(pcc.oPC, "Invalid Command!");
}
void DoConvertFeat(struct pl_chat_command pcc) { // !convert <feat> <to>
    pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 8);
    struct SubString ss = GetFirstSubString(pcc.sCommand); // Feat

    if(ss.first == "ep" && GetLootable(pcc.oPC) <= 40
       && GetLevelByClass(CLASS_TYPE_FIGHTER, pcc.oPC) > 21)
    {
        ss = GetFirstSubString(ss.rest); // Ability;
        if(ss.first == "str" && GetKnowsFeat (FEAT_BULLHEADED, pcc.oPC)
           && GetKnowsFeat (FEAT_EPIC_PROWESS, pcc.oPC))
        {
            RemoveKnownFeat(pcc.oPC, FEAT_EPIC_PROWESS);
            ModifyAbilityScore(pcc.oPC, ABILITY_STRENGTH, 1);
            SetLocalInt(pcc.oPC, VAR_PC_NO_RELEVEL, 1);
            SendChatLogMessage(pcc.oPC, C_GREEN+"Epic Prowess has been converted to strength!"+C_END + "\n", pcc.oPC, 5);
        }
        else if(ss.first == "dex" && GetKnowsFeat (FEAT_LUCK_OF_HEROES, pcc.oPC)
           && GetKnowsFeat (FEAT_EPIC_PROWESS, pcc.oPC))
        {
            RemoveKnownFeat(pcc.oPC, FEAT_EPIC_PROWESS);
            ModifyAbilityScore(pcc.oPC, ABILITY_DEXTERITY, 1);
            SetLocalInt(pcc.oPC, VAR_PC_NO_RELEVEL, 1);
            SendChatLogMessage(pcc.oPC, C_GREEN+"Epic Prowess has been converted to Dexterity!"+C_END + "\n", pcc.oPC, 5);
        }
        else if(ss.first == "con" && GetKnowsFeat (FEAT_BLOODED, pcc.oPC)
           && GetKnowsFeat (FEAT_EPIC_PROWESS, pcc.oPC))
        {
            RemoveKnownFeat(pcc.oPC, FEAT_EPIC_PROWESS);
            ModifyAbilityScore(pcc.oPC, ABILITY_CONSTITUTION, 1);
            SetLocalInt(pcc.oPC, VAR_PC_NO_RELEVEL, 1);
            SendChatLogMessage(pcc.oPC, C_GREEN+"Epic Prowess has been converted to Constitution!"+C_END + "\n", pcc.oPC, 5);
        }
        else
            ErrorMessage(pcc.oPC, "You are unable to convert Epic Prowess!");
    }
    else
        ErrorMessage(pcc.oPC, "Invalid Command!");
}

void DoDelete(struct pl_chat_command pcc){
    pcc.oTarget = VerifyTarget(pcc, OBJECT_TARGET, COMMAND_SYMBOL);
    if (!GetIsObjectValid(pcc.oTarget)) return;

    int nCount = GetLocalInt(pcc.oTarget, "FKY_CHAT_DELETE_CONFIRM");
    if (nCount == 1)
    {
        if (GetIsPC(pcc.oTarget))
        {
            if (GetStringRight(pcc.sCommand, 8) == GetStringLowerCase(GetPCPublicCDKey(pcc.oTarget)))
            {
                ExportSingleCharacter(pcc.oTarget);//export needed to ensure this .bic is the most recently edited
                SetLocalInt(pcc.oTarget, VAR_PC_DELETED, 1);
                string sql = "DELETE from nwn.characters WHERE id = "+GetCharacterId(pcc.oTarget);
                SQLExecDirect(sql);

                int nCurrentXP = GetXP(pcc.oTarget) - 3000;
                if(nCurrentXP < 0)
                    nCurrentXP = 0;
                if(!GetIsTestCharacter(pcc.oTarget)){
                    int nXPBalance = GetLocalInt(pcc.oTarget, VAR_PC_XP_BANK) + nCurrentXP;
                    DelayCommand(2.0, GiveTakeXP(pcc.oTarget, -GetXP(pcc.oTarget)));
                    DelayCommand(1.0, FloatingTextStringOnCreature(C_GREEN+IntToString(nCurrentXP)+" XP have been added to your XP Bank."+C_END, pcc.oTarget, FALSE));
                    SetLocalInt(pcc.oTarget, VAR_PC_XP_BANK, nXPBalance);
                    //SetDbInt(pcc.oTarget, VAR_PC_XP_BANK, nXPBalance, 0, TRUE);

                    Logger(pcc.oTarget, VAR_DEBUG_LOGS, LOGLEVEL_DEBUG, "Attempting to delete: %s and deposit %sXP in %s's bank.",
                        GetName(pcc.oTarget), IntToString(nXPBalance), GetPCPlayerName(pcc.oTarget));
                }
                FloatingTextStringOnCreature(C_RED+LETO_DELETE+C_END, pcc.oTarget, FALSE);
                DelayCommand(3.0, AssignCommand(GetModule(), DeleteBic(pcc.oTarget)));
            }
            else FloatingTextStringOnCreature(C_RED+DISCONFIRM+C_END, pcc.oPC, FALSE);
        }
        else FloatingTextStringOnCreature(C_RED+PC_ONLY+C_END, pcc.oPC, FALSE);
    }
    else if (pcc.sCommand ==  "delete")
    {
        if (SRV_SERVERVAULT != "")//check if vault specified, command error otherwise
        {
            //check permission
            int nPos = (pcc.oPC == pcc.oTarget);//self-targeted?
            if ((PLAYERS_CAN_DELETE && nPos) || (DMS_CAN_DELETE && VerifyDMKey(pcc.oPC)) || VerifyAdminKey(pcc.oPC))
            {
                if (GetIsPC(pcc.oTarget))
                {
                    if ((VerifyDMKey(pcc.oTarget) || VerifyAdminKey(pcc.oTarget)) && (!nPos)) FloatingTextStringOnCreature(C_RED+NO_OTHER_DM_TARGET+C_END, pcc.oPC, FALSE);
                    else
                    {
                        SetLocalInt(pcc.oTarget, "FKY_CHAT_DELETE_CONFIRM", 1);
                        FloatingTextStringOnCreature(C_RED+CONFIRM_DELETE+COMMAND_SYMBOL+CONFIRM_DELETE2+C_END, pcc.oPC, FALSE);
                    }
                }
                else FloatingTextStringOnCreature(C_RED+PC_ONLY+C_END, pcc.oPC, FALSE);
            }
            else CommandRedirect(pcc.oPC, 1);
        //check process
        }
        else CommandRedirect(pcc.oPC, 1);
    }
    else CommandRedirect(pcc.oPC, 1);

}

void DoDelevel(struct pl_chat_command pcc){
    pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 8); // "delevel <number>"

    if(!VerifyNumber(pcc.oPC, pcc.sCommand))
        return;

    pcc.oTarget = VerifyTarget(pcc, OBJECT_TARGET, COMMAND_SYMBOL);
    if (!GetIsObjectValid(pcc.oTarget))
        return;

    if(pcc.oPC != pcc.oTarget){
        ErrorMessage(pcc.oPC, "You may only use this command on yourself!");
        return;
    }
    if(!GetIsRelevelable(pcc.oPC)){
        ErrorMessage(pcc.oPC, "You are not able to delevel!");
        return;
    }

	if(GetLocalInt(pcc.oPC, "LL_CLASS")) {
        ErrorMessage(pcc.oPC, "You are not able to delevel while taking Legendary Levels!");
        return;
    }

    Delevel(pcc.oPC, StringToInt(pcc.sCommand));
}
void DoDieRoll(struct pl_chat_command pcc){
    int nText = FindSubString("d4 d6 d8 d10 d12 d20 d100", pcc.sCommand);
    switch (nText)       //0  3  6  9   13  17  21
    {
        case -1:
            if (TestStringAgainstPattern("*n", GetSubString(pcc.sCommand, 1, 1))) CommandRedirect(pcc.oPC, 3);
            else CommandRedirect(pcc.oPC, 1);
        break;
        case 0:  RollDie(pcc.oPC, 4);   break;
        case 3:  RollDie(pcc.oPC, 6);   break;
        case 6:  RollDie(pcc.oPC, 8);   break;
        case 9:  RollDie(pcc.oPC, 10);  break;
        case 13: RollDie(pcc.oPC, 12);  break;
        case 17: RollDie(pcc.oPC, 20);  break;
        case 21: RollDie(pcc.oPC, 100); break;
    }
}

void DoEleSwarm(struct pl_chat_command pcc){ // !eleswarm <type>
    pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 9);
    if(pcc.sCommand == "acid")
        SetLocalInt(pcc.oPC, "PL_ELE_SWARM", DAMAGE_TYPE_ACID);
    else if(pcc.sCommand == "cold")
        SetLocalInt(pcc.oPC, "PL_ELE_SWARM", DAMAGE_TYPE_COLD);
    else if(pcc.sCommand == "elec")
        SetLocalInt(pcc.oPC, "PL_ELE_SWARM", DAMAGE_TYPE_ELECTRICAL);
    else if(pcc.sCommand == "fire")
        SetLocalInt(pcc.oPC, "PL_ELE_SWARM", DAMAGE_TYPE_FIRE);
    else if(pcc.sCommand == "sonic")
        SetLocalInt(pcc.oPC, "PL_ELE_SWARM", DAMAGE_TYPE_SONIC);
    else{
        SendMessageToPC(pcc.oPC, C_RED+"Invalid damage type!+C_END");
        return;
    }
    SendMessageToPC(pcc.oPC, C_GREEN+"Elemental Swarm damage type set!"+C_END);
}

void DoFollow(struct pl_chat_command pcc){
    pcc.oTarget = VerifyTarget(pcc, OBJECT_TARGET, COMMAND_SYMBOL);
    if (!GetIsObjectValid(pcc.oTarget)) return;

    if (GetArea(pcc.oTarget) != GetArea(pcc.oPC)) return;

    if (GetIsPC(pcc.oTarget)){
        DelayCommand(0.2, AssignCommand(pcc.oPC, ActionForceFollowObject(pcc.oTarget, 3.0)));
    }
    else FloatingTextStringOnCreature(C_RED+PC_ONLY+C_END, pcc.oPC, FALSE);
}

void DoIgnore(struct pl_chat_command pcc){ // ignore <all | party | shout | tell>
    if (!GetIsObjectValid(pcc.oTarget)) return;

    pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 7);
    pcc.oTarget = VerifyTarget(pcc, OBJECT_TARGET, COMMAND_SYMBOL);
    string sTarget = GetPCPlayerName(pcc.oTarget);
    string sPlayer = GetPCPlayerName(pcc.oPC);

    if (!GetIsPC(pcc.oTarget)) {
        FloatingTextStringOnCreature(C_RED+PC_ONLY+C_END, pcc.oPC, FALSE);
        return;
    }
    //can't ignore DMs or Admins
    else if (VerifyDMKey(pcc.oTarget) || VerifyAdminKey(pcc.oTarget)){
        FloatingTextStringOnCreature(C_RED+IGNORE7+C_END, pcc.oPC, FALSE);
        return;
    }
    else if (pcc.oPC == pcc.oTarget){
        FloatingTextStringOnCreature(C_RED+IGNORE6+C_END, pcc.oPC, FALSE);
        return;
    }

    int level = 0;
    string pc_msg;
    if (pcc.sCommand == "all"){
        level = 15;
        pc_msg = IGNORE3;
    }
    else if (pcc.sCommand == "tell"){
        level = 1;
        pc_msg = "You are now ignoring tells from ";
    }
    else if (pcc.sCommand == "party"){
        level = 4;
        pc_msg = "You are now ignoring party messages from ";
    }
    else if (pcc.sCommand == "talk"){
        level = 2;
        pc_msg = "You are now ignoring talk messages from ";
    }
    else if (pcc.sCommand == "shout"){
        level = 8;
        pc_msg = "You are now ignoring shouts from ";
    }
    else if (pcc.sCommand == "off"){
        DeleteLocalInt(pcc.oPC, "FKY_CHT_IGNORE" + sTarget);
        pc_msg = "You are no longer ignoring ";
    }
    else{
        ErrorMessage(pcc.oPC, "Incorrect usages of the !ignore command!");
        return;
    }
    int current = GetLocalInt(pcc.oPC, "FKY_CHT_IGNORE" + sTarget);
    SetLocalInt(pcc.oPC, "FKY_CHT_IGNORE" + sTarget, level | current );
    SendMessageToPC(pcc.oPC, C_RED+pc_msg + sTarget + "."+C_END);
}

void DoLevel(object oPC){
    ExecuteScript("tall2_start_dlg", oPC);
}

void DoLFG(struct pl_chat_command pcc){
    //if they've been muted from either channel they can only use this 3 times, to avoid circumventing
    if (GetLocalInt(pcc.oPC, "FKY_CHT_BANSHOUT") || GetLocalInt(pcc.oPC, "FKY_CHT_BANDM"))
    {
        int nCount = GetLocalInt(pcc.oPC, "FKY_CHT_LFG");
        if (nCount > 2){
            SendMessageToPC(pcc.oPC, C_RED+USES_3+C_END);
        }
        else{
            nCount++;
            SetLocalInt(pcc.oPC, "FKY_CHT_LFG", nCount);
            SpeakString(LFG1+ IntToString(GetNumberOfLegendaryLevels(OBJECT_SELF)+ GetHitDice(OBJECT_SELF))+LFG2, TALKVOLUME_SHOUT);
        }
    }
    else{
        SpeakString(LFG1+ IntToString(GetNumberOfLegendaryLevels(OBJECT_SELF)+ GetHitDice(OBJECT_SELF))+LFG2, TALKVOLUME_SHOUT);
    }
}

void DoList(struct pl_chat_command pcc){
    if (pcc.sCommand ==  "list emotes") ListEmotes(pcc.oPC);
    else if (pcc.sCommand ==  "list commands") ListCommands(pcc.oPC);
    else if (pcc.sCommand ==  "list ignored") ListIgnored(pcc.oPC);
    else if (pcc.sCommand ==  "list modes") ListModes(pcc.oPC);
    else if (pcc.sCommand ==  "list aliases") ListAliases(pcc.oPC);
    else if (pcc.sCommand ==  "list nicknames") ListNicknames(pcc.oPC);
/*    else if (pcc.sCommand == "list languages"){
        if (ENABLE_LANGUAGES) ListLanguages(pcc.oPC);
        else CommandRedirect(pcc.oPC, 1);
    }
    else if (pcc.sCommand == "list alllanguages"){
        if (ENABLE_LANGUAGES && (ENABLE_FULL_LANGUAGE_LIST_FOR_PLAYERS || VerifyDMKey(pcc.oPC) || VerifyAdminKey(pcc.oPC))) ListAllLanguages(pcc.oPC);
        else CommandRedirect(pcc.oPC, 1);
    } */
    else CommandRedirect(pcc.oPC, 6);
}

void DoMode(struct pl_chat_command pcc){ // "mode <mode>"
    pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 5);

    int nMode;

    if (pcc.sCommand ==  "expertise"){
        if(GetHasFeat(FEAT_EXPERTISE, pcc.oPC)){
            SetLocalInt(pcc.oPC, "FKY_CHAT_MODE", ACTION_MODE_EXPERTISE);
            SendChatLogMessage(pcc.oPC, C_GREEN+"Mode Set!"+C_END + "\n", pcc.oPC, 5);
        }
        else SendChatLogMessage(pcc.oPC, C_RED+"You don't have the feat required for this mode!"+C_END + "\n", pcc.oPC, 5);
    }
    else if (pcc.sCommand ==  "impexpertise"){
        if(GetHasFeat(FEAT_IMPROVED_EXPERTISE, pcc.oPC)){
           SetLocalInt(pcc.oPC, "FKY_CHAT_MODE", ACTION_MODE_IMPROVED_EXPERTISE);
           SendChatLogMessage(pcc.oPC, C_GREEN+"Mode Set!"+C_END + "\n", pcc.oPC, 5);
        }
        else SendChatLogMessage(pcc.oPC, C_RED+"You don't have the feat required for this mode!"+C_END + "\n", pcc.oPC, 5);
    }
    else if (pcc.sCommand ==  "flurry"){
        if(GetHasFeat(FEAT_FLURRY_OF_BLOWS, pcc.oPC)){
           SetLocalInt(pcc.oPC, "FKY_CHAT_MODE", ACTION_MODE_FLURRY_OF_BLOWS);
           SendChatLogMessage(pcc.oPC, C_GREEN+"Mode Set!"+C_END + "\n", pcc.oPC, 5);
        }
        else SendChatLogMessage(pcc.oPC, C_RED+"You don't have the feat required for this mode!"+C_END + "\n", pcc.oPC, 5);
    }
    else if (pcc.sCommand ==  "rapidshot"){
        if(GetHasFeat(FEAT_RAPID_SHOT, pcc.oPC)){
           SetLocalInt(pcc.oPC, "FKY_CHAT_MODE", ACTION_MODE_RAPID_SHOT);
           SendChatLogMessage(pcc.oPC, C_GREEN+"Mode Set!"+C_END + "\n", pcc.oPC, 5);
        }
        else SendChatLogMessage(pcc.oPC, C_RED+"You don't have the feat required for this mode!"+C_END + "\n", pcc.oPC, 5);
    }
    else if (pcc.sCommand ==  "powerattack"){
        if(GetHasFeat(FEAT_POWER_ATTACK, pcc.oPC)){
           SetLocalInt(pcc.oPC, "FKY_CHAT_MODE", ACTION_MODE_POWER_ATTACK);
           SendChatLogMessage(pcc.oPC, C_GREEN+"Mode Set!"+C_END + "\n", pcc.oPC, 5);
        }
        else SendChatLogMessage(pcc.oPC, C_RED+"You don't have the feat required for this mode!"+C_END + "\n", pcc.oPC, 5);
    }
    else if (pcc.sCommand ==  "imppowerattack"){
        if(GetHasFeat(FEAT_IMPROVED_POWER_ATTACK, pcc.oPC)){
            SetLocalInt(pcc.oPC, "FKY_CHAT_MODE", ACTION_MODE_IMPROVED_POWER_ATTACK);
            SendChatLogMessage(pcc.oPC, C_GREEN+"Mode Set!"+C_END + "\n", pcc.oPC, 5);
        }
        else SendChatLogMessage(pcc.oPC, C_RED+"You don't have the feat required for this mode!"+C_END + "\n", pcc.oPC, 5);
    }
    else if (pcc.sCommand ==  "defcast"){
        SetLocalInt(pcc.oPC, "FKY_CHAT_MODE", ACTION_MODE_DEFENSIVE_CAST);
        SendChatLogMessage(pcc.oPC, C_GREEN+"Mode Set!"+C_END + "\n", pcc.oPC, 5);
    }
//    else if (pcc.sCommand ==  "counterspell"){
//        if(GetHasFeat(FEAT_EXPERTISE, pcc.oPC)){
//            SetLocalInt(pcc.oPC, "FKY_CHAT_MODE", ACTION_MODE_COUNTERSPELL);
//            SendChatLogMessage(pcc.oPC, C_GREEN+"Mode Set!"+C_END + "\n", pcc.oPC, 5);
//        }
//        else SendChatLogMessage(oPC, C_RED+"You don't have the feat required for this mode!"+C_END + "\n", oPC, 5);
//    }
    //else if (pcc.sCommand ==  "defensivecast") nMode = ACTION_MODE_DEFENSIVE_CAST;
    else if (pcc.sCommand ==  "xpbank on"){
        // Mode removed.
        /*
        if(!GetIsNormalRace(pcc.oPC)){
            ErrorMessage(pcc.oPC, "You are unable to use the XP Bank with Subraces!");
            return;
        }
        */
        SetLocalInt(pcc.oPC, "FKY_CHAT_XPBANK", TRUE);
        SendChatLogMessage(pcc.oPC, C_GREEN+"XPBank Mode has been activated!"+C_END + "\n", pcc.oPC, 5);
    }
    else if (pcc.sCommand ==  "xpbank off"){
        // Mode removed.
        SendChatLogMessage(pcc.oPC, C_GREEN+"XPBank Mode has been deactivated!"+C_END + "\n", pcc.oPC, 5);
        DeleteLocalInt(pcc.oPC, "FKY_CHAT_XPBANK");
    }
    else if (pcc.sCommand ==  "none"){
        // Mode removed.
        SendChatLogMessage(pcc.oPC, C_GREEN+"Mode removed!"+C_END + "\n", pcc.oPC, 5);
        DeleteLocalInt(pcc.oPC, "FKY_CHAT_MODE");
    }
    else{
        SendChatLogMessage(pcc.oPC, C_RED+"Invalid mode!"+C_END + "\n", pcc.oPC, 5);
    }
}

void DoPartyFix(object oPC){
    object oLeader = GetFirstFactionMember(oPC);
    if(oLeader == oPC)
        oLeader = GetNextFactionMember(oPC);

    RemoveFromParty(oPC);
    DelayCommand(1.0, AddToParty(oPC, oLeader));
}


void DoPartyJoin(struct pl_chat_command pcc){
    pcc.oTarget = VerifyTarget(pcc, OBJECT_TARGET, COMMAND_SYMBOL);
    if (!GetIsObjectValid(pcc.oTarget)) return;

    //if (((nCChannel == 4) ||(nCChannel == 20)) && GetIsObjectValid(pcc.oTarget))//can now target with command targeter
    if (!GetIsPC(pcc.oTarget)){
        FloatingTextStringOnCreature(C_RED+PC_ONLY+C_END, pcc.oPC, FALSE);
        return;
    }

    if (pcc.oPC == pcc.oTarget){
        FloatingTextStringOnCreature(C_RED+"You cannot use this command on yourself!"+C_END, pcc.oPC, FALSE);
        return;
    }

    object oLeader = GetFirstFactionMember(pcc.oPC);
    if(oLeader != OBJECT_INVALID)
        RemoveFromParty(pcc.oPC);

    DelayCommand(1.0, AddToParty(pcc.oPC, pcc.oTarget));
}

void DoPlayerInfo(struct pl_chat_command pcc){
    pcc.oTarget = VerifyTarget(pcc, OBJECT_TARGET, COMMAND_SYMBOL);
    if (!GetIsObjectValid(pcc.oTarget)) return;

    //if ((nCChannel == 4) || (nCChannel == 20))//can now target with the command targeter
    if (GetIsPC(pcc.oTarget)){
        ShowInfo(pcc.oPC, pcc.oTarget);
    }
    else FloatingTextStringOnCreature(C_RED+PC_ONLY+C_END, pcc.oPC, FALSE);
    //else FloatingTextStringOnCreature(C_RED+NFO14+C_END, pcc.oPC, FALSE);
}

void DoPlayerList(object oPC){
    object oPlayer = GetFirstPC();
    string sMsg;

    while(oPlayer != OBJECT_INVALID){
        if(!GetIsDM(oPlayer) && !GetIsDMPossessed(oPlayer))
            sMsg += GetName(oPlayer)+" ("+ GetName(GetArea(oPlayer)) +")\n";

        oPlayer = GetNextPC();
    }
    SendMessageToPC(oPC, C_WHITE+sMsg+C_END);
}

void DoPMShape(struct pl_chat_command pcc){ // !pmshape <3>
    pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 8);
    int nType, nPM = GetLevelByClass(CLASS_TYPE_PALEMASTER, pcc.oPC);

    if(VerifyNumber(pcc.oPC, pcc.sCommand)){
        nType = StringToInt(pcc.sCommand);
        switch(nType){
            case 0: //spectre
                DeleteLocalInt(pcc.oPC, "PL_PM_SHAPE");
                SendMessageToPC(pcc.oPC, C_GREEN+"PM shape set to default!"+C_END);
                return;
            break;
            case 1: //spectre
                if(nPM < 10){
                    ErrorMessage(pcc.oPC, "You do not have enough PM Levels to use this shape!");
                    return;
                }
            break;
            case 2: //Vampire
                if(nPM < 15){
                    ErrorMessage(pcc.oPC, "You do not have enough PM Levels to use this shape!");
                    return;
                }
            break;
            case 3: //Risen Lord
                if(nPM < 20){
                    ErrorMessage(pcc.oPC, "You do not have enough PM Levels to use this shape!");
                    return;
                }
            break;
            case 4: //Dracolich
                if(nPM < 25){
                    ErrorMessage(pcc.oPC, "You do not have enough PM Levels to use this shape!");
                    return;
                }
            break;
            default:
                ErrorMessage(pcc.oPC, "Unrecognized shape. 1: Spectre; 2: Vampire; " +
                    "3. Risen Lord; 4. Dracolich");
                return;
        }

        SetLocalInt(pcc.oPC, "PL_PM_SHAPE", nType);
        SendMessageToPC(pcc.oPC, "PM shape set!  Use !pmshape 0 to return to your level default."+C_END);
    }
}

/*
void DoSpeak(struct pl_chat_command pcc){
    pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 6);
    int nText = GetLanguageNumber(pcc.sCommand), nLang;
    if (nText == -1) FloatingTextStringOnCreature(C_RED+LANG1+C_END, pcc.oPC, FALSE);
    else if (nText == 109)//revert to speaking common
    {
        nLang = GetLocalInt(pcc.oPC, "FKY_CHT_SPEAKING");//what they were speaking
        if (nLang){
            DeleteLocalInt(pcc.oPC, "FKY_CHT_SPEAKING");
            SendMessageToPC(pcc.oPC, C_RED+SPEAK1+ GetNameOfLanguage(nLang) + "."+C_END);
        }
        else SendMessageToPC(pcc.oPC, C_RED+SPEAK2+C_END);
    }
    else //set them to speak the language from that point on if they are able to
    {
        nLang = GetLocalInt(pcc.oPC, "FKY_CHT_SPEAKING");//what they were speaking
        if (nLang == nText) SendMessageToPC(pcc.oPC, C_RED+SPEAK3+ GetNameOfLanguage(nLang) + "!"+C_END);
        else if (GetLocalInt(pcc.oPC, "FKY_CHAT_LANG" + IntToString(nText)))//can they speak it?
        {
            SetLocalInt(pcc.oPC, "FKY_CHT_SPEAKING", nText);
            SendMessageToPC(pcc.oPC, C_RED+SPEAK4+ GetNameOfLanguage(nText)+SPEAK5+GetNameOfLanguage(nLang) + "."+C_END);
        }
        else SendMessageToPC(pcc.oPC, C_RED+SPEAK6+ GetNameOfLanguage(nText) + "!"+C_END);
    }
}
*/

void ReequipItem(object oPC, object oItem, int nInventorySlot){
    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC, ActionUnequipItem(oItem));
    AssignCommand(oPC, ActionEquipItem(oItem, nInventorySlot));
    AssignCommand(oPC, ActionDoCommand(SetCommandable(TRUE)));
    AssignCommand(oPC, SetCommandable(FALSE));
}

void DoReequip(struct pl_chat_command pcc){
    object oItem;
    float fDelay;
    int i;

    for(i = 0; i < 11; i++){
        oItem = GetItemInSlot(i, pcc.oPC);
        if(GetIsObjectValid(oItem) && !GetItemCursedFlag(oItem)){
            DelayCommand(fDelay, ReequipItem(pcc.oPC, oItem, i));
        }
        fDelay += 0.2;
    }
}

void DoRerender(struct pl_chat_command pcc){
    object oArea = GetArea(pcc.oPC);
    if (GetLocalInt(oArea, "NO_PVP")) {
        FloatingTextStringOnCreature(C_RED + "You may not use this command in No PVP areas!" + C_END, pcc.oPC, FALSE);
        return;
    }
    int nUptime = GetLocalInt(GetModule(), "uptime");
    if (GetLocalInt(oArea, "RenderDelay") >= GetLocalInt(GetModule(), "uptime")) {
        FloatingTextStringOnCreature(C_RED + "You may not use this command again so soon!" + C_END, pcc.oPC, FALSE);
        return;
    }
    SetLocalInt(oArea, "RenderDelay", nUptime + 15);

    float fDelay = 0.01;
    location lLoc = GetLocation(pcc.oPC);
    effect eRender = EffectPolymorph(POLYMORPH_TYPE_NULL_HUMAN);
    object oRender = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLoc, FALSE, OBJECT_TYPE_CREATURE);
    while (oRender != OBJECT_INVALID) {
        if (!GetIsPC(oRender) && !GetIsDead(oRender) && !GetPlotFlag(oRender)) {
            SetPlotFlag(oRender, TRUE);
            SetLocalInt(oRender, "RenderPlot", 1);
            DelayCommand(fDelay += 0.01, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRender, oRender, 0.1));
        }
        if (GetLocalInt(oRender, "RenderPlot"))
            AssignCommand(oArea, DelayCommand(fDelay + 2.0, SetPlotFlag(oRender, FALSE)));

        oRender = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLoc, FALSE, OBJECT_TYPE_CREATURE);
    }
    FloatingTextStringOnCreature(C_GREEN + "Creatures rerendered!" + C_END, pcc.oPC, FALSE);
}

void DoResetDelay(struct pl_chat_command pcc){
    int nResetsDelayed = GetLocalInt(GetModule(), "RESETS_DELAYED");
    int nResetsVotes = GetLocalInt(GetModule(), "RESETS_VOTED");

    if(nResetsDelayed >= 2){
        ErrorMessage(pcc.oPC, "The reset cannot delayed!");
        return;
    }

    if(SRV_RESET_LENGTH - GetLocalInt(GetModule(), "MOD_RESET_TIMER") > 15){
        ErrorMessage(pcc.oPC, "You cannot vote unless there is less than 15 minutes to reset!");
        return;
    }

    if(nResetsVotes >= 3){
        DeleteLocalInt(GetModule(), "RESETS_VOTED");
        nResetsDelayed++;
        SetLocalInt(GetModule(), "RESETS_DELAYED", nResetsDelayed);
        ResetDelay();
    }
    else{
        nResetsVotes++;
        SetLocalInt(GetModule(), "RESETS_VOTED", nResetsVotes);
    }
}

void DoSetname(struct pl_chat_command pcc){
    pcc.oTarget = VerifyTarget(pcc, ITEM_TARGET, COMMAND_SYMBOL, FALSE, FALSE);
    if (!GetIsObjectValid(pcc.oTarget)) return;

    pcc.sCommand = GetStringRight(pcc.sOriginal, GetStringLength(pcc.sCommand) - 8);//switch in the normal case - they are the same length atm
    SetName(pcc.oTarget, pcc.sCommand);
}


void DoSetdesc(struct pl_chat_command pcc){

    if(pcc.oTarget != pcc.oPC){
        pcc.oTarget = VerifyTarget(pcc, ITEM_TARGET, COMMAND_SYMBOL, FALSE, FALSE);
        if (!GetIsObjectValid(pcc.oTarget)) return;
    }

    pcc.sCommand = GetStringRight(pcc.sOriginal, GetStringLength(pcc.sCommand) - 8);//switch in the normal case - they are the same length atm
    SetDescription(pcc.oTarget, pcc.sCommand);
}

void DoSkillCheckCom(struct pl_chat_command pcc){
    pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 11);
    int nPos = FindSubString(pcc.sCommand, " ");
    string sSort = GetStringLeft(pcc.sCommand, nPos);
    pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - (nPos+1));
    if ((!TestStringAgainstPattern("*n", sSort)) ||  (!TestStringAgainstPattern("*n", pcc.sCommand))) FloatingTextStringOnCreature(C_RED+REQUIRES_NUMBER+C_END, pcc.oPC, FALSE);
    else DoSkillCheck(pcc.oPC, StringToInt(sSort), StringToInt(pcc.sCommand));
}

void DoSkillList(struct pl_chat_command pcc){
    pcc.sCommand = "";
    int nPos;
    for (nPos = 0; nPos < 27; nPos++){
        pcc.sCommand += IntToString(nPos) + ": " + GetSkillName(nPos) + NEWLINE;
    }
    SendMessageToPC(pcc.oPC, pcc.sCommand);
}

void DoSummon(struct pl_chat_command pcc){ // summon <thing>
    pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 7);
    if(pcc.sCommand == "") return;

    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, pcc.oPC);
    if(oSummon == OBJECT_INVALID)
        oSummon = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, pcc.oPC);
    if(oSummon == OBJECT_INVALID){
        ErrorMessage(pcc.oPC, "You have no henchman or summon!");
        return;
    }
    if(pcc.sCommand == "offense") // summon offense
        SetLocalInt(oSummon, "X2_L_BEH_OFFENSE", 100);
    else if(pcc.sCommand == "defense")
        SetLocalInt(oSummon, "X2_L_BEH_OFFENSE", -100);
    else if(pcc.sCommand == "spells off")
        SetLocalInt(oSummon, "X2_L_BEH_MAGIC", -100);
    else if(pcc.sCommand == "spells on")
        DeleteLocalInt(oSummon, "X2_L_BEH_MAGIC");
    else if(pcc.sCommand == "clear"){
        DeleteLocalInt(oSummon, "X2_L_BEH_MAGIC");
        DeleteLocalInt(oSummon, "X2_L_BEH_OFFENSE");
    }
    else if(pcc.sCommand == "state"){
        string sMsg = "Summon: " + GetName(oSummon) + "\n";
        sMsg += "Combat: ";
        if(GetLocalInt(oSummon, "X2_L_BEH_OFFENSE") < 0)
            sMsg += "Defensive" + "\n";
        else if(GetLocalInt(oSummon, "X2_L_BEH_OFFENSE") > 0)
            sMsg += "Offensive" + "\n";
        else
            sMsg += "Mixed" + "\n";
        if(GetLocalInt(oSummon, "X2_L_BEH_MAGIC") < 0)
            sMsg += "Spells: Off" + "\n";
        else
            sMsg += "Spells: On" + "\n";

        SendMessageToPC(pcc.oPC, C_WHITE+sMsg+C_END);
    }
}

void DoTarget(struct pl_chat_command pcc){
    string sSort = GetLocalString(pcc.oPC, "FKY_CHAT_COMMAND"), sKey;
    location lLoc;

    if (sSort != ""){
        if (pcc.nChannel == 4 || pcc.nChannel == 20) //must be sent in tell
        {
            if (GetIsObjectValid(pcc.oTarget)){
                sKey = GetStringLeft(sSort, 1);
                sSort = GetStringRight(sSort, GetStringLength(sSort) - 1);
                if (sKey == AREA_TARGET_OK || sKey == OBJECT_TARGET){
                    SetLocalObject(pcc.oPC, "FKY_CHAT_TARGET", pcc.oTarget);
                    DeleteLocalString(pcc.oPC, "FKY_CHAT_COMMAND");
                    SetLocalString(pcc.oPC, "FKY_CHAT_COMMAND_EXE", sSort);//set the command to speak on them
                    DelayCommand(0.1, ExecuteScript("fky_chat_command", pcc.oPC));//this ensures the spoken string fires the chat script again
                }
                else if (sKey == LOCATION_TARGET){
                    lLoc = GetLocation(pcc.oTarget);
                    if (GetIsObjectValid(GetAreaFromLocation(lLoc))){
                        SetLocalLocation(pcc.oPC, "FKY_CHAT_LOCATION", lLoc);
                        DeleteLocalString(pcc.oPC, "FKY_CHAT_COMMAND");//here we only delete if they selected a valid location - otherwise propmpt for retry
                        SetLocalString(pcc.oPC, "FKY_CHAT_COMMAND_EXE", sSort);//set the command to speak on them
                        DelayCommand(0.1, ExecuteScript("fky_chat_command", pcc.oPC));//this ensures the spoken string fires the chat script again
                    }
                    else FloatingTextStringOnCreature(C_RED+TARGETER_ERROR3+C_END, pcc.oPC, FALSE);
                }
                else if (sKey == ITEM_TARGET){
                    DeleteLocalString(pcc.oPC, "FKY_CHAT_COMMAND");
                    FloatingTextStringOnCreature(C_RED + TARGETER_ERROR5 + C_END, pcc.oPC, FALSE);
                }
                else{
                    DeleteLocalString(pcc.oPC, "FKY_CHAT_COMMAND");
                    FloatingTextStringOnCreature(C_RED + TARGETER_ERROR5 + C_END, pcc.oPC, FALSE);
                }
            }
            else FloatingTextStringOnCreature(C_RED + TARGET_ON_SERV + C_END, pcc.oPC, FALSE);
        }
        else{
            DeleteLocalString(pcc.oPC, "FKY_CHAT_COMMAND");
            FloatingTextStringOnCreature(C_RED + TARGET_REQ_TELL1 + C_END + C_GREEN + COMMAND_SYMBOL+"target "+ C_END + C_RED + TARGET_REQ_TELL2 + C_END, pcc.oPC, FALSE);
        }
    }
    else FloatingTextStringOnCreature(C_RED + TARGET_NO_COMM + C_END, pcc.oPC, FALSE);
}

void DoUnignore(struct pl_chat_command pcc){
    //if (((pcc.nChannel == 4) ||(pcc.nChannel == 20)) && GetIsObjectValid(pcc.oTarget))//can now be targeted with the command targeter
    //{
    pcc.oTarget = VerifyTarget(pcc, OBJECT_TARGET, COMMAND_SYMBOL);
    if (!GetIsObjectValid(pcc.oTarget)) return;
        if (GetIsPC(pcc.oTarget)){
            string sTarget = GetPCPlayerName(pcc.oTarget);
            if (GetLocalInt(pcc.oPC, "FKY_CHT_IGNORE" + sTarget) == TRUE){
                string sPlayer = GetPCPlayerName(pcc.oPC);
                DeleteLocalInt(pcc.oPC, "FKY_CHT_IGNORE" + sTarget);//ignore list stored on PC ignoring
                SendMessageToPC(pcc.oPC, C_RED+UNIGNORE1+ sTarget + "."+C_END);
                SendMessageToPC(pcc.oTarget, C_RED + sPlayer+UNIGNORE2+C_END);
            }
            else FloatingTextStringOnCreature(C_RED+UNIGNORE3+ sTarget + "!"+C_END, pcc.oPC, FALSE);
        }
        else FloatingTextStringOnCreature(C_RED+PC_ONLY+C_END, pcc.oPC, FALSE);
    //}
    //else FloatingTextStringOnCreature(C_RED+UNIGNORE4+C_END, pcc.oPC, FALSE);
}


void DoUnanon(struct pl_chat_command pcc){
    DeleteLocalInt(pcc.oPC, "FKY_CHAT_ANON");
    SendMessageToPC(pcc.oPC, C_RED+UNANON+C_END);
}

void DoUnafk(struct pl_chat_command pcc){
    DeleteLocalInt(pcc.oPC, "FKY_CHAT_AFK");
    SendServerMessage(pcc.oPC, "[AFK] " + GetName(pcc.oPC) + " is back.");
}

void DoWeaponVisuals(struct pl_chat_command pcc){
    pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 2);
    object oRH = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, pcc.oPC);
    int nWpnVFX;

    if(oRH == OBJECT_INVALID)
        return;

    int nText = FindSubString("ac co el ev fi ho so none", pcc.sCommand);
    switch (nText){          //0  3  6  9  12 15 18 21
        case  0: nWpnVFX = ITEM_VISUAL_ACID; break;
        case  3: nWpnVFX = ITEM_VISUAL_COLD; break;
        case  6: nWpnVFX = ITEM_VISUAL_ELECTRICAL; break;
        case  9: nWpnVFX = ITEM_VISUAL_EVIL; break;
        case 12: nWpnVFX = ITEM_VISUAL_FIRE; break;
        case 15: nWpnVFX = ITEM_VISUAL_HOLY; break;
        case 18: nWpnVFX = ITEM_VISUAL_SONIC; break;
        case 21: IPRemoveMatchingItemProperties(oRH, ITEM_PROPERTY_VISUALEFFECT,
                                                DURATION_TYPE_PERMANENT);
            return;
            break;
    }

    ApplyVisualToObject(VFX_IMP_SUPER_HEROISM, pcc.oPC);
    AddVisualToWeapon(oRH, nWpnVFX, 0.0);
}

const int MAX_SPELLBOOKS = 3;

void EmptySpellbook(object oPC, int nClass){
    int nMaxSlots, nLevel, i;

    for(nLevel = 0; nLevel < 10; nLevel++){
        nMaxSlots = GetMaxSpellSlots(oPC, nClass, nLevel);
        for(i = 0; i < nMaxSlots; i++){
            ClearMemorizedSpell(oPC, nClass, nLevel, i);
        }
    }
}

void DeleteSavedSpellbook(object oPC, int nSlot){
    int nLevel;

    DeleteHideString(oPC, "SB_NAME_" + IntToString(nSlot));
    DeleteHideString(oPC, "SB_CLASS_" + IntToString(nSlot));

    for(nLevel = 0; nLevel < 10; nLevel++){
        DeleteHideString(oPC, "SB_" + IntToString(nSlot) +"_"+ IntToString(nLevel));
    }
}

void DoSpellbook(struct pl_chat_command pcc){ // "sb "
    pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 3);

    int nClass, nLevel, nMaxSlots, i, nSlot;
    string sName, sLevel, sSpell;

    struct MemorizedSpellSlot sMSS;

    int nText = FindSubString("delete list", pcc.sCommand);
                            // 0      8

    SendMessageToPC(pcc.oPC, "nText: " + IntToString(nText));
    switch (nText)
    {
        case -1: /* Number or Error CommandRedirect(pcc.oPC, 4); */
            if(VerifyNumber(pcc.oPC, pcc.sCommand)){ // Try to load spellbook
                nSlot = StringToInt(pcc.sCommand);
                sName = GetHideString(pcc.oPC, "SB_NAME_" + IntToString(nSlot));
                nClass = GetHideInt(pcc.oPC, "SB_CLASS_" + IntToString(nSlot));
                sMSS.ready = 0; // No loaded spells will be ready for use;
                if(sName != ""){
                    for(nLevel = 0; nLevel < 10; nLevel++){
                        sLevel = GetHideString(pcc.oPC, "SB_" + IntToString(nSlot) + "_" + IntToString(nLevel));

                        Logger(pcc.oPC, VAR_DEBUG_LOGS, LOGLEVEL_NONE, sLevel);
                        if(sLevel == "") continue;
                        i = 0;
                        nMaxSlots = GetMaxSpellSlots(pcc.oPC, nClass, nLevel);
                        while(sLevel != "" && i <= nMaxSlots){
                            sSpell = StringParse(sLevel, "~");
                            Logger(pcc.oPC, VAR_DEBUG_LOGS, LOGLEVEL_NONE, sLevel);
                            sMSS.id = StringToInt(sSpell);
                            if(sMSS.id == -1){
                                sMSS.meta = 0;
                            }
                            else{
                                sMSS.meta = sMSS.id % 1000;
                                sMSS.id = sMSS.id / 1000;
                            }
                            SetMemorizedSpell(pcc.oPC, nClass, nLevel, i, sMSS);
                            sLevel = StringRemoveParsed(sLevel, sSpell, "~");
                            i++;
                        }
                    }
                    SendMessageToPC(pcc.oPC, C_GREEN+"Spellbook " + sName + " has been loaded."+C_END);
                }
                else SendMessageToPC(pcc.oPC, C_RED+"You have not saved a spellbook in slot " + pcc.sCommand + "."+C_END);
             }
        break;
        case 0: // Delete Spellbook
            DeleteSavedSpellbook(pcc.oPC, nSlot);
        break;
         case 8: // List - !sb list
            string sMessage = C_WHITE + "You have the following spellbooks:\n";
            for(nSlot = 0; nSlot < MAX_SPELLBOOKS; nSlot++){
                sName = GetHideString(pcc.oPC, "SB_NAME_" + IntToString(nSlot));
                nClass = GetHideInt(pcc.oPC, "SB_CLASS_" + IntToString(nSlot));
                if(sName == "") sName = "Empty";

                sMessage += "    " + C_WHITE + "#" + IntToString(nSlot) + " " +
                C_LT_PURPLE + sName + "(" +GetClassName(nClass) + ")\n";
                SendChatLogMessage(pcc.oPC, sMessage + C_END + "\n", pcc.oPC, 5);
            }
        break;
    }
}

void DoClassSpellbook(struct pl_chat_command pcc){ // "sb"
    pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 2);
    int nClass, nSlot, nLevel, nMaxSlots, i;
    struct MemorizedSpellSlot sMSS;
    string sName;

    //w = wizard, c = cleric, p = pally, r = ranger, d = druid
    if("w " == GetStringLeft(pcc.sCommand, 2)){
        nClass = CLASS_TYPE_WIZARD;
    }
    else if("c " == GetStringLeft(pcc.sCommand, 2)){
        nClass = CLASS_TYPE_CLERIC;
    }
    else if("d " == GetStringLeft(pcc.sCommand, 2)){
        nClass = CLASS_TYPE_DRUID;
    }
/*
    else if("p " == GetStringLeft(pcc.sCommand, 2)){
        nClass = CLASS_TYPE_PALADIN;
    }
    else if("r " == GetStringLeft(pcc.sCommand, 2)){
        nClass = CLASS_TYPE_RANGER;
    }
*/
    else{
        SendMessageToPC(pcc.oPC, "No class identifier.");
        return;
    }
    pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 2);

    if("empty" == GetStringLeft(pcc.sCommand, 5)){
        EmptySpellbook(pcc.oPC, nClass);
    }
    else if("fill" == GetStringLeft(pcc.sCommand, 4)){
        //Unimplemented
    }
    else if("save " == GetStringLeft(pcc.sCommand, 5)){
                /* Save - !sb<class> save <name> <slot:0-3>
                 * !sbw save <name> <0-3> */
        pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 5);
        if(!VerifyNumber(pcc.oPC, GetStringRight(pcc.sCommand, 1))) return;

        sName = GetStringLeft(pcc.sCommand, GetStringLength(pcc.sCommand) - 2);
        nSlot = StringToInt(GetStringRight(pcc.sCommand, 1));

        if(nSlot > MAX_SPELLBOOKS || nSlot < 0){
            SendMessageToPC(pcc.oPC, "Spellbook slots are 0-" + IntToString(MAX_SPELLBOOKS));
            return;
        }
        DeleteSavedSpellbook(pcc.oPC, nSlot);

        SetHideString(pcc.oPC, "SB_NAME_" + IntToString(nSlot), sName);
        SetHideInt(pcc.oPC, "SB_CLASS_" + IntToString(nSlot), nClass);

        // Level: (<spellid>*1000)+<meta>~
        string sSpell, sLevel;
        for(nLevel = 0; nLevel < 10; nLevel++){
            sLevel = "";
            nMaxSlots = GetMaxSpellSlots(pcc.oPC, nClass, nLevel);
            for(i = 0; i < nMaxSlots; i++){
                sMSS = GetMemorizedSpell (pcc.oPC, nClass, nLevel, i);
                if(sMSS.id == -1) sSpell = IntToString(-1);
                else sSpell = IntToString((sMSS.id * 1000) + sMSS.meta);
                sLevel += sSpell + "~";
            }
            if(sLevel !=  "")
                SetHideString(pcc.oPC, "SB_" + IntToString(nSlot) + "_" + IntToString(nLevel), GetStringLeft(sLevel, GetStringLength(sLevel) -1));

            Logger(pcc.oPC, VAR_DEBUG_LOGS, LOGLEVEL_NONE, sLevel);
        }
        SendMessageToPC(pcc.oPC, "Spellbook " + sName + "has been saved in slot " + IntToString(nSlot));
    }
    else{
        SendMessageToPC(pcc.oPC, "Command Error.");
        return;
    }
}



void DoQuickslot(struct pl_chat_command pcc){// !qb
    int i, nPos;
    string sCmd = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 3);

    if (sCmd == "list") {
        string sMessage = C_WHITE + "You have the following quickbars:\n";
        for (i = 0; i < 10; i++) {
            string sBar = GetHideString(pcc.oPC, "QuickBar_" + IntToString(i));
            if ((nPos = FindSubString(sBar, " ")) >= 0)
                sMessage += "    " + C_WHITE + "#" + IntToString(i) + " " +
                C_LT_PURPLE + GetStringLeft(sBar, nPos) + "\n";
        }
        SendChatLogMessage(pcc.oPC, sMessage + C_END + "\n", pcc.oPC, 5);
    } else if (GetStringLeft(sCmd, 5) == "save ") {
        int nBar, nSave = 0;
        string sName = "";
        nBar = FindSubString("0 1 2 3 4 5 6 7 8 9 ", GetSubString(sCmd, 5, 2));
        sCmd = GetStringRight(sCmd, GetStringLength(sCmd) - 7);
        if ((nPos = FindSubString(sCmd, " ")) >= 0) {
            sName = GetStringLeft(sCmd, nPos);
            nSave = StringToInt(GetStringRight(sCmd, GetStringLength(sCmd) - (nPos + 1)));
        }
        if (nBar < 0 || sName == "" || nSave < 1 || nSave > 3) {
            FloatingTextStringOnCreature(C_RED + "You must specify a bar number, a name, and which quickbar to save!" + C_END, pcc.oPC, FALSE);
            return;
        }
        sCmd   = sName + " " + IntToString(nSave);
        nBar  /= 2;
        nSave -= 1;
        for (i = 0; i < 12; i++)
            sCmd += "|" + GetRawQuickBarSlot(pcc.oPC, (nSave * 12) + i);

        //SetLocalString(pcc.oPC, "QuickBar_" + IntToString(nBar), sCmd);
        SetHideString(pcc.oPC, "QuickBar_" + IntToString(nBar), sCmd);
        FloatingTextStringOnCreature(C_GREEN + "Quickbar saved!" + C_END, pcc.oPC, FALSE);

    }
    /*
    else if (GetStringLeft(sCmd, 5) == "poly ") {
        int nSlot = StringToInt(GetStringRight(sCmd, GetStringLength(sCmd) - 5));
        if (nSlot < 0 || nSlot > 10) {
            FloatingTextStringOnCreature(C_RED + "You can only specify slots 0-10 for your polymorph quickbar slot!" + C_END, pcc.oPC, FALSE);
            return;
        }
        if (nSlot == 0) {
            DeleteLocalInt(pcc.oPC, "QuickBar_Poly");
            DeleteDbVariable(pcc.oPC, "QuickBar_Poly");
            FloatingTextStringOnCreature(C_GREEN + "Polymorph quickbar slot cleared!" + C_END, pcc.oPC, FALSE);
            return;
        }
        SetLocalInt(pcc.oPC, "QuickBar_Poly", nSlot);
        SetPersistentInt(pcc.oPC, "QuickBar_Poly", nSlot);
        FloatingTextStringOnCreature(C_GREEN + "Polymorph quickbar slot set!" + C_END, pcc.oPC, FALSE);
    }*/
    else {
        int nBar;
        struct SubString ss;
        if ((nBar = StringToInt(sCmd)) < 1 || nBar > 9) {
            if (sCmd != "0") {
                FloatingTextStringOnCreature(C_RED + "You must specify a saved quickbar (0-9) to restore a quickbar!" + C_END, pcc.oPC, FALSE);
                return;
            }
        }
        ss = GetFirstSubString(GetHideString(pcc.oPC, "QuickBar_" + IntToString(nBar)), "|");
        if (ss.first == "") {
            FloatingTextStringOnCreature(C_RED + "You have not saved that quickbar!" + C_END, pcc.oPC, FALSE);
            return;
        }
        while (ss.rest != "") {
            ss = GetFirstSubString(ss.rest, "|");
            SetRawQuickBarSlot(pcc.oPC, ss.first);
        }
        FloatingTextStringOnCreature(C_GREEN + "Quickbar restored!" + C_END, pcc.oPC, FALSE);
    }
}

void DoXPBank(struct pl_chat_command pcc){ // !xpbank
    int nBalance, nWithdraw;
    object oToken;
    pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 7);
    //int nText = FindSubString("withdraw deposit", pcc.sCommand);

    if(pcc.sCommand == ""){// balance
        nBalance = GetLocalInt(pcc.oPC, VAR_PC_XP_BANK);
        SendMessageToPC(pcc.oPC, C_PURPLE+"You currently have " + IntToString(nBalance) + " experience points in your XP Bank."+C_END);

    }
    else if("withdraw " == GetStringLeft(pcc.sCommand, 9)){
        oToken = GetItemPossessedBy(pcc.oPC, "pl_xpbank_token");
        if(oToken == OBJECT_INVALID){
            /*
            if(!GetIsNormalRace(pcc.oPC)){
                ErrorMessage(pcc.oPC, "You are unable to use the XP Bank with Subraces!");
                return;
            }*/
            if(GetHitDice(pcc.oPC) < 40){
                ErrorMessage(pcc.oPC, "You are unable to use the XP Bank until you are 40th level!");
                return;
            }
        }
        pcc.sCommand = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 9);
        if(VerifyNumber(pcc.oPC, pcc.sCommand)){
            nWithdraw = StringToInt(pcc.sCommand);
            nBalance = GetLocalInt(pcc.oPC, VAR_PC_XP_BANK);
            if(nBalance >= nWithdraw){
                nBalance -= nWithdraw;
                SetLocalInt(pcc.oPC, VAR_PC_XP_BANK, nBalance);
                string sql = "UPDATE nwn.players SET xp = "+ IntToString(nBalance)
                    +" WHERE id="+GetPlayerId(pcc.oPC);
                SQLExecDirect(sql);

                if(GetIsObjectValid(oToken)){
                    DestroyObject(oToken);
                    FloatingTextStringOnCreature(C_GREEN+IntToString(nWithdraw)
                        + " XP have been withdrawn from your XP Bank. Current Balance: "+ IntToString(nBalance)+C_END, pcc.oPC, FALSE);
                }
                else{
                    nWithdraw /= 2;
                    FloatingTextStringOnCreature(C_GREEN+IntToString(nWithdraw)
                        + " XP have been withdrawn from your XP Bank with a 50% penalty. Current Balance: "+ IntToString(nBalance)+C_END, pcc.oPC, FALSE);

                }

                GiveTakeXP(pcc.oPC, nWithdraw);
            }
            else{
                SendMessageToPC(pcc.oPC, C_RED+"You do not have " + IntToString(nWithdraw) + " experience points to withdraw."+C_END);
            }
        }
    }
    // Currently Depositing is disabled.
    //else if("deposit " == GetStringLeft(pcc.sCommand, 8)){
    //}
    else SendMessageToPC(pcc.oPC, C_RED+"Command Error!"+C_END);
}



void main(){

    struct pl_chat_command pcc;

    pcc.oPC = OBJECT_SELF;
    pcc.oTarget = GetLocalObject(pcc.oPC, "FKY_CHAT_PCSHUNT_TARGET");
    pcc.sCommand = GetLocalString(pcc.oPC, "FKY_CHAT_PCSHUNT_TEXT");
    pcc.nChannel = GetLocalInt(pcc.oPC, "FKY_CHAT_PCSHUNT_CHANNEL");

    DeleteLocalObject(pcc.oPC, "FKY_CHAT_PCSHUNT_TARGET");
    DeleteLocalString(pcc.oPC, "FKY_CHAT_PCSHUNT_TEXT");
    DeleteLocalInt(pcc.oPC, "FKY_CHAT_PCSHUNT_CHANNEL");

    string sSort;
    int nText, nCount, nPos, nLang, nCheck;
    object oItem;
    location lLoc;
    SetLocalString(pcc.oPC, "NWNX!CHAT!SUPRESS", "1");//suppress command speech no matter what, helps avoid circumvention of shout ban
    if (!GetIsDead(pcc.oPC)){
        pcc.sOriginal = GetStringRight(pcc.sCommand, GetStringLength(pcc.sCommand) - 1); //preserve caps for setname command
        pcc.sCommand = GetStringLowerCase(pcc.sOriginal);  //case insensitive
        WriteTimestampedLogEntry(pcc.sCommand);
        sSort = GetStringLeft(pcc.sCommand, 1);
        nText = FindSubString("abcdefghijklmnopqrstuvwxyz", sSort);
        switch (nText)
        {
            case -1: CommandRedirect(pcc.oPC, 1); break;
    /*a*/   case 0:
                if (GetStringLeft(pcc.sCommand, 3) == "afk") DoAFK(pcc);
                else if (pcc.sCommand == "anon") DoAnon(pcc);
                else CommandRedirect(pcc.oPC, 1);
            break;
    /*b*/   case 1:
            break;
    /*c*/   case 2:
                if (GetStringLeft(pcc.sCommand, 5) == "cdkey") DoCDKey(pcc);
                else if (GetStringLeft(pcc.sCommand, 7) == "convert") DoConvertFeat(pcc);
            break;
    /*d*/   case 3:
                if (GetStringLeft(pcc.sCommand, 6) == "delete") DoDelete(pcc);
                else if (GetStringLeft(pcc.sCommand, 7) == "delevel") DoDelevel(pcc);
                else if (GetStringLeft(pcc.sCommand, 2) == "de") CommandRedirect(pcc.oPC, 2);
                else DoDieRoll(pcc);
            break;
    /*e*/   case 4:
                if (GetStringLeft(pcc.sCommand, 8) == "eleswarm") DoEleSwarm(pcc);
            break;
    /*f*/   case 5:
                if (pcc.sCommand == "follow") DoFollow(pcc);
            break;
    /*g*/   case 6:
            break;

    /*h*/   case 7:
            if (pcc.sCommand ==  "help") ListHelp(pcc.oPC);
            else CommandRedirect(pcc.oPC, 6);
            break;
    /*i*/   case 8:
                if (GetStringLeft(pcc.sCommand, 7) == "ignore ") DoIgnore(pcc);
                else if (GetStringLeft(pcc.sCommand, 2) == "ig") CommandRedirect(pcc.oPC, 8);
                else CommandRedirect(pcc.oPC, 1);
                break;
    /*j*/   case 9:
            break;

    /*k*/   case 10:
            break;

    /*l*/   case 11:
                if (pcc.sCommand == "level") DoLevel(pcc.oPC);
                else if (pcc.sCommand ==  "lfg") DoLFG(pcc);
                else if (GetStringLeft(pcc.sCommand, 2) == "lf") CommandRedirect(pcc.oPC, 8);
                else if (GetStringLeft(pcc.sCommand, 4) == "list") DoList(pcc);
                else if (GetStringLeft(pcc.sCommand, 2) == "li") CommandRedirect(pcc.oPC, 6);
                else CommandRedirect(pcc.oPC, 1);
                break;

    /*m*/   case 12://metachannels
                if (GetStringLeft(pcc.sCommand, 4) == "mode") DoMode(pcc);
                else CommandRedirect(pcc.oPC, 1);
                break;
    /*n*/   case 13:
              CommandRedirect(pcc.oPC, 1);
            break;
    /*o*/   case 14:
            break;

    /*p*/   case 15:
                if(pcc.sCommand == "partyfix") DoPartyFix(pcc.oPC);
                else if (pcc.sCommand == "partyjoin") DoPartyJoin(pcc);
                else if (pcc.sCommand == "partyroll") DoPartyRoll(pcc.oPC);
                else if (GetStringLeft(pcc.sCommand, 2) == "pa") CommandRedirect(pcc.oPC, 3);
                else if (pcc.sCommand == "playerinfo") DoPlayerInfo(pcc);
                else if (pcc.sCommand == "playerlist") DoPlayerList(pcc.oPC);
                else if (GetStringLeft(pcc.sCommand, 2) == "pl") CommandRedirect(pcc.oPC, 2);
                else if (GetStringLeft(pcc.sCommand, 7) == "pmshape") DoPMShape(pcc);
                else CommandRedirect(pcc.oPC, 1);
                break;
    /*q*/   case 16:
                if (GetStringLeft(pcc.sCommand, 3) == "qb ") DoQuickslot(pcc);
                else CommandRedirect(pcc.oPC, 1);
            break;
    /*r*/   case 17:
                if (pcc.sCommand == "reequip") DoReequip(pcc);
                else if (pcc.sCommand == "rerender") DoRerender(pcc);
                else if (pcc.sCommand == "resetdelay") DoResetDelay(pcc);
                else CommandRedirect(pcc.oPC, 1);
            break;

    /*s*/   case 18:
                if (GetStringLeft(pcc.sCommand, 3) == "sb ") DoSpellbook(pcc);
                else if (GetStringLeft(pcc.sCommand, 2) == "sb") DoClassSpellbook(pcc);
                //else if (ENABLE_LANGUAGES && (GetStringLeft(pcc.sCommand, 6) == "speak ")) DoSpeak(pcc);
                //else if (ENABLE_LANGUAGES && (GetStringLeft(pcc.sCommand, 2) == "sp")) CommandRedirect(pcc.oPC, 5);
                else if ((ENABLE_PLAYER_SETNAME || VerifyDMKey(pcc.oPC) || VerifyAdminKey(pcc.oPC))&& (GetStringLeft(pcc.sCommand, 8) == "setname ")) DoSetname(pcc);
                else if (GetStringLeft(pcc.sCommand, 8) == "setdesc ") DoSetdesc(pcc);
                else if ((ENABLE_PLAYER_SETNAME || VerifyDMKey(pcc.oPC) || VerifyAdminKey(pcc.oPC))&& (GetStringLeft(pcc.sCommand, 4) == "setn")) CommandRedirect(pcc.oPC, 4);
                else if (GetStringLeft(pcc.sCommand, 11) == "skillcheck ") DoSkillCheckCom(pcc);
                else if (pcc.sCommand == "skillslist") DoSkillList(pcc);
                else if (GetStringLeft(pcc.sCommand, 2) == "sk") CommandRedirect(pcc.oPC, 3);
                else if (GetStringLeft(pcc.sCommand, 7) == "summon ") DoSummon(pcc);
                else CommandRedirect(pcc.oPC, 1);
                break;
    /*t*/   case 19:
                if (pcc.sCommand ==  "target") DoTarget(pcc);
                else if (pcc.sCommand == "time2reset") Time2Reset(pcc.oPC);
                else CommandRedirect(pcc.oPC, 1);
                break;
    /*u*/   case 20:
                if (pcc.sCommand ==  "unignore") DoUnignore(pcc);
                else if (GetStringLeft(pcc.sCommand, 3) == "uni") CommandRedirect(pcc.oPC, 8);
                else if (pcc.sCommand ==  "unafk") DoUnafk(pcc);
                else if (pcc.sCommand ==  "unanon") DoUnanon(pcc);
                else if (GetStringLeft(pcc.sCommand, 3) == "una") CommandRedirect(pcc.oPC, 2);
                else CommandRedirect(pcc.oPC, 1);
                break;
    /*v*/   case 21:
            break;

    /*w*/   case 22:
                if ((GetStringLeft(pcc.sCommand, 2) == "wp") && ENABLE_WEAPON_VISUALS) DoWeaponVisuals(pcc);
                else CommandRedirect(pcc.oPC, 1);
                break;
    /*x*/   case 23:
                if ((GetStringLeft(pcc.sCommand, 6) == "xpbank")) DoXPBank(pcc);
                else CommandRedirect(pcc.oPC, 1);
            break;
    /*y*/   case 24:
            break;
    /*z*/   case 25:
            break;

        } // << switch (nText)
    } // << if (!GetIsDead(pcc.oPC))
    else FloatingTextStringOnCreature(C_RED+NOT_DEAD+C_END, pcc.oPC, FALSE);//no match
}
