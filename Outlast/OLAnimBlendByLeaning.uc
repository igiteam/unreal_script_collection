class OLAnimBlendByLeaning extends AnimNodeBlendBase
	native(Anim);      

var transient float CurrentRatio; // 0.0 - center, 1.0 - right, -1.0 - left

cpptext
{
	virtual void TickAnim(FLOAT deltaTime);
	virtual void OnBecomeRelevant();

private:
	enum { IdxIdle = 0, IdxLeft = 1, IdxRight = 2 };
}

defaultproperties
{
	Children(0)=(Name="Idle",Weight=1.0)
	Children(1)=(Name="LeanLeft")
	Children(2)=(Name="LeanRight")
	bFixNumChildren=true

	CategoryDesc = "Outlast"
}
