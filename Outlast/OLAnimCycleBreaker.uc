
class OLAnimCycleBreaker extends AnimNodeBlendBase
	native(Anim);

var() float DefaultCycleBias; // 1.0 -- always default, 0.7 - 70% of the time there's no breaker weight
var() float DefaultStretchDuration;

struct native CycleBreaker
{
	var() float MinWeight;
	var() float MaxWeight;
	var() bool bPlayStartToEnd;
	var() float MinDuration;
	var() float MaxDuration;
	var() float MinRate;
	var() float MaxRate;
	var() float BlendInSpeed;
	var() float BlendOutSpeed;
	var() float Probability;
	var() float LayerProbability;

	var() array< class<OLEnemyPawn> > SpecificClasses;

	var transient float CurrentWeight;
	var transient float TargetWeight;

	structdefaultproperties
	{
		MinWeight=0.0;
		MaxWeight=1.0;
		bPlayStartToEnd=false;
		MinDuration=1.0;
		MaxDuration=5.0;
		MinRate=0.75;
		MaxRate=1.5;
		BlendInSpeed=2.0;
		BlendOutSpeed=2.0;
		Probability=1.0;
		LayerProbability=0.0;
	}
};

var() array<CycleBreaker> Breakers;

var const CycleBreaker BreakerTemplate; // kept around just to get a copy of the default properties

var transient float NextBreakerWeightTransition;
var transient array<int> ValidBreakers;

cpptext
{
	virtual void InitAnim(USkeletalMeshComponent* MeshComp, UAnimNodeBlendBase* Parent);
	virtual void TickAnim(FLOAT deltaTime);
	virtual void OnBecomeRelevant();

	// AnimTree editor interface
	virtual INT GetNumSliders() const { return 1; }
	virtual FLOAT GetSliderPosition(INT SliderIndex, INT ValueIndex);
	virtual FString GetSliderDrawValue(INT SliderIndex);

	virtual void OnAddChild(INT newIdx);
	virtual void OnRemoveChild(INT remIdx);

private:
	void ActivateNewBreaker();
	void UpdateBreakers(FLOAT deltaTime);
	UAnimNodeSequence* GetAnimNodeForBreaker(INT breakerIdx);
};

defaultproperties
{
	NodeName="Cycle Breaker"
	CategoryDesc="Outlast"

	DefaultCycleBias=0.6
	DefaultStretchDuration=2.0

	Children(0)=(Name="Default")
}
