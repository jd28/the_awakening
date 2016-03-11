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

#include "item_func_inc"
#include "fky_chat_const"
#include "fky_chat_config"
#include "vfx_inc"
#include "pc_funcs_inc"
#include "pl_pcguild_inc"
#include "srv_funcs_inc"
#include "info_inc"
#include "area_inc"
#include "pc_persist"

const string sSpeech_SpeechList = "SpeechList_";
const string sSpeech_PlayerID = "SpeechPlayerID_";

//Added by pope_leo to clean and ease command additions.
struct pl_chat_command{
    object oPC, oTarget;
    string sCommand, sOriginal;
    int nChannel;
};

//Shunts the player to the appropriate conversation, sending the message specified in sColor.
//1 = main command
//2 = character
//3 = dice
//4 = items
//5 = language commands
//6 = listing commands
//7 = metachannels
//8 = social
//9 = languages
//11 = main dm command
//12 = dm player management
//13 = dm player management ability and appearance
//14 = dm player management alignment
//15 = dm player management avatar powers
//16 = dm player management banning
//17 = dm player management items
//18 = dm player management teleportation
//19 = dm player management experience
//20 = dm server management
//21 = dm server management time and weather
//22 = dm server management variables
//23 = dm creature management
//24 = dm creature management factions
//25 = dm visual effects
//26 = dm chat commands
//27 = dm chat commands ignore
//43 = dm visual effects duration type
//44 = dm visual effects subtype
void CommandRedirect(object oSpeaker, int nMenu, string sMessage = BADCOMMAND, string sColor = C_RED) {}

object VerifyTarget(struct pl_chat_command pcc, string sCommandType = OBJECT_TARGET, string sCommandSymbol = "dm_", int nPCOnly = TRUE, int nCreatureOnly = TRUE);

//Applys a cutscene invisible and cutscene ghost effect to the target.
void DoDMInvis(object oPlayer);

void InitSpeech()
{
    int nCount;
    object oMod = GetModule();
    // Allocate Memory
    string sMemory;
    for( nCount = 0; nCount < 8; nCount++ ) // Reserve 8*128 bytes
        sMemory += "................................................................................................................................";
    SetLocalString(oMod, "NWNX!CHAT!SPACER", sMemory);
    if (PROCESS_NPC_SPEECH) SetLocalString(oMod, "NWNX!CHAT!LOGNPC", "1");
    if (PROCESS_NPC_SPEECH && IGNORE_SILENT_CHANNELS) SetLocalString(oMod,"NWNX!CHAT!IGNORESILENT","1");
    if (SEND_CHANNELS_TO_CHAT_LOG)
    {
        location lSpawn = GetStartingLocation();
        object oMessenger = CreateObject(OBJECT_TYPE_CREATURE, "fky_chat_sender", lSpawn);
        SetLocalObject(oMod, "FKY_CHT_MESSENGER", oMessenger);
        DoDMInvis(oMessenger);
    }
    SetCustomToken(1701, C_END);
    SetCustomToken(1702, C_GREEN);
    SetCustomToken(1703, C_RED);
    SetCustomToken(1704, C_RED2);
    SetCustomToken(1705, C_WHITE);
    SetCustomToken(1706, C_BLUE);
    SetCustomToken(1707, C_PURPLE);
    SetCustomToken(1708, C_LT_PURPLE);
    SetCustomToken(1709, C_LT_GREEN);
    SetCustomToken(1710, C_ORANGE);
    SetCustomToken(1711, C_GOLD);
    SetCustomToken(1712, C_YELLOW);
    SetCustomToken(1713, C_LT_BLUE);
    SetCustomToken(1714, C_LT_BLUE2);
    SetCustomToken(1715, EMOTE_SYMBOL);
    SetCustomToken(1716, COMMAND_SYMBOL);
}

string Speech_GetSpacer()
{
    return GetLocalString(GetModule(), "NWNX!CHAT!SPACER");
}

void Speech_OnClientEnter(object oPlayer)
{
  if( !GetIsObjectValid(oPlayer) ) return;

  object oMod = GetModule();
  SetLocalString(oPlayer, "NWNX!CHAT!GETID", ObjectToString(oPlayer) + "        ");
  string sID = GetLocalString(oPlayer, "NWNX!CHAT!GETID");
  int nID = StringToInt(sID);
  if( nID != -1)
  {
    SetLocalObject(oMod, sSpeech_SpeechList + sID, oPlayer);
    SetLocalInt(oPlayer, sSpeech_PlayerID, nID);
  }
  DeleteLocalString(oPlayer, "NWNX!CHAT!GETID");
}

void Speech_OnClientExit(object oPlayer)
{
  if( !GetIsObjectValid(oPlayer) ) return;

  int nID = GetLocalInt(oPlayer, sSpeech_PlayerID);
  DeleteLocalInt(oPlayer, sSpeech_PlayerID);
  DeleteLocalObject(GetModule(), sSpeech_SpeechList + IntToString(nID));
}

object Speech_GetPlayer(int nID)
{
  return GetLocalObject(GetModule(), sSpeech_SpeechList + IntToString(nID));
}

string Speech_GetChannel(int nChannel) {
    string sChannel;

    switch(nChannel)
    {
        case 1: sChannel = TALK; break;
        case 2: sChannel = SHOUT; break;
        case 3: sChannel = WHISPER; break;
        case 4: sChannel = TELL; break;
        case 5: sChannel = SERVER; break;
        case 6: sChannel = PARTY; break;
        case 14: sChannel = DM; break;
        case 17: sChannel = TALK; break;
        case 18: sChannel = SHOUT; break;
        case 19: sChannel = WHISPER; break;
        case 20: sChannel = TELL; break;
        case 21: sChannel = SERVER; break;
        case 22: sChannel = PARTY; break;
        case 30: sChannel = DM; break;
        default: sChannel = UNKNOWN; break;
    }
    return sChannel;
}

object GetMessenger()
{
    return GetLocalObject(GetModule(), "FKY_CHT_MESSENGER");
}

void DoLogging(object oSender, string sTarget, int nChan, string sLogText)
{
    string sLogMessage = GetName(oSender) + "(" + GetPCPlayerName(oSender) + ")" + sTarget + "[" + Speech_GetChannel(nChan) + "] " + sLogText + "\n";
    SetLocalString(oSender, "NWNX!CHAT!LOG", sLogMessage);
}

void DoCleanup(object oSender)
{
    DeleteLocalString(oSender, "NWNX!CHAT!TEXT");
    DeleteLocalString(oSender, "NWNX!CHAT!SUPRESS");
    DeleteLocalString(oSender, "NWNX!CHAT!LOG");
}

int ModifiedGetIsSkillSuccessful(object oPC, int nSkill, int nDC)
{
    int nReturn;
    int nRank = GetSkillRank(nSkill, oPC);
    int nRoll = d20();
    if (SILENT_LORE_CHECKS)
    {
        if ((nRank + nRoll) < nDC) return FALSE;
        else return TRUE;
    }
    else
    {
        string sSign;
        if (nRank >= 0) sSign = "+";
        else sSign = "-";
        string sSuccess;
        if ((nRank + 20)< nDC)
        {
            sSuccess = IMPOSSIBLE;
            nReturn = FALSE;
        }
        else if ((nRank + nRoll) < nDC)
        {
            sSuccess = FAILED;
            nReturn = FALSE;
        }
        else
        {
            sSuccess = SUCCESS;
            nReturn = TRUE;
        }
        FloatingTextStringOnCreature(C_PURPLE+GetName(oPC)+C_END+" : "+GetSkillName(nSkill)+" : "+sSuccess+" : ("+IntToString(nRoll)+sSign+IntToString(abs(nRank))+" = "+IntToString(nRoll+nRank)+VERSUS+IntToString(nDC)+")", oPC, FALSE);
        return nReturn;
    }
}

void DoSkillCheck(object oPC, int nSkill, int nDC)
{
    int nRank = GetSkillRank(nSkill, oPC);
    int nRoll = d20();
    string sSign;
    if (nRank >= 0) sSign = "+";
    else sSign = "-";
    string sSuccess;
    if ((nRank + 20) < nDC) sSuccess = C_RED+IMPOSSIBLE+C_END;
    else if ((nRank + nRoll) < nDC) sSuccess = C_RED+FAILED+C_END;
    else sSuccess = C_GREEN+SUCCESS+C_END;
    AssignCommand(oPC, SpeakString(ESCAPE_STRING+C_PURPLE+GetName(oPC)+C_END+" : "+GetSkillName(nSkill)+" : "+sSuccess+" : ("+IntToString(nRoll)+sSign+IntToString(abs(nRank))+" = "+IntToString(nRoll+nRank)+VERSUS+IntToString(nDC)+")"));
}

string ColorEmote(string sEmote, string sShort = ""){
    string sReturn = C_PURPLE+EMOTE_SYMBOL+sEmote+C_END;

    if(sShort != "")
        sReturn += C_WHITE+" ("+C_END+C_PURPLE+EMOTE_SYMBOL+sShort+C_END+C_WHITE+")"+C_END+NEWLINE;

    return sReturn;
}

void ListEmotes(object oPlayer)
{   string sMessage;
    sMessage += ColorEmote("agree", "ag");
    sMessage += ColorEmote("bark", "bk");
    sMessage += ColorEmote("beg", "bg");
    sMessage += C_PURPLE+EMOTE_SYMBOL+"belch "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"bh"+C_END+C_WHITE+") (male only)"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"bend "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"bn"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"bored "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"bo"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"bow "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"bw"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"burp "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"bp"+C_END+C_WHITE+") (male only)"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"bye "+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"cantrip "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"ca"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"cast "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"cs"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"celebrate "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"cl"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"chat "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"ct"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"chant "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"cn"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"cheer "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"ch"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"choke "+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"chortle "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"cr"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"chuckle "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"ck"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"collapse "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"co"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"cough "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"cg"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += ColorEmote("cry");
    sMessage += C_PURPLE+EMOTE_SYMBOL+"curtsy "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"cy"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"dance "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"da"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"dead "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"dd"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"demand "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"dm"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"die "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"di"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"dodge "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"dg"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"drink "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"dr"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"drunk "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"dn"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"duck "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"dk"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"exhausted "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"ex"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"fall "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"fl"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"fatigue "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"fa"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"fiddle "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"fi"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"fidget "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"fg"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"flop "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"fp"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"giggle "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"gi"+C_END+C_WHITE+") (female only)"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"goodbye "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"gb"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"goodnight "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"gt"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"greet "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"gr"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"groan "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"gn"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"guffaw "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"gw"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"hello "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"hl"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"hiccup "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"hp"+C_END+C_WHITE+") (male only)"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"hooray "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"hy"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"hoot "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"ht"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"howl "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"hw"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"hum "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"hm"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"kneel "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"kn"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"laugh "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"la"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += ColorEmote("lie");
    sMessage += C_PURPLE+EMOTE_SYMBOL+"look "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"lk"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"meditate "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"md"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"meow "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"mw"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"moan "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"mn"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"mock "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"mk"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"moo "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"mo"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"nap "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"np"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"no "+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"nod "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"nd"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"nope "+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"ouch "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"ow"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"peer "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"pe"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"plead "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"pl"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"pray "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"pr"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"prone "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"pn"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"puke "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"pu"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"read "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"re"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"rest "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"rt"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"roar "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"rr"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"salute "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"sa"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"scan "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"sn"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"scratch "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"sc"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"scream "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"sm"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"screech "+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"shift "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"sh"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"sing "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"sg"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"sip "+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"sit "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"si"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"sleep "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"sl"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"smoke "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"sk"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"snarl "+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"sneeze "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"sz"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"snore "+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"sob "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"sb"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"spasm "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"sp"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"spit "+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"steal "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"st"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"stoop "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"so"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"stretch "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"sr"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"sway "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"sy"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"swipe "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"sw"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"talk "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"tl"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"taunt "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"ta"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"threaten "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"th"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"tired "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"ti"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"toast "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"tt"+C_END+C_WHITE+") (male only)"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"trip "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"tp"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"vomit "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"vm"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"wail "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"wl"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"wave "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"wa"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"weep "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"wp"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"whistle "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"wh"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"woozy "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"wz"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"worship "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"wo"+C_END+C_WHITE+")"+C_END+NEWLINE;
    sMessage += C_PURPLE+EMOTE_SYMBOL+"yawn "+C_END+C_WHITE+"("+C_END+C_PURPLE+EMOTE_SYMBOL+"yw"+C_END+C_WHITE+")"+C_END+NEWLINE;
    SendMessageToPC(oPlayer, sMessage);
}

