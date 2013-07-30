#include "fky_chat_inc"

void DoCough(object oCougher)
{
    SetLocalString(oCougher, "NWNX!CHAT!SUPRESS", "1");
    int nGender = GetGender(oCougher);
    if (nGender == GENDER_MALE) AssignCommand(oCougher, PlaySound("as_pl_coughm"+IntToString(Random(7)+1)));
    else if (nGender == GENDER_FEMALE) AssignCommand(oCougher, PlaySound("as_pl_coughf"+IntToString(Random(7)+1)));
}

void DoOuch(object oOucher)
{
    SetLocalString(oOucher, "NWNX!CHAT!SUPRESS", "1");
    int nGender = GetGender(oOucher);
    if (nGender == GENDER_MALE) AssignCommand(oOucher, PlaySound("as_pl_paincrym"+IntToString(Random(3)+1)));
    else if (nGender == GENDER_FEMALE) AssignCommand(oOucher, PlaySound("as_pl_paincryf1"));
}

void DoCry(object oCrier)
{
    SetLocalString(oCrier, "NWNX!CHAT!SUPRESS", "1");
    int nGender = GetGender(oCrier);
    if (nGender == GENDER_MALE) AssignCommand(oCrier, PlaySound("as_pl_cryingm"+IntToString(Random(3)+1)));
    else if (nGender == GENDER_FEMALE) AssignCommand(oCrier, PlaySound("as_pl_cryingf"+IntToString(Random(3)+1)));
}

void DoGoodbye(object oLeave)
{
    SetLocalString(oLeave, "NWNX!CHAT!SUPRESS", "1");
    AssignCommand(oLeave, ActionPlayAnimation(ANIMATION_FIREFORGET_BOW));
    PlayVoiceChat(VOICE_CHAT_GOODBYE, oLeave);
}

void DoLaugh2(object oLaugher)
{
    SetLocalString(oLaugher, "NWNX!CHAT!SUPRESS", "1");
    int nGender = GetGender(oLaugher);
    if (nGender == GENDER_MALE) AssignCommand(oLaugher, PlaySound("as_pl_tavlaughm"+IntToString(Random(2)+1)));
    else if (nGender == GENDER_FEMALE) AssignCommand(oLaugher, PlaySound("as_pl_tavlaughf1"));
    AssignCommand(oLaugher, ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING, 1.0, 5.0));
}

void DoHiccup(object oHiccuper)
{
    SetLocalString(oHiccuper, "NWNX!CHAT!SUPRESS", "1");
    string sSound;
    switch(Random(3))
    {
        case 0: sSound = "as_pl_hiccupm1";
        case 1: sSound = "as_pl_x2rghtav4";
        case 2: sSound = "as_pl_x2rghtav5";
    }
    AssignCommand(oHiccuper, PlaySound(sSound));
}

void DoBurp(object oBurper)
{
    SetLocalString(oBurper, "NWNX!CHAT!SUPRESS", "1");
    int nGender = GetGender(oBurper);
    if (nGender == GENDER_MALE) AssignCommand(oBurper, PlaySound("as_pl_x2rghtav"+IntToString(Random(3)+1)));
}

void DoBelch(object oBelcher)
{
    SetLocalString(oBelcher, "NWNX!CHAT!SUPRESS", "1");
    int nGender = GetGender(oBelcher);
    if (nGender == GENDER_MALE) AssignCommand(oBelcher, PlaySound("as_pl_belchingm"+IntToString(Random(2)+1)));
}

void DoToast(object oToaster)
{
    SetLocalString(oToaster, "NWNX!CHAT!SUPRESS", "1");
    int nGender = GetGender(oToaster);
    if (nGender == GENDER_MALE) AssignCommand(oToaster, PlaySound("as_pl_tavtoastm"+IntToString(Random(4)+1)));
}

void DoRoar(object oRoarer)
{
    SetLocalString(oRoarer, "NWNX!CHAT!SUPRESS", "1");
    string sSound;
    switch(Random(4))
    {
        case 0: sSound = "sff_summondrgn";
        case 1: sSound = "c_dragnold_bat1";
        case 2: sSound = "c_dragnyng_bat1";
        case 3: sSound = "c_catlion_bat1";
    }
    AssignCommand(oRoarer, PlaySound(sSound));
}

void DoScreech(object oScreecher)
{
    SetLocalString(oScreecher, "NWNX!CHAT!SUPRESS", "1");
    AssignCommand(oScreecher, PlaySound("as_an_catscrech1"));
}

void DoMoo(object oMooer)
{
    SetLocalString(oMooer, "NWNX!CHAT!SUPRESS", "1");
    AssignCommand(oMooer, PlaySound("as_an_cow"+IntToString(Random(2)+1)));
}

void DoMeow(object oMeower)
{
    SetLocalString(oMeower, "NWNX!CHAT!SUPRESS", "1");
    AssignCommand(oMeower, PlaySound("as_an_catmeow"+IntToString(Random(4)+1)));
}

void DoHoot(object oHooter)
{
    SetLocalString(oHooter, "NWNX!CHAT!SUPRESS", "1");
    AssignCommand(oHooter, PlaySound("as_an_owlhoot"+IntToString(Random(2)+1)));
}

