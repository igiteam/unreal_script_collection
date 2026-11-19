class SkyCameraNodeBlendBase extends SkyCameraNode
    abstract
    native;

enum ERotationDirection
{
    CamRot_None,                    // 0
    CamRot_CW,                      // 1
    CamRot_CCW,                     // 2
    CamRot_MAX                      // 3
};

struct native CameraBlendChild
{
    var() name Name;
    var() export editinline SkyCameraNode CameraNode;
    var float InitialWeight;
    var float Weight;
    var int DrawY;
    var s_CameraTransformInfo LastTransformInfo;
    var SkyCameraNodeBlendBase.ERotationDirection eYawDir;
    var SkyCameraNodeBlendBase.ERotationDirection ePitchDir;

    structdefaultproperties
    {
        Name="None"
        CameraNode=none
        InitialWeight=0.0000000
        Weight=0.0000000
        DrawY=0
        LastTransformInfo=(CamPos=(X=0.0000000,Y=0.0000000,Z=0.0000000),CamRot=(Pitch=0,Yaw=0,Roll=0),CamFocus=(X=0.0000000,Y=0.0000000,Z=0.0000000),CamPivot=(X=0.0000000,Y=0.0000000,Z=0.0000000),CamUpVect=(X=0.0000000,Y=0.0000000,Z=1.0000000),CamFOVAngle=0.0000000,CamPitchMin=0.0000000,CamPitchMax=0.0000000,bDisableCollision=false,bDisableCollisionPrediction=false,CamSafeLoc=(X=0.0000000,Y=0.0000000,Z=0.0000000),ConstraintPos=(X=0.0000000,Y=0.0000000,Z=0.0000000),FocusConstraintPos=(X=0.0000000,Y=0.0000000,Z=0.0000000),PivotConstraintPos=(X=0.0000000,Y=0.0000000,Z=0.0000000),SafeLocConstraintPos=(X=0.0000000,Y=0.0000000,Z=0.0000000),ConstraintRot=(Pitch=0,Yaw=0,Roll=0),FocusConstraintRot=(Pitch=0,Yaw=0,Roll=0),PivotConstraintRot=(Pitch=0,Yaw=0,Roll=0),SafeLocConstraintRot=(Pitch=0,Yaw=0,Roll=0),CollSmoothInSpeed=0.0000000,CollSmoothOutSpeed=0.0000000,CollWaitForSmoothOutTime=0.0000000,AutoPitchWaitTime=0.0000000,AutoPitchSpeed=0.0000000,AutoPitchMinAngle=0.0000000,AutoPitchDesiredAngle=0.0000000)
        eYawDir=CamRot_None
        ePitchDir=CamRot_None
    }
};

var SkyCameraNodeBlendBase.ERotationDirection eForceRotDirPitch;
var SkyCameraNodeBlendBase.ERotationDirection eForceRotDirYaw;
var s_CameraTransformInfo LastTransformInfo;
var Rotator rStartBlendRot;
var export editinline array<export editinline CameraBlendChild> Children;
var bool bFixNumChildren;
var bool bRenameChildrenOnRemove;
var() bool bContinuousBlend;
var float fCurrentContinuousBlendValue;
