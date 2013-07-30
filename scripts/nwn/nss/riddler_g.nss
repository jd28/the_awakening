//::///////////////////////////////////////////////
//:: RIDDLER GUESSESS
//::                     c_con_riddler
//:://////////////////////////////////////////////
/*
    this checks the pc's guess
    against the answer keywords.

    this is swiped from the nwn eliza scripts:
// Eliza/Doctor include file
// Original author: Joseph Weizenbaum
// This is a modified version for Neverwinter Nights
// by Tom 'Magi' Smallwood 10/23/2002
//
*/
//:://////////////////////////////////////////////
//:: Created By: bloodsong
//:://////////////////////////////////////////////

//-----EXTERNAL FUNCTIONS: ELIZA STRING HANDLERS--------------------


string GetWordFromList(string sKeyList) //Get the first word in a comma delimited list
{
  int x;
  string sNewWord=sKeyList;
  for(x=0;x<GetStringLength(sKeyList);x++)
  {
    if(GetSubString(sKeyList,x,1)==",")
    {
      sNewWord=GetStringLeft(sKeyList,x);
      break;
    }
  }

  //if a word was found, surround it with spaces.
  if(sNewWord!="")
    sNewWord=" "+sNewWord+" ";
  return sNewWord;
}

string FindAMatch(string Speech,string SubStr) //returns the matching substring, or nothing if not found
{
  //find first word in SubStr
  string sKey;
  sKey=GetWordFromList(SubStr);
  while(sKey!="")
  {
    if(FindSubString(GetStringUpperCase(Speech),sKey)>=0)
    {
      return sKey;
    }
    SubStr=GetStringRight(SubStr,GetStringLength(SubStr)-GetStringLength(sKey)+1);
    sKey=GetWordFromList(SubStr);
  }
  return "";
}

string FormatPlayerText(string sSpeech)
//clean up the player text by
//removing extra characters, keeping only letters, numbers and spaces
{
  int x;
  sSpeech=" "+sSpeech+" ";
  string sNewString="";
  string sChar;
  for(x=0;x<=GetStringLength(sSpeech)-1;x++)
  {
    sChar=GetSubString(sSpeech,x,1);
    if(FindSubString("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 ",sChar)>=0)
      sNewString=sNewString+sChar;
  }
  return sNewString;
}
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



void main()
{
    object oSelf = OBJECT_SELF;

    string sGuess = GetLocalString(oSelf, "GUESS");
    string sAns1 = GetLocalString(oSelf, "K1");
    string sAns2 = GetLocalString(oSelf, "K2");
    string sAns3 = GetLocalString(oSelf, "K3");
    string sAns4 = GetLocalString(oSelf, "K4");
    string sAns5 = GetLocalString(oSelf, "K5");
    int nResult = 0; //-- no joy
    int nRand;
    string sReply = "";

    string sSpeech=FormatPlayerText(sGuess);
    string sKey;

    if((sKey=FindAMatch(sSpeech,sAns1))!="")
    {
     sReply = "You are close.";
     if((sKey=FindAMatch(sSpeech,sAns2))!="" || sAns2 == "")
     {
      sReply = "You are very close.";
      if((sKey=FindAMatch(sSpeech,sAns3))!="" || sAns3 == "")
      {
       sReply = "You are extremely close.";
       if((sKey=FindAMatch(sSpeech,sAns4))!="" || sAns4 == "")
       {
        sReply = "You almost have it.  Try again.";
        if((sKey=FindAMatch(sSpeech,sAns5))!="" || sAns5 == "")
        {//-- if you get this far, all keywords match!
          sReply = "";
          nResult = 1; //-- yay!  um, now what?
        }
       }
      }
     }
    }
    if(sReply != "")
    {
    DelayCommand(1.0, SpeakString(sReply));
    //-- this is in case of some keywords correct and not others
    }

    if (nResult == 0)
    {//-- wrong guess
     if(sReply == "")
     {//-- not even close
     nRand = Random(6);

     switch(nRand)
     {
      case 0: {  sReply = "No."; break; }
      case 1: {  sReply = "Incorrect."; break; }
      case 2: {  sReply = "Wrong."; break; }
      case 3: {  sReply = "That is not the answer."; break; }
      case 4: {  sReply = "Incorrect."; break; }
      case 5: {  sReply = "Incorrect."; break; }
     }

     DelayCommand(1.0, SpeakString(sReply));
     }
     return;
    }

    //-- else we got the answer, hooray!

     nRand = Random(6);

     switch (nRand)
     {
      case 0: {  sReply = "Yes."; break; }
      case 1: {  sReply = "Correct."; break; }
      case 2: {  sReply = "You are correct."; break; }
      case 3: {  sReply = "That is the answer."; break; }
      case 4: {  sReply = "Correct."; break; }
      case 5: {  sReply = "Correct."; break; }
     }
     sReply += " You may pass.";
     DelayCommand(1.0, SpeakString(sReply));

   //--cleanup routine!
   DeleteLocalInt(oSelf, "RIDDLING");
   SetListening(oSelf, FALSE);

//----- PLACE CUSTOM SUCCESS RESULT ROUTINES HERE ---------\\

    object oDoor = GetNearestObjectByTag("ms_wp_forcefield");
    if(!GetIsOpen(oDoor)){
        AssignCommand(oDoor, SetLocked(oDoor, FALSE));
        AssignCommand(oDoor, ActionOpenDoor(oDoor));
    }
}
