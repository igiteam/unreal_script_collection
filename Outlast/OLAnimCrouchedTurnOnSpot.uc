class OLAnimCrouchedTurnOnSpot extends AnimNodeBlend
	native(Anim);

var transient float BaseHeading; // degs
var transient float LastHeading;
var transient float TurningVelocity;
var transient float HandUpWeight;
var transient bool bHandUp;

var transient float IKStrength;
var transient vector IKPosition;
var transient rotator IKRotationWS; // world space

var vector ActorSpaceIKOffset;
var quat ActorSpaceIKRotation;

var AkEvent HandUpSound;
var AkEvent HandDownSound;

cpptext
{
	virtual void TickAnim(FLOAT deltaTime);
	virtual void OnBecomeRelevant();
	virtual void OnCeaseRelevant();
}

defaultproperties
{	
	CategoryDesc="Outlast"
	Children(0)=(Name="Idle",Weight=1.0)
	Children(1)=(Name="Turning")
	bFixNumChildren=true

	HandUpSound=AkEvent'Player_Sound.Clothes_Soft'
	HandDownSound=AkEvent'Player_Sound.Clothes_Soft'

	ActorSpaceIKOffset=(X=2.923,Y=-25.336,Z=4.070)
	ActorSpaceIKRotation=(X=0.353,Y=0.643,Z=0.538,W=0.415)
}
