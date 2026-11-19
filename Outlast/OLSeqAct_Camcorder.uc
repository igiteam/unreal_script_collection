
class OLSeqAct_Camcorder extends SequenceAction
	native(Sequence);

var() bool bWithNightVision;
var() float NewMinFOV;
var() int NewNumBatteries;
var() float NewCurrentEnergy;

cpptext
{
	virtual void Activated();
}

defaultproperties
{
	ObjName="Camcorder"
	ObjCategory="Outlast - Gameplay"

	NewMinFOV=-1.0
	NewNumBatteries=-1
	NewCurrentEnergy=-1.0

	InputLinks(0)=(LinkDesc="Remove")
	InputLinks(1)=(LinkDesc="Give")
	InputLinks(2)=(LinkDesc="Give And Use")
	InputLinks(3)=(LinkDesc="Discard All Batteries")
	InputLinks(4)=(LinkDesc="Set Batteries")

	OutputLinks(0)=(LinkDesc="Out")
	VariableLinks.Empty
}
