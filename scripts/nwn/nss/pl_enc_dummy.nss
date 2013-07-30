#include "nwnx_inc"

void main() {
    JumpToLimbo(OBJECT_SELF);

    DelayCommand(20.0f, DestroyObject(OBJECT_SELF));
}


