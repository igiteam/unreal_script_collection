class OLAnimBlendBySpeed extends AnimNodeBlend
	native(Anim);  

/** minimum speed; at this or below the "Slow" anim is used completely */
var() float MinSpeed;
/** maximum speed; at this or above the "Fast" anim is used completely */
var() float MaxSpeed;
/** maximum weight change velocity, in normalized weight units per second (lower values prevent jerks but are less reactive) */
var() float MaxWeightRate;

var transient float CurrentWeight;

cpptext
{
	virtual void TickAnim(FLOAT deltaTime);
	virtual void OnBecomeRelevant();
}

defaultproperties
{
	MinSpeed=200.0
	MaxSpeed=400.0
	MaxWeightRate=2.0

	Children(0)=(Name="Slow",Weight=1.0)
	Children(1)=(Name="Fast")
	bFixNumChildren=true

	CategoryDesc = "Outlast"
}