void DoHowl(object oHowler)
{
    SetLocalString(oHowler, "NWNX!CHAT!SUPRESS", "1");
    AssignCommand(oHowler, PlaySound("as_an_wolfhowl"+IntToString(Random(2)+1)));
}

void DoBark(object oBarker)
{
    SetLocalString(oBarker, "NWNX!CHAT!SUPRESS", "1");
    AssignCommand(oBarker, PlaySound("as_an_dogbark"+IntToString(Random(4)+1)));
}

void DoSnarl(object oSnarler)
{
    SetLocalString(oSnarler, "NWNX!CHAT!SUPRESS", "1");
    AssignCommand(oSnarler, PlaySound("as_an_dogbark5"));
}

void DoSpit(object oSpitter)
{
    SetLocalString(oSpitter, "NWNX!CHAT!SUPRESS", "1");
    int nGender = GetGender(oSpitter);
    if (nGender == GENDER_MALE) AssignCommand(oSpitter, PlaySound("as_pl_spittingm"+IntToString(Random(2)+1)));
}

void DoSneeze(object oSneezer)
{
    SetLocalString(oSneezer, "NWNX!CHAT!SUPRESS", "1");
    int nGender = GetGender(oSneezer);
    if (nGender == GENDER_MALE) AssignCommand(oSneezer, PlaySound("as_pl_sneezingm1"));
    else if (nGender == GENDER_FEMALE) AssignCommand(oSneezer, PlaySound("as_pl_sneezingf1"));
}

void DoScream(object oScreamer)
{
    SetLocalString(oScreamer, "NWNX!CHAT!SUPRESS", "1");
    int nGender = GetGender(oScreamer);
    if (nGender == GENDER_MALE)
    {
        if (Random(2)) AssignCommand(oScreamer, PlaySound("as_pl_x2screamm"+IntToString(Random(6)+1)));
        else AssignCommand(oScreamer, PlaySound("as_pl_screamm"+IntToString(Random(6)+1)));
    }
    else if (nGender == GENDER_FEMALE)
    {
        if (Random(2)) AssignCommand(oScreamer, PlaySound("as_pl_x2screamf"+IntToString(Random(6)+1)));
        else AssignCommand(oScreamer, PlaySound("as_pl_screamf"+IntToString(Random(6)+1)));
    }
}

void DoGroan(object oGroaner)
{
    SetLocalString(oGroaner, "NWNX!CHAT!SUPRESS", "1");
    int nGender = GetGender(oGroaner);
    if (nGender == GENDER_MALE) AssignCommand(oGroaner, PlaySound("as_pl_hangoverm1"));
    else if (nGender == GENDER_FEMALE) AssignCommand(oGroaner, PlaySound("as_pl_hangoverf1"));
}

void DoMoan(object oMoaner)
{
    SetLocalString(oMoaner, "NWNX!CHAT!SUPRESS", "1");
    int nGender = GetGender(oMoaner);
    if (nGender == GENDER_MALE) AssignCommand(oMoaner, PlaySound("as_pl_ailingm"+IntToString(Random(5)+1)));
    else if (nGender == GENDER_FEMALE) AssignCommand(oMoaner, PlaySound("as_pl_ailingf"+IntToString(Random(5)+1)));
}

void DoWail(object oWailer)
{
    SetLocalString(oWailer, "NWNX!CHAT!SUPRESS", "1");
    int nGender = GetGender(oWailer);
    if (nGender == GENDER_MALE) AssignCommand(oWailer, PlaySound("as_pl_wailingm"+IntToString(Random(6)+1)));
    else if (nGender == GENDER_FEMALE) AssignCommand(oWailer, PlaySound("as_pl_wailingf"+IntToString(Random(6)+1)));
}

void DoChant(object oChanter)
{
    SetLocalString(oChanter, "NWNX!CHAT!SUPRESS", "1");
    int nGender = GetGender(oChanter);
    if (nGender == GENDER_MALE)
    {
        int nAlign = GetAlignmentGoodEvil(oChanter);
        if (nAlign == ALIGNMENT_EVIL) AssignCommand(oChanter, PlaySound("as_pl_evilchantm"));
        else AssignCommand(oChanter, PlaySound("as_pl_chantingm"+IntToString(Random(2)+1)));
    }
    else if (nGender == GENDER_FEMALE) AssignCommand(oChanter, PlaySound("as_pl_chantingf"+IntToString(Random(2)+1)));
}

void DoYawn(object oYawner)
{
        SetLocalString(oYawner, "NWNX!CHAT!SUPRESS", "1");
        int nGender = GetGender(oYawner);
        AssignCommand(oYawner, ClearAllActions());
        if(nGender==GENDER_MALE) AssignCommand(oYawner, PlaySound("as_pl_yawningm1"));
        else if(nGender==GENDER_FEMALE) AssignCommand(oYawner, PlaySound("as_pl_yawningf1"));
        AssignCommand(oYawner, ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_BORED));
}

