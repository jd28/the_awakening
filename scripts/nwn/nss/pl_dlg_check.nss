/**
 *  $Id: zdlg_check_01.nss,v 1.2 2005/08/07 04:38:30 pspeed Exp $
 *
 *  Entry conditional check for the Z-Dialog system.
 *
 *  Copyright (c) 2004 Paul Speed - BSD licensed.
 *  NWN Tools - http://nwntools.sf.net/
 */
#include "pl_dlg_include_i"

int StartingConditional(){
    object oSpeaker = GetPCSpeaker();
    int nNode = GetCurrentNodeID();

    int hasNext = _HasDlgNext( oSpeaker );
    int hasPrev = _HasDlgPrevious( oSpeaker );
    int hasEnd = _HasDlgEnd( oSpeaker );
    if( (hasNext || hasPrev || hasEnd) && nNode >= 10 ){
        if( hasNext && nNode == 10 ){
            SetCurrentNodeText("Next");
            return( TRUE );
        }
        else if( hasPrev && nNode == 11 ){
            SetCurrentNodeText("Previous");
            return( TRUE );
        }
        else if( hasEnd && nNode == 12 ){
            SetCurrentNodeText("End");
            return( TRUE );
        }
        return( FALSE );
    }

    int i = _GetDlgFirstResponse( oSpeaker ) + nNode;
    int count = GetDlgResponseCount( oSpeaker );
    if( i < count ){
        string response = GetDlgResponse( i, oSpeaker );
        SetCurrentNodeText(response);
        return( TRUE );
    }
    return( FALSE );
}
