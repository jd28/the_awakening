
// Three seperate 'events' can occurs:
const int NWNX_SPECIAL_ATTACK_EVENT_RESOLVE         = 0;
const int NWNX_SPECIAL_ATTACK_EVENT_AB              = 1;
const int NWNX_SPECIAL_ATTACK_EVENT_DAMAGE          = 2;

// You'll notice that the bulk of these are identical to the feats.2da
// entry number of the feat associated the special attack.
const int NWNX_SPECIAL_ATTACK_AOO				    = 65002;
const int NWNX_SPECIAL_ATTACK_CALLED_SHOT_ARM       = 65001;
const int NWNX_SPECIAL_ATTACK_CALLED_SHOT_LEG       = 65000;
const int NWNX_SPECIAL_ATTACK_CLEAVE				= 6;
const int NWNX_SPECIAL_ATTACK_CLEAVE_GREAT          = 391;
const int NWNX_SPECIAL_ATTACK_DISARM                = 9;
const int NWNX_SPECIAL_ATTACK_DISARM_IMPROVED       = 16;
const int NWNX_SPECIAL_ATTACK_KI_DAMAGE			    = 882;
const int NWNX_SPECIAL_ATTACK_KNOCKDOWN			    = 23;
const int NWNX_SPECIAL_ATTACK_KNOCKDOWN_IMPROVED    = 17;
const int NWNX_SPECIAL_ATTACK_QUIVERING_PALM		= 296;
const int NWNX_SPECIAL_ATTACK_SAP                   = 31;
const int NWNX_SPECIAL_ATTACK_SMITE_EVIL			= 301;
const int NWNX_SPECIAL_ATTACK_SMITE_GOOD			= 472;
const int NWNX_SPECIAL_ATTACK_STUNNING_FIST		    = 39;

// @return : returns the attack roll, error -1.
// Note : this function only works when
//      GetSpecialAttackEventType() == NWNX_SPECIAL_ATTACK_EVENT_RESOLVE
int GetSpecialAttackRoll();

// @return : object being attacked.
object GetSpecialAttackTarget();

// @return : NWNX_SPECIAL_ATTACK_*
int GetSpecialAttackType();

// @return : NWNX_SPECIAL_ATTACK_EVENT_*
int GetSpecialAttackEventType();

// Sets a script to execute on the attacker when the specified special
// attack occurs
// - nSpecAttack : NWNX_SPECIAL_ATTACK_*
// - sScript : Name of the script to fire.  Must be non-empty.
// @return : -1 signals failure.
int SetSpecialAttackHandler(int nSpecAttack, string sScript);


int GetSpecialAttackEventType() {
    SetLocalString(GetModule(), "NWNX!SPECATTACK!GETATTACKEVENTTYPE", "  ");
    return StringToInt(GetLocalString(GetModule(), "NWNX!SPECATTACK!GETATTACKEVENTTYPE"));
}

int GetSpecialAttackRoll() {
    SetLocalString(GetModule(), "NWNX!SPECATTACK!GETATTACKROLL", "    ");
    return StringToInt(GetLocalString(GetModule(), "NWNX!SPECATTACK!GETATTACKROLL"));
}

object GetSpecialAttackTarget() {
    SetLocalString(GetModule(), "NWNX!SPECATTACK!GETTARGET", "           ");
    return GetLocalObject(GetModule(), "NWNX!SPECATTACK!GETTARGET");
}

int GetSpecialAttackType() {
    SetLocalString(GetModule(), "NWNX!SPECATTACK!GETATTACKTYPE", "  ");
    return StringToInt(GetLocalString(GetModule(), "NWNX!SPECATTACK!GETATTACKTYPE"));

}

int SetSpecialAttackHandler(int nSpecAttack, string sScript){
    if (sScript == "")
        return -1;

    string sParam = IntToString(nSpecAttack) + " " + sScript;
    SetLocalString(GetModule(), "NWNX!SPECATTACK!SETSCRIPTHANDLER", sParam);
    return StringToInt(GetLocalString(GetModule(), "NWNX!SPECATTACK!SETSCRIPTHANDLER"));
    
}
