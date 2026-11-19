
class OLSeqAct_DarkLightControl extends SequenceAction
	native(Sequence);

var(Outlast) float DarkLightBrightness;
var(Outlast) float DarkLightRadius;

cpptext
{
	virtual UBOOL UpdateOp(FLOAT deltaTime);
}

defaultproperties
{
	ObjName="Dark Light Control"
	ObjCategory="Outlast - Effects"

	DarkLightBrightness=0.06
	DarkLightRadius=150.0

	InputLinks(0)=(LinkDesc="Enable")
	InputLinks(1)=(LinkDesc="Disable")
	
	OutputLinks(0)=(LinkDesc="Out")	
	VariableLinks.Empty
}
