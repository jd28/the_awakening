void main()
{
object oPC = GetPCSpeaker();
    if (!GetIsPC(oPC)) return;

CreateItemOnObject("dno_keeper_gift", oPC);

}
