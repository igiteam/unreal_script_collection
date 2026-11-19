class OLAnimBlendBySwarmForm extends AnimNodeBlendList
	native(Anim);                                         

cpptext
{
	enum { IdxSwarm = 0, IdxHuman = 1, IdxMorphingToSwarm = 2, IdxMorphingToHuman = 3 };
	virtual void TickAnim(FLOAT deltaTime);
	virtual void OnBecomeRelevant();
}

defaultproperties
{
	Children(0)=(Name="Swarm")
	Children(1)=(Name="Human")
	Children(2)=(Name="MorphingToSwarm")
	Children(3)=(Name="MorphingToHuman")
	bFixNumChildren=true

	CategoryDesc="Outlast"
}
