#include "pl_dds_inc"

// 1-99 reserved for Bosses

void DDS_100(object oSelf, int nID);
void DDS_100(object oSelf, int nID){
    ApplyExoticResistance(oSelf, 0, 5);
    ApplyMiscImmunities (oSelf, IMMUNITY_TYPE_KNOCKDOWN);

    switch(nID / 10){
        case 0: // 0 - 9
            switch (nID % 10){
                // No 0 ID
                case 1: // 1 -- Auroch
                    ApplyACBonus(oSelf, 6, 6, 6);
                    ApplyMiscDefense(oSelf, 40, 40, 80, TRUE);
                    ApplyPhysicalResistance(oSelf, 20, 20, 20);
                    ApplyElementalImmunities(oSelf, 30, 100, 30, 0, 30);
                    ApplyElementalResistance(oSelf, 40, 0, 0, 15, 0);
                    ApplyPhysicalImmunities(oSelf, 40, 40, 40);
                    ApplyExoticImmunities(oSelf, 30, 50, 30, 30);
                    ApplySoak(oSelf, 5, 40);
                    ApplySoak(oSelf, 6, 20);
                    ApplySoak(oSelf, 8, 10);
                    ApplyDamageShield(oSelf, 60, DAMAGE_BONUS_1d8, DAMAGE_TYPE_COLD);
                break;
                case 2: // 2 - Elder Furthmir, Furthmir the Younger, Yeti Chieftan, Ice Queen
                    ApplyPhysicalResistance(oSelf, 15, 15, 15);
                    ApplyACBonus(oSelf, 6, 6, 6);
                    ApplyMiscDefense(oSelf, 40, 40, 50, TRUE);
                    ApplyElementalImmunities(oSelf, 30, 100, 30, 0, 30);
                    ApplyElementalResistance(oSelf, 40, 0, 0, 15, 0);
                    ApplyPhysicalImmunities(oSelf, 40, 40, 40);
                    ApplyExoticImmunities(oSelf, 30, 30, 30, 30);
                    ApplySoak(oSelf, 5, 40);
                    ApplySoak(oSelf, 6, 20);
                    ApplySoak(oSelf, 8, 10);
                break;
                case 3: // 3 - Emissary Beder, Hodge, Fail Ward/Recycler, Yagnoloth
                    ApplyPhysicalResistance(oSelf, 10, 10, 10);
                    ApplyACBonus(oSelf, 6, 6, 6);
                    ApplyMiscDefense(oSelf, 50, 40, 20, TRUE);
                    ApplyElementalImmunities(oSelf, 20, 20, 20, 20, 20);
                    ApplyElementalResistance(oSelf, 10, 10, 10, 10, 10);
                    ApplyPhysicalImmunities(oSelf, 30, 30, 30);
                    ApplyExoticImmunities(oSelf, 20, 20, 20, 20);
                    ApplySoak(oSelf, 5, 40);
                    ApplySoak(oSelf, 6, 20);
                    ApplySoak(oSelf, 8, 10);
                break;
                case 4: // 4 - King Saleh, Dr. Alfonse Sevarius, Bacchus
                    ApplyPhysicalResistance(oSelf, 15, 15, 15);
                    ApplyACBonus(oSelf, 6, 6, 6);
                    ApplyMiscDefense(oSelf, 50, 40, 20, TRUE);
                    ApplyElementalImmunities(oSelf, 30, 30, 30, 30, 30);
                    ApplyElementalResistance(oSelf, 30, 0, 0, 15, 0);
                    ApplyPhysicalImmunities(oSelf, 40, 40, 40);
                    ApplyExoticImmunities(oSelf, 30, 30, 30, 30);
                    ApplySoak(oSelf, 5, 40);
                    ApplySoak(oSelf, 6, 20);
                    ApplySoak(oSelf, 8, 10);

                break;
                case 5: // 5 - Masterius
                    ApplyPhysicalResistance(oSelf, 15, 15, 15);
                    ApplyACBonus(oSelf, 6, 6, 6);
                    ApplyMiscDefense(oSelf, 50, 40, 20, TRUE);
                    ApplyElementalImmunities(oSelf, 30, 30, 30, 30, 30);
                    ApplyElementalResistance(oSelf, 30, 0, 0, 20, 0);
                    ApplyPhysicalImmunities(oSelf, 40, 40, 40);
                    ApplyExoticImmunities(oSelf, 30, 30, 30, 30);
                    ApplySoak(oSelf, 5, 40);
                    ApplySoak(oSelf, 6, 20);
                    ApplySoak(oSelf, 8, 10);

                break;
                case 6: // 6 - Bacchus
                    ApplyPhysicalResistance(oSelf, 5, 5, 5);
                    ApplyACBonus(oSelf, 4, 4, 4);
                    ApplyMiscDefense(oSelf, 10, 20, 0, TRUE);
                    ApplyElementalImmunities(oSelf, 20, 20, 20, 20, 20);
                    ApplyElementalResistance(oSelf, 5, 5, 5, 5, 5);
                    ApplyPhysicalImmunities(oSelf, 20, 20, 20);
                    ApplyExoticImmunities(oSelf, 20, 20, 20, 20);
                    ApplySoak(oSelf, 5, 40);
                    ApplySoak(oSelf, 6, 20);
                    ApplySoak(oSelf, 8, 10);

                break;
                case 7: // 7 - Drow Matrons, Queen, Temple WM
                    ApplyPhysicalResistance(oSelf, 15, 15, 15);
                    ApplyACBonus(oSelf, 6, 6, 6);
                    ApplyMiscDefense(oSelf, 40, 45, 80, TRUE);
                    ApplyElementalImmunities(oSelf, 30, 30, 30, 30, 30);
                    ApplyElementalResistance(oSelf, 30, 5, 5, 30, 5);
                    ApplyPhysicalImmunities(oSelf, 30, 30, 30);
                    ApplyExoticImmunities(oSelf, 30, 30, 100, 30);
                    ApplySoak(oSelf, 5, 40);
                    ApplySoak(oSelf, 6, 20);
                    ApplySoak(oSelf, 8, 10);

                break;
                case 8: // 8 - Akadi Lord of Air
                    ApplyACBonus(oSelf, 6, 6, 6);
                    ApplyMiscDefense(oSelf, 40, 45, 80, TRUE);
                    ApplyPhysicalResistance(oSelf, 15, 15, 15);
                    ApplyElementalImmunities(oSelf, 20, 20, 20, 20, 20);
                    ApplyElementalResistance(oSelf, 30, 5, 5, 30, 5);
                    ApplyPhysicalImmunities(oSelf, 20, 20, 20);
                    ApplyExoticImmunities(oSelf, 20, 20, 20, 20);
                    ApplySoak(oSelf, 5, 40);
                    ApplySoak(oSelf, 6, 20);
                    ApplySoak(oSelf, 8, 10);
                break;
                case 9: // 9 - Kussuth, Sultun of Fire
                    ApplyACBonus(oSelf, 6, 6, 6);
                    ApplyMiscDefense(oSelf, 40, 45, 80, TRUE);
                    ApplyPhysicalResistance(oSelf, 15, 15, 15);
                    ApplyElementalImmunities(oSelf, 20, 0, 20, 100, 20);
                    ApplyElementalResistance(oSelf, 30, 5, 5, 30, 5);
                    ApplyPhysicalImmunities(oSelf, 20, 20, 20);
                    ApplyExoticImmunities(oSelf, 20, 20, 20, 20);
                    ApplySoak(oSelf, 5, 40);
                    ApplySoak(oSelf, 6, 20);
                    ApplySoak(oSelf, 8, 10);

                break;
            }
        break;
        case 1: // 10
            switch (nID % 10){
                case 0: // 10 - Grumbar, Lord of Earth
                    ApplyACBonus(oSelf, 6, 6, 6);
                    ApplyMiscDefense(oSelf, 40, 45, 80, TRUE);
                    ApplyPhysicalResistance(oSelf, 15, 15, 15);
                    ApplyElementalImmunities(oSelf, 20, 20, 20, 20, 20);
                    ApplyElementalResistance(oSelf, 30, 5, 5, 30, 5);
                    ApplyPhysicalImmunities(oSelf, 20, 20, 20);
                    ApplyExoticImmunities(oSelf, 20, 20, 20, 20);
                    ApplySoak(oSelf, 5, 40);
                    ApplySoak(oSelf, 6, 20);
                    ApplySoak(oSelf, 8, 10);

                break;
                case 1: // 11- Lord of water
                    ApplyACBonus(oSelf, 6, 6, 6);
                    ApplyMiscDefense(oSelf, 40, 45, 80, TRUE);
                    ApplyPhysicalResistance(oSelf, 15, 15, 15);
                    ApplyElementalImmunities(oSelf, 20, 20, 20, 60, 20);
                    ApplyElementalResistance(oSelf, 30, 5, 5, 30, 5);
                    ApplyPhysicalImmunities(oSelf, 20, 20, 20);
                    ApplyExoticImmunities(oSelf, 20, 20, 20, 20);
                    ApplySoak(oSelf, 5, 40);
                    ApplySoak(oSelf, 6, 20);
                    ApplySoak(oSelf, 8, 10);
                break;
                case 2: // 12 - Azurax
                    ApplyPhysicalResistance(oSelf, 15, 15, 15);
                    ApplyACBonus(oSelf, 6, 6, 6);
                    ApplyMiscDefense(oSelf, 40, 45, 80, TRUE);
                    ApplyElementalImmunities(oSelf, 30, 30, 30, 30, 30);
                    ApplyElementalResistance(oSelf, 30, 5, 5, 30, 5);
                    ApplyPhysicalImmunities(oSelf, 30, 30, 30);
                    ApplyExoticImmunities(oSelf, 30, 30, 30, 30);
                    ApplySoak(oSelf, 5, 40);
                    ApplySoak(oSelf, 6, 20);
                    ApplySoak(oSelf, 8, 10);

                break;
                case 3: // 13 - Inferno Horrors
                    ApplyMiscDefense(oSelf, 40, 45, 40, TRUE);
                    ApplyPhysicalResistance(oSelf, 15, 15, 15);
                    ApplyACBonus(oSelf, 6, 6, 6);
                    ApplyElementalImmunities(oSelf, 10, -20, 10, 100, 10);
                    ApplyExoticImmunities(oSelf, 10, 10, 10, 10);
                    ApplyPhysicalImmunities(oSelf, 20, 20, 20);
                    ApplySight(oSelf, TRUE);
                    ApplySoak(oSelf, 5, 40);
                    ApplySoak(oSelf, 6, 20);
                    ApplySoak(oSelf, 8, 10);
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