void DoWhistle(object oWhistler)
{
    SetLocalString(oWhistler, "NWNX!CHAT!SUPRESS", "1");
    AssignCommand(oWhistler, PlaySound("as_pl_whistle2"));
}

void DoSong(object oSinger)
{
    SetLocalString(oSinger, "NWNX!CHAT!SUPRESS", "1");
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_BARD_SONG), oSinger, 6.0f);
}

void DoGiggle(object oLaugh)
{
    SetLocalString(oLaugh, "NWNX!CHAT!SUPRESS", "1");
    AssignCommand(oLaugh, PlaySound("vs_fshaldrf_haha"));
}

void DoHeadShake(object oRefuser)
{
    SetLocalString(oRefuser, "NWNX!CHAT!SUPRESS", "1");
    PlayVoiceChat(VOICE_CHAT_NO, oRefuser);
    AssignCommand(oRefuser, ClearAllActions(TRUE));
    AssignCommand(oRefuser, PlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_LEFT, 1.0, 0.25f));
    DelayCommand(0.15f, AssignCommand(oRefuser, PlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_RIGHT, 1.0, 0.25f)));
    DelayCommand(0.40f, AssignCommand(oRefuser, PlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_LEFT, 1.0, 0.25f)));
    DelayCommand(0.65f, AssignCommand(oRefuser, PlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_RIGHT, 1.0, 0.25f)));
}

void DoLaugh(object oChuckles)
{
    SetLocalString(oChuckles, "NWNX!CHAT!SUPRESS", "1");
    PlayVoiceChat(VOICE_CHAT_LAUGH, oChuckles);
    AssignCommand(oChuckles, ClearAllActions(TRUE));
    AssignCommand(oChuckles, ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING, 1.0, 2.0));
}

void DoTired(object oSleepy)
{
    SetLocalString(oSleepy, "NWNX!CHAT!SUPRESS", "1");
    PlayVoiceChat(VOICE_CHAT_REST, oSleepy);
    AssignCommand(oSleepy, ClearAllActions(TRUE));
    AssignCommand(oSleepy, ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_TIRED, 1.0, 3.0));
}

void DoCheer(object oCheerer)
{
    SetLocalString(oCheerer, "NWNX!CHAT!SUPRESS", "1");
    PlayVoiceChat(VOICE_CHAT_CHEER, oCheerer);
    AssignCommand(oCheerer, ClearAllActions(TRUE));
    AssignCommand(oCheerer, PlayAnimation(ANIMATION_FIREFORGET_VICTORY1, 1.0));
}

void DoCheer2(object oCheerer)
{
    SetLocalString(oCheerer, "NWNX!CHAT!SUPRESS", "1");
    PlayVoiceChat(VOICE_CHAT_CHEER, oCheerer);
    AssignCommand(oCheerer, ClearAllActions(TRUE));
    AssignCommand(oCheerer, PlayAnimation(ANIMATION_FIREFORGET_VICTORY2, 1.0));
}

void DoCheer3(object oCheerer)
{
    SetLocalString(oCheerer, "NWNX!CHAT!SUPRESS", "1");
    PlayVoiceChat(VOICE_CHAT_CHEER, oCheerer);
    AssignCommand(oCheerer, ClearAllActions(TRUE));
    AssignCommand(oCheerer, PlayAnimation(ANIMATION_FIREFORGET_VICTORY3, 1.0));
}

void DoTaunt(object oTaunter)
{
    SetLocalString(oTaunter, "NWNX!CHAT!SUPRESS", "1");
    PlayVoiceChat(VOICE_CHAT_TAUNT, oTaunter);
    AssignCommand(oTaunter, ClearAllActions(TRUE));
    AssignCommand(oTaunter, PlayAnimation(ANIMATION_FIREFORGET_TAUNT, 1.0));
}

//Smoking Function by Jason Robinson, taken from DMFI
location GetLocationAboveAndInFrontOf(object oPC, float fDist, float fHeight)
{
    float fDistance = -fDist;
    object oTarget = (oPC);
    object oArea = GetArea(oTarget);
    vector vPosition = GetPosition(oTarget);
    vPosition.z += fHeight;
    float fOrientation = GetFacing(oTarget);
    vector vNewPos = AngleToVector(fOrientation);
    float vZ = vPosition.z;
    float vX = vPosition.x - fDistance * vNewPos.x;
    float vY = vPosition.y - fDistance * vNewPos.y;
    fOrientation = GetFacing(oTarget);
    vX = vPosition.x - fDistance * vNewPos.x;
    vY = vPosition.y - fDistance * vNewPos.y;
    vNewPos = AngleToVector(fOrientation);
    vZ = vPosition.z;
    vNewPos = Vector(vX, vY, vZ);
    return Location(oArea, vNewPos, fOrientation);
}

