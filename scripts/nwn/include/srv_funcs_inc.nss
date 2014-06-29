#include "mod_funcs_inc"
#include "pc_funcs_inc"

// -----------------------------------------------------------------------------
//  PROTOTYPES - Verification
// -----------------------------------------------------------------------------
//Verify the player is an admin by public CDKey
int VerifyAdminKey(object oPlayer);
//Verify the player is an DM by public CDKey
int VerifyDMKey(object oPlayer);

////////////////////////////////////////////////////////////////////////////////
// -----------------------------------------------------------------------------
//  PROTOTYPES - Reset
// -----------------------------------------------------------------------------
void BootAll();
void ResetMessageHandler(int nTimer);
void ResetServer();
void ResetStart();
void ResetDelay();



// -----------------------------------------------------------------------------
//  FUNCTIONS - Reset
// -----------------------------------------------------------------------------

void SendRestartMessage(){
    location lLocation;
    SpeakString(C_RED+"Auto Restart Sequence Active, you will have to reconnect."+C_END, TALKVOLUME_SHOUT);
    object oPC = GetFirstPC();
    while (oPC != OBJECT_INVALID){
        lLocation = GetLocation(oPC);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_FNF_METEOR_SWARM), lLocation, 5.0);
        oPC = GetNextPC();
    }
}

void ResetMessageHandler(int nTimer){
    object oPC;
    location lLocation;
    string sMsg = C_RED;

    if(nTimer == SRV_RESET_LENGTH - 30){
        sMsg = C_RED+"Auto Restart Sequence Will Begin In THIRTY Minutes!";
        sMsg += C_END;
        SpeakString(sMsg, TALKVOLUME_SHOUT);
        //SendMessageToAll("Auto Restart Sequence Will Begin In THIRTY Minutes!");
    }
    else if (nTimer == SRV_RESET_LENGTH - 15){
        sMsg = C_RED+"Auto Restart Sequence Will Begin In FIFTEEN Minutes!";
        if(GetLocalInt(GetModule(), "RESETS_DELAYED") < 2)
            sMsg += "  To delay the reset 3 players must vote with the !resetdelay command!";
        sMsg += C_END;
        SpeakString(sMsg, TALKVOLUME_SHOUT);
        //SendMessageToAll("Auto Restart Sequence Will Begin In FIFTEEN Minutes!");
    }
    else if (nTimer == SRV_RESET_LENGTH - 5){
        sMsg = C_RED+"Auto Restart Sequence Will Begin In FIVE Minutes!";
        if(GetLocalInt(GetModule(), "RESETS_DELAYED") < 2)
            sMsg += "  To delay the reset 3 players must vote with the !resetdelay command!";
        sMsg += C_END;

        SpeakString(sMsg, TALKVOLUME_SHOUT);
        //SendMessageToAll("Auto Restart Sequence Will Begin In FIVE Minutes!");
    }
    else if (nTimer == SRV_RESET_LENGTH - 1){
        sMsg = C_RED+"Auto Restart Sequence Will Begin In ONE Minute!";
        if(GetLocalInt(GetModule(), "RESETS_DELAYED") < 2)
            sMsg += "  To delay the reset 3 players must vote with the !resetdelay command!";
        sMsg += C_END;

        SpeakString(sMsg, TALKVOLUME_SHOUT);
            oPC = GetFirstPC();
            while (oPC != OBJECT_INVALID){
                lLocation = GetLocation(oPC);
                ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_FNF_SCREEN_SHAKE), lLocation, 200.0);
                ExportSingleCharacter(oPC);
                oPC = GetNextPC();
            }
        DelayCommand(5.0f, SendRestartMessage());
        DelayCommand(15.0f, SendRestartMessage());
        DelayCommand(30.0f, SendRestartMessage());
        DelayCommand(45.0f, SendRestartMessage());
        //DelayCommand(50.0f, BootAll());
    }
    else if(nTimer >= SRV_RESET_LENGTH){
        BootAll();
        ResetServer();
    }
}

void BootAll(){
    object oPC = GetFirstPC();
    while(oPC != OBJECT_INVALID){
        BootPlayer(oPC);
        oPC = GetNextPC();
    }
}

