
class OLAnimSmartIdle extends AnimNodeBlendBase
	native(Anim);

var() bool bModifyPlayrateIdle;
var() float IdleMinRate;
var() float IdleMaxRate;
var() float IdleRateMinDuration;
var() float IdleRateMaxDuration;
var() float IdleRateTransitionSpeed;
var() float IdleBias; // 1.0 -- always idle, 0.7 - 70% of the time there's no breaker weight
var() float BreakerMaxWeight;
var() float BreakerMinDuration;
var() float BreakerMaxDuration;
var() float MinBreakerWeightTransitionSpeed;
var() float MaxBreakerWeightTransitionSpeed;

var transient float CurrentIdleRate;
var transient float TargetIdleRate;
var transient float NextIdleRateTransition;
var transient float CurrentBreakerWeight;
var transient float TargetBreakerWeight;
var transient float BreakerWeightTransitionSpeed;
var transient float NextBreakerWeightTransition;

cpptext
{
	virtual void TickAnim(FLOAT deltaTime);
	virtual void OnBecomeRelevant();

		// AnimTree editor interface
	virtual INT GetNumSliders() const { return 1; }
	virtual FLOAT GetSliderPosition(INT SliderIndex, INT ValueIndex);
	virtual FString GetSliderDrawValue(INT SliderIndex);

};

defaultproperties
{
	NodeName="Smart Idle"
	CategoryDesc="Outlast"

	bModifyPlayrateIdle=True
   IdleMinRate=0.5
   IdleMaxRate=1.0
   IdleRateMinDuration=0.5
   IdleRateMaxDuration=3.0
   IdleRateTransitionSpeed=2.0
   IdleBias=0.6
   BreakerMaxWeight=1.0
   BreakerMinDuration=0.5
   BreakerMaxDuration=5.0
   MinBreakerWeightTransitionSpeed=1.0
   MaxBreakerWeightTransitionSpeed=6.0

	bFixNumChildren=true
	Children(0)=(Name="Idle")
	Children(1)=(Name="Breaker")
}
