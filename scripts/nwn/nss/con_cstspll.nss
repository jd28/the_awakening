void main(){
    int nSpell = GetLocalInt(OBJECT_SELF, "CastSpell") - 1;
    ActionCastSpellAtObject(nSpell, GetPCSpeaker());

}
