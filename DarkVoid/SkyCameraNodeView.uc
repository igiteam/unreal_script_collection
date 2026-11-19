class SkyCameraNodeView extends SkyCameraNode
    native;

enum EUpVectorOptions
{
    UVO_UseWorldUp,                 // 0
    UVO_UseConstraintUp,            // 1
    UVO_UseExternalConstraintUp,    // 2
    UVO_MAX                         // 3
};

struct native s_ConstraintAtom
{
    var SkyCameraTreeObject.SKYCAMERA_CONSTRAINT Constraint;
    var() Vector Translation;
    var() s_RotatorDegrees Rotation;
    var() float Scale;
    var bool bAlignController;
    var name Joint;

    structdefaultproperties
    {
        Constraint=THE_PLAYER
        Translation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Rotation=(PitchDegrees=0.0000000,YawDegrees=0.0000000,RollDegrees=0.0000000)
        Scale=0.0000000
        bAlignController=false
        Joint="None"
    }
};

struct native s_FocusConstraintAtom
{
    var SkyCameraTreeObject.SKYCAMERA_CONSTRAINT Constraint;
    var() Vector Translation;
    var() s_RotatorDegrees Rotation;
    var() float Scale;
    var bool bAlignController;
    var() float FocusDistance;

    structdefaultproperties
    {
        Constraint=THE_PLAYER
        Translation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Rotation=(PitchDegrees=0.0000000,YawDegrees=0.0000000,RollDegrees=0.0000000)
        Scale=0.0000000
        bAlignController=false
        FocusDistance=0.0000000
    }
};

struct native s_ExternalFocusConstraintAtom
{
    var() SkyCameraTreeObject.SKYCAMERA_CONSTRAINT Constraint;
    var() Vector Translation;
    var() s_RotatorDegrees Rotation;
    var() float Scale;

    structdefaultproperties
    {
        Constraint=THE_PLAYER
        Translation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Rotation=(PitchDegrees=0.0000000,YawDegrees=0.0000000,RollDegrees=0.0000000)
        Scale=0.0000000
    }
};

struct native SOffsetData
{
    var SkyCameraTreeObject.SKYCAMERA_CONSTRAINT Constraint;
    var name Joint;
    var Vector Translation;
    var Rotator Rotation;
    var bool bRespectMirroring;
    var bool bRelativeToConstraint;
    var Vector AdditionalOffset;

    structdefaultproperties
    {
        Constraint=THE_PLAYER
        Joint="None"
        Translation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Rotation=(Pitch=0,Yaw=0,Roll=0)
        bRespectMirroring=false
        bRelativeToConstraint=false
        AdditionalOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct native SCameraOffsetData
{
    var() SkyCameraTreeObject.SKYCAMERA_CONSTRAINT Constraint;
    var() name Joint;
    var() Vector Translation;
    var deprecated bool bRespectMirroring;
    var Vector AdditionalOffset;

    structdefaultproperties
    {
        Constraint=THE_PLAYER
        Joint="None"
        Translation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        AdditionalOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct native SExternalFocusData
{
    var() SkyCameraTreeObject.SKYCAMERA_CONSTRAINT Constraint;
    var() name Joint;
    var() Vector Translation;
    var deprecated bool bRespectMirroring;
    var() SkyCameraNodeView.EUpVectorOptions UpVector;

    structdefaultproperties
    {
        Constraint=THE_PLAYER
        Joint="None"
        Translation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        UpVector=UVO_UseWorldUp
    }
};

struct native SSafeLocationData
{
    var() SkyCameraTreeObject.SKYCAMERA_CONSTRAINT Constraint;
    var() name Joint;
    var() Vector Translation;
    var deprecated bool bRespectMirroring;
    var() bool bRelativeToConstraint;
    var Vector AdditionalOffset;

    structdefaultproperties
    {
        Constraint=THE_PLAYER
        Joint="None"
        Translation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        bRelativeToConstraint=false
        AdditionalOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct native SAutoPitchParams
{
    var() float WaitTime;
    var() float Speed;
    var() float MinAngle;
    var() float DesiredAngle;

    structdefaultproperties
    {
        WaitTime=0.0000000
        Speed=0.0000000
        MinAngle=0.0000000
        DesiredAngle=0.0000000
    }
};

var() bool bShowCameraMesh;
var() bool bDisableCollision;
var() bool bDisableCollisionPrediction;
var() bool bDisableCollisionAllActors;
var() bool bRespectFootDisplacement;
var() bool bAdjustRotWhenAvoidingCollision;
var Matrix LeafCameraMatrix;
var() SAutoPitchParams AutoPitchParams;
var() SkyCameraTreeObject.EAlignControllerMode AlignControllerMode;
var() SkyCameraTreeObject.SKYCAMERA_CONSTRAINT DisableCollisionConstraint;
var SkyCameraTreeObject.EAlignControllerModeOffset AlignControllerModeOverride;
var SkyCameraTreeObject.EFlagOffset DisableCollisionOverride;
var SkyCameraTreeObject.EFlagOffset DisableCollisionPredictionOverride;
var SkyCameraTreeObject.EFlagOffset RespectFootDisplacementOverride;
var() SCameraOffsetData CameraPosition;
var() SCameraOffsetData FocusPosition;
var SCameraOffsetData PivotPosition;
var() SExternalFocusData ExternalFocus;
var() SSafeLocationData SafeLocation;
var() float CamFOVAngle;
var float AdditionalFOVOffset;
var() float CamPitchMin;
var() float CamPitchMax;
var() float CollSmoothInSpeed;
var() float CollSmoothOutSpeed;
var() float CollWaitForSmoothOutTime;
var() name PreviewPlayerAnim;
var() name PreviewVehicleAnim;
var() name PreviewExternalAnim;
var Rotator ConstraintRot;
