#include "info_inc"
#include "fky_chat_inc"

void main(){
    object oPC = GetPCSpeaker();
    object oItem = GetLocalObject(oPC, "ITEM_TALK_TO");
    int nNumSpells = GetLocalInt(oItem, VAR_BUFF_ROCK_NUM_SPELLS), i;
    string sName = "Buffitis Rock";

    if(nNumSpells > 0){
        string sMessage = C_WHITE + "Your "+sName+" has the following spells:\n";
        for (i = 1; i <= nNumSpells; i++){
            int iSpell = GetLocalInt(oItem, VAR_BUFF_ROCK_SPELL + IntToString(i));
            int nMeta = GetLocalInt(oItem, VAR_BUFF_ROCK_META + IntToString(i));
            if (iSpell > 0){
                iSpell--; // I added +1 to the spellID when the sequencer was created, so I have to remove it here

                sMessage += "    " + C_WHITE + "#" + IntToString(i) + " " + C_LT_PURPLE + GetSpellName(iSpell);
                if(nMeta > 0){
                    sMessage += " (" + GetMetaMagicName(nMeta) + ")";
                }
                sMessage += "\n";
            }
        }
        SendChatLogMessage(oPC, sMessage + C_END + "\n", oPC, 5);
    }
}
