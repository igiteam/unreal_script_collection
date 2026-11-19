class SkyCameraNodeBlendByFreeFall extends SkyCameraNodeBlendList
    native;

enum ECamBlendByFreeFall
{
    CamFreeFall_None,               // 0
    CamFreeFall_NoFreeFall,         // 1
    CamFreeFall_FreeFall,           // 2
    CamFreeFall_MAX                 // 3
};

var SkyCameraNodeBlendByFreeFall.ECamBlendByFreeFall CurrentState;
