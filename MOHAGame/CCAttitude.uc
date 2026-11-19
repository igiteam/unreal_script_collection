class CCAttitude extends Object
    native
    editinlinenew
    hidecategories(Object);

struct native CCRigBoneAttitude
{
    var() name ControlName;
    var() float TurnSpeed;
    var() float TurnAngleMaxPerSecond;
    var() float PitchMult;
    var() float YawMult;
    var() float PitchOffset;
    var() float YawOffset;
    var() float RollOffset;
    var() float PitchOnYaw;
    var() float RollOnYaw;
    var() float ShakeAmplitude;
    var() float ShakePeriod;
    var float CycleShake;
    var() float NodAmplitude;
    var() float NodPeriod;
    var float CycleNod;
    var() bool bUseCorrectionBone;
    var() float PitchCorrection;
    var() float YawCorrection;
    var() float RollCorrection;
    var() float PitchLimitAngle;
    var() float YawLimitAngle;
    var() float DeadZoneAngle;

    structdefaultproperties
    {
        ControlName="None"
        TurnSpeed=0.4000000
        TurnAngleMaxPerSecond=180.0000000
        PitchMult=0.5000000
        YawMult=0.5000000
        PitchOffset=0.0000000
        YawOffset=0.0000000
        RollOffset=0.0000000
        PitchOnYaw=0.0000000
        RollOnYaw=0.0000000
        ShakeAmplitude=0.0000000
        ShakePeriod=1.0000000
        CycleShake=0.0000000
        NodAmplitude=0.0000000
        NodPeriod=1.0000000
        CycleNod=0.0000000
        bUseCorrectionBone=false
        PitchCorrection=0.0000000
        YawCorrection=0.0000000
        RollCorrection=0.0000000
        PitchLimitAngle=60.0000000
        YawLimitAngle=60.0000000
        DeadZoneAngle=0.0000000
    }
};

var() float LookatDurationLower;
var() float LookatDurationUpper;
var() float BlinkLength;
var() float BetweenBlink;
var() float TurnSpeedVariance;
var() array<CCRigBoneAttitude> RigBoneAttitudes;

defaultproperties
{
    LookatDurationLower=1.0000000
    LookatDurationUpper=2.0000000
    BlinkLength=0.1000000
    BetweenBlink=1.0000000
}