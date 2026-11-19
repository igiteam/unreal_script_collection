class SkyCameraNodeBlendByMeleeTarget extends SkyCameraNodeBlendList
    native;

enum ECamBlendByMeleeTarget
{
    CamMeleeTarget_None,            // 0
    CamMeleeTarget_NoMeleeTarget,   // 1
    CamMeleeTarget_MeleeTarget,     // 2
    CamMeleeTarget_MAX              // 3
};

var SkyCameraNodeBlendByMeleeTarget.ECamBlendByMeleeTarget CurrentState;
