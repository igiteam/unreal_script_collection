class R6KitRestrictionInfo extends Object
    native;

enum eKitRestrictionType
{
    eKitRstr_ForbidClass,           // 0
    eKitRstr_OnlyWeaponClass,       // 1
    eKitRstr_ForbidWeaponSuppressor,// 2
    eKitRstr_ForceWeaponSuppressor, // 3
    eKitRstr_ForbidGadgetsNonExplosive,// 4
    eKitRstr_ForbidGadgetsExplosive,// 5
    eKitRstr_NoAlternateVision,     // 6
    eKitRstr_NoTakeCover,           // 7
    eKitRstr_NoBlindFire,           // 8
    eKitRstr_NoBlindFireFog,        // 9
    eKitRstr_NoArmor,               // 10
    eKitRstr_MAX                    // 11
};

var R6KitRestrictionInfo.eKitRestrictionType m_Type;
var class<Inventory> m_pClass;

defaultproperties
{
    m_Type=255
}