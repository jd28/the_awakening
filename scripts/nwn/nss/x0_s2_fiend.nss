//::///////////////////////////////////////////////
//:: x0_s2_fiend
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
Summons the 'fiendish' servant for the player.
This is a modified version of Planar Binding


At Level 5 the Blackguard gets a Succubus

At Level 9 the Blackguard will get a Vrock

Will remain for one hour per level of blackguard
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: April 2003
//:://////////////////////////////////////////////

#include "pl_summon_inc"
#include "gsp_func_inc"

void ScaleFiend(){
    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED);

    ScaleEpicFiendishServant(oSummon);
}

void main(){

    struct SpellInfo si = GetSpellInfo();
    if(si.id < 0) return;

    object oPC = OBJECT_SELF;
    int nCasterLevel = GetLevelByClass(CLASS_TYPE_BLACKGUARD, OBJECT_SELF);
    effect eSummon;
    float fDelay = 3.0;
    int nDuration = si.clevel;
    int bScale;

    if (si.clevel < 9)
    {
        eSummon = EffectSummonCreature("NW_S_SUCCUBUS",VFX_FNF_SUMMON_GATE, fDelay);
    }
    else if (si.clevel < 15 )
    {
        eSummon = EffectSummonCreature("NW_S_VROCK", VFX_FNF_SUMMON_GATE, fDelay);
    }
    // Vrock clone...
    else if (GetHasFeat(1003,OBJECT_SELF) &&
             CreateShadow(oPC, nCasterLevel + 10, "Fiendish Servant of " + GetName(oPC), APPEARANCE_TYPE_VROCK, 188))
    {
             return;
/*          if (GetLevelByClass(CLASS_TYPE_DRUID) == 0
                && GetLevelByClass(CLASS_TYPE_SHIFTER) == 0  ){

                if(GetIsPCShifted(oPC)){
                    SendMessageToPC(oPC, C_RED+"You can't use this feat while polymorphed"+C_END);
                    return;
                }

                object oShade = GetLocalObject(oPC, "X0_L_MYSHADE");
                if(GetIsObjectValid(oShade)){
                    AssignCommand(oShade, SetIsDestroyable(TRUE));
                    ApplyVisualToObject(VFX_IMP_UNSUMMON, oShade);
                    DestroyObject(oShade);
                }

                oShade = CopyObject(oPC, GetSpellTargetLocation(), OBJECT_INVALID, GetName(oPC) + "SDCLONE");
                SetName(oShade, "Fiendish Servant of " + GetName(oPC));
                SetCreatureAppearanceType(oShade, APPEARANCE_TYPE_VROCK);
                AddHenchman(oPC, oShade);
                SetCreatureEventHandler(oShade, CREATURE_EVENT_ATTACKED, "x0_ch_hen_attack");
                SetCreatureEventHandler(oShade, CREATURE_EVENT_BLOCKED, "x0_ch_hen_block");
                SetCreatureEventHandler(oShade, CREATURE_EVENT_CONVERSATION, "x0_hen_conv");
                SetCreatureEventHandler(oShade, CREATURE_EVENT_DAMAGED, "x0_ch_hen_damage");
                SetCreatureEventHandler(oShade, CREATURE_EVENT_DEATH, "x2_hen_death");
                SetCreatureEventHandler(oShade, CREATURE_EVENT_DISTURBED, "x0_ch_hen_distrb");
                SetCreatureEventHandler(oShade, CREATURE_EVENT_ENDCOMBAT, "x0_ch_hen_combat");
                SetCreatureEventHandler(oShade, CREATURE_EVENT_HEARTBEAT, "x0_ch_hen_heart");
                SetCreatureEventHandler(oShade, CREATURE_EVENT_PERCEPTION, "x0_ch_hen_percep");
                SetCreatureEventHandler(oShade, CREATURE_EVENT_RESTED, "x0_ch_hen_rest");
                SetCreatureEventHandler(oShade, CREATURE_EVENT_SPAWN, "x0_ch_hen_spawn");
                SetCreatureEventHandler(oShade, CREATURE_EVENT_SPELLCAST, "x2_hen_spell");
                SetCreatureEventHandler(oShade, CREATURE_EVENT_USERDEF, "x0_ch_hen_usrdef");
                SetConversation(oShade, "pl_shadow_conv");

                SetLocalInt(oShade, "X2_L_BEH_OFFENSE", TRUE);

                object oItem = GetFirstItemInInventory(oShade);
                while(oItem != OBJECT_INVALID){
                    SetPlotFlag(oItem, FALSE);
                    DestroyObject(oItem);
                    oItem = GetNextItemInInventory(oShade);
                }
                int i;
                for(i = 0; i < NUM_INVENTORY_SLOTS; i++){
                    oItem = GetItemInSlot(i, oShade);

                    if(i == INVENTORY_SLOT_ARMS ||
                       i == INVENTORY_SLOT_BELT ||
                       i == INVENTORY_SLOT_BOOTS ||
                       i == INVENTORY_SLOT_LEFTRING ||
                       i == INVENTORY_SLOT_RIGHTRING ||
                       i == INVENTORY_SLOT_NECK)
                    {
                        DestroyObject(oItem);
                        continue;
                    }
                    else if (i == INVENTORY_SLOT_CHEST ||
                             i == INVENTORY_SLOT_CLOAK ||
                             i == INVENTORY_SLOT_HEAD ||
                             (i == INVENTORY_SLOT_LEFTHAND && GetBaseItemType(oItem) == BASE_ITEM_TOWERSHIELD) ||
                             (i == INVENTORY_SLOT_LEFTHAND && GetBaseItemType(oItem) == BASE_ITEM_SMALLSHIELD) ||
                             (i == INVENTORY_SLOT_LEFTHAND && GetBaseItemType(oItem) == BASE_ITEM_LARGESHIELD) ||
                             (i == INVENTORY_SLOT_BULLETS && GetBaseItemType(oItem) == BASE_ITEM_HELMET))
                    {
                        RemoveAllItemProperties(oItem);
                    }

                    SetDroppableFlag(oItem, FALSE);
                    SetPickpocketableFlag(oItem, FALSE);
                    SetItemCursedFlag(oItem, TRUE);
                }
                TakeGoldFromCreature(GetGold(oShade), oShade, TRUE);

                //DelayCommand(TurnsToSeconds(nCasterLevel), )
                SetLocalInt(oShade, "X0_L_MYTIMERTOEXPLODE", 50);
                SetLocalObject(oShade, "X0_L_MYMASTER", oPC);
                SetLocalObject(oPC, "X0_L_MYSHADE", oShade);
                AssignCommand(oShade, SetIsDestroyable(TRUE));

                GSPScaleSummon(nCasterLevel + 10, oShade);

                return;
            }
            else{
                SendMessageToPC(oPC, C_RED+"Apologies, due to a crash bug, shadows for Druids and Shifters are currently disabled."+
                    "We'll try to fix it as soon as possible"+C_END);

                eSummon = EffectSummonCreature("NW_S_VROCK", VFX_FNF_SUMMON_GATE, fDelay);
            }
*/
    }
    else{
        eSummon = EffectSummonCreature("NW_S_VROCK", VFX_FNF_SUMMON_GATE, fDelay);
    }

    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), HoursToSeconds(nDuration));

//    if(bScale)
//        DelayCommand(fDelay + 1.0f, ScaleFiend());
}
