void main() {
	object pc = GetEnteringObject();
	if(!GetIsPC(pc))
		return;

	string tag = GetTag(OBJECT_SELF), resref;
	int i = 1;
	object door = GetNearestObjectByTag(tag, OBJECT_SELF, i);

	while(door != OBJECT_INVALID){
		AssignCommand(door, ActionOpenDoor(door));
		resref = GetLocalString(door, "spawn");
		if(resref == "") resref = "ms_illithi";
		CreateObject(OBJECT_TYPE_CREATURE, resref, GetLocation(door), FALSE, "Spawned");
		door = GetNearestObjectByTag(tag, OBJECT_SELF, ++i);
	}
}
