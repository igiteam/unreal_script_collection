class SkySeqAct_TriggerStreak extends SequenceAction;

var(Streak) Vector Location;
var(Streak) float Size;
var(Streak) float Duration;
var(Streak) float Intensity;
var(Streak) bool bUseStreakRays;
var(Streak) int Priority;
var(Streak) float Exposure;
var(Streak) float Decay;
var(Streak) float Weight;
var(Streak) float StartFadeAngle;
var(Streak) float FinishFadeAngle;
var(Streak) float MinDensityDistance;
var(Streak) float MinDensity;
var(Streak) float MaxDensityDistance;
var(Streak) float MaxDensity;
var(Streak) LinearColor BaseColor;
var(Streak) float GaussianBlurRadius;
var(Streak) float FadeAtEndLength;
var() float MaxTriggerDistance;

event Activated()
{
    Class'Engine.StreakEffect'.static.SetBlurPoint(Location, Size, Intensity, Duration, bUseStreakRays, Priority, Exposure, Decay, Weight, StartFadeAngle, FinishFadeAngle, MinDensityDistance, MinDensity, MaxDensityDistance, MaxDensity, BaseColor, GaussianBlurRadius, FadeAtEndLength, MaxTriggerDistance);
    // End:0xA1
    if(!OutputLinks[0].bDisabled)
    {
        OutputLinks[0].bHasImpulse = true;
    }
    //return;    
}