//Smoking Function by Jason Robinson, taken from DMFI
void SmokePipe(object oActivator)
{
    string sEmote1 = "*puffs on a pipe*";
    string sEmote2 = "*inhales from a pipe*";
    string sEmote3 = "*pulls a mouthful of smoke from a pipe*";
    float fHeight = 1.7;
    float fDistance = 0.1;
    // Set height based on race and gender
    if (GetGender(oActivator) == GENDER_MALE)
    {
        switch (GetRacialType(oActivator))
        {
            case RACIAL_TYPE_HUMAN:
            case RACIAL_TYPE_HALFELF: fHeight = 1.7; fDistance = 0.12; break;
            case RACIAL_TYPE_ELF: fHeight = 1.55; fDistance = 0.08; break;
            case RACIAL_TYPE_GNOME:
            case RACIAL_TYPE_HALFLING: fHeight = 1.15; fDistance = 0.12; break;
            case RACIAL_TYPE_DWARF: fHeight = 1.2; fDistance = 0.12; break;
            case RACIAL_TYPE_HALFORC: fHeight = 1.9; fDistance = 0.2; break;
        }
    }
    else
    {
        // FEMALES
        switch (GetRacialType(oActivator))
        {
            case RACIAL_TYPE_HUMAN:
            case RACIAL_TYPE_HALFELF: fHeight = 1.6; fDistance = 0.12; break;
            case RACIAL_TYPE_ELF: fHeight = 1.45; fDistance = 0.12; break;
            case RACIAL_TYPE_GNOME:
            case RACIAL_TYPE_HALFLING: fHeight = 1.1; fDistance = 0.075; break;
            case RACIAL_TYPE_DWARF: fHeight = 1.2; fDistance = 0.1; break;
            case RACIAL_TYPE_HALFORC: fHeight = 1.8; fDistance = 0.13; break;
        }
    }
    location lAboveHead = GetLocationAboveAndInFrontOf(oActivator, fDistance, fHeight);
    // emotes
    switch (d3())
    {
        case 1: AssignCommand(oActivator, ActionSpeakString(ESCAPE_STRING+sEmote1)); break;
        case 2: AssignCommand(oActivator, ActionSpeakString(ESCAPE_STRING+sEmote2)); break;
        case 3: AssignCommand(oActivator, ActionSpeakString(ESCAPE_STRING+sEmote3));break;
    }
    SetLocalString(oActivator, "NWNX!CHAT!SUPRESS", "1");//suppress speech
    // glow red
    AssignCommand(oActivator, ActionDoCommand(ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_LIGHT_RED_5), oActivator, 0.15)));
    // wait a moment
    AssignCommand(oActivator, ActionWait(3.0));
    // puff of smoke above and in front of head
    AssignCommand(oActivator, ActionDoCommand(ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SMOKE_PUFF), lAboveHead)));
    // if female, turn head to left
    if ((GetGender(oActivator) == GENDER_FEMALE) && (GetRacialType(oActivator) != RACIAL_TYPE_DWARF))
        AssignCommand(oActivator, ActionPlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_LEFT, 1.0, 5.0));
}

