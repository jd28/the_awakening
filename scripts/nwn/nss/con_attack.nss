#include "mon_func_inc"
#include "nw_i0_generic"
void main()
{
    AdjustReputation(GetPCSpeaker(), OBJECT_SELF, -100);
    DetermineCombatRound();
}
