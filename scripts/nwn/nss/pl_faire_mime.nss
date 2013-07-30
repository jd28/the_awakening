#include "nw_i0_spells"

void DoMime(){
    float fDelay = GetRandomDelay(3.5, 8.5);
    float fSpeed = GetRandomDelay(0.5, 1.5);
    int nAnimation = Random(18)+2;

    ClearAllActions();
    DelayCommand(0.2, ActionPlayAnimation(nAnimation, fSpeed, fDelay));
    DelayCommand(fDelay + 0.2f, DoMime());
}

void main(){
    DoMime();
}
