class OLAnimBlendByIdle extends UDKAnimBlendBase
	native(Anim);

var(Animation) name ChildSynchGroup;

cpptext
{
	virtual void OnBecomeRelevant();
	virtual void TickAnim(FLOAT deltaTime);
	virtual void OnChildAnimEnd(UAnimNodeSequence* Child, FLOAT PlayedTime, FLOAT ExcessTime);

private:
	enum { IdxIdle = 0, IdxMoving = 1, IdxStart = 2, IdxStop = 3 };

	void ResetSynchGroup();
}

defaultproperties
{
	Children(0)=(Name="Idle",Weight=1.0)
	Children(1)=(Name="Moving")
	Children(2)=(Name="IdleToMoving")
	Children(3)=(Name="MovingToIdle")
	bFixNumChildren=true

	bPlayActiveChild=true

	CategoryDesc = "Outlast"
}
