void main(){
    int i = 1;
    object oStuff = GetNearestObjectByTag("Spawned", OBJECT_SELF, i);
    while(oStuff != OBJECT_INVALID){
        DelayCommand(2.0, DestroyObject(oStuff));
        i++;
        oStuff = GetNearestObjectByTag("Spawned", OBJECT_SELF, i);
    }
}
