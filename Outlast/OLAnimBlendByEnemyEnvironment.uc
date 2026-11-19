class OLAnimBlendByEnemyEnvironment extends AnimNodeBlendList
	native(Anim);                                         

cpptext
{
	virtual void TickAnim(FLOAT deltaTime);
	virtual void OnBecomeRelevant();
}


defaultproperties
{
	Children(0)=(Name="Normal")
	Children(1)=(Name="Darkness")
	Children(2)=(Name="Electricity")
	bFixNumChildren=true

	CategoryDesc = "Outlast"
}
