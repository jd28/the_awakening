//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::: Shayan's Subrace Engine :::::::::::::::::::::::::::::
//::::::::::::::::::::::: File Name: sha_spellhooks  :::::::::::::::::::::::::::
//:::::::::::::::::::::::::: Include script ::::::::::::::::::::::::::::::::::::
//:: Written by: Shayan                                                     :://
//:: Contact: mail_shayan@yhaoo.com                                         :://
//
//
// Description: Spell hooking file for Shayan's Subrace Engine.
//              This is an essential optional file. (Meaning you can choose
//              either spell hooking option or modified spell hooks.)
//
//
#include "x2_inc_switches"
#include "x0_i0_spells"
#include "sha_subr_methds"



//::///////////////////////////////////////////////
//:: spellsCure
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Used by the 'cure' series of spells.
    Will do max heal/damage if at normal or low
    difficulty.
    Random rolls occur at higher difficulties.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
void spellsCureSSE(int nDamage, int nMaxExtraDamage, int nMaximized, int vfx_impactHurt, int vfx_impactHeal, int nSpellID);
void spellsCureSSE(int nDamage, int nMaxExtraDamage, int nMaximized, int vfx_impactHurt, int vfx_impactHeal, int nSpellID)
{
    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nHeal;
    int nMetaMagic = GetMetaMagicFeat();
    effect eHeal, eDam;

    int nExtraDamage = GetCasterLevel(OBJECT_SELF); // * figure out the bonus damage
    if (nExtraDamage > nMaxExtraDamage)
    {
        nExtraDamage = nMaxExtraDamage;
    }
    // * if low or normal difficulty is treated as MAXIMIZED
    if(GetIsPC(oTarget) && GetGameDifficulty() < GAME_DIFFICULTY_CORE_RULES)
    {
        nDamage = nMaximized + nExtraDamage;
    }
    else
    {
        nDamage = nDamage + nExtraDamage;
    }


    //Make metamagic checks
    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    {
        nDamage = nMaximized + nExtraDamage;
        // * if low or normal difficulty then MAXMIZED is doubled.
        if(GetIsPC(OBJECT_SELF) && GetGameDifficulty() < GAME_DIFFICULTY_CORE_RULES)
        {
            nDamage = nDamage + nExtraDamage;
        }
    }
    if (nMetaMagic == METAMAGIC_EMPOWER || GetHasFeat(FEAT_HEALING_DOMAIN_POWER))
    {
        nDamage = nDamage + (nDamage/2);
    }

    int nTouch = TouchAttackMelee(oTarget);
    if (nTouch > 0)
    {
        if(Subrace_GetIsUndead(oTarget))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellID));
            if (!MyResistSpell(OBJECT_SELF, oTarget))
            {
                eDam = EffectDamage(nDamage,DAMAGE_TYPE_POSITIVE);
                //Apply the VFX impact and effects
                DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                effect eVis = EffectVisualEffect(vfx_impactHurt);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
     }
}

//::///////////////////////////////////////////////
//:: spellsInflictTouchAttack
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    nDamage: Amount of damage to do
    nMaxExtraDamage: Max amount of +1 per level damage
    nMaximized: Amount of damage to do if maximized
    vfx_impactHurt: Impact to play if hurt by spell
    vfx_impactHeal: Impact to play if healed by spell
    nSpellID: SpellID to broactcast in the signal event
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
void spellsInflictTouchAttackSSE(int nDamage, int nMaxExtraDamage, int nMaximized, int vfx_impactHurt, int vfx_impactHeal, int nSpellID);
void spellsInflictTouchAttackSSE(int nDamage, int nMaxExtraDamage, int nMaximized, int vfx_impactHurt, int vfx_impactHeal, int nSpellID)
{
    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = GetMetaMagicFeat();
    int nTouch = TouchAttackMelee(oTarget);

    int nExtraDamage = GetCasterLevel(OBJECT_SELF); // * figure out the bonus damage
    if (nExtraDamage > nMaxExtraDamage)
    {
        nExtraDamage = nMaxExtraDamage;
    }

        //Check for metamagic
    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    {
        nDamage = nMaximized;
    }
    else
    if (nMetaMagic == METAMAGIC_EMPOWER)
    {
        nDamage = nDamage + (nDamage / 2);
    }


    //Check that the target is undead.
    //Edited For Shayan's Subrace Engine.
    if (Subrace_GetIsUndead(oTarget))
    {
        effect eVis2 = EffectVisualEffect(vfx_impactHeal);
        //Figure out the amount of damage to heal
        //nHeal = nDamage;
        //Set the heal effect
        effect eHeal = EffectHeal(nDamage + nExtraDamage);
        //Apply heal effect and VFX impact
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellID, FALSE));
    }
}



