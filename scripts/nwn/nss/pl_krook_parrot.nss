

void main(){
    int nCount = GetLocalInt(OBJECT_SELF, "ParrotCount");

    switch(nCount){
        case 0:
            ActionSpeakString("*awwwwwk* Woods are lovely dark and deep.");
            nCount++;
        break;
        case 1:
            ActionSpeakString("Promises to keep...*awwwwwk*");
            nCount++;
        break;
        case 2:
            ActionSpeakString("Miles to go... *awwwwwk* ...before I sleep. *awwwwwk*");
            nCount = 0;
        break;
    }

    SetLocalInt(OBJECT_SELF, "ParrotCount", nCount);
}
