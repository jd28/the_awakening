#include "mod_const_inc"
#include "nwnx_inc"

void main()
{
    int i, nValue;
    string sValue, sSchool, sSpellLevel, sHostile;

    // Spell Names
    if(!CreateHash(GetModule(), VAR_HASH_SPELL_NAME, MAX_SPELL_NUM))
        WriteTimestampedLogEntry("HASHSET : Creation of " + VAR_HASH_SPELL_NAME + " has failed!");
    if(!CreateHash(GetModule(), VAR_HASH_SPELL_NAME, MAX_SPELL_NUM))
        WriteTimestampedLogEntry("HASHSET : Creation of " + VAR_HASH_SPELL_INFO + " has failed!");

    for(i = 0; i < MAX_SPELL_NUM; i++){
        if(i >= 840 && i <= 1500){
            continue;
            SetHashInt(OBJECT_SELF, VAR_HASH_SPELL_INFO, IntToString(i), 0);
        }
        sValue = Get2DAString("spellinfo", "Name", i);
        if(sValue == "****") nValue = -1;
        else nValue = StringToInt(sValue);
        SetHashInt(OBJECT_SELF, VAR_HASH_SPELL_NAME, IntToString(i), nValue);

        nValue = 0;
        sValue = Get2DAString("spellinfo", "School", i);
        if(sValue == "****") nValue = 0;
        else{
            if(sValue == "A") nValue = SPELL_SCHOOL_ABJURATION * 100;
            else if (sValue == "C") nValue = SPELL_SCHOOL_CONJURATION * 100;
            else if (sValue == "D") nValue = SPELL_SCHOOL_DIVINATION * 100;
            else if (sValue == "E") nValue = SPELL_SCHOOL_ENCHANTMENT * 100;
            else if (sValue == "N") nValue = SPELL_SCHOOL_NECROMANCY * 100;
            else if (sValue == "T") nValue = SPELL_SCHOOL_TRANSMUTATION * 100;
            else if (sValue == "V") nValue = SPELL_SCHOOL_EVOCATION * 100;
            else nValue = 0;
        }
        sValue = Get2DAString("spellinfo", "Innate", i);
        if(sValue == "****") nValue += 0;
        else nValue += StringToInt(sValue) * 10;

        sValue = Get2DAString("spellinfo", "HostileSetting", i);
        if(sValue == "****") nValue += 0;
        else nValue += StringToInt(sValue);

        SetHashInt(OBJECT_SELF, VAR_HASH_SPELL_INFO, IntToString(i), nValue);
    }

    WriteTimestampedLogEntry("HASHSET : Creation of " + VAR_HASH_SPELL_INFO + " has succeeded!");
}
