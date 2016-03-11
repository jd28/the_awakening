/**
 * Creates a custom effect. This requires nwnx_structs.
 *
 * +truetype+ is a number meant to reflect further types beyond
 * EFFECT_TRUETYPE_DEFENSIVESTANCE (truetype > 95).
 *
 * To actually define what your custom effect does, use nwnx_structs
 * as usual to set it's integers. It is recommended to write your own
 * EffectX() constructors.
 *
 * Your truetype effect IDs are mapped 1:1 to script IDs, so you can check for
 * them with the usual suspects (GetHasEffect etc).
 *
 * Please see README.md for detailed usage instructions.
 */
effect EffectCustom(int truetype);

/**
 * Sets the native effect of EFFECT_TRUETYPE_x to trigger callbacks.
 *
 * This can be used to augment existing effect types.
 *
 * Best called in OnModuleLoad or similar.
 */
void SetNativeEffectCallsUs(int truetype);

/**
 * Returns the custom effect's truetype.
 *
 * This will only work inside nwnx_effect callback scripts. Returns -1 on error.
 */
int GetCustomEffectTrueType();

/**
 * Returns the custom effect's tickrate (>= 0).
 *
 * This will only work inside nwnx_effect callback scripts. Returns -1 on error.
 */
int GetCustomEffectTickRate();

/**
 * Sets the custom effect's tickrate (>= 0).
 *
 * This will only work inside nwnx_effect callback scripts.
 */
void SetCustomEffectTickRate(int value);

/**
 * Gets any of the custom parameters given to EffectCustom (arg0..19).
 *
 * This will only work inside nwnx_effect callback scripts.
 *
 * Returns -1 on error (unless your value is -1 ..).
 */
int GetCustomEffectInteger(int index);

/**
 * Sets any of the custom parameters given to EffectCustom (arg0..19).
 *
 * This will only work inside nwnx_effect callback scripts.
 */
void SetCustomEffectInteger(int index, int value);

/**
 * Stops the current apply from happening.
 *
 * This will only work inside the nwnx_effect apply callback.
 */
void SetCustomEffectFailed();

/**
 * Gets the effect creator (whatever was OBJECT_SELF when you called EffectCustom()).
 *
 * This will only work inside nwnx_effect callback scripts.
 */
object GetCustomEffectCreator();


int GetCustomEffectTrueType()
{
    SetLocalString(OBJECT_SELF, "NWNX!EFFECTS!GETTRUETYPE", " ");
    return StringToInt(GetLocalString(OBJECT_SELF, "NWNX!EFFECTS!GETTRUETYPE"));
}

int GetCustomEffectTickRate()
{
    return GetCustomEffectInteger(20);
}

void SetNativeEffectCallsUs(int truetype)
{
    SetLocalString(OBJECT_SELF, "NWNX!EFFECTS!SETEFFECTNATIVEHANDLED", IntToString(truetype) + " ");
}

void SetCustomEffectTickRate(int value)
{
    SetCustomEffectInteger(20, value);
}

int GetCustomEffectInteger(int index)
{
    SetLocalString(OBJECT_SELF, "NWNX!EFFECTS!GETINT", IntToString(index) + " ");
    return StringToInt(GetLocalString(OBJECT_SELF, "NWNX!EFFECTS!GETINT"));
}

void SetCustomEffectInteger(int index, int value)
{
    SetLocalString(OBJECT_SELF, "NWNX!EFFECTS!SETINT",
                   IntToString(index) + "~" + IntToString(value));
}

void SetCustomEffectFailed()
{
    SetLocalString(OBJECT_SELF, "NWNX!EFFECTS!SETFAILED", "1");
}

object GetCustomEffectCreator()
{
    return GetLocalObject(OBJECT_SELF, "NWNX!EFFECTS!GETCREATOR");
}

effect EffectCustom(int truetype)
{
    effect ret;

    if (truetype >= 96) {
        // We're using effectModifyAttacks as a template because it only uses
        // one int param.
        ret = EffectModifyAttacks(0);
        // We immediately set a custom truetype, so it never registers as such
        // with nwserver. You're free to use all local CGameEffect
        // ints/floats/object/strings for your own nefarious purposes.
        SetEffectTrueType(ret, truetype);
    }

    return ret;
}
