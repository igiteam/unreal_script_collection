
class OLAnimSmarterIdle extends OLAnimCycleBreaker
	native(Anim);

var() bool bModifyPlayrateIdle;
var() float IdleMinRate;
var() float IdleMaxRate;
var() float IdleRateMinDuration;
var() float IdleRateMaxDuration;
var() float IdleRateTransitionSpeed;


var transient float CurrentIdleRate;
var transient float TargetIdleRate;
var transient float NextIdleRateTransition;

cpptext
{
	virtual void TickAnim(FLOAT deltaTime);
	virtual void OnBecomeRelevant();

	virtual FString GetSliderDrawValue(INT SliderIndex);
};

defaultproperties
{
	NodeName="Smarter Idle"
	CategoryDesc="Outlast"

	bModifyPlayrateIdle=True
   IdleMinRate=0.5
   IdleMaxRate=1.0
   IdleRateMinDuration=0.5
   IdleRateMaxDuration=3.0
   IdleRateTransitionSpeed=2.0
   
	Children(0)=(Name="Idle")	
}
