
class OLSeqAct_ToggleNightVision extends SequenceAction
	native(Sequence);

// for use specifically in the lab sequence - turns on or off the NV PPS, light, enemy FX, HUD

cpptext
{
	virtual UBOOL UpdateOp(FLOAT deltaTime);
}

defaultproperties
{
	ObjName="Toggle Night Vision"
	ObjCategory="Outlast - Effects"

	InputLinks(0)=(LinkDesc="Enable")
	InputLinks(1)=(LinkDesc="Disable")
	
	OutputLinks(0)=(LinkDesc="Out")	
	VariableLinks.Empty
}
