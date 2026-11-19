class SeqAct_PlayHeroFlak extends SequenceAction
    hidecategories(Object);

var() int socketNum;
var() ShakeInfoStruct customShakeInfo;
var() SoundCue HeroFlakSoundCue;
var() float GlobalScale;
var() float GlobalAmplitudeScale;
var() float GlobalFrequencyScale;
var() bool bShakePlayerCamera;

defaultproperties
{
    customShakeInfo=(ShakeAmplitude=(X=5.0000000,Y=5.0000000,Z=5.0000000),shakeFrequency=(X=1000.0000000,Y=500.0000000,Z=1500.0000000),camShakeAmplitude=(X=5.0000000,Y=5.0000000,Z=5.0000000),camShakeFrequency=(X=1000.0000000,Y=500.0000000,Z=1500.0000000),camRollAmplitude=(X=200.0000000,Y=200.0000000,Z=90.0000000),camRollFrequency=(X=1000.0000000,Y=500.0000000,Z=1500.0000000),rollAmplitude=20.0000000,rollFrequency=1000.0000000,falloffTime=0.7500000,holdTime=0.2500000)
    GlobalScale=1.0000000
    GlobalAmplitudeScale=1.0000000
    GlobalFrequencyScale=1.0000000
    bShakePlayerCamera=true
    ObjName="PlayHeroFlak"
    ObjCategory="MOHAHeroPlaneEvents"
}