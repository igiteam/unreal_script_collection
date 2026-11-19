
class OLSeqAct_ChokePoint extends SeqAct_Latent
	native(Sequence);

var bool bWaitingForLoaded;
var bool bWaitingForVisible;
var() array<Name> LevelNames;

/** When enabled, streaming will be slower, but it will be able to leave the loading screen earlier when only the desired levels are visible. */
var() bool bNonBlocking;

cpptext
{
	virtual UBOOL UpdateOp(FLOAT deltaTime);

	UBOOL IsLoadingComplete();
}

defaultproperties
{
	ObjName="Choke Point"
	ObjCategory="Outlast - Systems"

	InputLinks(0)=(LinkDesc="BlockUntilLoaded")
	InputLinks(1)=(LinkDesc="BlockUntilVisible")
	OutputLinks(0)=(LinkDesc="Out")	
	OutputLinks(1)=(LinkDesc="Done")	
	VariableLinks.Empty
	bNonBlocking=false
}
