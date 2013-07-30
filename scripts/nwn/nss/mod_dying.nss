//::///////////////////////////////////////////////
//:: Dying Script
//:: NW_O0_DEATH.NSS
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This script handles the default behavior
    that occurs when a player is dying.
    DEFAULT CAMPAIGN: player dies automatically
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: November 6, 2001
//:://////////////////////////////////////////////

const int BLEEDING_ON = FALSE;

void bleed(int iBleedAmt);

void main(){
    object oPC = GetLastPlayerDying();
    effect eDeath = EffectDeath(FALSE, FALSE);

    if(BLEEDING_ON){
        AssignCommand(oPC, ClearAllActions());
        AssignCommand(oPC, bleed(1));
    }
    else{
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, GetLastPlayerDying());
    }
}

void bleed(int iBleedAmt){
    effect eBleedEff;

    /* keep executing recursively until character is dead or at +1 hit points */
    if (GetCurrentHitPoints() <= 0){

        /* a positive bleeding amount means damage, otherwise heal the character */
        if (iBleedAmt > 0) {
            eBleedEff = EffectDamage(iBleedAmt);
        } else {
            eBleedEff = EffectHeal(-iBleedAmt);  /* note the negative sign */
        }

        ApplyEffectToObject(DURATION_TYPE_INSTANT, eBleedEff, OBJECT_SELF);

        /* -10 hit points is the death threshold, at or beyond it the character dies */
        if (GetCurrentHitPoints() <= -10) {
            PlayVoiceChat(VOICE_CHAT_DEATH); /* scream one last time */
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH), OBJECT_SELF); /* make death dramatic */
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), OBJECT_SELF); /* now kill them */
            return;
        }

        if (iBleedAmt > 0) { /* only check if character has not stablized */
            if (d10(1) == 1) { /* 10% chance to stablize */
                iBleedAmt = -iBleedAmt; /* reverse the bleeding process */
                PlayVoiceChat(VOICE_CHAT_LAUGH);
                /* laugh at death -- this time */
            } else {
                switch (d6()) {
                    case 1: PlayVoiceChat(VOICE_CHAT_PAIN1); break;
                    case 2: PlayVoiceChat(VOICE_CHAT_PAIN2); break;
                    case 3: PlayVoiceChat(VOICE_CHAT_PAIN3); break;
                    case 4: PlayVoiceChat(VOICE_CHAT_HEALME); break;
                    case 5: PlayVoiceChat(VOICE_CHAT_NEARDEATH); break;
                    case 6: PlayVoiceChat(VOICE_CHAT_HELP);
                }
            }
        }
        DelayCommand(6.0,bleed(iBleedAmt)); /* do this again next round */
    }
}
