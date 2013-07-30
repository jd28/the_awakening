///////////////////////////////////////////////////////////////////////////////
// file: door_open
// event: OnClose
// description: This script is solely to reopen the new buggy doors like
//      the drawbridge... as PCs will often be seen walking on air.  No
//      settings.
///////////////////////////////////////////////////////////////////////////////
void main(){
    DelayCommand(0.1, AssignCommand(OBJECT_SELF, ActionOpenDoor(OBJECT_SELF)));
}