void ListModes(object oPlayer)
{
    string sMessage = C_WHITE+"Combat Modes:"+C_END+NEWLINE;
//    sMessage += "Counter Spell: " + C_PURPLE + COMMAND_SYMBOL + "mode counterspell "+C_END+NEWLINE;
    sMessage += "Defensive Casting: " + C_PURPLE + COMMAND_SYMBOL + "mode defcast"+C_END+NEWLINE;
    sMessage += "Expertise: " + C_PURPLE + COMMAND_SYMBOL + "mode expertise "+C_END+NEWLINE;
    sMessage += "Flurry of Blows: " + C_PURPLE + COMMAND_SYMBOL + "mode flurry "+C_END+NEWLINE;
    sMessage += "Improved Expertise: " + C_PURPLE + COMMAND_SYMBOL + "mode impexpertise "+C_END+NEWLINE;
    sMessage += "Improved Power Attack: " + C_PURPLE + COMMAND_SYMBOL + "mode imppowerattack "+C_END+NEWLINE;
    sMessage += "Power Attack: " + C_PURPLE + COMMAND_SYMBOL + "mode powerattack "+C_END+NEWLINE;
    sMessage += "Rapid Shot: " + C_PURPLE + COMMAND_SYMBOL + "mode rapidshot "+C_END+NEWLINE;
    sMessage += "None: " + C_PURPLE + COMMAND_SYMBOL + "mode none "+C_END+NEWLINE;
    SendMessageToPC(oPlayer, sMessage);
}

void ListAliases(object oPlayer){
    string sMessage = C_WHITE+"Aliases:"+C_END+NEWLINE;



    SendMessageToPC(oPlayer, sMessage);
}

void ListNicknames(object oPlayer){
    string sMessage = C_WHITE+"Aliases:"+C_END+NEWLINE;



    SendMessageToPC(oPlayer, sMessage);
}

void ListCommands(object oPlayer)
{
    string sMessage;
    sMessage = C_PURPLE+COMMAND1+C_END+NEWLINE;
    sMessage += C_GREEN+COMMAND2+C_END+NEWLINE;
    sMessage += C_PURPLE + COMMAND_SYMBOL + "d4 "+C_END+NEWLINE;
    sMessage += C_PURPLE + COMMAND_SYMBOL + "d6 "+C_END+NEWLINE;
    sMessage += C_PURPLE + COMMAND_SYMBOL + "d8 "+C_END+NEWLINE;
    sMessage += C_PURPLE + COMMAND_SYMBOL + "d10 "+C_END+NEWLINE;
    sMessage += C_PURPLE + COMMAND_SYMBOL + "d12 "+C_END+NEWLINE;
    sMessage += C_PURPLE + COMMAND_SYMBOL + "d20 "+C_END+NEWLINE;
    sMessage += C_PURPLE + COMMAND_SYMBOL + "d100 "+C_END+NEWLINE;
    sMessage += C_PURPLE + COMMAND_SYMBOL + "partyroll "+C_END+NEWLINE;
    if (VerifyDMKey(oPlayer) || VerifyAdminKey(oPlayer)) sMessage += C_GREEN + COMMAND_SYMBOL + "playerinfo "+C_END+NEWLINE;
    else sMessage += C_GREEN + COMMAND_SYMBOL + "playerinfo "+C_END+NEWLINE;
    sMessage += C_PURPLE + COMMAND_SYMBOL + "anon "+C_END+NEWLINE;
    sMessage += C_PURPLE + COMMAND_SYMBOL + "unanon "+C_END+NEWLINE;
    if (ENABLE_WEAPON_VISUALS) sMessage += C_PURPLE + COMMAND_SYMBOL + "wpac "+C_END+NEWLINE;
    if (ENABLE_WEAPON_VISUALS) sMessage += C_PURPLE + COMMAND_SYMBOL + "wpco "+C_END+NEWLINE;
    if (ENABLE_WEAPON_VISUALS) sMessage += C_PURPLE + COMMAND_SYMBOL + "wpel "+C_END+NEWLINE;
    if (ENABLE_WEAPON_VISUALS) sMessage += C_PURPLE + COMMAND_SYMBOL + "wpev "+C_END+NEWLINE;
    if (ENABLE_WEAPON_VISUALS) sMessage += C_PURPLE + COMMAND_SYMBOL + "wpfi "+C_END+NEWLINE;
    if (ENABLE_WEAPON_VISUALS) sMessage += C_PURPLE + COMMAND_SYMBOL + "wpho "+C_END+NEWLINE;
    if (ENABLE_WEAPON_VISUALS) sMessage += C_PURPLE + COMMAND_SYMBOL + "wpnone "+C_END+NEWLINE;
    sMessage += C_PURPLE + COMMAND_SYMBOL + "help "+C_END+NEWLINE;
    sMessage += C_PURPLE + COMMAND_SYMBOL + "list emotes "+C_END+NEWLINE;
    sMessage += C_PURPLE + COMMAND_SYMBOL + "list commands "+C_END+NEWLINE;
    sMessage += C_PURPLE + COMMAND_SYMBOL + "list ignored "+C_END+NEWLINE;
    sMessage += C_PURPLE + COMMAND_SYMBOL + "list modes "+C_END+NEWLINE;
    sMessage += C_PURPLE + COMMAND_SYMBOL + "lfg "+C_END+NEWLINE;
    if (ENABLE_METACHANNELS) sMessage += C_PURPLE + COMMAND_SYMBOL + "metaaccept "+C_END+NEWLINE;
    if (ENABLE_METACHANNELS) sMessage += C_PURPLE + COMMAND_SYMBOL + "metadecline "+C_END+NEWLINE;
    if (ENABLE_METACHANNELS) sMessage += C_PURPLE + COMMAND_SYMBOL + "metadisband "+C_END+NEWLINE;
    if (ENABLE_METACHANNELS) sMessage += C_GREEN + COMMAND_SYMBOL + "metainvite "+C_END+NEWLINE;
    if (ENABLE_METACHANNELS) sMessage += C_GREEN + COMMAND_SYMBOL + "metakick "+C_END+NEWLINE;
    if (ENABLE_METACHANNELS) sMessage += C_PURPLE + COMMAND_SYMBOL + "metaleave "+C_END+NEWLINE;
    if (ENABLE_METACHANNELS) sMessage += C_PURPLE + COMMAND_SYMBOL + "metalist "+C_END+NEWLINE;
    if (ENABLE_METACHANNELS) sMessage += C_PURPLE + "/m "+C_END+NEWLINE;
    if (ENABLE_PLAYER_SETNAME || VerifyDMKey(oPlayer) || VerifyAdminKey(oPlayer)) sMessage += C_GREEN + COMMAND_SYMBOL + "setname "+C_END+NEWLINE;
    if (PLAYERS_CAN_DELETE || (VerifyDMKey(oPlayer) && DMS_CAN_DELETE) || VerifyAdminKey(oPlayer)) sMessage += C_GREEN + COMMAND_SYMBOL + "delete "+C_END+NEWLINE;
    sMessage += C_PURPLE + COMMAND_SYMBOL + "skillcheck "+C_END+NEWLINE;
    sMessage += C_PURPLE + COMMAND_SYMBOL + "skillslist "+C_END+NEWLINE;
    sMessage += C_GREEN + COMMAND_SYMBOL + "ignore "+C_END+NEWLINE;
    sMessage += C_GREEN + COMMAND_SYMBOL + "unignore "+C_END+NEWLINE;
    SendMessageToPC(oPlayer, sMessage);
}

