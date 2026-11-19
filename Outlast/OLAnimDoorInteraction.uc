class OLAnimDoorInteraction extends AnimNodeBlendList
	native(Anim);                                         

var float InitialRatio;
var transient float CurrentRatio;
var transient float SmoothedDelta;
var() float PlayRate; // ratio units per second

var float MaxRatio; // maximum ratio, if the anim needs to be limited (-1: unlimited, or implictely 1.0)

cpptext
{
	virtual void TickAnim(FLOAT deltaTime);
	virtual void OnBecomeRelevant();
}

defaultproperties
{
	InitialRatio=0.0
	PlayRate=1.0
	MaxRatio=-1.0
	CategoryDesc="Outlast"

	bFixNumChildren=TRUE
	Children(0)=(Name="LeftPush")
	Children(1)=(Name="LeftPull")
	Children(2)=(Name="RightPush")
	Children(3)=(Name="RightPull")
}
