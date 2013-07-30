/**
 *  $Id: zdlg_check_01.nss,v 1.2 2005/08/07 04:38:30 pspeed Exp $
 *
 *  Entry conditional check for the Z-Dialog system.
 *
 *  Copyright (c) 2004 Paul Speed - BSD licensed.
 *  NWN Tools - http://nwntools.sf.net/
 */
#include "zdlg_include_i"

int StartingConditional(){
    int nNode = GetCurrentNodeID();
    return( _SetupDlgResponse( nNode, GetPCSpeaker() ) );
}
