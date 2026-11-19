class SkyAnimBlendByTurretFacing extends SkyAnimBlendBase
    native;

enum EAnimBlendByTurretFacing
{
    BlendByTurretFacing_Away,       // 0
    BlendByTurretFacing_Towards,    // 1
    BlendByTurretFacing_MAX         // 2
};

enum EFacingTowards
{
    EFRT_Target,                    // 0
    EFRT_MAX                        // 1
};

var() float LeftDegreeLimit;
var() float RightDegreeLimit;
var() name ReferenceBoneName;
var() SkyAnimBlendByTurretFacing.EFacingTowards FacingRelativeTo;
var(Sounds) SoundCue AwaySound;
var(Sounds) SoundCue TowardsSound;
