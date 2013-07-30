void main()
{

object oPC = GetLastClosedBy();
        if (!GetIsPC(oPC)) return;

object oSelf = OBJECT_SELF;

object oLight = GetObjectByTag("dno_Axie_Light");

object oEye = GetItemPossessedBy(oSelf, "dno_Axie_Eye");
      if (GetIsObjectValid(oEye)) return;

 {

DestroyObject(oLight, 0.5);
        }
     return;
}
