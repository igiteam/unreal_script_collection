class SkyAnimBlendByTurretTargetVertical extends SkyAnimBlendBase
    native;

enum EAnimBlendByTurretVertical
{
    BlendByTurretVertical_Above,    // 0
    BlendByTurretVertical_Below,    // 1
    BlendByTurretVertical_MAX       // 2
};

var() float UpDegreeLimit;
var() float DownDegreeLimit;
var() name ReferenceBoneName;
var(Sounds) SoundCue AboveSound;
var(Sounds) SoundCue BelowSound;
