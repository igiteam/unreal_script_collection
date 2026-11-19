class SkyAnimBlendByWeaponPickup extends SkyAnimBlendBase
    native;

enum EPickupBlendState
{
    PickupBlend_None,               // 0
    PickupBlend_Get,                // 1
    PickupBlend_Drop,               // 2
    PickupBlend_Swap,               // 3
    PickupBlend_Max                 // 4
};

var transient SkyAnimNodeSequence DropSequenceNode;
