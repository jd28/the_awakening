void main()
{
object oPC = GetPCSpeaker();
    if (!GetIsPC(oPC)) return;


CreateItemOnObject("ms_basementkey", oPC);
}
