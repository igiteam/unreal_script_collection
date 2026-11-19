class SkyAnimBlendByDigitalStickDirection extends SkyAnimBlendBase
    native;

enum EBlendByDigitalStickDirectionMode
{
    BlendByDigitalStickDirectionMode_Normal,// 0
    BlendByDigitalStickDirectionMode_UpDown,// 1
    BlendByDigitalStickDirectionMode_LeftRight,// 2
    BlendByDigitalStickDirectionMode_MAX// 3
};

enum EBlendByDigitalStickDirection
{
    BlendByDigitalStickDirection_None,// 0
    BlendByDigitalStickDirection_Up,// 1
    BlendByDigitalStickDirection_Right,// 2
    BlendByDigitalStickDirection_Down,// 3
    BlendByDigitalStickDirection_Left,// 4
    BlendByDigitalStickDirection_MAX// 5
};

var() SkyAnimBlendByDigitalStickDirection.EBlendByDigitalStickDirectionMode Mode;
