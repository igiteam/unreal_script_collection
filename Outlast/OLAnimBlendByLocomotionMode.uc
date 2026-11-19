class OLAnimBlendByLocomotionMode extends AnimNodeBlendList
	native(Anim);

var() array<float> ChildBlendTimes;

cpptext
{
	virtual void TickAnim(FLOAT deltaTime);
	virtual void OnBecomeRelevant();
}

defaultproperties
{
	bFixNumChildren=true
	Children(0)=(Name="LM_Walk")
	Children(1)=(Name="LM_Fall")
	Children(2)=(Name="LM_SpecialMove")
	Children(3)=(Name="LM_Ladder")
	Children(4)=(Name="LM_LedgeHang")
	Children(5)=(Name="LM_LedgeWalk")
	Children(6)=(Name="LM_Squeeze")		
	Children(7)=(Name="LM_Door")
	Children(8)=(Name="LM_Locker")
	Children(9)=(Name="LM_Cinematic")
	Children(10)=(Name="LM_Bed")
	Children(11)=(Name="LM_LookBack")
	Children(12)=(Name="LM_Struggle")
	Children(13)=(Name="LM_Grabbed")
	Children(14)=(Name="LM_Pushing")
	Children(15)=(Name="LM_ContextualLean")

	ChildBlendTimes(0)=0.25
	ChildBlendTimes(1)=0.5
	ChildBlendTimes(2)=0.25
	ChildBlendTimes(3)=0.25
	ChildBlendTimes(4)=0.25
	ChildBlendTimes(5)=0.25
	ChildBlendTimes(6)=0.25		
	ChildBlendTimes(7)=0.25
	ChildBlendTimes(8)=0.25
	ChildBlendTimes(9)=0.25
	ChildBlendTimes(10)=0.25
	ChildBlendTimes(11)=0.25
	ChildBlendTimes(12)=0.25
	ChildBlendTimes(13)=0.25
	ChildBlendTimes(14)=0.25
	ChildBlendTimes(15)=0.25

	CategoryDesc="Outlast"
}
