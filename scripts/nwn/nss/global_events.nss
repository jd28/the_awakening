//::///////////////////////////////////////////////
//:: Global Events
//:: global_events.nss
//:: Copyright (c) 2008 Cormyrean Wars Project
//:://////////////////////////////////////////////
/*
*/
//:://////////////////////////////////////////////
//:: Created By: SpiderX
//:: Created On: 11/03/2008
//:://////////////////////////////////////////////
//:: Updated By: SpiderX
//:: Updated On: 11/03/2008
//:://////////////////////////////////////////////

#include "nwnx_inc"
#include "mod_funcs_inc"
#include "pc_funcs_inc"
#include "pl_events_inc"

void main(){
    object oPC, oTarget, oItem;
    vector vTarget;
    int iEventSubType, nMode;
    string sMsg;

    switch (GetEventType()){
        case EVENT_PICKPOCKET:
            oPC = OBJECT_SELF;
            oTarget = GetActionTarget();
            if(GetIsPC(oTarget)){
                BypassEvent();
                ErrorMessage(oPC, "Stealing from other players is not allowed.");
            }
            break;
        case EVENT_ATTACK:
            oPC = OBJECT_SELF;
            oTarget = GetActionTarget();
            iEventSubType = GetEventSubType();

            if(GetLocalInt(oPC,"DebugEvents")){
                if(iEventSubType == 39)
                    BypassEvent();
            }
            nMode = GetLocalInt(oPC, "FKY_CHAT_MODE");
            if(nMode != 0)
                SetActionMode(oPC, nMode, TRUE);
            Logger(oPC, "DebugEvents", LOGLEVEL_NONE, "global_events : %s attacked %s with %s", GetName(oPC), GetName(oTarget), IntToString(iEventSubType));

            break;
        case EVENT_TYPE_CAST_SPELL:
            oPC = OBJECT_SELF;
            oTarget = GetActionTarget();
        break;
        case EVENT_USE_ITEM:
/*
            oPC = OBJECT_SELF;
            oTarget = GetActionTarget();
            oItem = GetEventItem();
            vTarget = GetEventPosition();

            if(!GetIsDM(oPC)) break;

            if(GetResRef(oItem) == "pl_mob_spawn") {
                DelayCommand(0.5, DMMobSpawn(oPC, oItem, vTarget));
/*
            if (GetBaseItemType(oItem) == BASE_ITEM_TRAPKIT) {
                Logger(oPC, "DebugEvents", LOGLEVEL_NONE, "global_events : Trap used by %s, Target: %s",
                    GetName(oPC), GetName(oTarget));
                SetTrapCreator(oTarget, oPC);
                FloatingTextStringOnCreature("Your trap has been set!", oPC); // test string

            }
*/
        break;
        case EVENT_QUICKCHAT:
            oPC = OBJECT_SELF;
            iEventSubType = GetEventSubType();
            break;
        case EVENT_EXAMINE:
            oPC = OBJECT_SELF;
            oTarget = GetActionTarget();
            if(GetTag(oTarget) == "pl_strongman_leadboard"){
                BypassEvent();
                ShowFaireLeaderboard(oPC, oTarget);
            }
            else if(GetLocalInt(oTarget, "OnHits") > 0){
                DisplayOnHitSpells(oPC, oTarget);
            }
            break;
        case EVENT_USE_SKILL:
            oPC = OBJECT_SELF;
            iEventSubType = GetEventSubType();    //SKILL_*
            oTarget = GetActionTarget();
            Logger(oPC, "DebugEvents", LOGLEVEL_NONE, "%s used skill #%s on %s", GetName(oPC),  IntToString(iEventSubType), GetName(oTarget));
            break;
        case EVENT_USE_FEAT:
            oPC = OBJECT_SELF;
            iEventSubType = GetEventSubType();   //FEAT_*
            oTarget = GetActionTarget();

            Logger(oPC, "DebugEvents", LOGLEVEL_NONE, "%s used feat #%s on %s", GetName(oPC),  IntToString(iEventSubType), GetName(oTarget));

            break;
        case EVENT_TOGGLE_MODE:
            oPC = OBJECT_SELF;
            iEventSubType = GetEventSubType();  //ACTION_MODE_*
            Logger(oPC, "DebugEvents", LOGLEVEL_NONE, "%s toggled mode #%s", GetName(oPC),  IntToString(iEventSubType));

            switch(iEventSubType){
                case ACTION_MODE_STEALTH:
                    //if(GetActionMode(oPC, ACTION_MODE_STEALTH))
                    //    RemoveEffectsFromSpell(OBJECT_SELF, SPELL_SANCTUARY);
                    //else
                        EventDoStealth(oPC);
                break;
            }
        break;
    }
}
