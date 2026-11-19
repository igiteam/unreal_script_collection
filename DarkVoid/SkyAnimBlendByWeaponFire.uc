class SkyAnimBlendByWeaponFire extends SkyAnimBlendBase
    native;

enum EAnimBlendByWeaponFire
{
    BlendByWeaponFire_None,         // 0
    BlendByWeaponFire_Charge,       // 1
    BlendByWeaponFire_Fire,         // 2
    BlendByWeaponFire_Cool,         // 3
    BlendByWeaponFire_Max           // 4
};

var() bool bUseAuxWeapon;
var() int AuxWeaponIndex;
