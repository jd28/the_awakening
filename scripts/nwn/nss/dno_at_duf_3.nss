///////////////////////////////////
//: dno_at_duf_3
//: UserDefined Event for Dufrat.
//: Moves Dufrat away from PC when disturbed.
/////////////////////////////
//: K9-69 ;o)
/////////////
void main()
    {
      int nUser = GetUserDefinedEventNumber();
      if (nUser == 1008) // OnDisturbed event
      {
        object oDufrat = GetLastDisturbed();
        object oPC = GetLastHostileActor();

AssignCommand(oDufrat, ActionMoveAwayFromObject(oPC, TRUE, 40.0f));


 }
 }
