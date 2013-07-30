int StartingConditional()
{

    if(!(GetLocalInt(GetPCSpeaker(), "ms_Volran_Kill") == 1))
        return FALSE;

    return TRUE;
}
