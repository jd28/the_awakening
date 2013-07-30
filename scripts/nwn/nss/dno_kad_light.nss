void main()
{

object oPC = GetLastClosedBy();
        if (!GetIsPC(oPC)) return;

object oSelf = OBJECT_SELF;

object oLight = GetObjectByTag("dno_Kad_Light");

//if (GetItemPossessor(GetObjectByTag("dno_Kad_Eye")) != oSelf)



object oEye = GetItemPossessedBy(oSelf, "dno_Kad_Eye");
      if (GetIsObjectValid(oEye)) return;

 {

DestroyObject(oLight, 0.5);
        }
     return;
}
