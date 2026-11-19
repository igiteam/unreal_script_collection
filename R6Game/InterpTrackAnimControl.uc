class InterpTrackAnimControl extends InterpTrack
    native
    collapsecategories
    hidecategories(Object);

struct AnimControlTrackKey
{
    var float StartTime;
    var name AnimSeqName;
    var float AnimStartOffset;
    var float AnimEndOffset;
    var float AnimStartBlendTime;
    var float AnimEndBlendTime;
    var float AnimPlayRate;
    var bool bLooping;
    var bool bKeepAnimAtLastFrame;

    structdefaultproperties
    {
        StartTime=0.0000000
        AnimSeqName="None"
        AnimStartOffset=0.0000000
        AnimEndOffset=0.0000000
        AnimStartBlendTime=0.5000000
        AnimEndBlendTime=0.5000000
        AnimPlayRate=0.0000000
        bLooping=false
        bKeepAnimAtLastFrame=false
    }
};

var() array<AnimSet> AnimSets;
var() bool ApplyRootMotionX;
var() bool ApplyRootMotionY;
var() bool ApplyRootMotionZ;
var() bool ApplyRootYawRotation;
var() bool NoFailCollision;
var() bool ApplyAnimVelocity;
var bool m_bIsFacialAnimTrack;
var name LastAnimPlayed;
var array<AnimControlTrackKey> AnimSeqs;

defaultproperties
{
    ApplyRootMotionX=true
    ApplyRootMotionY=true
    ApplyRootYawRotation=true
    TrackInstClass=Class'InterpTrackInstAnimControl'
    TrackTitle="Anim"
    bOnePerGroup=true
}