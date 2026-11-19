///////////////////////////////////////////////////////////////////////////////
class AnimatorIdleDefinition extends IdleDefinition
    perobjectconfig;
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
//
// AnimatorIdleDefinition Config Variables
var config name                 AnimationName;
var config float                AnimationTweenTime;
var config int					MinNumberOfTimesToPlay;
var config int					MaxNumberOfTimesToPlay;

///////////////////////////////////////////////////////////////////////////////
//
// Convenience

function int GetRandomNumberOfTimeToPlay()
{
	return RandRange(MinNumberOfTimesToPlay, MaxNumberOfTimesToPlay);
}







// Decompiled with UE Explorer.
defaultproperties
{
    AnimationTweenTime=0.2000000
    MinNumberOfTimesToPlay=1
    MaxNumberOfTimesToPlay=1
}