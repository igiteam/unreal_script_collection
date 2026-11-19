class OLSeqEvent_NightVision extends SequenceEvent
	native(Sequence);

enum ENVEvent
{
	NVE_CamcorderActivated,
	NVE_CamcorderDeactivated,
	NVE_DefaultViewSelected,
	NVE_PassiveNVSelected,
	NVE_ActiveNVSelected,
	NVE_OutOfBatteries,
};

defaultproperties
{
	ObjName="Night Vision"
	ObjCategory="Outlast"

	MaxTriggerCount=0

	VariableLinks.Empty
	OutputLinks(0)=(LinkDesc="Camcorder Activated")
	OutputLinks(1)=(LinkDesc="Camcorder Deactivated")
	OutputLinks(2)=(LinkDesc="Default View Selected")
	OutputLinks(3)=(LinkDesc="Passive NV Selected")
	OutputLinks(4)=(LinkDesc="Active NV Selected")
	OutputLinks(5)=(LinkDesc="Out Of Batteries")
	bPlayerOnly=false
}

