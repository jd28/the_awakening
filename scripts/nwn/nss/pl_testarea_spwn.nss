#include "area_inc"

void main(){
    object oPC = GetLastUsedBy();
    object oArea = GetArea(oPC), oMonster;
    int nType = OBJECT_TYPE_CREATURE;

    if(!GetIsAreaClear(oArea, oPC)){
        ErrorMessage(oPC, "Area will be despawned!");
        AreaClean(oArea, oPC);
        return;
    }

    int nPick = d4();
    object oWay = GetWaypointByTag(GetResRef(oArea));
    if(oWay == OBJECT_INVALID){
        Logger(oPC, VAR_DEBUG_LOGS, LOGLEVEL_DEBUG, "Tag: %s in Area: %s, waypoint not found.",
            GetTag(OBJECT_SELF), GetName(oArea));
        return;
    }

    location lLoc = GetLocation(oWay);

    if(GetTag(OBJECT_SELF) == "pl_testarea_boss"){
        switch(nPick){
            case 1:
                oMonster = CreateObject(nType, "pl_satyr_boss", lLoc, FALSE, "Spawned"); break;
            case 2:
                oMonster = CreateObject(nType, "pl_assass_boss", lLoc, FALSE, "Spawned"); break;
            case 3:
                oMonster = CreateObject(nType, "pl_gntfrost_boss", lLoc, FALSE, "Spawned"); break;
            case 4:
                oMonster = CreateObject(nType, "dk_agen_boss", lLoc, FALSE, "Spawned"); break;
        }
    }
    else if(GetTag(OBJECT_SELF) == "pl_testarea_3040"){
        switch(nPick){
            case 1: //Ogre
                oMonster = CreateObject(nType, "pl_cr_ogre_001", lLoc, FALSE, "Spawned");
            break;
            case 2: // Vampires
                oMonster = CreateObject(nType, "pl_cd_vamp_00"+IntToString(d4()), lLoc, FALSE, "Spawned");
            break;
            case 3: // Agents
                oMonster = CreateObject(nType, "pl_agent_00"+IntToString(d4()), lLoc, FALSE, "Spawned");
                break;
            case 4: // Apes
                oMonster = CreateObject(nType, "pl_ape_00"+IntToString(d2()), lLoc, FALSE, "Spawned");
                break;
        }
    }
    else if(GetTag(OBJECT_SELF) == "pl_testarea_4050"){
        switch(nPick){
            case 1:
                oMonster = CreateObject(nType, "ms_fr_silento2", lLoc, FALSE, "Spawned");
            break;
            case 2:
                oMonster = CreateObject(nType, "ms_fr_hunter", lLoc, FALSE, "Spawned");
            break;
            case 3:
                oMonster = CreateObject(nType, "ms_sv_dwarf_figh", lLoc, FALSE, "Spawned");
            break;
            case 4:
                oMonster = CreateObject(nType, "pl_gntfrost_001", lLoc, FALSE, "Spawned");
            break;
        }
    }
    else if(GetTag(OBJECT_SELF) == "pl_testarea_5060"){
        switch(d2()){
            case 1:
                oMonster = CreateObject(nType, "ms_iqc_guard", lLoc, FALSE, "Spawned");
            break;
            case 2:
                oMonster = CreateObject(nType, "pl_draco_berserk", lLoc, FALSE, "Spawned");
            break;
        }
    }

    SetLocalInt(oMonster, "Despawn", 1);
}
