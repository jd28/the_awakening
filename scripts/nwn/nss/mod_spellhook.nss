#include "x2_inc_switches"
//#include "spell_funcs_inc"
#include "mod_const_inc"
#include "info_inc"

void AddSpellToBuffitisRock();

void main(){

    //Declare Major Variables;
    object oCaster = OBJECT_SELF;
    object oArea = GetArea(oCaster);
    object oTarget = GetSpellTargetObject();
    object oItem = GetSpellCastItem();
    int nSpell = GetSpellId();
    int nCastLevel = GetCasterLevel(OBJECT_SELF);
    int zInt;
    location sLocation = GetSpellTargetLocation();
    int sClass = GetLastSpellCastClass();

    // Only Spellhook for Players... TODO: Make sure DMs can still cast.
    if(!GetIsPC(oCaster)) return;

    if("pl_buffitisrock" == GetTag(oTarget)){
        AddSpellToBuffitisRock();
        SetModuleOverrideSpellScriptFinished();
    }

    // If it is a No Magic area, no spells will be cast, even itemed spells.
    // TODO: Limit this to hostile spells.
    if(GetTag(oArea) == "pl_cbfaire_001"){
        SendMessageToPC(oCaster, C_RED+"Casting is not permitted in this area."+C_END);
        SetModuleOverrideSpellScriptFinished();
    }

    //Itemed Spells... i.e. An spell is cast from an item.
    if(GetIsObjectValid(oItem)){
        switch (nSpell){
            case SPELL_DIVINE_POWER:
                if(GetTag(oItem) == "harper_potion" && GetLevelByClass(CLASS_TYPE_HARPER, oCaster) < 20){
                    SetModuleOverrideSpellScriptFinished();
                }
            break;
            case SPELL_SHADOW_SHIELD:
                if(GetTag(oItem) == "harper_potion" && GetLevelByClass(CLASS_TYPE_HARPER, oCaster) < 30){
                    SetModuleOverrideSpellScriptFinished();
                }
            break;
            //SPELLS HERE
        } // switch (nSpell)

    } // if(GetIsObjectValid(GetSpellCastItem()))

    // Individual spells
    switch(nSpell){
        case SPELL_TIME_STOP:
            if(GetLocalInt(oArea, VAR_AREA_NO_TIMESTOP))
                SetModuleOverrideSpellScriptFinished();
        break;
        case SPELL_SANCTUARY:
        case SPELL_ETHEREALNESS:
            if(GetIsObjectValid(oItem) &&
               (GetBaseItemType(oItem) == BASE_ITEM_SCROLL ||
                GetBaseItemType(oItem) == BASE_ITEM_SPELLSCROLL ||
                GetBaseItemType(oItem) == BASE_ITEM_ENCHANTED_SCROLL)){
                FloatingTextStringOnCreature(C_RED + "Greater Sanctuary cannot be cast from a scroll." + C_END, oCaster, FALSE);
                SetModuleOverrideSpellScriptFinished();
            }
            else if(GetLocalInt(oArea, "area_no_sanctuary")){
                FloatingTextStringOnCreature(C_RED + "Sanctuary spels cannot be used in this area." + C_END, oCaster, FALSE);
                SetModuleOverrideSpellScriptFinished();
            }
        break;
        default:
        //Code goes here
        break;
    } // switch(nSpell)
} // void main()

void AddSpellToBuffitisRock(){
    object oPC = OBJECT_SELF;                 // The player who cast the spell
    object oTarget = GetSpellTargetObject();  // The item targeted by the spell
    int iSpell = GetSpellId();             // The id of the spell that was cast
                                       // See the list of SPELL_* constants
    int nMeta = GetMetaMagicFeat(), nHostile, nNumberOfTriggers;
    // Spell Caster must posses the item
    int bHasItem = FALSE;
    object oStorage = GetFirstItemInInventory(oPC);
    while(GetIsObjectValid(oStorage)){
        if(oStorage == oTarget) bHasItem = TRUE;

        oStorage = GetNextItemInInventory();
    }

    if(bHasItem){
        // Item Spells are not allowed
        if (!GetIsObjectValid(GetSpellCastItem())){
            // Check if the spell is marked as hostile in spells.2da
            nHostile = StringToInt(Get2DAString("spells", "HostileSetting", GetSpellId()));
            if(!nHostile){
                nNumberOfTriggers = GetLocalInt(oTarget, VAR_BUFF_ROCK_NUM_SPELLS);
                // is there still space left on the sequencer?
                if (nNumberOfTriggers < BUFF_ROCK_MAX_SPELLS){
                    // success visual and store spell-id on item.
                    effect eVisual = EffectVisualEffect(VFX_IMP_BREACH);
                    nNumberOfTriggers++;
                    //NOTE: I add +1 to the SpellId to spell 0 can be used to trap failure
                    int nSID = GetSpellId()+1;

                    SetLocalInt(oTarget, VAR_BUFF_ROCK_SPELL + IntToString(nNumberOfTriggers), nSID);
                    SetLocalInt(oTarget, VAR_BUFF_ROCK_META + IntToString(nNumberOfTriggers), nMeta);
                    SetLocalInt(oTarget, VAR_BUFF_ROCK_NUM_SPELLS, nNumberOfTriggers);

                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, OBJECT_SELF);
                    string sMessage = C_LT_PURPLE + GetSpellName(nSID-1);
                    if(nMeta > 0){
                        sMessage += " (" + GetMetaMagicName(nMeta) + ")";
                    }
                    FloatingTextStringOnCreature(sMessage + " stored!", oPC, FALSE);
                }
                else FloatingTextStringOnCreature(C_RED+"Hostile Spells are not allowed"+C_END, oPC, FALSE);
            }
            else FloatingTextStringOnCreature(C_RED+"Your Buffitis Rock is full."+C_END, oPC, FALSE);
        }
        else  FloatingTextStringOnCreature(C_RED+"Item spells not allowed"+C_END, oPC, FALSE);
    }
    else FloatingTextStringOnCreature(C_RED+"You may only cast spells on your own Buffitis Rocks"+C_END, oPC, FALSE);
}