void ListHelp(object oPlayer)
{
    string sMessage;
    sMessage = C_PURPLE+COMMAND1+C_END+NEWLINE;
    sMessage += C_GREEN+COMMAND2+C_END+NEWLINE;
    sMessage += C_PURPLE + COMMAND_SYMBOL + "d4 "+C_END+C_WHITE+COMMAND2_1+C_END+NEWLINE;
    sMessage += C_PURPLE + COMMAND_SYMBOL + "d6 "+C_END+C_WHITE+COMMAND3+C_END+NEWLINE;
    sMessage += C_PURPLE + COMMAND_SYMBOL + "d8 "+C_END+C_WHITE+COMMAND4+C_END+NEWLINE;
    sMessage += C_PURPLE + COMMAND_SYMBOL + "d10 "+C_END+C_WHITE+COMMAND4_1+C_END+NEWLINE;
    sMessage += C_PURPLE + COMMAND_SYMBOL + "d12 "+C_END+C_WHITE+COMMAND5+C_END+NEWLINE;
    sMessage += C_PURPLE + COMMAND_SYMBOL + "d20 "+C_END+C_WHITE+COMMAND6+C_END+NEWLINE;
    sMessage += C_PURPLE + COMMAND_SYMBOL + "d100 "+C_END+C_WHITE+COMMAND7+C_END+NEWLINE;
    sMessage += C_PURPLE + COMMAND_SYMBOL + "partyroll "+C_END+C_WHITE+COMMAND8+C_END+NEWLINE;
    if (VerifyDMKey(oPlayer) || VerifyAdminKey(oPlayer)) sMessage += C_GREEN + COMMAND_SYMBOL + "playerinfo "+C_END+C_WHITE+COMMAND9+C_END+NEWLINE;
    else sMessage += C_GREEN + COMMAND_SYMBOL + "playerinfo "+C_END+C_WHITE+COMMAND10+C_END+C_LT_PURPLE+COMMAND_SYMBOL+"anon "+C_END+C_WHITE+COMMAND10b+C_END+NEWLINE;
    sMessage += C_PURPLE + COMMAND_SYMBOL + "anon "+C_END+C_WHITE+COMMAND10_1+C_END+C_LT_GREEN+COMMAND_SYMBOL+"playerinfo "+C_END+C_WHITE+COMMAND10b+C_END+NEWLINE;
    sMessage += C_PURPLE + COMMAND_SYMBOL + "unanon "+C_END+C_WHITE+COMMAND10_2+C_END+NEWLINE;
    if (ENABLE_WEAPON_VISUALS) sMessage += C_PURPLE + COMMAND_SYMBOL + "wpac "+C_END+C_WHITE+COMMAND11+C_END+NEWLINE;
    if (ENABLE_WEAPON_VISUALS) sMessage += C_PURPLE + COMMAND_SYMBOL + "wpco "+C_END+C_WHITE+COMMAND12+C_END+NEWLINE;
    if (ENABLE_WEAPON_VISUALS) sMessage += C_PURPLE + COMMAND_SYMBOL + "wpel "+C_END+C_WHITE+COMMAND13+C_END+NEWLINE;
    if (ENABLE_WEAPON_VISUALS) sMessage += C_PURPLE + COMMAND_SYMBOL + "wpev "+C_END+C_WHITE+COMMAND14+C_END+NEWLINE;
    if (ENABLE_WEAPON_VISUALS) sMessage += C_PURPLE + COMMAND_SYMBOL + "wpfi "+C_END+C_WHITE+COMMAND15+C_END+NEWLINE;
    if (ENABLE_WEAPON_VISUALS) sMessage += C_PURPLE + COMMAND_SYMBOL + "wpho "+C_END+C_WHITE+COMMAND16+C_END+NEWLINE;
    if (ENABLE_WEAPON_VISUALS) sMessage += C_PURPLE + COMMAND_SYMBOL + "wpnone "+C_END+C_WHITE+COMMAND50+C_END+NEWLINE;
    sMessage += C_PURPLE + COMMAND_SYMBOL + "help "+C_END+C_WHITE+COMMAND40+C_END+NEWLINE;
    sMessage += C_PURPLE + COMMAND_SYMBOL + "list emotes "+C_END+C_WHITE+COMMAND17+C_END+NEWLINE;
    sMessage += C_PURPLE + COMMAND_SYMBOL + "list commands "+C_END+C_WHITE+COMMAND18+C_END+NEWLINE;
    sMessage += C_PURPLE + COMMAND_SYMBOL + "list ignored "+C_END+C_WHITE+COMMAND19+C_END+NEWLINE;
    sMessage += C_PURPLE + COMMAND_SYMBOL + "lfg "+C_END+C_WHITE+COMMAND22+C_END+NEWLINE;
    if (ENABLE_METACHANNELS) sMessage += C_PURPLE + COMMAND_SYMBOL + "metaaccept "+C_END+C_WHITE+COMMAND23+C_END+NEWLINE;
    if (ENABLE_METACHANNELS) sMessage += C_PURPLE + COMMAND_SYMBOL + "metadecline "+C_END+C_WHITE+COMMAND24+C_END+NEWLINE;
    if (ENABLE_METACHANNELS) sMessage += C_PURPLE + COMMAND_SYMBOL + "metadisband "+C_END+C_WHITE+COMMAND25+C_END+NEWLINE;
    if (ENABLE_METACHANNELS) sMessage += C_GREEN + COMMAND_SYMBOL + "metainvite "+C_END+C_WHITE+COMMAND26+C_END+NEWLINE;
    if (ENABLE_METACHANNELS) sMessage += C_GREEN + COMMAND_SYMBOL + "metakick "+C_END+C_WHITE+COMMAND27+C_END+NEWLINE;
    if (ENABLE_METACHANNELS) sMessage += C_PURPLE + COMMAND_SYMBOL + "metaleave "+C_END+C_WHITE+COMMAND28+C_END+NEWLINE;
    if (ENABLE_METACHANNELS) sMessage += C_PURPLE + COMMAND_SYMBOL + "metalist "+C_END+C_WHITE+COMMAND29+C_END+NEWLINE;
    if (ENABLE_METACHANNELS) sMessage += C_PURPLE + "/m "+C_END+C_WHITE+COMMAND30+C_END+NEWLINE;
    if (ENABLE_PLAYER_SETNAME || VerifyDMKey(oPlayer) || VerifyAdminKey(oPlayer)) sMessage += C_GREEN + COMMAND_SYMBOL + "setname "+C_END+C_WHITE+COMMAND31+C_LT_GREEN+COMMAND_SYMBOL+"setname ("+COMMAND31c+")"+C_END+C_WHITE+COMMAND31d+C_LT_GREEN+COMMAND_SYMBOL+"setname "+COMMAND31f+C_END+C_WHITE+COMMAND31g+C_END+NEWLINE;
    if (PLAYERS_CAN_DELETE || (VerifyDMKey(oPlayer) && DMS_CAN_DELETE) || VerifyAdminKey(oPlayer)) sMessage += C_GREEN + COMMAND_SYMBOL + "delete "+C_END+C_WHITE+COMMAND49+C_LT_GREEN + COMMAND_SYMBOL+"playerinfo"+C_END+C_WHITE+COMMAND48+ C_END+NEWLINE;
    sMessage += C_PURPLE + COMMAND_SYMBOL + "skillcheck "+C_END+C_WHITE+COMMAND33+C_LT_PURPLE+COMMAND_SYMBOL+"skillcheck "+COMMAND33b+C_END+C_WHITE+COMMAND33c+C_LT_PURPLE+COMMAND_SYMBOL+"skillcheck 3 20"+C_END+C_WHITE+COMMAND33d+C_LT_PURPLE+COMMAND_SYMBOL+"skillslist"+C_END+C_WHITE+COMMAND33e+C_END+NEWLINE;
    sMessage += C_PURPLE + COMMAND_SYMBOL + "skillslist "+C_END+C_WHITE+COMMAND34+C_LT_PURPLE+COMMAND_SYMBOL+"skillcheck"+C_END+C_WHITE+COMMAND34b+C_END+NEWLINE;
    sMessage += C_GREEN + COMMAND_SYMBOL + "ignore "+C_END+C_WHITE+COMMAND35+C_END+NEWLINE;
    sMessage += C_GREEN + COMMAND_SYMBOL + "unignore "+C_END+C_WHITE+COMMAND36+C_END+NEWLINE;
    SendMessageToPC(oPlayer, sMessage);
}

void ListDMCommands(object oPlayer)
{
    string sMessage;
    sMessage = C_PURPLE+DMCOMMAND1+C_END+NEWLINE;
    sMessage += C_GREEN+COMMAND2+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_align_chaos "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_align_evil "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_align_good "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_align_law "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_bandm "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_banplayer_perm "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_banplayer_temp "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_banshout_temp "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_banshout_perm "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_boot "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_change_appear "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_change_appear base "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_create (resref) "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_fac_a_allally "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_fac_a_allfoe "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_fac_a_peace "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_fac_a_reset "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_fac_c_allally "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_fac_c_allfoe "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_fac_c_peace "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_fac_c_reset "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_fac_m_allally "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_fac_m_allfoe "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_fac_m_peace "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_fac_m_reset "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_fac_p_allally "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_fac_p_allfoe "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_fac_p_peace "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_fac_p_reset "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_freeze "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_fx "+C_END+NEWLINE;
    sMessage += C_PURPLE+"dm_fx_list_* "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_fx_loc "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_fx_rem "+C_END+NEWLINE;
    sMessage += C_PURPLE+"dm_getbanlist "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_getbanreason "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_givexp "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_givelevel "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_takexp "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_takelevel "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_givepartyxp "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_givepartylevel "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_takepartyxp "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_takepartylevel "+C_END+NEWLINE;
    if ((DM_PLAYERS_HEAR_DM && VerifyDMKey(oPlayer) && (!GetIsDM(oPlayer))) || (ADMIN_PLAYERS_HEAR_DM && VerifyAdminKey(oPlayer) && (!GetIsDM(oPlayer)))) sMessage += C_PURPLE+"dm_ignoredm "+C_END+NEWLINE;
    if ((DMS_HEAR_META && VerifyDMKey(oPlayer) && GetIsDM(oPlayer)) || (DM_PLAYERS_HEAR_META && VerifyDMKey(oPlayer) && (!GetIsDM(oPlayer))) || (ADMIN_DMS_HEAR_META && VerifyAdminKey(oPlayer) && GetIsDM(oPlayer)) || (ADMIN_PLAYERS_HEAR_META && VerifyAdminKey(oPlayer) && (!GetIsDM(oPlayer)))) sMessage += C_PURPLE+"dm_ignoremeta "+C_END+NEWLINE;
    if ((DMS_HEAR_TELLS && VerifyDMKey(oPlayer) && GetIsDM(oPlayer)) || (DM_PLAYERS_HEAR_TELLS && VerifyDMKey(oPlayer) && (!GetIsDM(oPlayer))) || (ADMIN_DMS_HEAR_TELLS && VerifyAdminKey(oPlayer) && GetIsDM(oPlayer)) || (ADMIN_PLAYERS_HEAR_TELLS && VerifyAdminKey(oPlayer) && (!GetIsDM(oPlayer)))) sMessage += C_PURPLE+"dm_ignoretells "+C_END+NEWLINE;
    sMessage += C_PURPLE+"dm_stealth "+C_END+NEWLINE;
    sMessage += C_PURPLE+"dm_invis "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_invuln "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_item_id "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_item_destroy_all "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_item_destroy_equip "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_item_destroy_inv "+C_END+NEWLINE;
    sMessage += C_PURPLE+"dm_help "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_kill "+C_END+NEWLINE;
    if (ENABLE_LANGUAGES) sMessage += C_GREEN+"dm_learn "+C_END+NEWLINE;
    sMessage += C_PURPLE+"dm_listcommands "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_jump "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_porthere "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_porthell "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_portjail "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_portleader "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_portthere "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_porttown "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_portway "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_portpartyhere "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_portpartyhell "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_portpartyjail "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_portpartyleader "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_portpartythere "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_portpartytown "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_portpartyway "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_rez "+C_END+NEWLINE;
    sMessage += C_PURPLE+"dm_reset_mod "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_rest "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_reveal "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_hide "+C_END+NEWLINE;
    if ((!LETO_FOR_ADMINS_ONLY) || VerifyAdminKey(oPlayer))
    {
        sMessage += C_GREEN+"dm_setcha "+C_END+NEWLINE;
        sMessage += C_GREEN+"dm_setcon "+C_END+NEWLINE;
        sMessage += C_GREEN+"dm_setdex "+C_END+NEWLINE;
        sMessage += C_GREEN+"dm_setint "+C_END+NEWLINE;
        sMessage += C_GREEN+"dm_setstr "+C_END+NEWLINE;
        sMessage += C_GREEN+"dm_setwis "+C_END+NEWLINE;
        sMessage += C_GREEN+"dm_setfort "+C_END+NEWLINE;
        sMessage += C_GREEN+"dm_setreflex "+C_END+NEWLINE;
        sMessage += C_GREEN+"dm_setwill "+C_END+NEWLINE;
    }
    sMessage += C_PURPLE+"dm_settime "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_setvarint "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_setvarfloat "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_setvarstring "+C_END+NEWLINE;
    sMessage += C_PURPLE+"dm_setvarmodint "+C_END+NEWLINE;
    sMessage += C_PURPLE+"dm_setvarmodfloat "+C_END+NEWLINE;
    sMessage += C_PURPLE+"dm_setvarmodstring "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_getvarint "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_getvarfloat "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_getvarstring "+C_END+NEWLINE;
    sMessage += C_PURPLE+"dm_getvarmodint "+C_END+NEWLINE;
    sMessage += C_PURPLE+"dm_getvarmodfloat "+C_END+NEWLINE;
    sMessage += C_PURPLE+"dm_getvarmodstring "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_setweather_a_clear "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_setweather_a_rain "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_setweather_a_reset "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_setweather_a_snow "+C_END+NEWLINE;
    sMessage += C_PURPLE+"dm_setweather_m_clear "+C_END+NEWLINE;
    sMessage += C_PURPLE+"dm_setweather_m_rain "+C_END+NEWLINE;
    sMessage += C_PURPLE+"dm_setweather_m_reset "+C_END+NEWLINE;
    sMessage += C_PURPLE+"dm_setweather_m_snow "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_spawn "+C_END+NEWLINE;
    if (VerifyAdminKey(oPlayer)) sMessage += C_PURPLE+"dm_sql "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_unbandm "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_unbanshout "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_unfreeze "+C_END+NEWLINE;
    if ((DM_PLAYERS_HEAR_DM && VerifyDMKey(oPlayer) && (!GetIsDM(oPlayer))) || (ADMIN_PLAYERS_HEAR_DM && VerifyAdminKey(oPlayer) && (!GetIsDM(oPlayer)))) sMessage += C_PURPLE+"dm_unignoredm "+C_END+NEWLINE;
    if ((DMS_HEAR_META && VerifyDMKey(oPlayer) && GetIsDM(oPlayer)) || (DM_PLAYERS_HEAR_META && VerifyDMKey(oPlayer) && (!GetIsDM(oPlayer))) || (ADMIN_DMS_HEAR_META && VerifyAdminKey(oPlayer) && GetIsDM(oPlayer)) || (ADMIN_PLAYERS_HEAR_META && VerifyAdminKey(oPlayer) && (!GetIsDM(oPlayer)))) sMessage += C_PURPLE+"dm_unignoremeta "+C_END+NEWLINE;
    if ((DMS_HEAR_TELLS && VerifyDMKey(oPlayer) && GetIsDM(oPlayer)) || (DM_PLAYERS_HEAR_TELLS && VerifyDMKey(oPlayer) && (!GetIsDM(oPlayer))) || (ADMIN_DMS_HEAR_TELLS && VerifyAdminKey(oPlayer) && GetIsDM(oPlayer)) || (ADMIN_PLAYERS_HEAR_TELLS && VerifyAdminKey(oPlayer) && (!GetIsDM(oPlayer)))) sMessage += C_PURPLE+"dm_unignoretells "+C_END+NEWLINE;
    sMessage += C_PURPLE+"dm_uninvis "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_uninvuln "+C_END+NEWLINE;
    if (ENABLE_LANGUAGES) sMessage += C_GREEN+"dm_unlearn "+C_END+NEWLINE;
    sMessage += ""+C_PURPLE+"/v "+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_vent "+C_END+NEWLINE;
    SendMessageToPC(oPlayer, sMessage);
}

