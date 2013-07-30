//::///////////////////////////////////////////////
//:: Death Script
//:: NW_O0_DEATH.NSS
//:: Copyright (c) 2008 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This script handles the default behavior
    that occurs when a player dies.

    BK: October 8 2002: Overriden for Expansion

    Deva Winblood:  April 21th, 2008: Modified to
    handle dismounts when PC dies while mounted.

*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: November 6, 2001
//:://////////////////////////////////////////////

#include "pc_funcs_inc"
#include "vfx_inc"
#include "pl_pvp_inc"

void SendDeathMessage(object oPC, object oKiller){
    if(GetLocalInt(oPC, "DeathMsg")) return;
    SetLocalInt(oPC, "DeathMsg", 1);

    string sDeathMessage = C_CRIMSON+ GetName(oPC)+" was slain";
    if(GetIsObjectValid(oKiller)) sDeathMessage += " by " + GetName(oKiller);
    else sDeathMessage += ".";
    sDeathMessage += C_END;
    SendPartyMessage(oPC, sDeathMessage);

    DelayCommand(2.0, DeleteLocalInt(oPC, "DeathMsg"));
}

void UseBranch(object oPC, object oBranch){
    if(!GetIsDead(oPC))
        return;

    int nCharges = GetLocalInt(oBranch, "PL_BRANCH_CHARGES");
    nCharges -= 1;
    SetLocalInt(oBranch, "PL_BRANCH_CHARGES", nCharges);

    effect eSanc = EffectEthereal();
    Raise(oPC);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSanc, oPC, 12.0f);
}

void main()
{
    object oPC = GetLastPlayerDied();
    object oKiller = GetLastHostileActor(oPC);
    SetLocalLocation(oPC, "DeathLocation", GetLocation(oPC));

    object oShade = GetLocalObject(oPC, "X0_L_MYSHADE");
    if(GetIsObjectValid(oShade)){
        AssignCommand(oShade, SetIsDestroyable(TRUE));
        ApplyVisualToObject(VFX_IMP_UNSUMMON, oShade);
        DestroyObject(oShade, 0.3);
    }

    // -------------------------------------------------------------------------
    // Arena Code
    // -------------------------------------------------------------------------
    if(GetLocalInt(GetArea(oPC), "PVP_CTF")){
        PVPModDeath(oPC, oKiller);
        return;
    }
    // -------------------------------------------------------------------------
    // Possible rebirth item..
    // -------------------------------------------------------------------------
    object oBranch = GetItemPossessedBy(oPC, "pl_branch_life");
    if(oBranch != OBJECT_INVALID && GetLocalInt(oBranch, "PL_BRANCH_CHARGES") > 0)
        DelayCommand(60.0f, UseBranch(oPC, oBranch));


    if(GetIsObjectValid(oKiller)){
        SetLocalObject(oKiller, "pl_pdk_vengeance", oPC);
        SetLocalInt(oKiller, "pl_pdk_vengeance", GetLocalInt(GetModule(), "uptime"));
    }

    // -------------------------------------------------------------------------
    // Make friendly to each of the 3 common factions
    // -------------------------------------------------------------------------
    AssignCommand(oPC, ClearAllActions());
    // * Note: waiting for Sophia to make SetStandardFactionReptuation to clear all personal reputation
    if (GetStandardFactionReputation(STANDARD_FACTION_COMMONER, oPC) <= 10)
    {   SetLocalInt(oPC, "NW_G_Playerhasbeenbad", 10); // * Player bad
        SetStandardFactionReputation(STANDARD_FACTION_COMMONER, 80, oPC);
    }
    if (GetStandardFactionReputation(STANDARD_FACTION_MERCHANT, oPC) <= 10)
    {   SetLocalInt(oPC, "NW_G_Playerhasbeenbad", 10); // * Player bad
        SetStandardFactionReputation(STANDARD_FACTION_MERCHANT, 80, oPC);
    }
    if (GetStandardFactionReputation(STANDARD_FACTION_DEFENDER, oPC) <= 10)
    {   SetLocalInt(oPC, "NW_G_Playerhasbeenbad", 10); // * Player bad
        SetStandardFactionReputation(STANDARD_FACTION_DEFENDER, 80, oPC);
    }

    // -------------------------------------------------------------------------
    // Apply a little visual effect.  Commented out, atm
    // -------------------------------------------------------------------------
    //location lSelf = GetLocation(oPC);
    //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(234), lSelf);

    // -------------------------------------------------------------------------
    // Send PC death message.
    // -------------------------------------------------------------------------
    //SendDeathMessage(oPC, oKiller);

    // -------------------------------------------------------------------------
    // Popup the the death panel.
    // -------------------------------------------------------------------------
    DelayCommand(2.5, PopUpGUIPanel(oPC, GUI_PANEL_PLAYER_DEATH));

}
///////////////////////////////////////////////////////////////[ MAIN ]/////////