void main()
{
    int nSpell= GetSpellId();
    int nSpellDC= GetSpellSaveDC();
    int nCastLevel= GetCasterLevel(OBJECT_SELF);
    object oTarget = GetSpellTargetObject();
    location lTarget = GetSpellTargetLocation();
    location lLoc;
    effect eVisual;
    effect eBad;
    effect eGood;
    int nHeal;
    effect eHeal;
    int nDamage;
    int nMetaMagic;
    int nTouch;
    effect eVis;
    effect eVis2;
    effect eDam;
    effect eKill;
    int nModify;
    effect eSun;
    effect eHealVis;
    effect eStrike;
    float fDelay;
    int bValid;
    effect eRay;
    effect eVisHeal;
    int IsUndead = Subrace_GetIsUndead(oTarget);

    switch (nSpell)
    {

          case SPELL_NEGATIVE_ENERGY_BURST:
            eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
            eVisHeal = EffectVisualEffect(VFX_IMP_HEALING_M);
            nModify = nCastLevel/4;
            if(nModify == 0)
                {
                nModify = 1;
                }
            eGood = EffectLinkEffects(EffectAbilityIncrease(ABILITY_STRENGTH, nModify), EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
            eBad = EffectLinkEffects(EffectAbilityDecrease(ABILITY_STRENGTH, nModify), EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));


            //Apply the explosion at the location captured above.
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_EVIL_20), lTarget);
            //Declare the spell shape, size and the location.  Capture the first target object in the shape.
            oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget);
            //Cycle through the targets within the spell shape until an invalid object is captured.
            while (GetIsObjectValid(oTarget))
            {
               if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
               {
                    //Roll damage for each target
                    nDamage = d8() + nCastLevel;
                    //Resolve metamagic
                    if (nMetaMagic == METAMAGIC_MAXIMIZE)
                    {
                        nDamage = 8 + nCastLevel;
                    }
                        else if (nMetaMagic == METAMAGIC_EMPOWER)
                    {
                       nDamage = nDamage + (nDamage / 2);
                    }
                    if(MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NEGATIVE, OBJECT_SELF, fDelay))
                    {
                        nDamage /= 2;
                    }
                    //Get the distance between the explosion and the target to calculate delay
                    fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;

                    // * any undead should be healed, not just Friendlies

        //-------------------------------------------------------------Shayan's Subrace Engine code
                    if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD || Subrace_GetIsUndead(oTarget))
                    {
                        //Fire cast spell at event for the specified target
                        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NEGATIVE_ENERGY_BURST, FALSE));
                        //Set the heal effect
                        eHeal = EffectHeal(nDamage);
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget));
                        //This visual effect is applied to the target object not the location as above.  This visual effect
                        //represents the flame that erupts on the target not on the ground.
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisHeal, oTarget));
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eGood, oTarget));
                    }
                    else if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
                    {
                        if(GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
                        {
                            if(!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
                            {
                                //Fire cast spell at event for the specified target
                                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NEGATIVE_ENERGY_BURST));
                                //Set the damage effect
                                eDam = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
                                // Apply effects to the currently selected target.
                                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                                //This visual effect is applied to the target object not the location as above.  This visual effect
                                //represents the flame that erupts on the target not on the ground.
                                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBad, oTarget));
                            }
                        }
                    }
                }

               //Select the next target within the spell shape.
               oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget);
            }
          SetModuleOverrideSpellScriptFinished();
          break;


          case SPELL_MASS_HEAL:
              eVis = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
              eVis2 = EffectVisualEffect(VFX_IMP_HEALING_G);
              eStrike = EffectVisualEffect(VFX_FNF_LOS_HOLY_10);
              //Apply VFX area impact
              ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eStrike, lTarget);
              //Get first target in spell area
              oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget);
              while(GetIsObjectValid(oTarget))
              {
                  fDelay = GetRandomDelay();
                  if ((IsUndead || GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD) && !GetIsReactionTypeFriendly(oTarget))
                  {
                        //Fire cast spell at event for the specified target
                        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MASS_HEAL));
                        //Make a touch attack
                        nTouch = TouchAttackRanged(oTarget);
                        if (nTouch > 0)
                        {
                            if(!GetIsReactionTypeFriendly(oTarget) || Subrace_GetIsUndead(oTarget))
                            {
                                //Make an SR check
                                if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
                                {
                                    //Roll damage
                                    nModify = d4();
                                    //make metamagic check
                                    if (nMetaMagic == METAMAGIC_MAXIMIZE)
                                    {
                                        nModify = 1;
                                    }
                                    //Detemine the damage to inflict to the undead
                                    nDamage =  GetCurrentHitPoints(oTarget) - nModify;
                                    //Set the damage effect
                                    eKill = EffectDamage(nDamage, DAMAGE_TYPE_POSITIVE);
                                    //Apply the VFX impact and damage effect
                                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eKill, oTarget));
                                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                                }
                             }
                        }
                  }
                  else
                  {
                        //Make a faction check
                        if(GetIsFriend(oTarget) && (GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD && !Subrace_GetIsUndead(oTarget)))
                        {
                            //Fire cast spell at event for the specified target
                            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MASS_HEAL, FALSE));
                            //Determine amount to heal
                            nHeal = GetMaxHitPoints(oTarget);
                            //Set the damage effect
                            eHeal = EffectHeal(nHeal);
                            //Apply the VFX impact and heal effect
                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget));
                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
                        }
                  }
                  //Get next target in the spell area
                  oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget);
              }
          SetModuleOverrideSpellScriptFinished();
          break;


          case SPELL_HEALING_CIRCLE:
            eVis = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
            eVis2 = EffectVisualEffect(VFX_IMP_HEALING_M);
            if(nCastLevel > 20)
                {
                nCastLevel = 20;
                }
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_HOLY_20), lTarget);
            //Get first target in shape
            oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget);
            while (GetIsObjectValid(oTarget))
            {
                fDelay = GetRandomDelay();
                //Check if racial type is undead
                if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD || Subrace_GetIsUndead(oTarget))
                {
                    if(!GetIsReactionTypeFriendly(oTarget))
                    {
                        //Fire cast spell at event for the specified target
                        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HEALING_CIRCLE));
                        //Make SR check
                        if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
                        {
                            nModify = d8() + nCastLevel;
                            //Make metamagic check
                            if (nMetaMagic == METAMAGIC_MAXIMIZE)
                            {
                                nModify = 8 + nCastLevel;
                            }
                            if (nMetaMagic == METAMAGIC_EMPOWER)
                            {
                                nModify = (3*nModify)/2; //Damage/Healing is +50%
                            }

                            //Make Fort save
                            if (MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
                            {
                                nModify /= 2;
                            }
                            //Set damage effect
                            eKill = EffectDamage(nModify, DAMAGE_TYPE_POSITIVE);
                            //Apply damage effect and VFX impact
                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eKill, oTarget));
                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                        }
                    }
                }
                else
                {
                    // * May 2003: Heal Neutrals as well
                    if(!GetIsReactionTypeHostile(oTarget) || GetFactionEqual(oTarget))
                    {
                        //Fire cast spell at event for the specified target
                        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HEALING_CIRCLE, FALSE));
                        nHeal = d8();
                        //Enter Metamagic conditions
                        if (nMetaMagic == METAMAGIC_MAXIMIZE)
                        {
                            nHeal = 8;//Damage is at max
                        }
                        //Set healing effect
                        nHeal = nHeal + nCastLevel;
                        if (nMetaMagic == METAMAGIC_EMPOWER)
                        {
                            nHeal = (3*nHeal)/2; //Damage/Healing is +50%
                        }
                        eHeal = EffectHeal(nHeal);
                        //Apply heal effect and VFX impact
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget));
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
                    }
                }
                //Get next target in the shape
                oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget);

            }
            SetModuleOverrideSpellScriptFinished();
            break;

          case SPELL_CURE_CRITICAL_WOUNDS:
               if(IsUndead)
               {
                  spellsCure(d8(4), 20, 32, VFX_IMP_SUNSTRIKE, VFX_IMP_HEALING_G, GetSpellId());
                  SetModuleOverrideSpellScriptFinished();
               }
               break;


          case SPELL_CURE_LIGHT_WOUNDS:
               if(IsUndead)
               {
                   spellsCure(d8(), 5, 8, VFX_IMP_SUNSTRIKE, VFX_IMP_HEALING_S, GetSpellId());
                   SetModuleOverrideSpellScriptFinished();
               }
               break;


          case SPELL_CURE_MINOR_WOUNDS:
               if(IsUndead)
               {
                   spellsCure(4, 0, 4, VFX_IMP_SUNSTRIKE, VFX_IMP_HEAD_HEAL, GetSpellId());
                   SetModuleOverrideSpellScriptFinished();
               }
               break;


         case SPELL_CURE_MODERATE_WOUNDS:
               if(IsUndead)
               {
                   spellsCure(d8(2), 10, 16, VFX_IMP_SUNSTRIKE, VFX_IMP_HEALING_M, GetSpellId());
                   SetModuleOverrideSpellScriptFinished();
               }
               break;


         case SPELL_CURE_SERIOUS_WOUNDS:
               if(IsUndead)
               {
                   spellsCure(d8(3), 15, 24, VFX_IMP_SUNSTRIKE, VFX_IMP_HEALING_L, GetSpellId());
                   SetModuleOverrideSpellScriptFinished();
               }
               break;


         case SPELL_GREATER_RESTORATION:

                eVisual = EffectVisualEffect(VFX_IMP_RESTORATION_GREATER);
                eBad = GetFirstEffect(oTarget);
                //Search for negative effects
                while(GetIsEffectValid(eBad))
                {
                    if (GetEffectType(eBad) == EFFECT_TYPE_ABILITY_DECREASE ||
                        GetEffectType(eBad) == EFFECT_TYPE_AC_DECREASE ||
                        GetEffectType(eBad) == EFFECT_TYPE_ATTACK_DECREASE ||
                        GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_DECREASE ||
                        GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ||
                        GetEffectType(eBad) == EFFECT_TYPE_SAVING_THROW_DECREASE ||
                        GetEffectType(eBad) == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
                        GetEffectType(eBad) == EFFECT_TYPE_SKILL_DECREASE ||
                        GetEffectType(eBad) == EFFECT_TYPE_BLINDNESS ||
                        GetEffectType(eBad) == EFFECT_TYPE_DEAF ||
                        GetEffectType(eBad) == EFFECT_TYPE_CURSE ||
                        GetEffectType(eBad) == EFFECT_TYPE_DISEASE ||
                        GetEffectType(eBad) == EFFECT_TYPE_POISON ||
                        GetEffectType(eBad) == EFFECT_TYPE_PARALYZE ||
                        GetEffectType(eBad) == EFFECT_TYPE_CHARMED ||
                        GetEffectType(eBad) == EFFECT_TYPE_DOMINATED ||
                        GetEffectType(eBad) == EFFECT_TYPE_DAZED ||
                        GetEffectType(eBad) == EFFECT_TYPE_CONFUSED ||
                        GetEffectType(eBad) == EFFECT_TYPE_FRIGHTENED ||
                        GetEffectType(eBad) == EFFECT_TYPE_NEGATIVELEVEL ||
                        GetEffectType(eBad) == EFFECT_TYPE_PARALYZE ||
                        GetEffectType(eBad) == EFFECT_TYPE_SLOW ||
                        GetEffectType(eBad) == EFFECT_TYPE_STUNNED)
                        {
                            //Remove effect if it is not subracial effect
                            if(GetEffectSubType(eBad) == SUBTYPE_SUPERNATURAL)
                            {
                                if(GetEffectCreator(eBad) != oTarget)
                                {
                                    RemoveEffect(oTarget, eBad);
                                }
                            }
                            else
                            {
                               RemoveEffect(oTarget, eBad);
                            }
                        }
                    eBad = GetNextEffect(oTarget);
                }
                if(GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
                {
                    //Apply the VFX impact and effects
                    nHeal = GetMaxHitPoints(oTarget) - GetCurrentHitPoints(oTarget);
                    eHeal = EffectHeal(nHeal);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
                }
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_GREATER_RESTORATION, FALSE));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget);
                SetModuleOverrideSpellScriptFinished();
                break;


          case SPELL_HARM:
                nMetaMagic = GetMetaMagicFeat();
                nTouch = TouchAttackMelee(oTarget);
                eVis = EffectVisualEffect(246);
                eVis2 = EffectVisualEffect(VFX_IMP_HEALING_G);
                //Check that the target is undead
                if (IsUndead)
                {
                    //Figure out the amount of damage to heal
                    nHeal = GetMaxHitPoints(oTarget) - GetCurrentHitPoints(oTarget);
                    //Set the heal effect
                    eHeal = EffectHeal(nHeal);
                    //Apply heal effect and VFX impact
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
                    //Fire cast spell at event for the specified target
                    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HARM, FALSE));
                    SetModuleOverrideSpellScriptFinished();
                }
                break;


          case SPELL_HEAL:
              eSun = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
              eHealVis = EffectVisualEffect(VFX_IMP_HEALING_X);
              //Check to see if the target is an undead
              if (IsUndead)
              {
                  if(!GetIsReactionTypeFriendly(oTarget) || IsUndead)
                  {
                    //Fire cast spell at event for the specified target
                    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HEAL));
                    //Make a touch attack
                    if (TouchAttackMelee(oTarget))
                    {
                        //Make SR check
                        if (!MyResistSpell(OBJECT_SELF, oTarget))
                        {
                            //Roll damage
                            nModify = d4();
                            nMetaMagic = GetMetaMagicFeat();
                            //Make metamagic check
                            if (nMetaMagic == METAMAGIC_MAXIMIZE)
                            {
                                nModify = 1;
                            }
                            //Figure out the amount of damage to inflict
                            nDamage =  GetCurrentHitPoints(oTarget) - nModify;
                            //Set damage
                            eKill = EffectDamage(nDamage, DAMAGE_TYPE_POSITIVE);
                            //Apply damage effect and VFX impact
                            ApplyEffectToObject(DURATION_TYPE_INSTANT, eKill, oTarget);
                            ApplyEffectToObject(DURATION_TYPE_INSTANT, eSun, oTarget);
                        }
                    }
                 }
                 SetModuleOverrideSpellScriptFinished();
              }
              break;




          case SPELL_INFLICT_MINOR_WOUNDS:
               if(IsUndead)
               {
                    spellsInflictTouchAttack(1, 0, 1, 246, VFX_IMP_HEALING_G, nSpell);
                    SetModuleOverrideSpellScriptFinished();
               }
               break;


          case SPELL_INFLICT_LIGHT_WOUNDS:
               if(IsUndead)
               {
                    spellsInflictTouchAttack(d8(), 5, 8, 246, VFX_IMP_HEALING_G, nSpell);
                    SetModuleOverrideSpellScriptFinished();
               }
               break;


          case SPELL_INFLICT_MODERATE_WOUNDS:
               if(IsUndead)
               {
                    spellsInflictTouchAttack(d8(2), 10, 16, 246, VFX_IMP_HEALING_G, nSpell);
                    SetModuleOverrideSpellScriptFinished();
               }
               break;



          case SPELL_INFLICT_SERIOUS_WOUNDS:
               if(IsUndead)
               {
                    spellsInflictTouchAttack(d8(3), 15, 24, 246, VFX_IMP_HEALING_G, nSpell);
                    SetModuleOverrideSpellScriptFinished();
               }
               break;




          case SPELL_INFLICT_CRITICAL_WOUNDS:
               if(IsUndead)
               {
                    spellsInflictTouchAttack(d8(4), 20, 32, 246, VFX_IMP_HEALING_G, nSpell);
                    SetModuleOverrideSpellScriptFinished();
               }
               break;




          case SPELL_LESSER_RESTORATION:
                eVisual = EffectVisualEffect(VFX_IMP_RESTORATION_LESSER);
                eBad = GetFirstEffect(oTarget);
                //Search for negative effects
                while(GetIsEffectValid(eBad))
                {
                    if (GetEffectType(eBad) == EFFECT_TYPE_ABILITY_DECREASE ||
                        GetEffectType(eBad) == EFFECT_TYPE_AC_DECREASE ||
                        GetEffectType(eBad) == EFFECT_TYPE_ATTACK_DECREASE ||
                        GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_DECREASE ||
                        GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ||
                        GetEffectType(eBad) == EFFECT_TYPE_SAVING_THROW_DECREASE ||
                        GetEffectType(eBad) == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
                        GetEffectType(eBad) == EFFECT_TYPE_SKILL_DECREASE)
                    {

                        //Remove effect if it is not subracial effect
                            if(GetEffectSubType(eBad) == SUBTYPE_SUPERNATURAL)
                            {
                                if(GetEffectCreator(eBad) != oTarget)
                                {
                                    RemoveEffect(oTarget, eBad);
                                }
                            }
                            else
                            {
                               RemoveEffect(oTarget, eBad);
                            }
                    }
                    eBad = GetNextEffect(oTarget);
                }
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_LESSER_RESTORATION, FALSE));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget);
                SetModuleOverrideSpellScriptFinished();
                break;


          case SPELL_LIGHT:
               if(GetIsPCLightSensitive(oTarget))
               {
                  if(FortitudeSave(oTarget, LIGHT_SENSITIVE_SAVING_THROW_DC) == 0)
                  {
                       ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBlindness(), oTarget, RoundsToSeconds(LIGHT_STRUCK_BLIND_FOR_ROUNDS));
                  }
               }
               break;


          case SPELL_NEGATIVE_ENERGY_RAY:
               //---- Shayan's Subrace Engine code
               if(IsUndead)
               {
                    nMetaMagic = GetMetaMagicFeat();
                    if(nCastLevel > 9)
                    {
                        nCastLevel = 9;
                    }
                    nCastLevel = (nCastLevel + 1) / 2;
                    nDamage = d6(nCastLevel);

                    //Enter Metamagic conditions
                    if (nMetaMagic == METAMAGIC_MAXIMIZE)
                    {
                        nDamage = 6 * nCastLevel;//Damage is at max
                    }
                    else if (nMetaMagic == METAMAGIC_EMPOWER)
                    {
                        nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
                    }
                    eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
                    eHeal = EffectHeal(nDamage);
                    eVisHeal = EffectVisualEffect(VFX_IMP_HEALING_M);
                    //Fire cast spell at event for the specified target
                    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NEGATIVE_ENERGY_RAY, FALSE));
                    eRay = EffectBeam(VFX_BEAM_EVIL, OBJECT_SELF, BODY_NODE_HAND);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisHeal, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7);
                    SetModuleOverrideSpellScriptFinished();
               }
               break;


          case SPELL_RAISE_DEAD:
                DelayCommand(2.0, ReapplySubraceAbilities(oTarget));
                break;



         case SPELL_RESTORATION:
                   //Declare major variables
                    eVisual = EffectVisualEffect(VFX_IMP_RESTORATION);
                    eBad = GetFirstEffect(oTarget);
                    //Search for negative effects
                    while(GetIsEffectValid(eBad))
                    {
                        if (GetEffectType(eBad) == EFFECT_TYPE_ABILITY_DECREASE ||
                            GetEffectType(eBad) == EFFECT_TYPE_AC_DECREASE ||
                            GetEffectType(eBad) == EFFECT_TYPE_ATTACK_DECREASE ||
                            GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_DECREASE ||
                            GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ||
                            GetEffectType(eBad) == EFFECT_TYPE_SAVING_THROW_DECREASE ||
                            GetEffectType(eBad) == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
                            GetEffectType(eBad) == EFFECT_TYPE_SKILL_DECREASE ||
                            GetEffectType(eBad) == EFFECT_TYPE_BLINDNESS ||
                            GetEffectType(eBad) == EFFECT_TYPE_DEAF ||
                            GetEffectType(eBad) == EFFECT_TYPE_PARALYZE ||
                            GetEffectType(eBad) == EFFECT_TYPE_NEGATIVELEVEL)
                            {

                    //Remove effect if it is not subracial effect
                                if(GetEffectSubType(eBad) == SUBTYPE_SUPERNATURAL)
                                {
                                    if(GetEffectCreator(eBad) != oTarget)
                                    {
                                        RemoveEffect(oTarget, eBad);
                                    }
                                }
                                else
                                {
                                   RemoveEffect(oTarget, eBad);
                                }
                            }
                //---------------->End Modification by Shayan.
                        eBad = GetNextEffect(oTarget);
                    }
                    //Fire cast spell at event for the specified target
                    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RESTORATION, FALSE));
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget);
                    SetModuleOverrideSpellScriptFinished();



          case SPELL_RESURRECTION:
                DelayCommand(2.0, ReapplySubraceAbilities(oTarget));
                break;



          case SPELLABILITY_BG_INFLICT_SERIOUS_WOUNDS:
               if(IsUndead)
               {
                    spellsInflictTouchAttack(d8(3), 15, 24, 246, VFX_IMP_HEALING_G, nSpell);
                    SetModuleOverrideSpellScriptFinished();
               }
               break;


          case SPELLABILITY_BG_INFLICT_CRITICAL_WOUNDS:
               if(IsUndead)
               {
                    spellsInflictTouchAttack(d8(4), 20, 32, 246, VFX_IMP_HEALING_G, nSpell);
                    SetModuleOverrideSpellScriptFinished();
               }
               break;

    }
}
