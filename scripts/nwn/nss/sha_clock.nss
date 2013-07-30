//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::: Shayan's Subrace Engine :::::::::::::::::::::::::::::
//::::::::::::::::::::::: File Name: sha_clock :::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::::: Heartbeat Script ::::::::::::::::::::::::::::::::::
//:: Written by: Shayan
//:: Contact: mail_shayan@yhaoo.com                                         :://
//:: Forums: http://p2.forumforfree.com/shayan.html                         :://

//:: This script should be placed on one random inanimate object in the module
//:: This is absolutely cruical bit (and new to version 2.7). Without it things won't function.

#include "sha_subr_methds"

//3.0.6.3 added fix by MetaPhaze
#include "x2_inc_intweapon"

//3.0.6.2
//  void DoSubraceServerHeartbeats(float fHeartBeats);

void DoSubraceServerHeartbeats()
{
//3.0.6.4 changed to be non-recurcive
    object oPC = GetFirstPC();
    while(oPC!=OBJECT_INVALID)
    {
//3.0.6.3 changed to ignore poly'd chars
        if(!GetHasEffect(EFFECT_TYPE_POLYMORPH, oPC))
        {
            SubraceHeartbeat(oPC);
        }
        oPC = GetNextPC();
    }
}

void main()
{
   int iTime = SHA_GetCurrentTime();
   int iLastTime = GetLocalInt(OBJECT_SELF, "STORED_TIME");
   SetLocalInt(OBJECT_SELF, "STORED_TIME", iTime);
   int ID;

   if(GetIsSSEDisabled() )
   { return; }

// 3.0.6.2 - Pseudo Heartbeat for better compatibility with other systems
//
   if (USE_SSE_CLOCK_HEARTBEATS==TRUE)
   {
// 3.0.6.4 heartbeat calls made non-recurcive
        DoSubraceServerHeartbeats();
        DelayCommand(1.0,DoSubraceServerHeartbeats());
        DelayCommand(2.0,DoSubraceServerHeartbeats());
        DelayCommand(3.0,DoSubraceServerHeartbeats());
        DelayCommand(4.0,DoSubraceServerHeartbeats());
        DelayCommand(5.0,DoSubraceServerHeartbeats());
   }

   if(iTime != iLastTime)
   {

       //There has been a day/night transition! Signal Event!
       object oPC = GetFirstPC();
       do
       {
            if(GetIsDM(oPC) || GetSSEStatus(GetArea(oPC)) ) continue;
            ID = GetPlayerSubraceID(oPC);
            if(!ID) continue;

//3.0.6.3 added fix by MetaPhaze
            if( GetHasEffect(EFFECT_TYPE_POLYMORPH, oPC)) continue;

            string SubraceStorage = GetSubraceStorageLocationByID(ID);
            ApplyTemporarySubraceAppearance(SubraceStorage, oPC, iTime);
            ApplySubraceEffect(oPC, SubraceStorage, iTime);
            CheckIfCanUseEquipedWeapon(oPC);
            DelayCommand(6.0, CheckIfCanUseEquippedArmor(oPC));
            DelayCommand(8.0, EquipTemporarySubraceSkin(SubraceStorage, oPC, iTime));
            DelayCommand(11.0, EquipTemporarySubraceClaw(SubraceStorage, oPC, iTime));
       }while(GetIsObjectValid(oPC = GetNextPC() ));
   }
}
