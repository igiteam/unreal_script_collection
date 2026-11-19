class OLAnimSelectByCamcorder extends AnimNodeBlendList
	native(Anim);

cpptext
{
	virtual void TickAnim(FLOAT deltaTime);
}

defaultproperties
{
	bFixNumChildren=true
	Children(0)=(Name="Lowered")
	Children(1)=(Name="Raised")
	CategoryDesc = "Outlast"
}
