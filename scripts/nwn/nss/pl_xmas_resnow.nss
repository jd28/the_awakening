#include "gsp_func_inc"

void main(){
    object self = OBJECT_SELF;
    string res = GetResRef(self);
    location loc = GetLocation(self);
    if (res == "pl_snowman_fk001") {
        ApplyVisualAtLocation(VFX_FNF_STRIKE_HOLY, loc);
        CreateObject(OBJECT_TYPE_ITEM, "pl_xmas_key", loc);

    }
    else {
        struct SpellInfo si;
        si.dc = 84;
        si.caster = self;
        si.clevel = 60;
        si.loc = loc;
        si.sp = -1;

        struct SpellImpact impact = CreateSpellImpact();
        int nCap;
        effect eEff;

        nCap             = 60;
        impact.bStorm    = TRUE;
        impact.nSave     = SAVING_THROW_FORT;
        impact.nDamDice2 = -2;
        impact.nDamSides = 20;
        impact.nDamType  = DAMAGE_TYPE_COLD;
        impact.nDamType2 = DAMAGE_TYPE_BLUDGEONING;
        impact.nImpact   = VFX_IMP_FROST_S;
        
        ApplyVisualAtLocation(VFX_FNF_ICESTORM, si.loc);

        struct FocusBonus fb = GetOffensiveFocusBonus(si.caster, SPELL_SCHOOL_EVOCATION, nCap);
        impact.nDamDice = 80;
        ApplySpellImpactToShape(si, impact, fb);
    }

    DelayCommand(1200.0f, ObjectToVoid(CreateObject(OBJECT_TYPE_PLACEABLE, res, loc)));
}

