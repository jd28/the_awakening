//::///////////////////////////////////////////////
//:: Combat Dummy
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////

#include "mod_funcs_inc"
#include "pc_funcs_inc"
#include "nwnx_redis"

void DummyMain(object oPC, object oDummy){


/*
  // initial user interaction, starts training session
  if( !GetLocalInt(oDummy,"PLC_INTERACT_INUSE") )
  {
    //DelayCommand(5.0,CombatDummyReport(oPC, oDummy));
    // set target PC
    SetLocalObject(oDummy,"PLC_INTERACT_USER",oPC);
    // set InUse flag
    SetLocalInt(oDummy,"PLC_INTERACT_INUSE",TRUE);
    // set strength of dummy based on player level
    SetLocalInt(oDummy,"PLC_INTERACT_SESSIONHP", ((GetLevelByPosition(1,oPC) + GetLevelByPosition(2,oPC) + GetLevelByPosition(3,oPC)) * PLC_DUMMY_HP_MODIFIER ) + PLC_DUMMY_HP_MODIFIER );
    // initiate "check for session abort/cancel"
    // this function polls every 5 sec and checks if the player is still
    // fighting with the dummy. if not, session gets aborted
    // and dummy gets re-created. this deletes all variables and resets
    // everything to clean state.
    // this "pseudo heartbeat" only runs during PC<>dummy interaction
    // and is very small
    DelayCommand(5.0,DummyCheckSession(oDummy));
    FloatingTextStringOnCreature("Session Started - Dummy Strength: "+IntToString(GetLocalInt(oDummy,"PLC_INTERACT_SESSIONHP")),oPC);
  }

  object oUser = GetLocalObject(oDummy,"PLC_INTERACT_USER");
  if(oUser == oPC)
  {
    int nSessionHP = GetLocalInt(oDummy,"PLC_INTERACT_SESSIONHP");
    int nTotalDamage = GetMaxHitPoints() - GetCurrentHitPoints();
    int nHitCount;
    int nLastTotalDamage = GetLocalInt(oDummy,"PLC_INTERACT_LASTHP");
    nHitCount = GetLocalInt(oDummy,"PLC_INTERACT_HITCOUNT");

    // register hit
    if(nTotalDamage > nLastTotalDamage)
    {
      SetLocalInt(oDummy,"PLC_INTERACT_LASTHP", nTotalDamage);
      nHitCount++;
      SetLocalInt(oDummy,"PLC_INTERACT_HITCOUNT", nHitCount);
    }

    // apply some effects based on damage
    int nDamage = nTotalDamage - nLastTotalDamage;
    if (nDamage > 24) ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(75), OBJECT_SELF);
    if (nDamage > 12) ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(281), OBJECT_SELF);
    if (nDamage > 6)  ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(112), OBJECT_SELF);
    if (nDamage > 3)  ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(236 + d3()), OBJECT_SELF);
    FloatingTextStringOnCreature("Total Damage: " +IntToString(nTotalDamage)+ " Hits: "+IntToString(nHitCount),oPC);

    if(nTotalDamage > nSessionHP) // session done - dummy HP depleted
    {
      FloatingTextStringOnCreature("You have finished your training session",oPC);
      // report final statistic
      AssignCommand(GetModule(),DelayCommand(4.0,FloatingTextStringOnCreature("You inflicted "+IntToString(nTotalDamage)+ " damage to the dummy with "+IntToString(nHitCount)+" hits",oPC)));
      AssignCommand(GetModule(),DelayCommand(6.0,FloatingTextStringOnCreature("Your average damage is " + IntToString(nTotalDamage/nHitCount)+" per attack",oPC)));
      // award xp only if permitted
          if(GetLocalInt(oPC,"PLC_INTERACT_COMBATDUMMY_NOXP"))
            AssignCommand(GetModule(),DelayCommand(8.0,FloatingTextStringOnCreature("No XP reward ! You trained too recently...",oPC)));
          else
          {
            // award xp and report it to the user
            AssignCommand(GetModule(),DelayCommand(8.0,FloatingTextStringOnCreature("You earned " + IntToString( FloatToInt( IntToFloat(nSessionHP) * PLC_DUMMY_XP_MODIFIER ) ) + " xp for your training",oPC)));
            AssignCommand(GetModule(),DelayCommand(9.0,GiveXPToCreature(oPC,FloatToInt( IntToFloat(nSessionHP)* PLC_DUMMY_XP_MODIFIER ) ) ) );
            // set no-xp flag
            SetLocalInt(oPC,"PLC_INTERACT_COMBATDUMMY_NOXP",TRUE);
            // set deletion timer for no-xp flag
            AssignCommand(GetModule(),DelayCommand(PLC_DUMMY_XP_TIMER,DeleteLocalInt(oPC,"PLC_INTERACT_COMBATDUMMY_NOXP")));
          }
      // destroy & re-create dummy
      string sResRef = GetResRef(oDummy); location lLoc = GetLocation(oDummy);
      AssignCommand(GetModule(),DelayCommand(0.1,DummyRespawn(sResRef,lLoc)));;
      DestroyObject(oDummy);
    }
  }
  else
    SendMessageToPC(oPC,"Dummy is currently busy...");

    */
}

