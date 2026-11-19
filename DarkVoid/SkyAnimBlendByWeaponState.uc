class SkyAnimBlendByWeaponState extends SkyAnimBlendBase
    native;

enum EAnimBlendByWeaponState
{
    BlendByWeaponState_Unarmed,     // 0
    BlendByWeaponState_Acquiring,   // 1
    BlendByWeaponState_Discarding,  // 2
    BlendByWeaponState_Drawn,       // 3
    BlendByWeaponState_Holstering,  // 4
    BlendByWeaponState_Drawing,     // 5
    BlendByWeaponState_Holstered,   // 6
    BlendByWeaponState_SwitchingHands,// 7
    BlendByWeaponState_Swapping,    // 8
    BlendByWeaponState_MAX          // 9
};

var() bool bPrimary;
