class SkyAnimBlendByArmor extends SkyAnimBlendBase
    native;

enum EAnimBlendByArmor
{
    BlendByArmor_Active,            // 0
    BlendByArmor_Destroyed,         // 1
    BlendByArmor_MAX                // 2
};

var() SkyPawn.EArmorType ArmorType;
