/**
 *  $Id: zdlg_do_01.nss,v 1.2 2005/08/07 04:38:30 pspeed Exp $
 *
 *  Entry selection script for the Z-Dialog system.
 *
 *  Copyright (c) 2004 Paul Speed - BSD licensed.
 *  NWN Tools - http://nwntools.sf.net/
 */
#include "pl_dlg_include_i"

const int ENTRY_NUM = 1;

void main(){
    int nNode = GetSelectedNodeID();

    _DoDlgSelection( GetPCSpeaker(), nNode );
}
