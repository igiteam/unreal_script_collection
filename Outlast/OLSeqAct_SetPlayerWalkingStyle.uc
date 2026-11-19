
class OLSeqAct_SetPlayerWalkingStyle extends SequenceAction
	dependson(OLHero)
	native(Sequence);

var() EHeroWalkingStyle WalkingStyle;
var() float WalkSpeedOverride;
var() float RunSpeedOverride;

var() float AccelApproachFactorOverride;
var() float DecelApproachFactorOverride;

cpptext
{
	virtual void Activated();
}

defaultproperties
{
	ObjName="Set Player Walking Style"
	ObjCategory="Outlast - Experimental"

	WalkSpeedOverride=-1.0
	RunSpeedOverride=-1.0
	AccelApproachFactorOverride=-1.0
	DecelApproachFactorOverride=-1.0

	InputLinks(0)=(LinkDesc="Set")
	OutputLinks(0)=(LinkDesc="Out")
	VariableLinks.Empty
}