void ListDMHelp(object oPlayer)
{
    string sMessage;
    sMessage = C_PURPLE+DMCOMMAND1+C_END+NEWLINE;
    sMessage += C_GREEN+COMMAND2+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_align_chaos "+C_END+C_WHITE+DMCOMMAND43+C_LT_GREEN+"dm_align_chaos "+DMCOMMAND44+C_END+C_WHITE+DMCOMMAND45+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_align_evil "+C_END+C_WHITE+DMCOMMAND46+C_LT_GREEN+"dm_align_evil "+DMCOMMAND44+C_END+C_WHITE+DMCOMMAND45+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_align_good "+C_END+C_WHITE+DMCOMMAND47+C_LT_GREEN+"dm_align_good "+DMCOMMAND44+C_END+C_WHITE+DMCOMMAND45+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_align_law "+C_END+C_WHITE+DMCOMMAND48+C_LT_GREEN+"dm_align_law "+DMCOMMAND44+C_END+C_WHITE+DMCOMMAND45+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_bandm "+C_END+C_WHITE+DMCOMMAND2+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_banplayer_perm "+C_END+C_WHITE+DMCOMMAND3+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_banplayer_temp "+C_END+C_WHITE+DMCOMMAND4+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_banshout_temp "+C_END+C_WHITE+DMCOMMAND5+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_banshout_perm "+C_END+C_WHITE+DMCOMMAND6+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_boot "+C_END+C_WHITE+DMCOMMAND79+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_change_appear "+C_END+C_WHITE+DMCOMMAND7+C_LT_GREEN+"dm_change_appear ("+DMCOMMAND7b+")"+C_END+C_WHITE+DMCOMMAND7c+C_LT_GREEN+"dm_change_appear 8"+C_END+C_WHITE+DMCOMMAND7d+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_change_appear base "+C_END+C_WHITE+DMCOMMAND8+C_LT_GREEN+"dm_change_appear"+C_END+C_WHITE+DMCOMMAND8b+C_LT_GREEN+"dm_change_appear"+C_END+C_WHITE+DMCOMMAND8c+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_create (resref) "+C_END+C_WHITE+DMCOMMAND9+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_fac_a_allally "+C_END+C_WHITE+DMCOMMAND49+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_fac_a_allfoe "+C_END+C_WHITE+DMCOMMAND50+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_fac_a_peace "+C_END+C_WHITE+DMCOMMAND51+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_fac_a_reset "+C_END+C_WHITE+DMCOMMAND52+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_fac_c_allally "+C_END+C_WHITE+DMCOMMAND53+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_fac_c_allfoe "+C_END+C_WHITE+DMCOMMAND54+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_fac_c_peace "+C_END+C_WHITE+DMCOMMAND55+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_fac_c_reset "+C_END+C_WHITE+DMCOMMAND56+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_fac_m_allally "+C_END+C_WHITE+DMCOMMAND57+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_fac_m_allfoe "+C_END+C_WHITE+DMCOMMAND58+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_fac_m_peace "+C_END+C_WHITE+DMCOMMAND59+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_fac_m_reset "+C_END+C_WHITE+DMCOMMAND60+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_fac_p_allally "+C_END+C_WHITE+DMCOMMAND61+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_fac_p_allfoe "+C_END+C_WHITE+DMCOMMAND62+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_fac_p_peace "+C_END+C_WHITE+DMCOMMAND63+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_fac_p_reset "+C_END+C_WHITE+DMCOMMAND64+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_freeze "+C_END+C_WHITE+DMCOMMAND10+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_fx "+C_END+C_WHITE+DMCOMMAND11+C_LT_GREEN+"dm_fx ("+DMCOMMAND11b+") 0 0"+C_END+C_WHITE+DMCOMMAND11c+C_LT_GREEN+"dm_vfx 28 0 0"+C_END+C_WHITE+" ."+C_END+NEWLINE;
    sMessage += C_WHITE+DMCOMMAND11d+C_LT_GREEN+"dm_fx ("+DMCOMMAND11b+") ("+DMCOMMAND11e+") ("+DMCOMMAND11f+") (E/S/SE)"+C_END+C_WHITE+DMCOMMAND11g+C_LT_GREEN+"dm_vfx 209 1 300 ."+C_END+NEWLINE;
    sMessage += C_WHITE+DMCOMMAND11h+C_LT_GREEN+"dm_vfx 209 1 300 E"+C_END+C_WHITE+DMCOMMAND11i+C_LT_GREEN+"dm_vfx 209 2 0"+C_END+C_WHITE+DMCOMMAND11j+C_LT_GREEN+"dm_fx_list_*"+C_END+C_WHITE+DMCOMMAND11k+C_END+NEWLINE;
    sMessage += C_PURPLE+"dm_fx_list_* "+C_END+C_WHITE+DMCOMMAND12+C_LT_PURPLE+"dur, bea, eye, imp, com, fnf"+C_END+C_WHITE+DMCOMMAND12b+C_LT_PURPLE+"dm_fx_list_fnf"+C_END+C_WHITE+DMCOMMAND12c+C_LT_PURPLE+"dm_fx_list_dur"+C_END+C_WHITE+DMCOMMAND12d+C_LT_PURPLE+"dm_fx_list_bea"+C_END+C_WHITE+DMCOMMAND12e+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_fx_loc "+C_END+C_WHITE+DMCOMMAND13+C_LT_GREEN+"dm_fx"+C_END+C_WHITE+DMCOMMAND13b+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_fx_rem "+C_END+C_WHITE+DMCOMMAND14+C_LT_GREEN+"dm_fx command."+C_END+NEWLINE;
    sMessage += C_PURPLE+"dm_getbanlist "+C_END+C_WHITE+DMCOMMAND15+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_getbanreason "+C_END+C_WHITE+DMCOMMAND16+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_givexp "+C_END+C_WHITE+DMCOMMAND16_1+C_LT_GREEN+"dm_givexp ("+DMCOMMAND16_1b+")"+C_END+C_WHITE+DMCOMMAND16_1c+C_LT_GREEN+"dm_givexp 500"+C_END+C_WHITE+"."+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_givelevel "+C_END+C_WHITE+DMCOMMAND16_2+C_LT_GREEN+"dm_givelevel ("+DMCOMMAND16_2b+")"+C_END+C_WHITE+DMCOMMAND16_2c+C_LT_GREEN+"dm_givelevel 2"+C_END+C_WHITE+"."+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_takexp "+C_END+C_WHITE+DMCOMMAND16_3+C_LT_GREEN+"dm_takexp ("+DMCOMMAND16_3b+")"+C_END+C_WHITE+DMCOMMAND16_3c+C_LT_GREEN+"dm_takexp 500"+C_END+C_WHITE+"."+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_takelevel "+C_END+C_WHITE+DMCOMMAND16_4+C_LT_GREEN+"dm_takelevel ("+DMCOMMAND16_4b+")"+C_END+C_WHITE+DMCOMMAND16_4c+C_LT_GREEN+"dm_takelevel 2"+C_END+C_WHITE+"."+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_givepartyxp "+C_END+C_WHITE+DMCOMMAND65+C_LT_GREEN+"dm_givepartyxp "+DMCOMMAND69+C_END+C_WHITE+"."+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_givepartylevel "+C_END+C_WHITE+DMCOMMAND66+C_LT_GREEN+"dm_givepartylevel "+DMCOMMAND70+C_END+C_WHITE+"."+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_takepartyxp "+C_END+C_WHITE+DMCOMMAND67+C_LT_GREEN+"dm_takepartyxp "+DMCOMMAND71+C_END+C_WHITE+"."+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_takepartylevel "+C_END+C_WHITE+DMCOMMAND68+C_LT_GREEN+"dm_takepartylevel "+DMCOMMAND72+C_END+C_WHITE+"."+C_END+NEWLINE;
    if ((DM_PLAYERS_HEAR_DM && VerifyDMKey(oPlayer) && (!GetIsDM(oPlayer))) || (ADMIN_PLAYERS_HEAR_DM && VerifyAdminKey(oPlayer) && (!GetIsDM(oPlayer)))) sMessage += C_PURPLE+"dm_ignoredm "+C_END+C_WHITE+DMCOMMAND17+C_END+NEWLINE;
    if ((DMS_HEAR_META && VerifyDMKey(oPlayer) && GetIsDM(oPlayer)) || (DM_PLAYERS_HEAR_META && VerifyDMKey(oPlayer) && (!GetIsDM(oPlayer))) || (ADMIN_DMS_HEAR_META && VerifyAdminKey(oPlayer) && GetIsDM(oPlayer)) || (ADMIN_PLAYERS_HEAR_META && VerifyAdminKey(oPlayer) && (!GetIsDM(oPlayer)))) sMessage += C_PURPLE+"dm_ignoremeta "+C_END+C_WHITE+DMCOMMAND18+C_END+NEWLINE;
    if ((DMS_HEAR_TELLS && VerifyDMKey(oPlayer) && GetIsDM(oPlayer)) || (DM_PLAYERS_HEAR_TELLS && VerifyDMKey(oPlayer) && (!GetIsDM(oPlayer))) || (ADMIN_DMS_HEAR_TELLS && VerifyAdminKey(oPlayer) && GetIsDM(oPlayer)) || (ADMIN_PLAYERS_HEAR_TELLS && VerifyAdminKey(oPlayer) && (!GetIsDM(oPlayer)))) sMessage += C_PURPLE+"dm_ignoretells "+C_END+C_WHITE+DMCOMMAND19+C_END+NEWLINE;
    sMessage += C_PURPLE+"dm_stealth "+C_END+C_WHITE+DMCOMMAND132+C_END+NEWLINE;
    sMessage += C_PURPLE+"dm_invis "+C_END+C_WHITE+DMCOMMAND20+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_invuln "+C_END+C_WHITE+DMCOMMAND21+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_item_id "+C_END+C_WHITE+DMCOMMAND73+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_item_destroy_all "+C_END+C_WHITE+DMCOMMAND74+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_item_destroy_equip "+C_END+C_WHITE+DMCOMMAND75+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_item_destroy_inv "+C_END+C_WHITE+DMCOMMAND76+C_END+NEWLINE;
    sMessage += C_PURPLE+"dm_help "+C_END+C_WHITE+DMCOMMAND78+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_kill "+C_END+C_WHITE+DMCOMMAND22+C_END+NEWLINE;
    if (ENABLE_LANGUAGES) sMessage += C_GREEN+"dm_learn "+C_END+C_WHITE+DMCOMMAND23+C_END+C_LT_GREEN+"dm_learn sylvan"+C_END+C_WHITE+DMCOMMAND23b+C_END+C_LT_PURPLE+"!list alllanguages"+C_END+C_WHITE+DMCOMMAND23c+C_END+NEWLINE;
    sMessage += C_PURPLE+"dm_listcommands "+C_END+C_WHITE+DMCOMMAND24+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_jump "+C_END+C_WHITE+DMCOMMAND86+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_porthere "+C_END+C_WHITE+DMCOMMAND25+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_porthell "+C_END+C_WHITE+DMCOMMAND26+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_portjail "+C_END+C_WHITE+DMCOMMAND27+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_portleader "+C_END+C_WHITE+DMCOMMAND28+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_portthere "+C_END+C_WHITE+DMCOMMAND29+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_porttown "+C_END+C_WHITE+DMCOMMAND30+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_portway "+C_END+C_WHITE+DMCOMMAND130+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_portpartyhere "+C_END+C_WHITE+DMCOMMAND87+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_portpartyhell "+C_END+C_WHITE+DMCOMMAND88+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_portpartyjail "+C_END+C_WHITE+DMCOMMAND89+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_portpartyleader "+C_END+C_WHITE+DMCOMMAND90+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_portpartythere "+C_END+C_WHITE+DMCOMMAND91+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_portpartytown "+C_END+C_WHITE+DMCOMMAND92+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_portpartyway "+C_END+C_WHITE+DMCOMMAND131+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_rez "+C_END+C_WHITE+DMCOMMAND31+C_END+NEWLINE;
    sMessage += C_PURPLE+"dm_reset_mod "+C_END+C_WHITE+DMCOMMAND32+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_rest "+C_END+C_WHITE+DMCOMMAND83+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_reveal "+C_END+C_WHITE+DMCOMMAND84+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_hide "+C_END+C_WHITE+DMCOMMAND85+C_END+NEWLINE;
    if ((!LETO_FOR_ADMINS_ONLY) || VerifyAdminKey(oPlayer))
    {
        sMessage += C_GREEN+"dm_setcha "+C_END+C_WHITE+DMCOMMAND95+C_END+C_LT_GREEN+"dm_setcha "+C_END+C_WHITE+COMMAND38+C_END+NEWLINE;
        sMessage += C_GREEN+"dm_setcon "+C_END+C_WHITE+DMCOMMAND96+C_END+C_LT_GREEN+"dm_setcon "+C_END+C_WHITE+COMMAND38+C_END+NEWLINE;
        sMessage += C_GREEN+"dm_setdex "+C_END+C_WHITE+DMCOMMAND97+C_END+C_LT_GREEN+"dm_setcha "+C_END+C_WHITE+COMMAND38+C_END+NEWLINE;
        sMessage += C_GREEN+"dm_setint "+C_END+C_WHITE+DMCOMMAND98+C_END+C_LT_GREEN+"dm_setint "+C_END+C_WHITE+COMMAND38+C_END+NEWLINE;
        sMessage += C_GREEN+"dm_setstr "+C_END+C_WHITE+DMCOMMAND99+C_END+C_LT_GREEN+"dm_setstr "+C_END+C_WHITE+COMMAND38+C_END+NEWLINE;
        sMessage += C_GREEN+"dm_setwis "+C_END+C_WHITE+DMCOMMAND100+C_END+C_LT_GREEN+"dm_setwis "+C_END+C_WHITE+COMMAND38+C_END+NEWLINE;
        sMessage += C_GREEN+"dm_setfort "+C_END+C_WHITE+DMCOMMAND101+C_END+C_LT_GREEN+"dm_setfort "+DMCOMMAND94+C_END+C_WHITE+COMMAND38+C_END+NEWLINE;
        sMessage += C_GREEN+"dm_setreflex "+C_END+C_WHITE+DMCOMMAND102+C_END+C_LT_GREEN+"dm_setreflex "+DMCOMMAND94+C_END+C_WHITE+COMMAND38+C_END+NEWLINE;
        sMessage += C_GREEN+"dm_setwill "+C_END+C_WHITE+DMCOMMAND103+C_END+C_LT_GREEN+"dm_setwill "+DMCOMMAND94+C_END+C_WHITE+COMMAND38+C_END+NEWLINE;
    }
    sMessage += C_PURPLE+"dm_settime "+C_END+C_WHITE+DMCOMMAND116+C_END+C_LT_PURPLE+"dm_settime "+DMCOMMAND125+C_END+C_WHITE+"."+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_setvarint "+C_END+C_WHITE+DMCOMMAND109+DMCOMMAND111+DMCOMMAND114+C_END+C_LT_GREEN+"dm_setvarint "+DMCOMMAND104+DMCOMMAND105+C_END+C_WHITE+DMCOMMAND108+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_setvarfloat "+C_END+C_WHITE+DMCOMMAND109+DMCOMMAND112+DMCOMMAND114+C_END+C_LT_GREEN+"dm_setvarfloat "+DMCOMMAND104+DMCOMMAND106+C_END+C_WHITE+DMCOMMAND108+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_setvarstring "+C_END+C_WHITE+DMCOMMAND109+DMCOMMAND113+DMCOMMAND114+C_END+C_LT_GREEN+"dm_setvarstring "+DMCOMMAND104+DMCOMMAND107+C_END+C_WHITE+DMCOMMAND108+C_END+NEWLINE;
    sMessage += C_PURPLE+"dm_setvarmodint "+C_END+C_WHITE+DMCOMMAND109+DMCOMMAND111+DMCOMMAND115+C_END+C_LT_PURPLE+"dm_setvarmodint "+DMCOMMAND104+DMCOMMAND105+C_END+C_WHITE+"."+C_END+NEWLINE;
    sMessage += C_PURPLE+"dm_setvarmodfloat "+C_END+C_WHITE+DMCOMMAND109+DMCOMMAND112+DMCOMMAND115+C_END+C_LT_PURPLE+"dm_setvarmodfloat "+DMCOMMAND104+DMCOMMAND106+C_END+C_WHITE+"."+C_END+NEWLINE;
    sMessage += C_PURPLE+"dm_setvarmodstring "+C_END+C_WHITE+DMCOMMAND109+DMCOMMAND113+DMCOMMAND115+C_END+C_LT_PURPLE+"dm_setvarmodstring "+DMCOMMAND104+DMCOMMAND107+C_END+C_WHITE+"."+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_getvarint "+C_END+C_WHITE+DMCOMMAND110+DMCOMMAND111+DMCOMMAND114+C_END+C_LT_GREEN+"dm_getvarint "+DMCOMMAND104+C_END+C_WHITE+DMCOMMAND108+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_getvarfloat "+C_END+C_WHITE+DMCOMMAND110+DMCOMMAND112+DMCOMMAND114+C_END+C_LT_GREEN+"dm_getvarfloat "+DMCOMMAND104+C_END+C_WHITE+DMCOMMAND108+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_getvarstring "+C_END+C_WHITE+DMCOMMAND110+DMCOMMAND113+DMCOMMAND114+C_END+C_LT_GREEN+"dm_getvarstring "+DMCOMMAND104+C_END+C_WHITE+DMCOMMAND108+C_END+NEWLINE;
    sMessage += C_PURPLE+"dm_getvarmodint "+C_END+C_WHITE+DMCOMMAND110+DMCOMMAND111+DMCOMMAND115+C_END+C_LT_PURPLE+"dm_getvarmodint "+DMCOMMAND104+C_END+C_WHITE+"."+C_END+NEWLINE;
    sMessage += C_PURPLE+"dm_getvarmodfloat "+C_END+C_WHITE+DMCOMMAND110+DMCOMMAND112+DMCOMMAND115+C_END+C_LT_PURPLE+"dm_getvarmodfloat "+DMCOMMAND104+C_END+C_WHITE+"."+C_END+NEWLINE;
    sMessage += C_PURPLE+"dm_getvarmodstring "+C_END+C_WHITE+DMCOMMAND110+DMCOMMAND113+DMCOMMAND115+C_END+C_LT_PURPLE+"dm_getvarmodstring "+DMCOMMAND104+C_END+C_WHITE+"."+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_setweather_a_clear "+C_END+C_WHITE+DMCOMMAND117+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_setweather_a_rain "+C_END+C_WHITE+DMCOMMAND118+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_setweather_a_reset "+C_END+C_WHITE+DMCOMMAND119+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_setweather_a_snow "+C_END+C_WHITE+DMCOMMAND120+C_END+NEWLINE;
    sMessage += C_PURPLE+"dm_setweather_m_clear "+C_END+C_WHITE+DMCOMMAND121+C_END+NEWLINE;
    sMessage += C_PURPLE+"dm_setweather_m_rain "+C_END+C_WHITE+DMCOMMAND122+C_END+NEWLINE;
    sMessage += C_PURPLE+"dm_setweather_m_reset "+C_END+C_WHITE+DMCOMMAND123+C_END+NEWLINE;
    sMessage += C_PURPLE+"dm_setweather_m_snow "+C_END+C_WHITE+DMCOMMAND124+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_spawn "+C_END+C_WHITE+DMCOMMAND126+C_END+C_LT_GREEN+"dm_spawn "+DMCOMMAND127+C_END+C_WHITE+"."+C_END+NEWLINE;
    if (VerifyAdminKey(oPlayer)) sMessage += C_PURPLE+"dm_sql "+C_END+C_WHITE+DMCOMMAND80+C_END+C_LT_PURPLE+"dm_sql"+DMCOMMAND81+C_END+C_WHITE+DMCOMMAND82+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_unbandm "+C_END+C_WHITE+DMCOMMAND33+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_unbanshout "+C_END+C_WHITE+DMCOMMAND34+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_unfreeze "+C_END+C_WHITE+DMCOMMAND35+C_END+NEWLINE;
    if ((DM_PLAYERS_HEAR_DM && VerifyDMKey(oPlayer) && (!GetIsDM(oPlayer))) || (ADMIN_PLAYERS_HEAR_DM && VerifyAdminKey(oPlayer) && (!GetIsDM(oPlayer)))) sMessage += C_PURPLE+"dm_unignoredm "+C_END+C_WHITE+DMCOMMAND36+C_END+NEWLINE;
    if ((DMS_HEAR_META && VerifyDMKey(oPlayer) && GetIsDM(oPlayer)) || (DM_PLAYERS_HEAR_META && VerifyDMKey(oPlayer) && (!GetIsDM(oPlayer))) || (ADMIN_DMS_HEAR_META && VerifyAdminKey(oPlayer) && GetIsDM(oPlayer)) || (ADMIN_PLAYERS_HEAR_META && VerifyAdminKey(oPlayer) && (!GetIsDM(oPlayer)))) sMessage += C_PURPLE+"dm_unignoremeta "+C_END+C_WHITE+DMCOMMAND37+C_END+NEWLINE;
    if ((DMS_HEAR_TELLS && VerifyDMKey(oPlayer) && GetIsDM(oPlayer)) || (DM_PLAYERS_HEAR_TELLS && VerifyDMKey(oPlayer) && (!GetIsDM(oPlayer))) || (ADMIN_DMS_HEAR_TELLS && VerifyAdminKey(oPlayer) && GetIsDM(oPlayer)) || (ADMIN_PLAYERS_HEAR_TELLS && VerifyAdminKey(oPlayer) && (!GetIsDM(oPlayer)))) sMessage += C_PURPLE+"dm_unignoretells "+C_END+C_WHITE+DMCOMMAND38+C_END+NEWLINE;
    sMessage += C_PURPLE+"dm_uninvis "+C_END+C_WHITE+DMCOMMAND39+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_uninvuln "+C_END+C_WHITE+DMCOMMAND40+C_END+NEWLINE;
    if (ENABLE_LANGUAGES) sMessage += C_GREEN+"dm_unlearn "+C_END+C_WHITE+DMCOMMAND41+C_LT_GREEN+"dm_learn"+C_END+C_WHITE+": "+C_LT_GREEN+"dm_unlearn sylvan"+C_END+C_WHITE+DMCOMMAND41b+C_LT_PURPLE+"!list alllanguages"+C_END+C_WHITE+DMCOMMAND41c+C_END+NEWLINE;
    sMessage += ""+C_PURPLE+"/v "+C_END+C_WHITE+DMCOMMAND42+C_END+NEWLINE;
    sMessage += C_GREEN+"dm_vent "+C_END+C_WHITE+DMCOMMAND128+C_END+C_LT_PURPLE+"/v"+C_END+C_WHITE+DMCOMMAND129+C_END+NEWLINE;
    SendMessageToPC(oPlayer, sMessage);
}

