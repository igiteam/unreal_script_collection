class OLAnimTurnOnSpot extends AnimNodeBlendList
	native(Anim);

var float CurrentFeetHeading; // degs

cpptext
{
	virtual void TickAnim(FLOAT deltaTime);
	virtual void OnBecomeRelevant();
}

defaultproperties
{	
	CategoryDesc="Outlast"
	Children(0)=(Name="LookLeftToRight",Weight=1.0)
	Children(1)=(Name="CorrectLeft45")
	Children(2)=(Name="CorrectRight45")
	bFixNumChildren=true
}
