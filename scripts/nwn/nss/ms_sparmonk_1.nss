void main()
{

string sMonk = GetTag(OBJECT_SELF);
string sDummy = "_CD";

object oDummy = GetObjectByTag(sMonk + sDummy);

ActionAttack(oDummy);

}
