#include "nwnx_structs"

// NWNX_EFFECT_ADDITIONAL_ATTACKS must be 0, it's hardcoded.
const int NWNX_EFFECT_ADDITIONAL_ATTACKS = 0;


const int NWNX_EFFECTS_EVENT_APPLY        = 0;
const int NWNX_EFFECTS_EVENT_REMOVE       = 1;

// This is a replacement for EffectModifyAttacks.  It is handled in the
// plugin.  If you use nwnx_effects you'd have to replace all occurances
// of EffectModifyAttacks with EffectAdditionalAttacks
// - nAmount: (0, 5]
effect EffectAdditionalAttacks(int nAmount);

// Returns whatever integer was identifies the effect being applied/removed.
int GetCustomEffectType();

// Returns NWNX_EFFECTS_EVENT_* depending on whether the effect is being
// applied or removed.
int GetCustomEffectEventType();

// See nwnx_structs GetEffectInteger this function is identical save that it
// can return integers only from the effect currently being applied/removed.
int GetCustomEffectInteger(int nInteger);

// Sets the Effect script handler
// @return -1 signals an error that the handler was not set.
int SetCustomEffectHandler(int nEffectType, string sScript);

// This function only needs to be called when an effect fails, for whatever reason,
// to be applied or applicable.  nwnx_effects assumes success.
// NOTE: you'd only ever need to call this in a script applying an effect.
// bSuccess : if FALSE signals to the plugin that the effect was not applied,
//      if true that it was.
void SetCustomEffectSuccess(int bSuccess = TRUE);

int GetCustomEffectType(){
    SetLocalString(GetModule(), "NWNX!EFFECTS!GETEFFECTTYPE", "     ");
    return StringToInt(GetLocalString(GetModule(), "NWNX!EFFECTS!GETEFFECTTYPE"));
}

int GetCustomEffectEventType(){
    SetLocalString(GetModule(), "NWNX!EFFECTS!GETEFFECTEVENTTYPE", "     ");
    return StringToInt(GetLocalString(GetModule(), "NWNX!EFFECTS!GETEFFECTEVENTTYPE"));
}

int GetCustomEffectInteger(int nInteger){
    SetLocalString(GetModule(), "NWNX!EFFECTS!GETEFFECTINTEGER", IntToString(nInteger)+ "               ");
    return StringToInt(GetLocalString(GetModule(), "NWNX!EFFECTS!GETEFFECTINTEGER"));
}

int SetCustomEffectHandler(int nEffectType, string sScript){
    // No point in setting the handler to an empty string.
    if (sScript == "")
        return -1;

    string sParam = IntToString(nEffectType) + " " + sScript;
    SetLocalString(GetModule(), "NWNX!EFFECTS!SETEFFECTHANDLER", sParam);
    return StringToInt(GetLocalString(GetModule(), "NWNX!EFFECTS!SETEFFECTHANDLER"));
}

void SetCustomEffectSuccess(int bSuccess = TRUE) {
    SetLocalString(GetModule(), "NWNX!EFFECTS!SETEFFECTSUCCESS", IntToString(bSuccess));
}
