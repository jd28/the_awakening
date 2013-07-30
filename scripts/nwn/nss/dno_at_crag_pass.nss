void main()
{
object oPC = GetPCSpeaker();
    if (!GetIsPC(oPC)) return;

CreateItemOnObject("dno_craggy_pass", oPC);

}
