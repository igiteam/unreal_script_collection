class SkyBTNode_Cond_HasAmmo extends SkyBTNode_Leaf_Condition
    native;

enum WhichWeapon
{
    WW_Primary,                     // 0
    WW_Secondary,                   // 1
    WW_Auxiliary,                   // 2
    WW_MAX                          // 3
};

var(AmmoTest) SkyBTNode_Cond_HasAmmo.WhichWeapon WeaponToCheck;
var(AmmoTest) int AuxiliaryIndex;
