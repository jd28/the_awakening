///////////////////////////////////////////////////////////
//Required Include only for Appraise...
#include "nw_i0_plot"
#include "mod_const_inc"

// This function opens sStore for oPC using nMarkup or nMarkdown on top of what
// The store already uses for its markup and markdown
// if nAppraise is true, the opened store will allow an appraise check for better prices
void OpenModuleStore( string sStore, object oPC, int nMarkup = 0, int nMarkdown = 0, int nAppraise = TRUE );

void main(){
    object oPC    = GetPCSpeaker();
    string sStore = GetLocalString(OBJECT_SELF, "store_1");
    int nMarkup   = GetLocalInt( OBJECT_SELF, "store_markup" );
    int nMarkdown = GetLocalInt( OBJECT_SELF, "store_markdown" );
    int nAppraise = GetLocalInt( OBJECT_SELF, "store_appraise" );

    //SendMessageToPC(oPC, "Store: " + sStore);

    OpenModuleStore( sStore, oPC, nMarkup, nMarkdown, nAppraise );
}

void OpenModuleStore( string sStore, object oPC, int nMarkup = 0, int nMarkdown = 0, int nAppraise = TRUE ){
    object oStore = GetNearestObjectByTag(sStore);

    if(!GetIsObjectValid(oStore)){
        SendMessageToPC(oPC, C_RED+"ERROR: No store!"+C_END);
    }

    //Check if nAppraise has been set
    if( nAppraise ) gplotAppraiseOpenStore( oStore, oPC, nMarkup, nMarkdown );
    else OpenStore( oStore, oPC, nMarkup, nMarkdown );
}
