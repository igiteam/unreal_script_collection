class SeqAct_MOHACameraShake extends SequenceAction
    hidecategories(Object);

var() ScreenShakeStruct CameraShake;
var() float GlobalScale;
var() float GlobalAmplitudeScale;
var() float GlobalFrequencyScale;

defaultproperties
{
    CameraShake=(TimeToGo=0.0000000,TimeDuration=1.0000000,RotAmplitude=(X=100.0000000,Y=100.0000000,Z=200.0000000),RotFrequency=(X=10.0000000,Y=10.0000000,Z=25.0000000),RotSinOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000),RotParam=(X=0,Y=0,Z=0,Padding=0),LocAmplitude=(X=0.0000000,Y=3.0000000,Z=5.0000000),LocFrequency=(X=1.0000000,Y=10.0000000,Z=20.0000000),LocSinOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000),LocParam=(X=0,Y=0,Z=0,Padding=0),FOVAmplitude=2.0000000,FOVFrequency=5.0000000,FOVSinOffset=0.0000000,FOVParam=0)
    GlobalScale=1.0000000
    GlobalAmplitudeScale=1.0000000
    GlobalFrequencyScale=1.0000000
    InputLinks[0]=(LinkDesc="Timed",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000)
    InputLinks[1]=(LinkDesc="Continuous",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000)
    InputLinks[2]=(LinkDesc="Stop",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000)
    ObjName="Camera Shake"
    ObjCategory="Camera"
}