#include "mod_const_inc"

void main()
{
    object oPC = GetEnteringObject();

    SendMessageToPC(oPC, C_WHITE+"You hear from the mineshaft before you a strange and momentary echo that seems a dwarven voice singing: "+C_END);
    SendMessageToPC(oPC, C_WHITE+"Dig, dig, I dig and dig, dig; and I dig my life away-o."+C_END);
}
