
class OLAnimNodeDelayed extends AnimNodeBlendList
	native(Anim);

var() float TimeDelay;
var() float BlendTime;

var float ElapsedTime;

cpptext
{
	virtual void TickAnim(FLOAT deltaTime);
	virtual void OnBecomeRelevant();
};

defaultproperties
{
	NodeName="AnimNodeDelayed"
	bFixNumChildren=TRUE
	Children(0)=(Name="Initial")
	Children(1)=(Name="Delayed")
	TargetWeight(0)=1.0
	TargetWeight(1)=0.0

	TimeDelay=0.5
	BlendTime=0.25

	CategoryDesc = "Outlast"
}