void ResetStart(){
    SetLocalInt(GetModule(), "MOD_RESET_TIMER", SRV_RESET_LENGTH - 6);
}
void ResetDelay(){
    int timekeeper = GetLocalInt(GetModule(), "MOD_RESET_TIMER");
    timekeeper -= SRV_RESET_DELAY;
    SetLocalInt(GetModule(), "MOD_RESET_TIMER", timekeeper);
    AssignCommand(GetModule(), SpeakString(C_GREEN+"Reset has been delayed for 30 minutes!"+C_END, TALKVOLUME_SHOUT));
}

void ResetServer(){
    WriteTimestampedLogEntry("Attempting Reset Server.  Booting Players");
	SetLocalInt(GetModule(), "SERVER_SHUTTING_DOWN", 1);
    ShutdownServer(12);
}

// -----------------------------------------------------------------------------
//  Functions - Verification
// -----------------------------------------------------------------------------
int VerifyDMKey(object oPlayer){
    string cdkey = GetPCPublicCDKey(oPlayer);
    return GetLocalInt(GetModule(), cdkey);
}

int VerifyAdminKey(object oPlayer){
    string cdkey = GetPCPublicCDKey(oPlayer);
    int val = GetLocalInt(GetModule(), cdkey);
    return val > 1;
}

// The following code is a slightly modified version of the system
// released on the bioware forums by FunkySwerve:
// http://social.bioware.com/forum/1/topic/199/index/7846801
int VerifyPlayernameAgainstCDKey(object oPlayer);
int VerifyPlayernameAgainstCDKey(object oPlayer) {
    DeleteLocalInt(oPlayer, "InvalidCDKey");
    int nBoot = FALSE;
    string sUnencoded = GetPCPlayerName(oPlayer);
    string sPlayer = SQLEncodeSpecialChars(sUnencoded);
    string sKey = GetPCPublicCDKey(oPlayer);
    string sStoredKey, sAddingKey;
    string sSQL = "SELECT cdkey FROM cdkeys WHERE player='" + sPlayer + "'";

    //SendMessageToPC(oPlayer, "Attempting to Verify CDKey");

    SQLExecDirect(sSQL);

    /* there's at least one key stored already */

    if (SQLFetch() == SQL_SUCCESS) {
        sStoredKey = SQLGetData(1);
        //sAddingKey = SQLGetData(2);

        /* they indicated that they wanted to add a key this login */

        if (GetDbInt(oPlayer, "pc_add_key", TRUE)) {
            DeleteDbVariable(oPlayer, "pc_add_key", TRUE);

            /* their current key is not in the key string, add it unless at 7 keys already */
            if (FindSubString(sStoredKey, sKey) == -1) {
                int nKeyLength = GetStringLength(sStoredKey);

                /* allow 7 keys max key-key-key-key-key-key-key    6 spacers + 7x8 keys = 62 */
                if (nKeyLength > 61) {
                    nBoot = TRUE;

                    /* add the key to the string */
                } else {
                    sSQL =
                        "UPDATE cdkeys SET cdkey='" + sStoredKey + "-" + sKey + "' WHERE player='" + sPlayer +
                        "'";
                    SQLExecDirect(sSQL);
                    DelayCommand(25.0, FloatingTextStringOnCreature("New CD Key Successfully Added!", oPlayer, FALSE));
                }


                /* let them know they already had this key in their string */
            } else {
                DelayCommand(25.0,
                    FloatingTextStringOnCreature("CD Key Addition Failed! This key already listed for this account!", oPlayer,
                        FALSE));
            }


            /* they are not adding, and the cd key doesnt match those listed - boot and log */
        } else if (FindSubString(sStoredKey, sKey) == -1) {
            string sReport = "INCORRECT CD KEY DETECTED! ID: " + sUnencoded + "; Name: " +
                GetName(oPlayer) + "; CD Key: " + sKey + "; IP: " + GetPCIPAddress(oPlayer) ;

            WriteTimestampedLogEntry(sReport);
            SendMessageToAllDMs(sReport);

            nBoot = TRUE;
        }


        /* new account, add the key */
    } else {
        sSQL = "INSERT INTO cdkeys (cdkey,player) VALUES" + "('" + sKey + "','" + sPlayer + "')";
        //SendMessageToPC(oPlayer, sSQL);
        SQLExecDirect(sSQL);
    }

    return nBoot;
}
