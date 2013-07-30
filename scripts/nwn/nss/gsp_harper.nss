#include "gsp_func_inc"

void main () {
    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0)
        return;

    SpeakString("gsp_harper");
    
    switch(si.id){
        case TASPELL_HARPER_LYCANBANE:
        break;
        case TASPELL_HARPER_MILILS_EAR:
        break;
        case TASPELL_HARPER_MIELIKKIS_TRUTH:
        break;
        default:
            SpeakString("Something Terrible Happened");
            return;
        break;
    }
}
