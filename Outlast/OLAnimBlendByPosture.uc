class OLAnimBlendByPosture extends AnimNodeBlendList
	native(Anim);                                         

cpptext
{
	virtual void TickAnim(FLOAT deltaTime);
	virtual void OnBecomeRelevant();
}


defaultproperties
{
	Children(0)=(Name="Stand",Weight=1.0)
	Children(1)=(Name="Crouch")
	bFixNumChildren=true

	CategoryDesc = "Outlast"
}
