//::///////////////////////////////////////////////
//:: Tailoring - Dye Helm Color 5
//:: tlr_helmcolor5.nss
//:://////////////////////////////////////////////
/*
    Sets the color to 5.
*/
//:://////////////////////////////////////////////
//:: Created By: Stacy L. Ropella
//:: from Mandragon's mil_tailor
//:://////////////////////////////////////////////
void main()
{
    SetLocalInt(OBJECT_SELF, "ColorToDye", 5);

    ExecuteScript("tlr_dyehelm", OBJECT_SELF);
}
