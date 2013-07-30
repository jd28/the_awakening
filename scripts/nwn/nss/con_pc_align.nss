//----------------------------------------------------------------------
//  File: con_pc_align
//----------------------------------------------------------------------

#include "nwnx_events"

void main(){
    object oPC = GetPCSpeaker();
    int nSelectedNode = GetSelectedNodeID();
    int nAlign1, nAlign2;

    //SendMessageToPC(oPC, "Selected Node: " + IntToString(nSelectedNode));

    switch(nSelectedNode){
        case 0:
            nAlign1 = ALIGNMENT_LAWFUL;
            nAlign2 = ALIGNMENT_GOOD;
            break;
        case 1:
            nAlign1 = ALIGNMENT_NEUTRAL;
            nAlign2 = ALIGNMENT_LAWFUL;
            break;
        case 2:
            nAlign1 = ALIGNMENT_LAWFUL;
            nAlign2 = ALIGNMENT_EVIL;
            break;
        case 3:
            nAlign1 = ALIGNMENT_NEUTRAL;
            nAlign2 = ALIGNMENT_GOOD;
            break;
        case 4:
            nAlign1 = ALIGNMENT_NEUTRAL;
            nAlign2 = ALIGNMENT_NEUTRAL;
            break;
        case 5:
            nAlign1 = ALIGNMENT_NEUTRAL;
            nAlign2 = ALIGNMENT_EVIL;
            break;
        case 6:
            nAlign1 = ALIGNMENT_CHAOTIC;
            nAlign2 = ALIGNMENT_GOOD;
            break;
        case 7:
            nAlign1 = ALIGNMENT_NEUTRAL;
            nAlign2 = ALIGNMENT_CHAOTIC;
            break;
        case 8:
            nAlign1 = ALIGNMENT_CHAOTIC;
            nAlign2 = ALIGNMENT_EVIL;
            break;
        default:
    }

    AdjustAlignment(oPC, nAlign1, 100, FALSE);
    AdjustAlignment(oPC, nAlign2, 100, FALSE);

}

