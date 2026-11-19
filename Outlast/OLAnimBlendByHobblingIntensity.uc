class OLAnimBlendByHobblingIntensity extends AnimNodeBlend
	native(Anim);  

cpptext
{
	virtual void TickAnim(FLOAT deltaTime);
}

defaultproperties
{
	Children(0)=(Name="Normal",Weight=1.0)
	Children(1)=(Name="Hobbling")
	bFixNumChildren=true

	CategoryDesc = "Outlast"
}