void Animation_Dance(object oPlayer)
{
    SetLocalString(oPlayer, "NWNX!CHAT!SUPRESS", "1");
    AssignCommand(oPlayer,ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY2));
    DelayCommand(3.0,AssignCommand(oPlayer,ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING, 3.0, 2.0)));
    DelayCommand(3.0,AssignCommand(oPlayer,PlayVoiceChat(VOICE_CHAT_LAUGH)));
    DelayCommand(5.0,AssignCommand(oPlayer,ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY1)));
    DelayCommand(8.5,AssignCommand(oPlayer,ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY3)));
    DelayCommand(11.0,AssignCommand(oPlayer,ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 3.0, 2.0)));
    DelayCommand(14.5,AssignCommand(oPlayer,PlayVoiceChat(VOICE_CHAT_LAUGH)));
    DelayCommand(13.0,AssignCommand(oPlayer,ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY3)));
}
void DoDance(object oPlayer)
{
    SetLocalString(oPlayer, "NWNX!CHAT!SUPRESS", "1");
    if(GetLocalInt(oPlayer,"Dancefix")== TRUE)
    {
        FloatingTextStringOnCreature(C_RED+SPAMFIX+C_END,oPlayer);
        return;
    }
    else
    {
        SetLocalInt(oPlayer,"Dancefix",TRUE);
        DelayCommand(14.0,SetLocalInt(oPlayer,"Dancefix",FALSE));
        AssignCommand(oPlayer,ClearAllActions(TRUE));
        Animation_Dance(oPlayer);
    }
}
void DoLoopAnimation(object oPlayer, int nAnimation, float fSpeed = 1.0, float fDur = 9999.0)
{
    SetLocalString(oPlayer, "NWNX!CHAT!SUPRESS", "1");
    AssignCommand(oPlayer, ClearAllActions(TRUE));
    AssignCommand(oPlayer, ActionPlayAnimation(nAnimation,fSpeed,fDur));
}
void DoFireForgetAnimation(object oPlayer, int nAnimation)
{
    SetLocalString(oPlayer, "NWNX!CHAT!SUPRESS", "1");
    AssignCommand(oPlayer, ClearAllActions(TRUE));
    AssignCommand(oPlayer,ActionPlayAnimation(nAnimation));
}
void DoDrink(object oPlayer)
{
    SetLocalString(oPlayer, "NWNX!CHAT!SUPRESS", "1");
    effect Vis = EffectVisualEffect(VFX_IMP_STUN);
    AssignCommand(oPlayer, ClearAllActions(TRUE));
    AssignCommand(oPlayer,ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK));
    DelayCommand(2.0,AssignCommand(oPlayer,ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_DRUNK,10.0,5.0)));
    DelayCommand(2.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,Vis,oPlayer));
}
void DoDrunk(object oPlayer)
{
    SetLocalString(oPlayer, "NWNX!CHAT!SUPRESS", "1");
    effect Vis = EffectVisualEffect(VFX_IMP_CONFUSION_S);
    AssignCommand(oPlayer, ClearAllActions(TRUE));
    AssignCommand(oPlayer,ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_DRUNK,1.0,9999.0));
    ApplyEffectToObject(DURATION_TYPE_INSTANT,Vis,oPlayer);
}
void DoFakeDeath(object oPlayer)
{
   SetLocalString(oPlayer, "NWNX!CHAT!SUPRESS", "1");
   effect Vis = EffectVisualEffect(VFX_COM_CHUNK_RED_LARGE);
    if(GetLocalInt(oPlayer,"FakeDeath")== TRUE)
    {
        FloatingTextStringOnCreature(C_RED+SPAMFIX+C_END,oPlayer);
        return;
    }
    else
    {
        SetLocalInt(oPlayer,"FakeDeath",TRUE);
        DelayCommand(2.0,SetLocalInt(oPlayer,"FakeDeath",FALSE));
        AssignCommand(oPlayer, ClearAllActions(TRUE));
        AssignCommand(oPlayer,ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT,1.0,9999.0));
        ApplyEffectToObject(DURATION_TYPE_INSTANT,Vis,oPlayer);
        PlayVoiceChat(VOICE_CHAT_DEATH,oPlayer);
    }
}
void DoPuke(object oPlayer)
{
    SetLocalString(oPlayer, "NWNX!CHAT!SUPRESS", "1");
    effect Puke1 = EffectVisualEffect(VFX_COM_CHUNK_GREEN_MEDIUM);
    effect Puke2 = EffectVisualEffect(VFX_COM_CHUNK_YELLOW_MEDIUM);
    int PukeFix;
    if(GetLocalInt(oPlayer,"PukeFix")== TRUE)
    {
        FloatingTextStringOnCreature(C_RED+SPAMFIX+C_END,oPlayer);
        return;
    }
    else
    {
        SetLocalInt(oPlayer,"PukeFix",TRUE);
        DelayCommand(3.0,SetLocalInt(oPlayer,"PukeFix",FALSE));
        AssignCommand(oPlayer, ClearAllActions(TRUE));
        AssignCommand(oPlayer,ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE));
        DelayCommand(1.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,Puke1,oPlayer));
        DelayCommand(1.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,Puke2,oPlayer));
        DelayCommand(1.0,AssignCommand(oPlayer,SpeakString(VOMIT,TALKVOLUME_TALK)));
    }
}
void DoSleep(object oPlayer)
{
    SetLocalString(oPlayer, "NWNX!CHAT!SUPRESS", "1");
    effect Vis = EffectVisualEffect(VFX_IMP_SLEEP);
    AssignCommand(oPlayer, ClearAllActions(TRUE));
    AssignCommand(oPlayer,ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT,1.0,9999.0));
    ApplyEffectToObject(DURATION_TYPE_INSTANT,Vis,oPlayer);
}

void DoSnore(object oPlayer)
{
    SetLocalString(oPlayer, "NWNX!CHAT!SUPRESS", "1");
    effect Vis = EffectVisualEffect(VFX_IMP_SLEEP);
    AssignCommand(oPlayer, ClearAllActions(TRUE));
    int nGender = GetGender(oPlayer);
    if (nGender == GENDER_MALE) AssignCommand(oPlayer, PlaySound("as_pl_snoringm"+IntToString(Random(2)+1)));
    else if (nGender == GENDER_FEMALE) AssignCommand(oPlayer, PlaySound("as_pl_snoringf1"));
    AssignCommand(oPlayer,ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT,1.0,9999.0));
    ApplyEffectToObject(DURATION_TYPE_INSTANT,Vis,oPlayer);
}