void ListIgnored(object oPlayer)
{
    string sPlayername;
    string sMessage = "";
    object oPC = GetFirstPC();
    while (GetIsObjectValid(oPC))
    {
        sPlayername = GetPCPlayerName(oPC);
        if (GetLocalInt(oPlayer, "CHT_IGNORE" + sPlayername) == TRUE)
        {
            sMessage += C_RED+IGNORE1+sPlayername+"."+C_END+NEWLINE;
        }
        oPC = GetNextPC();
    }
    if (sMessage != "") SendMessageToPC(oPlayer, sMessage);
    else SendMessageToPC(oPlayer, C_RED+IGNORE2+C_END);
}

void SendMessageToPCDMs(string sMessage)
{
    object oPC = GetFirstPC();
    while (GetIsObjectValid(oPC))
    {//check to see if they've chosen to ignore
        if (VerifyDMKey(oPC) && (!GetIsDM(oPC)) && (!GetLocalInt(oPC, "FKY_CHT_IGNORETELLS")))
        {
            if (SEND_CHANNELS_TO_CHAT_LOG) SendChatLogMessage(oPC, sMessage, GetMessenger());
            else SendMessageToPC(oPC, sMessage);
        }
        oPC = GetNextPC();
    }
}
void SendMessageToPCAdmins(string sMessage)
{
    object oPC = GetFirstPC();
    while (GetIsObjectValid(oPC))
    {//check to see if they've chosen to ignore
        if (VerifyAdminKey(oPC) && (!GetIsDM(oPC)) && (!GetLocalInt(oPC, "FKY_CHT_IGNORETELLS")))
        {
            if (SEND_CHANNELS_TO_CHAT_LOG) SendChatLogMessage(oPC, sMessage, GetMessenger());
            else SendMessageToPC(oPC, sMessage);
        }
        oPC = GetNextPC();
    }
}
void SendMessageToDMDMs(string sMessage)
{
    object oPC = GetFirstPC();
    while (GetIsObjectValid(oPC))
    {//check to see if they've chosen to ignore
        if (VerifyDMKey(oPC) && GetIsDM(oPC) && (!GetLocalInt(oPC, "FKY_CHT_IGNORETELLS")))
        {
            if (SEND_CHANNELS_TO_CHAT_LOG) SendChatLogMessage(oPC, sMessage, GetMessenger());
            else SendMessageToPC(oPC, sMessage);
        }
        oPC = GetNextPC();
    }
}
void SendMessageToDMAdmins(string sMessage)
{
    object oPC = GetFirstPC();
    while (GetIsObjectValid(oPC))
    {//check to see if they've chosen to ignore
        if (VerifyAdminKey(oPC) && GetIsDM(oPC) && (!GetLocalInt(oPC, "FKY_CHT_IGNORETELLS")))
        {
            if (SEND_CHANNELS_TO_CHAT_LOG) SendChatLogMessage(oPC, sMessage, GetMessenger());
            else SendMessageToPC(oPC, sMessage);
        }
        oPC = GetNextPC();
    }
}
void GetBanList(object oPlayer)
{
    string sString = "";
    string sList = "";
    object oPC = GetFirstPC();
    while (GetIsObjectValid(oPC))
    {
        if (GetLocalInt(oPC, "FKY_CHT_BANSHOUT") == TRUE)
        {
            sString = C_RED+GetName(oPC)+BAN1+C_END+NEWLINE;
            sList += sString;
        }
        if (GetLocalInt(oPC, "FKY_CHT_BANDM") == TRUE)
        {
            sString = C_RED+GetName(oPC)+BAN2+C_END+NEWLINE;
            sList += sString;
        }
        oPC = GetNextPC();
    }
    if (sList != "") SendMessageToPC(oPlayer, sList);
    else SendMessageToPC(oPlayer, C_RED+BAN3+C_END);
}
void DMTellForwarding(object oPlayer, string sTarget, string sMessage, int nChannel)
{
    string sSend = C_PURPLE + GetName(oPlayer) + "(" + GetPCPlayerName(oPlayer) + ")" + sTarget + C_END+C_GREEN+"["+TELL+"] " + sMessage + C_END+NEWLINE;
    if ((nChannel == 4) || (ENABLE_DM_TELL_ROUTING && (nChannel == 20)))
    {
        if (DMS_HEAR_TELLS) SendMessageToDMDMs(sSend);
        if (DM_PLAYERS_HEAR_TELLS) SendMessageToPCDMs(sSend);
        if (ADMIN_DMS_HEAR_TELLS) SendMessageToDMAdmins(sSend);
        if (ADMIN_PLAYERS_HEAR_TELLS) SendMessageToPCAdmins(sSend);
    }
    else if ((nChannel == 20) && DM_TELLS_ROUTED_ONLY_TO_ADMINS)
    {
        if (ADMIN_DMS_HEAR_TELLS) SendMessageToDMAdmins(sSend);
        if (ADMIN_PLAYERS_HEAR_TELLS) SendMessageToPCAdmins(sSend);
    }
}
void DMChannelForwardToDMs(object oPlayer, string sMessage)
{
    string sSend = C_PURPLE + GetName(oPlayer) + "(" + GetPCPlayerName(oPlayer) + ")" + ": "+C_END+C_LT_BLUE+"["+DM+"] " + sMessage + C_END+NEWLINE;
    object oPC = GetFirstPC();
    while (GetIsObjectValid(oPC))
    {
        if (VerifyDMKey(oPC) && (!GetIsDM(oPC)) && (!GetLocalInt(oPC, "FKY_CHT_IGNOREDM")))
        {
            if (SEND_CHANNELS_TO_CHAT_LOG) SendChatLogMessage(oPC, sSend, GetMessenger());
            else SendMessageToPC(oPC, sSend);
        }
        oPC = GetNextPC();
    }
}
void DMChannelForwardToAdmins(object oPlayer, string sMessage)
{
    string sSend = C_PURPLE + GetName(oPlayer) + "(" + GetPCPlayerName(oPlayer) + ")" + ":"+C_END+C_LT_BLUE+"[DM] " + sMessage + C_END+NEWLINE;
    object oPC = GetFirstPC();
    while (GetIsObjectValid(oPC))
    {
        if (VerifyAdminKey(oPC) && (!GetIsDM(oPC)) && (!GetLocalInt(oPC, "FKY_CHT_IGNOREDM")))
        {
            if (SEND_CHANNELS_TO_CHAT_LOG) SendChatLogMessage(oPC, sSend, GetMessenger());
            else SendMessageToPC(oPC, sSend);
        }
        oPC = GetNextPC();
    }
}
void DoDMInvis(object oPlayer)
{
    effect eEffect = EffectCutsceneGhost();
    effect eEffect2 = EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY);
    effect eLink = SupernaturalEffect(EffectLinkEffects(eEffect, eEffect2));
    ApplyEffectToObject(2, eLink, oPlayer);
}
void DoDMUninvis(object oPlayer)
{
    effect eEffect = GetFirstEffect(oPlayer);
    while (GetIsEffectValid(eEffect))
    {
        if (GetEffectCreator(eEffect) == GetModule()) DelayCommand(0.1, RemoveEffect(oPlayer, eEffect));
        eEffect = GetNextEffect(oPlayer);
    }
}
void ShowInfo(object oPlayer, object oGetInfoFrom)
{
    //collect info
    string sName = GetName(oGetInfoFrom);
    string sPlayername = GetPCPlayerName(oGetInfoFrom);
    string sKey = GetPCPublicCDKey(oGetInfoFrom);
    string sIP = GetPCIPAddress(oGetInfoFrom);
    int nGuild = GetLocalInt(oGetInfoFrom, VAR_PC_GUILD);


    int nClass1 = GetClassByPosition(1, oGetInfoFrom);
    int nClass2 = GetClassByPosition(2, oGetInfoFrom);
    int nClass3 = GetClassByPosition(3, oGetInfoFrom);
    int nClassLevel1 = GetLevelByClass(nClass1, oGetInfoFrom);
    int nClassLevel2 = GetLevelByClass(nClass2, oGetInfoFrom);
    int nClassLevel3 = GetLevelByClass(nClass3, oGetInfoFrom);
    int nControlClass = GetPCBodyBag(oGetInfoFrom)-1;
    if(nControlClass < 0){ // Body Bag == -1
    if ((nClassLevel1 > nClassLevel2) && (nClassLevel1 > nClassLevel3)) nControlClass = nClass1;
        else if ((nClassLevel2 > nClassLevel1) && (nClassLevel2 > nClassLevel3)) nControlClass = nClass2;
        else if ((nClassLevel3 > nClassLevel1) && (nClassLevel3 > nClassLevel2)) nControlClass = nClass3;
        else if (nClassLevel1 == nClassLevel2) nControlClass = nClass1;
        else if (nClassLevel1 == nClassLevel3) nControlClass = nClass1;
        else if (nClassLevel2 == nClassLevel3) nControlClass = nClass2;
    }
    int nLevel = GetHitDice(oGetInfoFrom);
    int nLL = GetNumberOfLegendaryLevels(oGetInfoFrom);
    int nTotal = nLevel + nLL;
    string sClasses = C_LT_BLUE2+GetClassName(nClass1)+C_END+C_WHITE+": "+IntToString(nClassLevel1)+C_END;
    if (nClass2 != CLASS_TYPE_INVALID) sClasses += C_WHITE+", "+C_END+C_LT_BLUE2+GetClassName(nClass2)+C_END+C_WHITE+": "+IntToString(nClassLevel2)+C_END;
    if (nClass3 != CLASS_TYPE_INVALID) sClasses += C_WHITE+", "+C_END+C_LT_BLUE2+GetClassName(nClass3)+C_END+C_WHITE+": "+IntToString(nClassLevel3)+C_END;
    if (nLL) sClasses += C_WHITE+", "+C_END+C_LT_BLUE2+LEGLEVEL+C_END+C_LT_BLUE+"["+GetClassName(nControlClass)+"]"+C_END+C_WHITE+": "+IntToString(nLL)+C_END;
    if ((nClass2 != CLASS_TYPE_INVALID) || (nLL)) sClasses += C_WHITE+", "+C_END+C_BLUE+NFOHD+C_END+C_WHITE+": "+IntToString(nTotal)+C_END;
    string sDeity = ""; //GetDeity(oGetInfoFrom);
    if (sDeity == "") sDeity = NONE;
    int nGold = GetGold(oGetInfoFrom);
    int nGoldTotal, nValue, nX;
    object oItem = GetFirstItemInInventory(oGetInfoFrom);
    while (GetIsObjectValid(oItem))
    {
        nValue = GetGoldPieceValue(oItem);
        nGoldTotal += nValue;
        oItem = GetNextItemInInventory(oGetInfoFrom);
    }
    for (nX = 0; nX < 14; nX++)
    {
        oItem = GetItemInSlot(nX, oGetInfoFrom);
        nValue = GetGoldPieceValue(oItem);
        nGoldTotal += nValue;
    }
    nGoldTotal += nGold;
    string sSubrace = GetSubRace(oGetInfoFrom);
    if (sSubrace == "") sSubrace = NONE;
    int nXP = GetXP(oGetInfoFrom);
    int nNextXP = (( nLevel * ( nLevel + 1 )) / 2 * 1000 );
    int nXPForNextLevel = nNextXP - nXP;
    if (nLevel == 40) nXPForNextLevel = 0;
    string sArea = GetName(GetArea(oGetInfoFrom));
    string sFactionMembers = "";
    object oLeader = GetFactionLeader(oGetInfoFrom);
    object oMember = GetFirstFactionMember(oGetInfoFrom);
    while (GetIsObjectValid(oMember))
    {
        if (oMember == oLeader) sFactionMembers = C_WHITE+GetName(oMember)+C_END+C_BLUE+" ["+LFG1+IntToString(GetNumberOfLegendaryLevels(oMember) + GetHitDice(oMember))+"] "+C_END+C_ORANGE+LEADER+C_END+NEWLINE+sFactionMembers;
        else sFactionMembers = sFactionMembers+C_WHITE+GetName(oMember)+C_END+C_BLUE+" ["+LFG1+IntToString(GetNumberOfLegendaryLevels(oMember) + GetHitDice(oMember))+"] "+C_END+NEWLINE;
        oMember = GetNextFactionMember(oGetInfoFrom);
    }
    //combine
    string sMessage = C_PURPLE+NFOHEADER+C_END+NEWLINE;
    sMessage += C_PURPLE+NFO1+C_END+C_WHITE+sName+C_END+NEWLINE;
    sMessage += C_PURPLE+NFO2+C_END+C_WHITE+sPlayername+C_END+NEWLINE;

    if(nGuild > 0)
        sMessage += C_PURPLE+"Guild: "+C_END+C_WHITE+GetGuildName(nGuild)+" ("+GetGuildAbbreviation(nGuild)+")"+C_END+NEWLINE;

    sMessage += C_PURPLE+NFO3+C_END+C_WHITE+sKey+C_END+NEWLINE;
    if (VerifyDMKey(oPlayer) || VerifyAdminKey(oPlayer) || (oPlayer == oGetInfoFrom)) sMessage += C_PURPLE+NFO4+C_END+C_WHITE+sIP+C_END+NEWLINE;
    if (VerifyDMKey(oPlayer) || VerifyAdminKey(oPlayer) || (oPlayer == oGetInfoFrom) || (!GetLocalInt(oGetInfoFrom, "FKY_CHAT_ANON"))) sMessage += C_PURPLE+NFO5+C_END+sClasses+NEWLINE;
    if (VerifyDMKey(oPlayer) || VerifyAdminKey(oPlayer) || (oPlayer == oGetInfoFrom) || (!GetLocalInt(oGetInfoFrom, "FKY_CHAT_ANON"))) sMessage += C_PURPLE+NFO6+C_END+C_YELLOW+IntToString(nXP)+C_END+NEWLINE;
    if (VerifyDMKey(oPlayer) || VerifyAdminKey(oPlayer) || (oPlayer == oGetInfoFrom) || (!GetLocalInt(oGetInfoFrom, "FKY_CHAT_ANON"))) sMessage += C_PURPLE+NFO7+C_END+C_RED+IntToString(nXPForNextLevel)+C_END+NEWLINE;
    if (VerifyDMKey(oPlayer) || VerifyAdminKey(oPlayer) || (oPlayer == oGetInfoFrom) || (!GetLocalInt(oGetInfoFrom, "FKY_CHAT_ANON"))) sMessage += C_PURPLE+NFO8+C_END+C_GREEN+sArea+C_END+NEWLINE;
    if (VerifyDMKey(oPlayer) || VerifyAdminKey(oPlayer) || (oPlayer == oGetInfoFrom) || (!GetLocalInt(oGetInfoFrom, "FKY_CHAT_ANON"))) sMessage += C_PURPLE+NFO9+C_END+sFactionMembers;
    if (VerifyDMKey(oPlayer) || VerifyAdminKey(oPlayer) || (oPlayer == oGetInfoFrom)) sMessage += C_PURPLE+NFO10+C_END+C_LT_BLUE+sDeity+C_END+NEWLINE;
    if (VerifyDMKey(oPlayer) || VerifyAdminKey(oPlayer) || (oPlayer == oGetInfoFrom)) sMessage += C_PURPLE+NFO11+C_END+C_LT_BLUE+sSubrace+C_END+NEWLINE;
    if (VerifyDMKey(oPlayer) || VerifyAdminKey(oPlayer) || (oPlayer == oGetInfoFrom)) sMessage += C_PURPLE+NFO12+C_END+C_GOLD+IntToString(nGold)+C_END+NEWLINE;
    if (VerifyDMKey(oPlayer) || VerifyAdminKey(oPlayer) || (oPlayer == oGetInfoFrom)) sMessage += C_PURPLE+NFO13+C_END+C_GOLD+IntToString(nGoldTotal)+C_END+NEWLINE;
    SendMessageToPC(oPlayer, sMessage);
}

