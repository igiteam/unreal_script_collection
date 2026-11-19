class AdvInterpTrackCameraEvent extends InterpTrack
    native(Sequence)
    collapsecategories
    hidecategories(Object);

enum EMatineeCameraEvent
{
    MCE_None,                       // 0
    MCE_EnableLook,                 // 1
    MCE_DisableLook,                // 2
    MCE_PlayerOutStart,             // 3
    MCE_PlayerOutFinish,            // 4
    MCE_PlayerInStart,              // 5
    MCE_PlayerInFinish,             // 6
    MCE_MAX                         // 7
};

struct native CameraEventTrackKey
{
    var float Time;
    var() AdvInterpTrackCameraEvent.EMatineeCameraEvent EventType;

    structdefaultproperties
    {
        Time=0.0000000
        EventType=EMatineeCameraEvent.MCE_None
    }
};

var array<CameraEventTrackKey> EventTrack;
var() bool bFireEventsWhenForwards;
var() bool bFireEventsWhenBackwards;
var() bool bFireEventsWhenJumpingForwards;
var() bool bAutomaticMeshVisibility;
var() bool bSkipMeshAdjustmentOnBlend;
var() bool bAdvancedMeshBlending;
var() bool bFinishCrouching;

defaultproperties
{
    bFireEventsWhenForwards=true
    bFireEventsWhenBackwards=true
    bAutomaticMeshVisibility=true
    TrackInstClass=Class'AdvInterpTrackInstCameraEvent'
    TrackTitle="Camera Event"
    bOnePerGroup=true
    bDirGroupOnly=true
}