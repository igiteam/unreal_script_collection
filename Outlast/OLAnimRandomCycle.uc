
class OLAnimRandomCycle extends AnimNodeBlendList
	native(Anim);

/** 1.0 -- always default, 0.5 - 50% more chance of playing default, 0 - no bias */
var() float DefaultCycleBiasWalking; 
var() float DefaultCycleBiasRunning; 
var() float BlendTime;

var transient float NextCycleCheckTime;

var transient bool bIsMaster;
var transient OLAnimRandomCycle ShadowNode;

cpptext
{
	virtual void TickAnim(FLOAT deltaTime);
	virtual void OnBecomeRelevant();

private:
	void StartNewCycle();
	void StartChild(INT childIdx);
	UAnimNodeSequence* GetAnimNodeForChild(INT childIdx);
};

defaultproperties
{
	NodeName="Random Cycle"
	CategoryDesc="Outlast"

	DefaultCycleBiasWalking=0.92
	DefaultCycleBiasRunning=0.8
	BlendTime=0.15

	Children(0)=(Name="Default")
}
