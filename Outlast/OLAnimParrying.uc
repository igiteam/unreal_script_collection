
class OLAnimParrying extends AnimNodeBlendBase
	native(Anim);

// config

/** Distance where there low starts to blend in */
var() float MinimumDistance;

/** Distance where Low starts to blend with High */
var() float LowDistance;

/** Distance where it's 100% high */
var() float HighDistance;

/** Angle left or right (in degrees) for the extreme high pose */
var() float AngleRange;

// gameplay params
var transient bool bActive;
var transient float EnemyDistance;
var transient float EnemyRelYaw;

// internal
var transient float ParryWeight; // weight from normal motion to parrying (prevents pops coming in or out of mode)
var transient float ParryStrength; // smoothed strength, 0.0f - none, 0.5f - low, 1.0f - high
var transient float ParryAngleRatio; // smoothed - 0.0 : left, 0.5 : center, 1.0f : right

cpptext
{
	virtual void TickAnim(FLOAT deltaSeconds);
	virtual void OnBecomeRelevant();
	
	void SetActive(UBOOL isActive);

private:
	enum { IdxNormal = 0, IdxLow = 1, IdxHigh = 2 };
};

defaultproperties
{
	MinimumDistance=150.0
	LowDistance=100.0
	HighDistance=30.0
	AngleRange=25.0
	NodeName="Parrying"
	bFixNumChildren=TRUE
	Children(0)=(Name="Normal")
	Children(1)=(Name="Low")
	Children(2)=(Name="High")
	CategoryDesc="Outlast"
}
