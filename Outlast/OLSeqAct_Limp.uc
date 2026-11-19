
class OLSeqAct_Limp extends SequenceAction
	native(Sequence);

enum EHobbleIntensity
{
	HI_VeryBad,
	HI_Bad,
	HI_NotSoBad,
	HI_RatherOk,
	HI_Healed,
};

var() EHobbleIntensity HobbleIntensity;

cpptext
{
	virtual void Activated();
}

defaultproperties
{
	ObjName="Limp/Hobble"
	ObjCategory="Outlast - Gameplay"
	HobbleIntensity=HI_VeryBad

	InputLinks(0)=(LinkDesc="Activate")
	InputLinks(1)=(LinkDesc="Deactivate")

	OutputLinks(0)=(LinkDesc="Out")
	VariableLinks.Empty
}
