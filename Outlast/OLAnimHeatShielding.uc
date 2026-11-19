
class OLAnimHeatShielding extends AnimNodeBlendBase
	native(Anim);

// config

/** Distance where there low starts to blend in */
var() float MinimumDistance;

/** Distance where Low starts to blend with High */
var() float LowDistance;

/** Distance where it's 100% high */
var() float HighDistance;

// gameplay params
var transient bool bActive;

// internal
var transient float HeatShieldingWeight; // weight from normal motion to shielding (prevents pops coming in or out of mode)
var transient float HeatStrength; // smoothed strength, 0.0f - none, 0.5f - low, 1.0f - high

cpptext
{
	virtual void TickAnim(FLOAT deltaSeconds);
	virtual void OnBecomeRelevant();

protected:
	void SetActive(UBOOL isActive);
};

defaultproperties
{
	MinimumDistance=600.0
	LowDistance=400.0
	HighDistance=50.0
	NodeName="Heat Shielding"
	bFixNumChildren=TRUE
	Children(0)=(Name="Normal")
	Children(1)=(Name="Low")
	Children(2)=(Name="High")
	CategoryDesc="Outlast"
}