void GiveLevel(object oReceiver, object oDM, int nLevels, int nMessage = TRUE)
{
    int nHD = GetHitDice(oReceiver);
    if (nHD < 40)
    {
        int nTargetLevel = nHD+nLevels;
        if (nTargetLevel > 40) nTargetLevel = 40;
        int nTargetXP = (( nTargetLevel * ( nTargetLevel - 1 )) / 2 * 1000 );
        SetXP(oReceiver, nTargetXP);
        string sLevel = XP4;
        if (nLevels == 1) sLevel = XP5;
        if (nMessage) SendMessageToPC(oDM, C_RED+XP6+IntToString(nLevels)+sLevel+XP7+GetName(oReceiver) + "."+C_END);
    }
    else if (nMessage) SendMessageToPC(oDM, C_RED+GetName(oReceiver)+XP3+C_END);
}

void TakeLevel(object oLoser, object oDM, int nLevels, int nMessage = TRUE)
{
    if(!GetIsRelevelable(oLoser)){
        if (nMessage) SendMessageToPC(oDM, C_RED+GetName(oLoser) + "is unable to lose levels."+C_END);
        return;
    }
    int nHD = GetHitDice(oLoser);
    int nTargetLevel = nHD-nLevels;
    if (nTargetLevel < 1) nTargetLevel = 1;
    int nTargetXP = (( nTargetLevel * ( nTargetLevel - 1 )) / 2 * 1000 );
    SetXP(oLoser, nTargetXP);
    string sLevel = XP4;
    if (nLevels == 1) sLevel = XP5;
    if (nMessage) SendMessageToPC(oDM, C_RED+XP8+IntToString(nLevels)+sLevel+XP10+GetName(oLoser) + "."+C_END);
}

