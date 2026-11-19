class OLAnimSelectByWalkingStyle extends AnimNodeBlendList
	native(Anim);

cpptext
{
	virtual void TickAnim(FLOAT deltaTime);
}

defaultproperties
{
	bFixNumChildren=true

	// Must match EHeroWalkingStyle
	Children(0)=(Name="Normal")
	Children(1)=(Name="Water")
	Children(2)=(Name="Limping")
	Children(3)=(Name="Hobbling")
	Children(4)=(Name="Prototype A")
	Children(5)=(Name="Prototype B")
	Children(6)=(Name="Prototype C")
	Children(7)=(Name="Prototype D")
	Children(8)=(Name="Prototype E")
	CategoryDesc = "Outlast"
}
