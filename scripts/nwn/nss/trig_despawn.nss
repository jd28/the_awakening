//This script goes in an OnEnter event to kill
//encounter NPCs that don't belong
void main(){
    object oTrespasser = GetEnteringObject();
    if (GetIsEncounterCreature(oTrespasser))
        DestroyObject(oTrespasser);
}

