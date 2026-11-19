
class OLAnimPushing extends AnimNodeBlendBase
	native(Anim);

var transient float PushRatio; // 0.0f = idle, 1.0 = fully pushing

cpptext
{
	enum { IdxIdleLeft = 0, IdxIdleRight = 1, IdxLoopLeft = 2, IdxLoopRight = 3 };
	virtual void TickAnim(FLOAT deltaTime);
	virtual void OnBecomeRelevant();
};

defaultproperties
{
	NodeName="Pushing"
	CategoryDesc="Outlast"

	bFixNumChildren=TRUE
	Children(0)=(Name="IdleLeft")
	Children(1)=(Name="IdleRight")
	Children(2)=(Name="LoopLeft")
	Children(3)=(Name="LoopRight")
}
