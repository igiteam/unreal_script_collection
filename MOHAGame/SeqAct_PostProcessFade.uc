class SeqAct_PostProcessFade extends SequenceAction
    hidecategories(Object);

var() bool bFadeIn;
var() float delay;
var() float FadeTime;

defaultproperties
{
    bFadeIn=true
    FadeTime=1.0000000
    ObjName="Post Process Fade"
    ObjCategory="Camera"
}