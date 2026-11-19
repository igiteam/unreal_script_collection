class SeqAct_AkPostTrigger extends SequenceAction
	native;

var()	name BoneName;

cpptext
{
	void Activated();
};

var() string Trigger;

defaultproperties
{
	ObjName="AkPostTrigger"
	ObjCategory="AkAudio"

	InputLinks(0)=(LinkDesc="Post")
}