void DummyEndSession(object oDummy = OBJECT_SELF){
    object oLeader = GetNearestObjectByTag("pl_strongman_leadboard");
    object oPC = GetLocalObject(oDummy,"PLC_INTERACT_USER");
    int nHitCount = GetLocalInt(oDummy,"PLC_INTERACT_HITCOUNT");
    int nTotalDamage = GetLocalInt(oDummy, "PLC_INTERACT_TOTAL");
    int nHighest = GetLocalInt(oDummy, "PLC_INTERACT_HIGHEST");
    int nAvgDamage = nTotalDamage / nHitCount, bGood;

    string sMessage, sPlayer;
    sMessage = "Total Damage: " + IntToString(nTotalDamage) + "\n";
    sMessage += "Hits: " + IntToString(nHitCount) + "\n";
    if(nHitCount > 0)
        sMessage += "Average Damage per Hit: " + IntToString(nAvgDamage) + "\n";
    sMessage += "Hardest Hit: " + IntToString(nHighest);
    sPlayer = GetName(oPC)+ " ("+GetPCPlayerName(oPC)+")";



    // Check Leader Board
    if(nHitCount > GetLocalInt(oLeader, "PLC_INTERACT_HITCOUNT")){
        SetLocalInt(oLeader, "PLC_INTERACT_HITCOUNT", nHitCount);
        SetLocalString(oLeader, "PLC_INTERACT_HITCOUNT", sPlayer);
        bGood = TRUE;
    }
    if(nTotalDamage > GetLocalInt(oLeader, "PLC_INTERACT_TOTAL")){
        SetLocalInt(oLeader, "PLC_INTERACT_TOTAL", nTotalDamage);
        SetLocalString(oLeader, "PLC_INTERACT_TOTAL", sPlayer);
        bGood = TRUE;
    }
    if(nHighest > GetLocalInt(oLeader, "PLC_INTERACT_HIGHEST")){
        SetLocalInt(oLeader, "PLC_INTERACT_HIGHEST", nHighest);
        SetLocalString(oLeader, "PLC_INTERACT_HIGHEST", sPlayer);
        bGood = TRUE;
    }
    if(nAvgDamage > GetLocalInt(oLeader, "PLC_INTERACT_AVERAGE")){
        SetLocalInt(oLeader, "PLC_INTERACT_AVERAGE", nAvgDamage);
        SetLocalString(oLeader, "PLC_INTERACT_AVERAGE", sPlayer);
        bGood = TRUE;
    }

    struct SubString ssAllTime = GetFirstSubString(GET("faire:leaderboard:hits"));
    if(nHitCount > StringToInt(ssAllTime.first)){
        SET("faire:leaderboard:hits", IntToString(nHitCount)+ " by " + sPlayer);
        bGood = TRUE;
    }
    ssAllTime = GetFirstSubString(GET("faire:leaderboard:total"));
    if(nTotalDamage > StringToInt(ssAllTime.first)){
        SET("faire:leaderboard:total", IntToString(nTotalDamage)+ " by " + sPlayer);
        bGood = TRUE;
    }
    ssAllTime = GetFirstSubString(GET("faire:leaderboard:highest"));
    if(nHighest > StringToInt(ssAllTime.first)){
        SET("faire:leaderboard:highest", IntToString(nHighest)+ " by " + sPlayer);
        bGood = TRUE;
    }
    ssAllTime = GetFirstSubString(GET("faire:leaderboard:avg"));
    if(nAvgDamage > StringToInt(ssAllTime.first)){
        SET("faire:leaderboard:avg", IntToString(nAvgDamage)+ " by " + sPlayer);
        bGood = TRUE;
    }
    object oStrongMan = GetNearestObjectByTag("pl_strongman");
    if(bGood){
        switch(d4()){
            case 1: AssignCommand(oStrongMan, SpeakString("You is strong!!")); break;
            case 2: AssignCommand(oStrongMan, SpeakString("Impressive!!")); break;
            case 3: AssignCommand(oStrongMan, SpeakString("Nice job!!")); break;
            case 4: AssignCommand(oStrongMan, SpeakString("Very Good!!")); break;
        }
    }
    else{
        switch(d4()){
            case 1: AssignCommand(oStrongMan, SpeakString("You is weak!!")); break;
            case 2: AssignCommand(oStrongMan, SpeakString("Girlie man!!")); break;
            case 3: AssignCommand(oStrongMan, SpeakString("You hit like woman!!")); break;
            case 4: AssignCommand(oStrongMan, SpeakString("You need exercise!")); break;
        }
    }

    // Respawn Dummy
    string sResRef = GetResRef(oDummy);
    location lLoc = GetLocation(oDummy);
    AssignCommand(GetModule(), ObjectToVoid(CreateObject(OBJECT_TYPE_PLACEABLE, sResRef, lLoc)));
    DestroyObject(oDummy);

    AssignCommand(GetModule(),DelayCommand(4.0,FloatingTextStringOnCreature(sMessage, oPC)));
}

