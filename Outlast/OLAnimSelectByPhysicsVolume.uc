class OLAnimSelectByPhysicsVolume extends AnimNodeBlendList
	native(Anim);

cpptext
{
	virtual void TickAnim(FLOAT deltaTime);
}

defaultproperties
{
	bFixNumChildren=true
	Children(0)=(Name="Normal")
	Children(1)=(Name="Water")
	CategoryDesc = "Outlast"
}
