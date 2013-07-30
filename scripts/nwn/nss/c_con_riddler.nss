//::///////////////////////////////////////////////
//:: RIDDLER CONVERSATION
//::                     onConv riddler creature
//:://////////////////////////////////////////////
/*
   first, check if we have a riddle. (unanswered)
     if so, repeat it. (?)
   if not, pick one.  set answer/riddle number.
   listen for answer.  pattern 4115

*/
//:://////////////////////////////////////////////
//:: Created By: bloodsong
//:://////////////////////////////////////////////



void main()
{
    object oSelf = OBJECT_SELF;
    object oPC = GetLastSpeaker();

    int nRiddle = GetLocalInt(oSelf, "RIDDLING");
    string sRiddle = GetLocalString(oSelf, "RIDDLE");
    string sAns1 =  GetLocalString(oSelf, "K1");
    string sAns2 =  GetLocalString(oSelf, "K2");
    string sAns3 =  GetLocalString(oSelf, "K3");
    string sAns4 =  GetLocalString(oSelf, "K4");

    string sGuess = GetMatchedSubstring(0); //-- i think??
    SetLocalString(oSelf, "GUESS", sGuess);

//-- step one: check riddle status
    if (nRiddle == 0)
    {//-- no riddle selected.
       ExecuteScript("riddler_q", oSelf);  //-- this should stock our strings and such
       SetLocalInt(oSelf, "RIDDLING", 1); //-- remember to zero this on a win case
       sRiddle = GetLocalString(oSelf, "RIDDLE");
       //-- turn on listen
       SetListenPattern(oSelf, "**", 4115);
       SetListening(oSelf, TRUE);
       //-- ask the riddle
       SpeakString(sRiddle);
       return;
    }

    //-- else we have a riddle out
  //-- step two: repeating the riddle.
   if(GetListenPatternNumber() == -1)
   {//-- this means they just clicked to talk? i hope
     SpeakString(sRiddle);
     return;
   }

  //-- step three: checking the K

  ExecuteScript("riddler_g", oSelf);


}