string GetColorStringForColumn(int nNum)
{
    string sReturn;
    switch(nNum)
    {
        case 1: sReturn = C_RED; break;
        case 2: sReturn = C_ORANGE; break;
        case 3: sReturn = C_YELLOW; break;
        case 4: sReturn = C_GREEN; break;
        case 5: sReturn = C_BLUE; break;
        case 6: sReturn = C_PURPLE; break;
    }
    return sReturn;
}

int VerifyNumber(object oPC, string sText);
int VerifyNumber(object oPC, string sText){
    if (TestStringAgainstPattern("*n", sText)) return TRUE;
    else FloatingTextStringOnCreature(C_RED+REQUIRES_NUMBER+C_END, oPC);

    return FALSE;
}

location VerifyLocation(object oPC, string sVLNormalCase)
{
    location lReturn = GetLocalLocation(oPC, "FKY_CHAT_LOCATION"); //have they already used the targeter?
    if (!GetIsObjectValid(GetAreaFromLocation(lReturn)))
    {
        FloatingTextStringOnCreature(C_GOLD+REQUIRES_TARGET+C_END, oPC, FALSE);//tell them
        SetLocalString(oPC, "FKY_CHAT_COMMAND", LOCATION_TARGET+"dm_" + sVLNormalCase);//mark them for the targeter
        if (!GetIsObjectValid(GetItemPossessedBy(oPC, "fky_chat_target"))) CreateItemOnObject("fky_chat_target", oPC);//give them a targeter if they need one
    }
    //else DeleteLocalLocation(oPC, "FKY_CHAT_LOCATION");//variable cleanup - done in individual commands
    return lReturn;
}

//return the target object, if invaild a validity check will return out of the chat script
object VerifyTarget(struct pl_chat_command pcc, string sCommandType = OBJECT_TARGET, string sCommandSymbol = "dm_", int nPCOnly = TRUE, int nCreatureOnly = TRUE)//defaults to OBJECT_TARGET for object - no area object allowed; other option is AREA_TARGET_OK for area object allowed
{
    object oReturn = pcc.oTarget;
    if (!GetIsObjectValid(oReturn))//target verification - do they need to use the command targeter?
    {
        oReturn = GetLocalObject(pcc.oPC, "FKY_CHAT_TARGET"); //have they already used the targeter?
        if (!GetIsObjectValid(oReturn))
        {
            FloatingTextStringOnCreature(C_GOLD+REQUIRES_TARGET+C_END, pcc.oPC, FALSE);//tell them
            SetLocalString(pcc.oPC, "FKY_CHAT_COMMAND", sCommandType+sCommandSymbol+ pcc.sOriginal);//mark them for the targeter
            if (!GetIsObjectValid(GetItemPossessedBy(pcc.oPC, "fky_chat_target"))) CreateItemOnObject("fky_chat_target", pcc.oPC);//give them a targeter if they need one
            return OBJECT_INVALID;
        }
        else DeleteLocalObject(pcc.oPC, "FKY_CHAT_TARGET");//variable cleanup
    }
    if (sCommandType == AREA_TARGET_OK)//failsafe check to ensure that if the command allows area targets it will ignore PCOnly and Creature only settings
    {
        nPCOnly = FALSE;
        nCreatureOnly = FALSE;
    }
    if (nPCOnly && (!GetIsPC(oReturn)))
    {
        FloatingTextStringOnCreature(C_RED+PC_ONLY+C_END, pcc.oPC, FALSE);
        return OBJECT_INVALID;
    }
    if (nCreatureOnly && (GetObjectType(oReturn) != OBJECT_TYPE_CREATURE))
    {
        FloatingTextStringOnCreature(C_RED+CREATURE_ONLY+C_END, pcc.oPC, FALSE);
        return OBJECT_INVALID;
    }
    return oReturn;
}

void ShoutBlock(object oPC, int nSBChannel)
{
    if (nSBChannel == 2) SetLocalString(oPC, "NWNX!CHAT!SUPRESS", "1");//suppress emote speech no matter what, helps avoid circumvention of shout bans
    FloatingTextStringOnCreature(C_RED+BADEMOTE+C_END, oPC, FALSE);//no match
    if (USING_LINUX && (!GetLocalInt(oPC, "FKY_CHAT_EMOTETOGGLE")))
    {
        SetLocalInt(oPC, "FKY_CHAT_CONVONUMBER", 80);
        AssignCommand(oPC, ClearAllActions(TRUE));
        AssignCommand(oPC, ActionStartConversation(oPC, "chat_emote", TRUE, FALSE));
    }
}

void DoSpamBan(object oPC, string sSBText)
{
    string sKey = GetPCPublicCDKey(oPC);
    SetLocalString(oPC, "NWNX!CHAT!SUPRESS", "1");//mute em
    SetLocalInt(oPC, "FKY_CHT_BANSHOUT", TRUE);//temp ban em
    if (GetLocalString(oPC, "FKY_CHT_BANREASON") == "") SetLocalString(oPC, "FKY_CHT_BANREASON", sSBText);
    //capture the first message that got them busted so that that can't overwrite with something
    //benign to show the dms to get unbanned so they can try again
    SetPersistantInt(oPC, "ban:shout", 1);
    SendMessageToPC(oPC, C_RED+PERMBANSHT1+C_END);//tell em
}

void HandlePartySpeak(string sText, object oPC)
{
/*
    SetLocalString(oPC, "NWNX!CHAT!SUPRESS", "1");
    string var1 = "FKY_CHT_IGNORE" + GetPCPlayerName(oPC);
    string var2 = "FKY_CHT_IGNOREP" + GetPCPlayerName(oPC);
    object oParty = GetFirstFactionMember(oPC);

    sText = "[Party] " + sText;

    while (oParty != OBJECT_INVALID) {
        if (!GetLocalInt(oParty, var1) && !GetLocalInt(oParty, var2)){
            SendChatLogMessage(oParty, sText, oPC, 1);
        }
        oParty = GetNextFactionMember(oPC);
    }
*/
}

