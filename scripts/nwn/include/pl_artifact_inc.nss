#include "mod_funcs_inc"
#include "item_func_inc"
#include "pc_funcs_inc"

void ArtifactLevelUp(object oPC);
int ArtifactApplyProperties(object oItem, int nClass, int nLevel);

int ArtifactApplyProperties(object oItem, int nClass, int nLevel){
    switch (nClass){
        case 1:  // CLASS_TYPE_BARBARIAN;
        break;
        case 2:  // CLASS_TYPE_BARD;
        break;
        case 3:  // CLASS_TYPE_CLERIC;
        break;
        case 4:  // CLASS_TYPE_DRUID;
        break;
        case 5:  // CLASS_TYPE_FIGHTER;
        break;
        case 6:  // CLASS_TYPE_MONK;
        break;
        case 7:  // CLASS_TYPE_PALADIN;
        break;
        case 8:  // CLASS_TYPE_RANGER;
        break;
        case 9:  // CLASS_TYPE_ROGUE;
        break;
        case 10: // CLASS_TYPE_SORCERER;
        break;
        case 11: // CLASS_TYPE_WIZARD;
        break;
        case 12: // CLASS_TYPE_SHADOWDANCER;
        break;
        case 13: // CLASS_TYPE_HARPER;
        break;
        case 14: // CLASS_TYPE_ARCANE_ARCHER;
        break;
        case 15: // CLASS_TYPE_ASSASSIN;
        break;
        case 16: // CLASS_TYPE_BLACKGUARD;
        break;
        case 17: // CLASS_TYPE_DIVINECHAMPION;
        break;
        case 18: // CLASS_TYPE_WEAPON_MASTER;
        break;
        case 19: // CLASS_TYPE_PALEMASTER;
        break;
        case 20: // CLASS_TYPE_SHIFTER;
        break;
        case 21: // CLASS_TYPE_DWARVENDEFENDER;
        break;
        case 22: // CLASS_TYPE_DRAGON_DISCIPLE;
        break;
        case 23: // CLASS_TYPE_PURPLE_DRAGON_KNIGHT;
        break;
        case 24: // CLASS_TYPE_BARD_GROUP;
        break;
        case 25: // CLASS_TYPE_DRUID_GROUP;
        break;
        case 26: // CLASS_TYPE_FIGHTER_GROUP;
        break;
        case 27: // CLASS_TYPE_MAGE_GROUP;
        break;
        case 28: // CLASS_TYPE_ROGUE_GROUP;
        break;
    }
    return FALSE;
}

void ArtifactLevelUp(object oPC){
    int nHD, nClass, nLevel;
    object oItem = GetItemPossessedBy(oPC, "pl_artifact");

    if(oItem == OBJECT_INVALID) return;

    string sType = GetLocalString(oItem, VAR_ILR_CLASS);
    if(sType == ""){ // New ring.  Resref == "pl_artifact_<class>"
        sType = GetResRef(oItem);
        sType = GetStringRight( sType, GetStringLength(sType) - 12);
        nClass = StringToInt(sType);
    }
    else{
        nHD = FindSubString(sType, ":");
        if(nHD != -1){
            nClass = StringToInt(GetStringLeft(sType, nHD - 1));
            nLevel = StringToInt(GetStringRight(sType, GetStringLength(sType) - nHD));
        }
        else return;
    }

    nHD = PLGetLevelByClass(GetILRClass(nClass), oPC);
    if(nHD > nLevel){
        int nAdds = FALSE;

        for(nLevel; nLevel <= nHD; nLevel++){
            // nAdds = level at which a property was added.
            nAdds = ArtifactApplyProperties(oItem, nClass, nLevel);
        }
        if(nAdds){ // Some property has been added to the item.
            SendPCMessage(oPC, C_GOLD+"Your " +GetName(oItem)+" has increased in power!"+C_END);
            // Tells us how many levels we've applied and also creates a new item level
            // restriction at the last level a property was applied.
            SetLocalString(oItem, VAR_ILR_CLASS, IntToString(nClass)+":"+IntToString(nAdds));
        }
    }
}
