class SkelControlPALookAt extends SkelControlLOD
    native
    hidecategories(Object);

var() editconst transient CCRig Rig;
var transient SkelControlLookAtRules LAControl;
var transient SkelControlPA PAControl;
var() editconst transient CCAttitude Attitude;
var() transient bool bVerbose;
var() transient bool bShowLimit;
var(LookAt) editconst transient bool bTargetIsActive;
var transient bool bInvertLookAtAxis;
var transient bool bDefineUpAxis;
var transient bool bInvertUpAxis;
var transient bool bInvertCorrectionBoneLookAtAxis;
var transient bool bInvertCorrectionBoneUpAxis;
var transient bool bInitialized;
var transient bool bInvertYawBoneLookAtAxis;
var transient bool bInvertYawBoneUpAxis;
var transient bool bUseCorrectionBone;
var transient bool bEnableLimit;
var transient bool bInvertParentLookAtAxis;
var transient bool bInvertParentUpAxis;
var transient bool bUsePyramid;
var(LookAt) editconst transient Vector TargetLocation;
var(LookAt) editconst transient SkelControlBase.EBoneControlSpace TargetLocationSpace;
var transient Object.EAxis LookAtAxis;
var transient Object.EAxis UpAxis;
var transient Object.EAxis CorrectionBoneLookAtAxis;
var transient Object.EAxis CorrectionBoneUpAxis;
var transient Object.EAxis YawBoneLookAtAxis;
var transient Object.EAxis YawBoneUpAxis;
var transient Object.EAxis ParentLookAtAxis;
var transient Object.EAxis ParentUpAxis;
var(LookAt) editconst transient name TargetSpaceBoneName;
var transient Vector TargetPosition;
var transient Vector TargetLookDir;
var transient Vector DesiredLookDir;
var transient name CorrectionBoneName;
var transient Vector CurrentLookDir;
var transient float TurnSpeed;
var transient float TurnSpeedVariance;
var transient float TurnAngleMaxPerSecond;
var transient float DeltaTime;
var transient float PitchOnYaw;
var transient float RollOnYaw;
var transient float PitchOffset;
var transient float YawOffset;
var transient float RollOffset;
var transient float PitchMult;
var transient float YawMult;
var transient name YawBoneName;
var transient Vector RelativeYaw;
var transient Vector YawBoneLookDir;
var transient float PitchCorrection;
var transient float YawCorrection;
var transient float RollCorrection;
var transient float PitchLimitAngle;
var transient float YawLimitAngle;
var transient float DeadZoneAngle;
var transient Vector LimitLookDir;
var transient Vector LimitUp;
var transient Vector LimitRight;
var const transient float LookAtAlpha;
var const transient float LookAtAlphaTarget;
var const transient float LookAtAlphaBlendTimeToGo;
var transient name Name_Eyes;
var transient Vector ViewDirection;

defaultproperties
{
    bShowLimit=true
    bInvertUpAxis=true
    bInvertCorrectionBoneUpAxis=true
    bInvertYawBoneUpAxis=true
    bEnableLimit=true
    bInvertParentUpAxis=true
    LookAtAxis=4
    UpAxis=2
    CorrectionBoneLookAtAxis=4
    CorrectionBoneUpAxis=2
    YawBoneLookAtAxis=4
    YawBoneUpAxis=2
    ParentLookAtAxis=4
    ParentUpAxis=2
    CorrectionBoneName="Undefined"
    TurnSpeed=0.5000000
    PitchMult=1.0000000
    YawMult=1.0000000
    YawBoneName="Undefined"
    PitchLimitAngle=60.0000000
    YawLimitAngle=60.0000000
    LookAtAlpha=1.0000000
    LookAtAlphaTarget=1.0000000
    Name_Eyes="Eyes"
}