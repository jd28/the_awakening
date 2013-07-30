void main(){
    object oPC = GetPCSpeaker();
    if(GetGold(oPC) < 20000000){
        SpeakString("You haven't 20million!");
        return;
    }
    TakeGoldFromCreature(20000000, oPC, TRUE);
    CreateItemOnObject("pl_krook_bag", oPC);
}
