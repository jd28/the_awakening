///////////////////////////////////
//: dno_at_rope_1
//: Climb Check for Rope and JumpTo Waypoint.
//: DC 30 on STR & DEX Bonu's +D20 roll.
/////////////////////////////
//: K9-69 ;o)
/////////////
#include "nw_i0_tool"
void main()
{

object oPC = GetPCSpeaker();
if (!GetIsPC(oPC)) return;

int nStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
int nDex = GetAbilityModifier(ABILITY_DEXTERITY, oPC);
int nMod = nStr + nDex;
int nRoll = d20();
int nResult = nMod + nRoll;

if (nResult >= 29)

{
object oWP = GetObjectByTag("dno_WP_Rope_1");

AssignCommand(oPC, JumpToObject(oWP));
SendMessageToPC(oPC, "You have climbed up the rope and are now at the top of the pit.");
DelayCommand(1.5, FloatingTextStringOnCreature("You have climbed up the rope and are now at the top of the pit.", oPC, TRUE));


}
else
if (nResult <= 30)
{
object oFP = GetObjectByTag("dno_WP_Climb_2");

AssignCommand(oPC, JumpToObject(oFP));
ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(4), DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_NORMAL), oPC, 0.0);
SendMessageToPC(oPC, "Your attempt to climb up the rope has failed, you have fallen back down to the bottom of the pit.");
DelayCommand(1.5, FloatingTextStringOnCreature("Your attempt to climb up the rope has failed, you have fallen back down to the bottom of the pit.", oPC, TRUE));

}
}
