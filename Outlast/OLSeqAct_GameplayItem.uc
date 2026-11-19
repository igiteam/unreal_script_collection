
class OLSeqAct_GameplayItem extends SequenceAction
	native(Sequence);

var() name ItemName;

cpptext
{
	virtual void Activated();
}

defaultproperties
{
	ObjName="Gameplay Item"
	ObjCategory="Outlast - Gameplay"
	bAutoActivateOutputLinks=false

	VariableLinks.Empty
	InputLinks(0)=(LinkDesc="Check Inventory")
	InputLinks(1)=(LinkDesc="Use And Keep")
	InputLinks(2)=(LinkDesc="Use And Consume")
	InputLinks(3)=(LinkDesc="Give to Player")
	
	OutputLinks(0)=(LinkDesc="Success")
	OutputLinks(1)=(LinkDesc="Failed")
}