void main(){
    object oPC = GetLastDamager(), oDummy = OBJECT_SELF;
    int nHitCount = GetLocalInt(oDummy,"PLC_INTERACT_HITCOUNT");
    int nTotalDamage = GetLocalInt(oDummy, "PLC_INTERACT_TOTAL");
    int nHighest = GetLocalInt(oDummy, "PLC_INTERACT_HIGHEST");
    int nDamage, nDamType = 1, i, nTemp;

    if(oPC == OBJECT_INVALID) return;

    if( !GetLocalInt(oDummy,"PLC_INTERACT_INUSE")){
        SetLocalObject(oDummy,"PLC_INTERACT_USER",oPC);
        // set InUse flag
        SetLocalInt(oDummy,"PLC_INTERACT_INUSE",TRUE);

        // set strength of dummy based on player level
        //SetLocalInt(oDummy,"PLC_INTERACT_SESSIONHP", (GetJ * PLC_DUMMY_HP_MODIFIER ) + PLC_DUMMY_HP_MODIFIER );
        // initiate "check for session abort/cancel"
        // this function polls every 5 sec and checks if the player is still
        // fighting with the dummy. if not, session gets aborted
        // and dummy gets re-created. this deletes all variables and resets
        // everything to clean state.
        // this "pseudo heartbeat" only runs during PC<>dummy interaction
        // and is very small
        //DelayCommand(5.0,DummyCheckSession(oDummy));
        FloatingTextStringOnCreature("Session Started - Time: 10 Seconds", oPC);
        DelayCommand(6.0f, DummyEndSession());
    }
    if(GetLocalObject(oDummy,"PLC_INTERACT_USER") != oPC){
        SendPCMessage(oPC, C_RED+"The combat dummy is currently being used!"+C_END);
        return;
    }

    for(i = 0; i < 13; i++){
        nTemp = GetDamageDealtByType(nDamType);
        if(nTemp > 0) nDamage += nTemp;
        nDamType = nDamType << 1;
    }

    if (nDamage > 24) ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(75), OBJECT_SELF);
    if (nDamage > 12) ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(281), OBJECT_SELF);
    if (nDamage > 6)  ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(112), OBJECT_SELF);
    if (nDamage > 3)  ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(236 + d3()), OBJECT_SELF);

    // Update total damage.
    nTotalDamage += nDamage;
    SetLocalInt(oDummy, "PLC_INTERACT_TOTAL", nTotalDamage);
    // Update hit count
    nHitCount++;
    SetLocalInt(oDummy,"PLC_INTERACT_HITCOUNT", nHitCount);
    // Update hardest hit
    if(nDamage > nHighest)
        SetLocalInt(oDummy, "PLC_INTERACT_HIGHEST", nDamage);

    FloatingTextStringOnCreature("Total Damage: " +IntToString(nTotalDamage)+ " Hits: "+IntToString(nHitCount), oPC);
}
