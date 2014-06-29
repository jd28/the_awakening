// cep23_port_inc
//
///////////////////////////////////////////////////
// Created By: Genisys / Guile
// Created On: 3/06/2014
///////////////////////////////////////////////////
// Copyright © 2014 All Rights Reserved Worldwide
///////////////////////////////////////////////////
/*
   This handles the next & previous portrait functions...
*/
////////////////////////////////////////////////////////////////////////////////
//Required Includes
// none...
////////////////////////////////////////////////////////////////////////////////

// Increment oPC's portrait by nCount
void SetNextPortrait(object oPC, int nCount);

// Decrement oPC's portriat by nCount
void SetPreviousPortrait(object oPC, int nCount);

////////////////////////////////////////////////////////////////////////////////
void SetNextPortrait(object oPC, int nCount)
{
 int nPort = GetPortraitId(oPC);
 nPort += nCount;
 if(nPort >3499)
 { nPort = 1; }
 else if(nPort > 322 & nPort < 348)
 { nPort = 348; }
 else if(nPort > 357 & nPort < 559)
 { nPort = 559; }
 else if(nPort > 571 & nPort < 601)
 { nPort = 601; }
 else if(nPort > 694 & nPort < 701)
 { nPort = 701; }
 else if(nPort > 625 & nPort < 630)
 { nPort = 630; }
 else if(nPort > 656 & nPort < 692)
 { nPort = 692; }
 else if(nPort > 749 & nPort < 935)
 { nPort = 935; }
 else if(nPort > 986 & nPort < 1014)
 { nPort = 1014; }
 else if(nPort > 1068 & nPort < 1264)
 { nPort = 1264; }
 else if(nPort > 1275 & nPort < 1290)
 { nPort = 1290; }
 else if(nPort > 1298 & nPort < 2000)
 { nPort = 2000; }
 else if(nPort > 2003 & nPort < 2012)
 { nPort = 2012; }
 else if(nPort > 2163 & nPort < 2189)
 { nPort = 2189; }
 else if(nPort > 2245 & nPort < 2254)
 { nPort = 2254; }
 else if(nPort > 2395 & nPort < 3091)
 { nPort = 3091; }
 else if(nPort > 3100 & nPort < 3169)
 { nPort = 3169; }
 else if(nPort > 3214 & nPort < 3296)
 { nPort = 3296; }
 else if(nPort > 3346 & nPort < 3350)
 { nPort = 3350; }
 else if(nPort > 3360 & nPort < 3463)
 { nPort = 3463; }
 else if(nPort > 3465 & nPort < 3477)
 { nPort = 3477; }
 else if(nPort > 3479 & nPort < 3485)
 { nPort = 3485; }

 // Debugging...
 // SendMessageToPC(oPC, "Portrait ID = " + IntToString(nPort) );

 SetPortraitId(oPC, nPort);

}


void SetPreviousPortrait(object oPC, int nCount)
{
 int nPort = GetPortraitId(oPC);
 nPort -= nCount;
 if(nPort < 1)
 { nPort = 3499; }
 else if(nPort > 322 & nPort < 348)
 { nPort = 322; }
 else if(nPort > 357 & nPort < 559)
 { nPort = 357; }
 else if(nPort > 571 & nPort < 601)
 { nPort = 571; }
 else if(nPort > 656 & nPort < 692)
 { nPort = 656; }
 else if(nPort > 694 & nPort < 701)
 { nPort = 694; }
 else if(nPort > 625 & nPort < 630)
 { nPort = 625; }
 else if(nPort > 749 & nPort < 935)
 { nPort = 749; }
 else if(nPort > 986 & nPort < 1014)
 { nPort = 986; }
 else if(nPort > 1068 & nPort < 1264)
 { nPort = 1068; }
 else if(nPort > 1275 & nPort < 1290)
 { nPort = 1275; }
 else if(nPort > 1298 & nPort < 2000)
 { nPort = 1298; }
 else if(nPort > 2003 & nPort < 2012)
 { nPort = 2003; }
 else if(nPort > 2163 & nPort < 2189)
 { nPort = 2163; }
 else if(nPort > 2245 & nPort < 2254)
 { nPort = 2245; }
 else if(nPort > 2395 & nPort < 3091)
 { nPort = 2395; }
 else if(nPort > 3100 & nPort < 3169)
 { nPort = 3100; }
 else if(nPort > 3214 & nPort < 3296)
 { nPort = 3214; }
 else if(nPort > 3346 & nPort < 3350)
 { nPort = 3346; }
 else if(nPort > 3360 & nPort < 3463)
 { nPort = 3360; }
 else if(nPort > 3465 & nPort < 3477)
 { nPort = 3465; }
 else if(nPort > 3479 & nPort < 3485)
 { nPort = 3479; }
 else if(nPort > 3499)
 { nPort = 3499; }

 // Debugging...
 // SendMessageToPC(oPC, "Portrait ID = " + IntToString(nPort) );

 SetPortraitId(oPC, nPort);

}
