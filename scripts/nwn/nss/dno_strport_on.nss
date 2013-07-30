
void main()
{

object oSpire1 = GetObjectByTag("dno_inv_Spire_1");
object oSpire2 = GetObjectByTag("dno_inv_Spire_2");
object oSpire3 = GetObjectByTag("dno_inv_Spire_3");
object oSpire4 = GetObjectByTag("dno_inv_Spire_4");
object oSwitch = GetObjectByTag("dno_inv_Switch_5");
object oTarget = GetObjectByTag("dno_inv_Portal_6");
object oPortal = GetObjectByTag("dno_Portal_044_1");

effect eBeam1 = EffectBeam(VFX_BEAM_SILENT_ODD, oSpire1, BODY_NODE_CHEST);
effect eBeam2 = EffectBeam(VFX_BEAM_SILENT_ODD, oSpire2, BODY_NODE_CHEST);
effect eBeam3 = EffectBeam(VFX_BEAM_SILENT_ODD, oSpire3, BODY_NODE_CHEST);
effect eBeam4 = EffectBeam(VFX_BEAM_SILENT_ODD, oSpire4, BODY_NODE_CHEST);
effect eBeam5 = EffectBeam(VFX_BEAM_ODD, oSwitch, BODY_NODE_CHEST);


int nActive = GetLocalInt (OBJECT_SELF,"X2_L_PLC_ACTIVATED_STATE");

    if (!nActive)
    {
      ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);

DelayCommand(3.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBeam5, oTarget));
DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBeam1, oTarget));
DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBeam2, oTarget));
DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBeam3, oTarget));
DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBeam4, oTarget));

DelayCommand(6.0, SetUseableFlag(oPortal, TRUE));
    }
    else
    {
      ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE);

effect eTarget = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eTarget))
    {
    if (GetEffectDurationType(eTarget) == DURATION_TYPE_PERMANENT)
    {
    RemoveEffect(oTarget, eTarget);
    }
    eTarget = GetNextEffect(oTarget);
    }



    }

    SetLocalInt(OBJECT_SELF,"X2_L_PLC_ACTIVATED_STATE",!nActive);
    SetUseableFlag(oPortal, FALSE);


}
