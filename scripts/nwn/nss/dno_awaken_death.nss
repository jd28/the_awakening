void CreateChest(string sChest, location lLoc)
{
    CreateObject(OBJECT_TYPE_PLACEABLE, sChest, lLoc);
}

void main(){

    object oSelf = OBJECT_SELF;
    object oArea = GetArea(oSelf);
    object oWay;
    string sArea = GetTag(oArea);
    string sSelf = GetTag(oSelf);
    string sChest, sWay;
    location lLoc;

    if (sArea != "dno_Area_028") return;

    if (sSelf == "dno_axieros_1"){
        sWay   = "dno_WP_Axie_Chest";
        sChest = "dno_axie_chest";
    }
    else if (sSelf == "dno_Kadmilos_1"){
        sWay   = "dno_WP_Kad_Chest";
        sChest = "dno_kad_chest";
    }
    else if (sSelf == "dno_Kersa_1"){
        sWay   = "dno_WP_Kersa_Chest";
        sChest = "dno_kersa_chest";
    }
    else if (sSelf == "dno_Kersos_1"){
        sWay  = "dno_WP_Kerso_Chest";
        sChest = "dno_kerso_chest";
    }
    
    lLoc = GetLocation(GetWaypointByTag(sWay));
    DelayCommand(1.0, CreateChest(sChest, lLoc));
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HARM), lLoc);
}
