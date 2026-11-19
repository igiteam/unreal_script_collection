class OLAnimBlendByEnemyMode extends AnimNodeBlendList
	native(Anim);                                         

cpptext
{
	virtual void TickAnim(FLOAT deltaTime);
	virtual void OnBecomeRelevant();
}


defaultproperties
{
	Children(0)=(Name="Patrol")
	Children(1)=(Name="Investigate")
	Children(2)=(Name="Chase")
	Children(3)=(Name="SqueezeGrabLeft")
	Children(4)=(Name="SqueezeGrabRight")
	bFixNumChildren=true

	CategoryDesc = "Outlast"
}