void main(){

    object oEPC = OBJECT_SELF;
    string sEText = GetLocalString(oEPC, "FKY_CHAT_PCSHUNT_TEXT");
    int nEChannel = GetLocalInt(oEPC, "FKY_CHAT_PCSHUNT_CHANNEL");
    DeleteLocalString(oEPC, "FKY_CHAT_PCSHUNT_TEXT");
    DeleteLocalInt(oEPC, "FKY_CHAT_PCSHUNT_CHANNEL");

    int nText, nSort2;
    string sSort;
    if (!GetIsDead(oEPC))
    {
        sEText = GetStringLowerCase(GetStringRight(sEText, GetStringLength(sEText) - 1));  //23 commands, case insensitive
        sSort = GetStringLeft(sEText, 1);
        nText = FindSubString("abcdefghijklmnopqrstuvwxyz", sSort);
        nSort2 = nText < 0 ? -1 : nText / 5;
        switch (nSort2)
        {
            case -1:
            if (USING_LINUX && (sEText == EMOTE_SYMBOL))//double emote symbol toggles emote popup window on and off
            {
                if (GetLocalInt(oEPC, "FKY_CHAT_EMOTETOGGLE")) DeleteLocalInt(oEPC, "FKY_CHAT_EMOTETOGGLE");
                else SetLocalInt(oEPC, "FKY_CHAT_EMOTETOGGLE", 1);
            }
            else ShoutBlock(oEPC, nEChannel);
            break;
            case 0:
            switch(nText)
            {
                case 0:/*a*/
                if (sEText == "ag" || sEText == "agree") DoLoopAnimation(oEPC, ANIMATION_LOOPING_LISTEN);
                else ShoutBlock(oEPC, nEChannel);
                break;
                case 1:/*b*/
                if (sEText =="bg" || sEText == "beg") DoLoopAnimation(oEPC, ANIMATION_LOOPING_TALK_PLEADING);
                else if (sEText == "bn" || sEText == "bend") DoLoopAnimation(oEPC, ANIMATION_LOOPING_GET_LOW);
                else if (sEText == "bw" || sEText == "bow") DoFireForgetAnimation(oEPC, ANIMATION_FIREFORGET_BOW);
                else if (sEText == "bo" || sEText == "bored") DoFireForgetAnimation(oEPC, ANIMATION_FIREFORGET_PAUSE_BORED);
                else if (sEText == "bk" || sEText == "bark") DoBark(oEPC);
                else if (sEText == "bh" || sEText == "belch") DoBelch(oEPC);
                else if (sEText == "bp" || sEText == "burp") DoBurp(oEPC);
                else if (sEText == "bye") DoGoodbye(oEPC);
                else ShoutBlock(oEPC, nEChannel);
                break;
                case 2:/*c*/
                if (sEText == "cl" || sEText == "celebrate") DoCheer3(oEPC);
                else if (sEText == "ca" || sEText == "cantrip") DoLoopAnimation(oEPC, ANIMATION_LOOPING_CONJURE1);
                else if (sEText == "ch" || sEText == "cheer") DoCheer(oEPC);
                else if (sEText == "ck" || sEText == "chuckle") DoLaugh(oEPC);
                else if (sEText == "ct" || sEText == "chat") DoLoopAnimation(oEPC, ANIMATION_LOOPING_TALK_NORMAL);
                else if (sEText == "cs" || sEText == "cast") DoLoopAnimation(oEPC, ANIMATION_LOOPING_CONJURE2);
                else if (sEText == "cy" || sEText == "curtsy") DoFireForgetAnimation(oEPC, ANIMATION_FIREFORGET_BOW);
                else if (sEText == "co" || sEText == "collapse") DoLoopAnimation(oEPC, ANIMATION_LOOPING_DEAD_FRONT);
                else if (sEText == "cn" || sEText == "chant") DoChant(oEPC);
                else if (sEText == "cr" || sEText == "chortle") DoLaugh2(oEPC);
                else if (sEText == "cg" || sEText == "cough" || sEText == "choke") DoCough(oEPC);
                else if (sEText == "cry") DoCry(oEPC);
                else ShoutBlock(oEPC, nEChannel);
                break;
                case 3:/*d*/
                if (sEText == "da" || sEText == "dance") DoDance(oEPC);
                else if (sEText == "dd" || sEText == "dead") DoLoopAnimation(oEPC, ANIMATION_LOOPING_DEAD_BACK);
                else if (sEText == "dk" || sEText == "duck") DoFireForgetAnimation(oEPC, ANIMATION_FIREFORGET_DODGE_DUCK);
                else if (sEText == "di" || sEText == "die") DoLoopAnimation(oEPC, ANIMATION_LOOPING_DEAD_FRONT);
                else if (sEText == "dr" || sEText == "drink") DoDrink(oEPC);
                else if (sEText == "dm" || sEText == "demand") DoLoopAnimation(oEPC, ANIMATION_LOOPING_TALK_FORCEFUL);
                else if (sEText == "dg" || sEText == "dodge") DoFireForgetAnimation(oEPC, ANIMATION_FIREFORGET_DODGE_SIDE);
                else if (sEText == "dn" || sEText == "drunk") DoDrunk(oEPC);
                else ShoutBlock(oEPC, nEChannel);
                break;
                case 4:/*e*/
                if (sEText == "ex" || sEText == "exhausted") DoTired(oEPC);
                else ShoutBlock(oEPC, nEChannel);
                break;
                default: ShoutBlock(oEPC, nEChannel);
                break;
            }
            break;
            case 1:
            switch(nText)
            {
                case 5:/*f*/
                if (sEText == "fa" || sEText== "fatigue") DoTired(oEPC);
                else if (sEText == "fd" || sEText == "fakedead") DoFakeDeath(oEPC);
                else if (sEText == "fg" || sEText == "fidget")  DoLoopAnimation(oEPC, ANIMATION_LOOPING_PAUSE2);
                else if (sEText == "fi" || sEText == "fiddle")  DoLoopAnimation(oEPC, ANIMATION_LOOPING_GET_MID);
                else if (sEText == "fl" || sEText == "fall") DoLoopAnimation(oEPC, ANIMATION_LOOPING_DEAD_FRONT);
                else if (sEText == "fp" || sEText == "flop") DoLoopAnimation(oEPC, ANIMATION_LOOPING_DEAD_FRONT);
                else ShoutBlock(oEPC, nEChannel);
                break;
                case 6:/*g*/
                if ((sEText == "gi" || sEText == "giggle") && (GetGender(oEPC) == GENDER_FEMALE)) DoGiggle(oEPC);
                else if (sEText == "gr" || sEText == "greet") DoFireForgetAnimation(oEPC, ANIMATION_FIREFORGET_GREETING);
                else if (sEText == "gn" || sEText == "groan") DoGroan(oEPC);
                else if (sEText == "gw" || sEText == "guffaw") DoLaugh2(oEPC);
                else if (sEText == "gb" || sEText == "gt" || sEText == "goodnight" || sEText == "goodbye") DoGoodbye(oEPC);
                else ShoutBlock(oEPC, nEChannel);
                break;
                case 7:/*h*/
                if (sEText == "hm" || sEText == "hum") DoSong(oEPC);
                else if (sEText == "hy" || sEText == "hooray") DoCheer2(oEPC);
                else if (sEText == "hl" || sEText == "hello") DoFireForgetAnimation(oEPC, ANIMATION_FIREFORGET_GREETING);
                else if (sEText == "hw" || sEText == "howl") DoHowl(oEPC);
                else if (sEText == "ht" || sEText == "hoot") DoHoot(oEPC);
                else if (sEText == "hp" || sEText == "hiccup") DoHiccup(oEPC);
                else ShoutBlock(oEPC, nEChannel);
                break;
                //case 8:/*i*/
                //break;
                //case 9:/*j*/
                //break;
                default: ShoutBlock(oEPC, nEChannel);
                break;
            }
            break;
            case 2:
            switch(nText)
            {
                case 10:/*k*/
                if (sEText == "kn" || sEText == "kneel") DoLoopAnimation(oEPC, ANIMATION_LOOPING_MEDITATE);
                else ShoutBlock(oEPC, nEChannel);
                break;
                case 11:/*l*/
                if (sEText == "la" || sEText == "laugh") DoLaugh(oEPC);
                else if (sEText == "lie") DoLoopAnimation(oEPC, ANIMATION_LOOPING_DEAD_BACK);
                else if (sEText == "lk" || sEText == "look") DoLoopAnimation(oEPC, ANIMATION_LOOPING_LOOK_FAR);
                else ShoutBlock(oEPC, nEChannel);
                break;
                case 12:/*m*/
                if (sEText == "md" || sEText == "meditate") DoLoopAnimation(oEPC, ANIMATION_LOOPING_MEDITATE);
                else if (sEText == "mk" || sEText == "mock") DoTaunt(oEPC);
                else if (sEText == "mn" || sEText == "moan") DoMoan(oEPC);
                else if (sEText == "mw" || sEText == "meow") DoMeow(oEPC);
                else if (sEText == "mo" || sEText == "moo") DoMoo(oEPC);
                else ShoutBlock(oEPC, nEChannel);
                break;
                case 13:/*n*/
                if (sEText == "nd" || sEText == "nod") DoLoopAnimation(oEPC, ANIMATION_LOOPING_LISTEN);
                else if (sEText == "no") DoHeadShake(oEPC);
                else if (sEText == "np" || sEText == "nap") DoSleep(oEPC);
                else ShoutBlock(oEPC, nEChannel);
                break;
                case 14:/*o*/
                if (sEText == "ow" || sEText == "ouch") DoOuch(oEPC);
                else ShoutBlock(oEPC, nEChannel);
                break;
                default: ShoutBlock(oEPC, nEChannel);
                break;
            }
            break;
            case 3:
            switch(nText)
            {
                case 15:/*p*/
                if (sEText == "pe" || sEText == "peer") DoLoopAnimation(oEPC, ANIMATION_LOOPING_LOOK_FAR);
                else if (sEText == "pl" || sEText == "plead") DoLoopAnimation(oEPC, ANIMATION_LOOPING_TALK_PLEADING);
                else if (sEText == "pr" || sEText == "pray") DoLoopAnimation(oEPC, ANIMATION_LOOPING_MEDITATE);
                else if (sEText == "pn" || sEText == "prone") DoLoopAnimation(oEPC, ANIMATION_LOOPING_DEAD_FRONT);
                else if (sEText == "pu" || sEText == "puke") DoPuke(oEPC);
                else ShoutBlock(oEPC, nEChannel);
                break;
                //case 16:/*q*/
                //break;
                case 17:/*r*/
                if (sEText == "re" || sEText == "read") DoFireForgetAnimation(oEPC, ANIMATION_FIREFORGET_READ);
                else if (sEText == "rt" || sEText == "rest") DoLoopAnimation(oEPC, ANIMATION_LOOPING_DEAD_BACK);
                else if (sEText == "rr" || sEText == "roar") DoRoar(oEPC);
                else ShoutBlock(oEPC, nEChannel);
                break;
                case 18:/*s*/
                if (sEText == "sa" || sEText == "salute") DoFireForgetAnimation(oEPC, ANIMATION_FIREFORGET_SALUTE);
                else if (sEText == "sn" || sEText == "scan") DoLoopAnimation(oEPC, ANIMATION_LOOPING_LOOK_FAR);
                else if (sEText == "sc" || sEText == "scratch") DoFireForgetAnimation(oEPC, ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD);
                else if (sEText == "sg" || sEText == "sing") DoSong(oEPC);
                else if (sEText == "sh" || sEText == "shift") DoLoopAnimation(oEPC, ANIMATION_LOOPING_PAUSE2);
                else if (sEText == "si" || sEText == "sit") DoLoopAnimation(oEPC, ANIMATION_LOOPING_SIT_CROSS);
                else if (sEText == "sip") DoDrink(oEPC);
                else if (sEText == "sl" || sEText == "sleep") DoSleep(oEPC);
                else if (sEText == "snore") DoSnore(oEPC);
                else if (sEText == "sk" || sEText == "smoke") SmokePipe(oEPC);
                else if (sEText == "sp" || sEText == "spasm") DoLoopAnimation(oEPC, ANIMATION_LOOPING_SPASM);
                else if (sEText == "st" || sEText == "steal" || sEText == "sw" || sEText == "swipe") DoFireForgetAnimation(oEPC, ANIMATION_FIREFORGET_STEAL);
                else if (sEText == "so" ||sEText == "stoop") DoLoopAnimation(oEPC, ANIMATION_LOOPING_GET_LOW);
                else if (sEText == "sr" || sEText == "stretch") DoFireForgetAnimation(oEPC, ANIMATION_FIREFORGET_PAUSE_BORED);
                else if (sEText == "sy" || sEText == "sway") DoLoopAnimation(oEPC, ANIMATION_LOOPING_PAUSE_DRUNK);
                else if (sEText == "sm" || sEText == "scream") DoScream(oEPC);
                else if (sEText == "sz" || sEText == "sneeze") DoSneeze(oEPC);
                else if (sEText == "spit") DoSpit(oEPC);
                else if (sEText == "snarl") DoSnarl(oEPC);
                else if (sEText == "screech") DoScreech(oEPC);
                else if (sEText == "sb" || sEText == "sob") DoCry(oEPC);
                else ShoutBlock(oEPC, nEChannel);
                break;
                case 19:/*t*/
                if (sEText == "ta" || sEText == "taunt") DoTaunt(oEPC);
                else if (sEText == "th" || sEText == "threaten") DoLoopAnimation(oEPC, ANIMATION_LOOPING_TALK_FORCEFUL);
                else if (sEText == "ti" || sEText == "tired") DoTired(oEPC);
                else if (sEText == "tl" || sEText == "talk") DoLoopAnimation(oEPC, ANIMATION_LOOPING_TALK_NORMAL);
                else if (sEText == "tp" || sEText == "trip") DoLoopAnimation(oEPC, ANIMATION_LOOPING_DEAD_FRONT);
                else if (sEText == "tt" || sEText == "toast") DoToast(oEPC);
                else ShoutBlock(oEPC, nEChannel);
                break;
                default: ShoutBlock(oEPC, nEChannel);
                break;
            }
            break;
            case 4:
            switch(nText)
            {
                //case 20:/*u*/
                //break;
                case 21:/*v*/
                if (sEText == "vm" || sEText == "vomit") DoPuke(oEPC);
                else ShoutBlock(oEPC, nEChannel);
                break;
                case 22:/*w*/
                if (sEText == "wa" || sEText == "wave") DoFireForgetAnimation(oEPC, ANIMATION_FIREFORGET_GREETING);
                else if (sEText == "wh" || sEText == "whistle") DoWhistle(oEPC);
                else if (sEText == "wo" || sEText == "worship") DoLoopAnimation(oEPC, ANIMATION_LOOPING_WORSHIP);
                else if (sEText == "wz" || sEText == "woozy") DoDrunk(oEPC);
                else if (sEText == "wl" || sEText == "wail") DoWail(oEPC);
                else if (sEText == "wp" || sEText == "weep") DoCry(oEPC);
                else ShoutBlock(oEPC, nEChannel);
                break;
                //case 23:/*x*/
                //break;
                case 24:/*y*/
                if (sEText == "yw" || sEText == "yawn") DoYawn(oEPC);
                else ShoutBlock(oEPC, nEChannel);
                break;
                default: ShoutBlock(oEPC, nEChannel);
                break;
            }
            break;
            //case 5:
            //switch(nText)
            //{
            //    case 25:/*z*/
            //    break;
            //}
            break;
            default: ShoutBlock(oEPC, nEChannel);
            break;
        }
    }
    else
    {
        SetLocalString(oEPC, "NWNX!CHAT!SUPRESS", "1");
        FloatingTextStringOnCreature(C_RED+NOT_DEAD_EM+C_END, oEPC, FALSE);
    }
}
