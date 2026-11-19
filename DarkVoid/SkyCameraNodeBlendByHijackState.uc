class SkyCameraNodeBlendByHijackState extends SkyCameraNodeBlendList
    native;

enum ECameraBlendByCoverHijackState
{
    CamBlendByHijackState_None,     // 0
    CamBlendByHijackState_Approach, // 1
    CamBlendByHijackState_Idle,     // 2
    CamBlendByHijackState_Melee,    // 3
    CamBlendByHijackState_Failure,  // 4
    CamBlendByHijackState_MAX       // 5
};
