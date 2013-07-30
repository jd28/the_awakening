//::///////////////////////////////////////////////
//:: Associate: On Spawn In
//:: NW_CH_AC9
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

This must support the OC henchmen and all summoned/companion
creatures.

*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 19, 2001
//:://////////////////////////////////////////////
//:: Updated By: Georg Zoeller, 2003-08-20: Added variable check for spawn in animation


#include "X0_INC_HENAI"
#include "x2_inc_switches"
#include "mon_func_inc"
#include "dip_func_inc"
#include "pl_dds_inc"
void main()
{
     //Sets up the special henchmen listening patterns
    SetAssociateListenPatterns();

    // Set additional henchman listening patterns
    bkSetListeningPatterns();

    // Default behavior for henchmen at start
    SetAssociateState(NW_ASC_POWER_CASTING);
    SetAssociateState(NW_ASC_HEAL_AT_50);
    SetAssociateState(NW_ASC_RETRY_OPEN_LOCKS);
    SetAssociateState(NW_ASC_DISARM_TRAPS);
    SetAssociateState(NW_ASC_MODE_DEFEND_MASTER, FALSE);

    //Use melee weapons by default
    SetAssociateState(NW_ASC_USE_RANGED_WEAPON, FALSE);

    // Distance: make henchmen stick closer
    SetAssociateState(NW_ASC_DISTANCE_4_METERS);
    if (GetAssociate(ASSOCIATE_TYPE_HENCHMAN, GetMaster()) == OBJECT_SELF) {
    SetAssociateState(NW_ASC_DISTANCE_2_METERS);
    }

    int nID = GetLocalInt(OBJECT_SELF, "ID");
    if(nID)
        ApplyDDS(OBJECT_SELF, nID);

    ApplyLocals();

    switch(GetLocalInt(OBJECT_SELF, "DIPType")){
        case 1: // Right hand
            DelayCommand(2.0, ApplyLocalsToWeapon(OBJECT_SELF, GetItemInSlot(INVENTORY_SLOT_RIGHTHAND),
                OBJECT_INVALID, OBJECT_INVALID));
        break;
        case 2: // Dual
            DelayCommand(2.0, ApplyLocalsToWeapon(OBJECT_SELF, GetItemInSlot(INVENTORY_SLOT_RIGHTHAND),
                GetItemInSlot(INVENTORY_SLOT_LEFTHAND), OBJECT_INVALID));
        break;
        case 3: // Guants
            DelayCommand(2.0, ApplyLocalsToWeapon(OBJECT_SELF, GetItemInSlot(INVENTORY_SLOT_ARMS),
                OBJECT_INVALID, OBJECT_INVALID));
        break;
        default:
            DelayCommand(2.0, ApplyLocalsToWeapon(OBJECT_SELF, GetItemInSlot(INVENTORY_SLOT_CWEAPON_R),
                GetItemInSlot(INVENTORY_SLOT_CWEAPON_L), GetItemInSlot(INVENTORY_SLOT_CWEAPON_B)));
    }

    // * If Incorporeal, apply changes
    if (GetCreatureFlag(OBJECT_SELF, CREATURE_VAR_IS_INCORPOREAL) == TRUE)
    {
        effect eConceal = EffectConcealment(50, MISS_CHANCE_TYPE_NORMAL);
        eConceal = ExtraordinaryEffect(eConceal);
        effect eGhost = EffectCutsceneGhost();
        eGhost = ExtraordinaryEffect(eGhost);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eConceal, OBJECT_SELF);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eGhost, OBJECT_SELF);
    }


    // Set starting location
    SetAssociateStartLocation();
}