void HandleShoutSpeak(string sText, object oPC)
{
/*
    SetLocalString(oPC, "NWNX!CHAT!SUPRESS", "1");
    string var1 = "FKY_CHT_IGNORE" + GetPCPlayerName(oPC);
    string var2 = "FKY_CHT_IGNORES" + GetPCPlayerName(oPC);

    sText = C_GOLD+"[Shout] " + sText+C_END;

    object oParty = GetFirstPC();
    while (oParty != OBJECT_INVALID) {
        if (!GetLocalInt(oParty, var1) && !GetLocalInt(oParty, var2)){
            SendChatLogMessage(oParty, sText, oPC, 1);
        }
        oParty = GetNextPC();
    }
*/
}

void HandleAFK(object oSpeaker, object oTarget){
    if(GetLocalInt(oTarget, "FKY_CHAT_AFK")){
        string msg = GetName(oTarget) + " is AFK";
        string afk = GetLocalString(oTarget, "FKY_CHAT_AFK_MSG");
        if(afk != "")
            msg += ": " + afk;
        else
            msg += ".";

        SendMessageToPC(oSpeaker, C_RED+msg+C_END);//tell em
        SendMessageToPC(oTarget, C_RED+msg+C_END);//tell em
    }
}

void HandleVentrilo(string sVText, object oVPC)
{
    SetLocalString(oVPC, "NWNX!CHAT!SUPRESS", "1");
    sVText = GetStringRight(sVText, GetStringLength(sVText) - 2);
    object oTarget = GetLocalObject(oVPC, "FKY_CHT_VENTRILO");
    if (GetIsObjectValid(oTarget)) AssignCommand(oTarget, SpeakString(sVText));
    else FloatingTextStringOnCreature(C_RED+BADVENT+C_END, oVPC, FALSE);
}

string GetCommandString(int nCommand)
{
    string sReturn;
    switch (nCommand)
    {
        case 1: sReturn = COMMAND_SYMBOL + "settail"; break;
        case 2: sReturn = COMMAND_SYMBOL + "setwings"; break;
        case 3: sReturn = COMMAND_SYMBOL + "skillcheck"; break;
        case 4: sReturn = "dm_align_chaos"; break;
        case 5: sReturn = "dm_align_evil"; break;
        case 6: sReturn = "dm_align_good"; break;
        case 7: sReturn = "dm_align_law"; break;
        case 8: sReturn = "dm_fx"; break;
        case 9: sReturn = "dm_fx_loc"; break;
        case 10: sReturn = "dm_setcha"; break;
        case 11: sReturn = "dm_setcon"; break;
        case 12: sReturn = "dm_setdex"; break;
        case 13: sReturn = "dm_setint"; break;
        case 14: sReturn = "dm_setstr"; break;
        case 15: sReturn = "dm_setwis"; break;
        case 16: sReturn = "dm_setfort"; break;
        case 17: sReturn = "dm_setreflex"; break;
        case 18: sReturn = "dm_setwill"; break;
        case 19: sReturn = "dm_change_appear"; break;
        case 20: sReturn = "dm_givexp"; break;
        case 21: sReturn = "dm_takexp"; break;
        case 22: sReturn = "dm_givepartyxp"; break;
        case 23: sReturn = "dm_takepartyxp"; break;
        case 24: sReturn = "dm_givelevel"; break;
        case 25: sReturn = "dm_takelevel"; break;
        case 26: sReturn = "dm_givepartylevel"; break;
        case 27: sReturn = "dm_takepartylevel"; break;
        case 30: sReturn = "/v"; break;
        case 31: sReturn = COMMAND_SYMBOL + "setname"; break;
        case 32: sReturn = COMMAND_SYMBOL + "setnameall"; break;
        case 33: sReturn = "dm_create"; break;
        case 34: sReturn = "dm_spawn"; break;
        case 35: sReturn = "dm_sql"; break;
        case 36: sReturn = "dm_getvarint"; break;
        case 37: sReturn = "dm_getvarfloat"; break;
        case 38: sReturn = "dm_getvarstring"; break;
        case 39: sReturn = "dm_getvarmodint"; break;
        case 40: sReturn = "dm_getvarmodfloat"; break;
        case 41: sReturn = "dm_getvarmodstring"; break;
        case 42: sReturn = "dm_settime"; break;
        case 70: sReturn = "dm_setvarint"; break;
        case 71: sReturn = "dm_setvarfloat"; break;
        case 72: sReturn = "dm_setvarstring"; break;
        case 73: sReturn = "dm_setvarmodint"; break;
        case 74: sReturn = "dm_setvarmodfloat"; break;
        case 75: sReturn = "dm_setvarmodstring"; break;
    }
    return sReturn;
}

void DoCommandCompletion(object oCCPC, string sCCText, int nCommand)
{
    SetLocalString(oCCPC, "NWNX!CHAT!SUPRESS", "1");
    FloatingTextStringOnCreature(sCCText, oCCPC, FALSE);//so they can see what they entered without evading channel blocks
    int nStage = GetLocalInt(oCCPC, "FKY_CHAT_COMMAND_COM_STAGE");
    string sInject = GetLocalString(oCCPC, "FKY_CHAT_COMMAND_COM_TRACKING");
    if (nStage == 1)//add command and text and make the pc speak it
    {
        string sCommand = GetCommandString(nCommand);
        if (nCommand == 8 || nCommand == 9)//vfx numbers are intered after command, followed by dur type, duration, and subtype
        {
            while (GetStringLeft(sCCText, 1) == " ") sCCText = GetStringRight(sCCText, GetStringLength(sCCText) - 1);//parse out left spaces
            while (GetStringRight(sCCText, 1) == " ") sCCText = GetStringLeft(sCCText, GetStringLength(sCCText) - 1);//parse out right spaces
            string sFXType = GetLocalString(oCCPC, "FKY_CHAT_COMMAND_COM_FX_TYPE");
            string sFXSubType = GetLocalString(oCCPC, "FKY_CHAT_COMMAND_COM_FX_SUB");
            if (sFXType == "1") sFXType = sFXType + " " + sInject; //other two types, instant and permanent, already have dur set to 0 - (0 0 and 2 0)
            if (sFXSubType != "") sFXType = sFXType + " " + sFXSubType;
            sCommand = sCommand + " " + sCCText + " " + sFXType;
        }
        else
        {
            while (GetStringLeft(sCCText, 1) == " ") sCCText = GetStringRight(sCCText, GetStringLength(sCCText) - 1);//parse out left spaces
            if (sInject != "") sCommand = sCommand + " " + sInject;
            sCommand = sCommand + " " + sCCText;
        }
        //variable cleanup
        DeleteLocalInt(oCCPC, "FKY_CHAT_COMMAND_COMPLETE");
        DeleteLocalInt(oCCPC, "FKY_CHAT_COMMAND_COM_STAGE");
        DeleteLocalString(oCCPC, "FKY_CHAT_COMMAND_COM_TRACKING");
        DeleteLocalString(oCCPC, "FKY_CHAT_COMMAND_COM_FX_TYPE");
        DeleteLocalString(oCCPC, "FKY_CHAT_COMMAND_COM_FX_SUB");
        DeleteLocalInt(oCCPC, "FKY_CHAT_COMMAND_COM_FX_FUNC");//shouldn't ever still be here by now, just a failsafe
        DeleteLocalString(oCCPC, "FKY_CHAT_COMMAND_COM_MENU");//shouldn't ever still be here by now, just a failsafe
        //////////////////
        SetLocalString(oCCPC, "FKY_CHAT_COMMAND_EXE", sCommand);//set the command to speak on them
        DelayCommand(0.1, ExecuteScript("fky_chat_command", oCCPC));//this ensures the spoken string fires the chat script again
    }
    else if (nStage == 2)
    {
        string sPrompt;
        while (GetStringLeft(sCCText, 1) == " ") sCCText = GetStringRight(sCCText, GetStringLength(sCCText) - 1);//parse out left spaces
        while (GetStringRight(sCCText, 1) == " ") sCCText = GetStringLeft(sCCText, GetStringLength(sCCText) - 1);//parse out right spaces
        if (nCommand > 69) sPrompt = COMCOM17;
        else sPrompt = COMCOM5;
        SetLocalString(oCCPC, "FKY_CHAT_COMMAND_COM_TRACKING", sCCText);
        SetLocalInt(oCCPC, "FKY_CHAT_COMMAND_COM_STAGE", 1);//signal transition to last input stage
        FloatingTextStringOnCreature(C_GOLD+sPrompt+C_END, oCCPC, FALSE);
    }
}

void DoStealth(object oSPC, object oSTarget, string sSText, int nSChannel, string sSLogMessageTarget)
{
    SetLocalString(oSPC, "NWNX!CHAT!SUPRESS", "1");
    SendMessageToPC(oSPC, DMSTEALTH1);
    if (SEND_CHANNELS_TO_CHAT_LOG) SendChatLogMessage(oSTarget, C_PURPLE+GetName(oSPC)+C_END+C_WHITE+DMSTEALTH2+sSText, GetMessenger());
    else SendMessageToPC(oSTarget, C_PURPLE+GetName(oSPC)+C_END+C_WHITE+DMSTEALTH2+sSText);
    if (TEXT_LOGGING_ENABLED) DoLogging(oSPC, sSLogMessageTarget, nSChannel, sSText);
    DoCleanup(oSPC);
}

void HandleOtherSpeech(object oHOPC, object oHOTarget, string sHOText, int nHOChannel, string sHOLogMessageTarget)
{
        string sHOTarget, sEscape, var1, var2;
        switch(nHOChannel)//all speech besides emotes, player commands, and metachannels - sort by channel
        {
////////////Player speaker channels from 1-14
/*talk*/    case 1:
                // Nothing
            break;
/*shout*/   case 2:
            if (GetLocalInt(oHOPC, "FKY_CHT_BANSHOUT"))//check for shout ban
            {
                SetLocalString(oHOPC, "NWNX!CHAT!SUPRESS", "1");//mute em
                SendMessageToPC(oHOPC, C_RED+BANNEDSHT+C_END);//tell em
            }
            else HandleShoutSpeak(sHOText, oHOPC);
            break;
/*whisper*/ case 3:
                // Nothing
            break;
/*tell*/    case 4:
                var1 = "FKY_CHT_IGNORE" + GetPCPlayerName(oHOPC);
                var2 = "FKY_CHT_IGNORET" + GetPCPlayerName(oHOPC);

                if (GetLocalInt(oHOTarget, var1) || GetLocalInt(oHOTarget, var1)){
                    SetLocalString(oHOPC, "NWNX!CHAT!SUPRESS", "1");//mute em
                    SendMessageToPC(oHOPC, C_RED + GetName(oHOTarget)+ISIGNORED+C_END);//tell em
                }
                else
                    HandleAFK(oHOPC, oHOTarget);

            break;
/*party*/   case 6:
                HandlePartySpeak(sHOText, oHOPC);
            break;
/*dm*/      case 14:
            if (GetLocalInt(oHOPC, "FKY_CHT_BANDM"))//check for DM ban
            {
                SetLocalString(oHOPC, "NWNX!CHAT!SUPRESS", "1");//mute em
                SendMessageToPC(oHOPC, C_RED+BANNEDDM+C_END);//tell em
            }
            if (DM_PLAYERS_HEAR_DM) DMChannelForwardToDMs(oHOPC, sHOText);//check for dm players hearing dm
            if (ADMIN_PLAYERS_HEAR_DM) DMChannelForwardToAdmins(oHOPC, sHOText);//check for admin players hearing dm
            break;
////////////DM speaker channels from 17-30
/*talk*/    //case 17:
/*shout*/   //case 18:
/*whisper*/ //case 19:
/*tell*/    case 20:
            DMTellForwarding(oHOPC, sHOLogMessageTarget, sHOText, nHOChannel); //check for tell options
            break;
/*party*/   //case 22:
/*dm*/      case 30:
            if (DM_PLAYERS_HEAR_DM) DMChannelForwardToDMs(oHOPC, sHOText); //check for dm players hearing dm
            if (ADMIN_PLAYERS_HEAR_DM) DMChannelForwardToAdmins(oHOPC, sHOText);//check for admin players hearing dm
            break;
        }
}

//void main(){}
