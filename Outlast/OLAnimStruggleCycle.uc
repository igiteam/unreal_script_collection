
class OLAnimStruggleCycle extends AnimNodeSequence
	native(Anim);

cpptext
{
	virtual void TickAnim(FLOAT deltaTime);
	virtual void OnBecomeRelevant();
};

defaultproperties
{
	NodeName="Struggle"
	CategoryDesc="Outlast"
}
