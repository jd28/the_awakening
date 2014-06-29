#include "pl_dds_inc"

void DDS_200(object oSelf, int nID);
void DDS_200(object oSelf, int nID){
    effect eEff;
    nID -= 100;

    // Haste
    eEff = SupernaturalEffect(EffectHaste());
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);

    if(d100() > 50)
        ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_MIND_SPELLS);

    switch(nID / 10){
        case 0: // 0 - 9
            switch (nID % 10){
                case 0: // 100 - Mountain Trolls
                    ApplyPhysicalResistance(oSelf, 5, 5, 5);
                    ApplyACBonus(oSelf, 6, 6, 6);
                    ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_DEATH, IMMUNITY_TYPE_CHARM, IMMUNITY_TYPE_DOMINATE, IMMUNITY_TYPE_FEAR);
                    ApplyElementalImmunities(oSelf, 10, 0, 0, -10, 0);
                    ApplyPhysicalImmunities(oSelf, 10, 10, 10);
                    ApplySight(oSelf, FALSE, TRUE, TRUE);
                break;
                case 1: // 101 - Winter Wolf, Glacial Spider, Snow Leopard
                    ApplyPhysicalResistance(oSelf, 5, 5, 5);
                    ApplyACBonus(oSelf, 6, 6, 6);
                    ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_CHARM, IMMUNITY_TYPE_DOMINATE);
                    ApplyElementalImmunities(oSelf, 0, 100, 0, -20, 0);
                    ApplySight(oSelf, 0, TRUE);
                break;
                case 2: // 102 - Frost Giants, Sentient Ice, Ice Kobolds, Yeti, Ice Elves
                    ApplyPhysicalResistance(oSelf, 15, 15, 15);
                    ApplyACBonus(oSelf, 6, 6, 6);
                    ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_DEATH, IMMUNITY_TYPE_CHARM, IMMUNITY_TYPE_DOMINATE, IMMUNITY_TYPE_FEAR);
                    ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_KNOCKDOWN);
                    ApplyElementalImmunities(oSelf, 0, 100, 0, -20, 0);
                    ApplyExoticImmunities(oSelf, 10, 10, 10, 10);
                    ApplyPhysicalImmunities(oSelf, 20, 20, 20);
                    ApplySight(oSelf, TRUE);
                break;
                case 3: // 103 - Ice Fiend
                    ApplyPhysicalResistance(oSelf, 15, 15, 15);
                    ApplyACBonus(oSelf, 6, 6, 6);
                    ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_DEATH, IMMUNITY_TYPE_CHARM, IMMUNITY_TYPE_DOMINATE, IMMUNITY_TYPE_FEAR);
                    ApplyElementalImmunities(oSelf, 0, 100, 0, -20, 0);
                    ApplyPhysicalImmunities(oSelf, 10, 10, 10);
                    ApplyExoticImmunities(oSelf, 10, 10, 50, 10);
                    SetHealDamage(oSelf, DAMAGE_TYPE_COLD);
                    ApplySight(oSelf, TRUE);
                break;
                case 4: // 104 - Sahuagin
                    ApplyPhysicalResistance(oSelf, 10, 10, 10);
                    ApplyACBonus(oSelf, 6, 6, 6);
                    ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_CHARM, IMMUNITY_TYPE_DOMINATE);
                    ApplySight(oSelf, 0, TRUE);
                break;
                case 5: // 105 - Merfolk, Forest Scavangers, ED's Guardbeasts
                    ApplyPhysicalResistance(oSelf, 10, 10, 10);
                    ApplyACBonus(oSelf, 6, 6, 6);
                    ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_DEATH, IMMUNITY_TYPE_CHARM, IMMUNITY_TYPE_DOMINATE, IMMUNITY_TYPE_FEAR);
                    ApplyElementalImmunities(oSelf, 10, 10, 10, 10, 10);
                    ApplyPhysicalImmunities(oSelf, 10, 10, 10);
                    ApplySight(oSelf, TRUE);
                break;
                case 6: // 106 - Failed Experiments, Maelephants
                    ApplyPhysicalResistance(oSelf, 15, 15, 15);
                    ApplyACBonus(oSelf, 6, 6, 6);
                    ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_DEATH, IMMUNITY_TYPE_CHARM, IMMUNITY_TYPE_DOMINATE, IMMUNITY_TYPE_FEAR);
                    ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_KNOCKDOWN);
                    ApplyElementalResistance(oSelf, 5, 5, 5, 5, 5);
                    ApplyElementalImmunities(oSelf, 10, 10, 10, 10, 10);
                    ApplyExoticImmunities(oSelf, 10, 10, 50, 10);
                    ApplyPhysicalImmunities(oSelf, 15, 15, 15);
                    ApplySight(oSelf, TRUE);
                break;
                case 7: // 107 - Umber Hulks
                    ApplyPhysicalResistance(oSelf, 10, 10, 10);
                    ApplyACBonus(oSelf, 6, 6, 6);
                    ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_DEATH, IMMUNITY_TYPE_CHARM, IMMUNITY_TYPE_DOMINATE, IMMUNITY_TYPE_FEAR);
                    ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_KNOCKDOWN);
                    ApplyElementalResistance(oSelf, 5, 5, 5, 5, 5);
                    ApplyElementalImmunities(oSelf, 10, 10, 10, 10, 10);
                    ApplyExoticImmunities(oSelf, 10, 10, 50, 10);
                    ApplyPhysicalImmunities(oSelf, 15, 15, 15);
                    ApplySight(oSelf, TRUE);
                break;
                case 8: // 108 - Drow
                    ApplyPhysicalResistance(oSelf, 15, 15, 15);
                    ApplyACBonus(oSelf, 6, 6, 6);
                    ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_DEATH, IMMUNITY_TYPE_CHARM, IMMUNITY_TYPE_DOMINATE, IMMUNITY_TYPE_FEAR);
                    ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_KNOCKDOWN);
                    ApplyElementalResistance(oSelf, 30, 5, 5, 30, 5);
                    ApplyElementalImmunities(oSelf, 30, 30, 30, 30, 30);
                    ApplyExoticImmunities(oSelf, 25, 25, 100, 25);
                    ApplyPhysicalImmunities(oSelf, 20, 20, 20);
                    ApplySight(oSelf, TRUE);
                break;
                case 9: // 109 - Living Darkness
                    ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_DEATH, IMMUNITY_TYPE_CHARM, IMMUNITY_TYPE_DOMINATE, IMMUNITY_TYPE_FEAR);
                    ApplySpellImmunities(oSelf, SPELL_HARM);
                    ApplySpellImmunities(oSelf, SPELL_BIGBYS_CRUSHING_HAND, SPELL_BIGBYS_FORCEFUL_HAND, SPELL_BIGBYS_GRASPING_HAND, SPELL_DROWN);
                    ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_KNOCKDOWN, IMMUNITY_TYPE_CRITICAL_HIT, IMMUNITY_TYPE_SNEAK_ATTACK);
                    ApplyElementalImmunities(oSelf, 90, 90, 90, 90, 90);
                    ApplyExoticImmunities(oSelf, 90, 90, 90, 90);
                    ApplyPhysicalImmunities(oSelf, 90, 90, 90);
                    ApplySight(oSelf, TRUE);
                    ApplyMiscDefense(oSelf, 50, 45, 30, TRUE);
                break;
            }
        break;
        case 1: // 110
            switch (nID % 10){
                case 0: // 110 - Ancient Fire Elementals
                    ApplyPhysicalResistance(oSelf, 15, 15, 15);
                    ApplyACBonus(oSelf, 6, 6, 6);
                    ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_DEATH, IMMUNITY_TYPE_CHARM, IMMUNITY_TYPE_DOMINATE, IMMUNITY_TYPE_FEAR);
                    ApplyElementalImmunities(oSelf, 0, -20, 0, 100, 0);
                    ApplyExoticImmunities(oSelf, 10, 10, 10, 10);
                    ApplyPhysicalImmunities(oSelf, 20, 20, 20);
                    ApplySight(oSelf, TRUE);
                break;
                case 1: // 111 - Ancient Air Elementals
                    ApplyPhysicalResistance(oSelf, 15, 15, 15);
                    ApplyACBonus(oSelf, 6, 6, 6);
                    ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_DEATH, IMMUNITY_TYPE_CHARM, IMMUNITY_TYPE_DOMINATE, IMMUNITY_TYPE_FEAR);
                    ApplyElementalImmunities(oSelf, 0, 0, 0, 0, 0);
                    ApplyExoticImmunities(oSelf, 10, 10, 10, 10);
                    ApplyPhysicalImmunities(oSelf, 20, 20, 20);
                    ApplySight(oSelf, TRUE);
                break;
                case 2: // 112 - Ancient Water Elementals
                    ApplyPhysicalResistance(oSelf, 15, 15, 15);
                    ApplyACBonus(oSelf, 6, 6, 6);
                    ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_DEATH, IMMUNITY_TYPE_CHARM, IMMUNITY_TYPE_DOMINATE, IMMUNITY_TYPE_FEAR);
                    ApplyElementalImmunities(oSelf, 0, 0, 0, 0, 0);
                    ApplyExoticImmunities(oSelf, 10, 10, 10, 10);
                    ApplyPhysicalImmunities(oSelf, 20, 20, 20);
                    ApplySight(oSelf, TRUE);
                break;
                case 3: // 113 - Ancient Earth Elementals.
                    ApplyPhysicalResistance(oSelf, 15, 15, 15);
                    ApplyACBonus(oSelf, 6, 6, 6);
                    ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_DEATH, IMMUNITY_TYPE_CHARM, IMMUNITY_TYPE_DOMINATE, IMMUNITY_TYPE_FEAR);
                    ApplyElementalImmunities(oSelf, 0, 0, 0, 0, 0);
                    ApplyExoticImmunities(oSelf, 10, 10, 10, 10);
                    ApplyPhysicalImmunities(oSelf, 20, 20, 20);
                    ApplySight(oSelf, TRUE);
                break;
                case 4: // 114
                    ApplyPhysicalResistance(oSelf, 15, 15, 15);
                    ApplyACBonus(oSelf, 6, 6, 6);
                    ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_DEATH, IMMUNITY_TYPE_CHARM, IMMUNITY_TYPE_DOMINATE, IMMUNITY_TYPE_FEAR);
                    ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_KNOCKDOWN);
                    ApplyElementalResistance(oSelf, 30, 5, 5, 30, 5);
                    ApplyElementalImmunities(oSelf, 30, 30, 30, 30, 30);
                    ApplyExoticImmunities(oSelf, 25, 25, 25, 25);
                    ApplyPhysicalImmunities(oSelf, 20, 20, 20);
                    ApplySight(oSelf, TRUE);
                break;
                case 5: // 115
                    ApplyPhysicalResistance(oSelf, 15, 15, 15);
                    ApplyACBonus(oSelf, 6, 6, 6);
                    ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_DEATH, IMMUNITY_TYPE_CHARM, IMMUNITY_TYPE_DOMINATE, IMMUNITY_TYPE_FEAR);
                    ApplyElementalResistance(oSelf, 30, 5, 5, 30, 5);
                    ApplyElementalImmunities(oSelf, 30, 30, 30, 30, 30);
                    ApplyExoticImmunities(oSelf, 25, 25, 25, 25);
                    ApplyPhysicalImmunities(oSelf, 20, 20, 20);
                    ApplySight(oSelf, TRUE);
                break;
                case 6: // 116 - Dark Order Monks
                    ApplyPhysicalResistance(oSelf, 5, 5, 5);
                    ApplyACBonus(oSelf, 2, 2, 2);
                    ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_DEATH, IMMUNITY_TYPE_CHARM, IMMUNITY_TYPE_DOMINATE, IMMUNITY_TYPE_FEAR);
                    ApplyElementalResistance(oSelf, 30, 5, 5, 30, 5);
                    ApplyElementalImmunities(oSelf, 10, 10, 10, 10, 10);
                    ApplyExoticImmunities(oSelf, 15, 15, 15, 15);
                    ApplyPhysicalImmunities(oSelf, 10, 10, 10);
                    ApplySight(oSelf, TRUE);
                break;
                case 7: // 7
                break;
                case 8: // 8
                break;
                case 9: // 9
                break;
            }
        break;
        case 2: // 20
            switch (nID % 10){
                case 0: // 0
                break;
                case 1: // 1
                break;
                case 2: // 2
                break;
                case 3: // 3
                break;
                case 4: // 4
                break;
                case 5: // 5
                break;
                case 6: // 6
                break;
                case 7: // 7
                break;
                case 8: // 8
                break;
                case 9: // 9
                break;
            }
        break;
        case 3: // 30
            switch (nID % 10){
                case 0: // 0
                break;
                case 1: // 1
                break;
                case 2: // 2
                break;
                case 3: // 3
                break;
                case 4: // 4
                break;
                case 5: // 5
                break;
                case 6: // 6
                break;
                case 7: // 7
                break;
                case 8: // 8
                break;
                case 9: // 9
                break;
            }
        break;
        case 4: // 40
            switch (nID % 10){
                case 0: // 0
                break;
                case 1: // 1
                break;
                case 2: // 2
                break;
                case 3: // 3
                break;
                case 4: // 4
                break;
                case 5: // 5
                break;
                case 6: // 6
                break;
                case 7: // 7
                break;
                case 8: // 8
                break;
                case 9: // 9
                break;
            }
        break;
        case 5: // 50
            switch (nID % 10){
                case 0: // 0
                break;
                case 1: // 1
                break;
                case 2: // 2
                break;
                case 3: // 3
                break;
                case 4: // 4
                break;
                case 5: // 5
                break;
                case 6: // 6
                break;
                case 7: // 7
                break;
                case 8: // 8
                break;
                case 9: // 9
                break;
            }
        break;
        case 6: // 60
            switch (nID % 10){
                case 0: // 0
                break;
                case 1: // 1
                break;
                case 2: // 2
                break;
                case 3: // 3
                break;
                case 4: // 4
                break;
                case 5: // 5
                break;
                case 6: // 6
                break;
                case 7: // 7
                break;
                case 8: // 8
                break;
                case 9: // 9
                break;
            }
        break;
        case 7: // 70
            switch (nID % 10){
                case 0: // 0
                break;
                case 1: // 1
                break;
                case 2: // 2
                break;
                case 3: // 3
                break;
                case 4: // 4
                break;
                case 5: // 5
                break;
                case 6: // 6
                break;
                case 7: // 7
                break;
                case 8: // 8
                break;
                case 9: // 9
                break;
            }
        break;
        case 8: // 80
            switch (nID % 10){
                case 0: // 0
                break;
                case 1: // 1
                break;
                case 2: // 2
                break;
                case 3: // 3
                break;
                case 4: // 4
                break;
                case 5: // 5
                break;
                case 6: // 6
                break;
                case 7: // 7
                break;
                case 8: // 8
                break;
                case 9: // 9
                break;
            }
        break;
        case 9: // 90
            switch (nID % 10){
                case 0: // 0
                break;
                case 1: // 1
                break;
                case 2: // 2
                break;
                case 3: // 3
                break;
                case 4: // 4
                break;
                case 5: // 5
                break;
                case 6: // 6
                break;
                case 7: // 7
                break;
                case 8: // 8
                break;
                case 9: // 9
                break;
            }
        break;

        default:
            // flag error no ID.
    }
}
