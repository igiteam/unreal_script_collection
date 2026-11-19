class OLAnimSelectByShadowProxy extends AnimNodeBlendList
	native(Anim);

cpptext
{
	virtual void OnBecomeRelevant();
}

defaultproperties
{
	bFixNumChildren=true
	Children(0)=(Name="Normal")
	Children(1)=(Name="ShadowProxy")
	CategoryDesc = "Outlast"
}
