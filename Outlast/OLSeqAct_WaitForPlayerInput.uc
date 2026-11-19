class OLSeqAct_WaitForPlayerInput extends SeqAct_Latent
	native(Sequence);

var() bool bOnClick;
var() bool bOnPrototypeActionA;
var() bool bOnPrototypeActionB;
var() bool bOnPrototypeActionC;
var() bool bOnPrototypeActionD;
var() bool bOnPrototypeActionE;
var() name PromptTextId;
var() float MaxTime;

var transient string TranslatedPrompt;
var transient float StartedTime;

var transient bool bWaiting;

cpptext
{
	virtual UBOOL UpdateOp(FLOAT deltaTime);	
	virtual void DeActivated() {}
} 

defaultproperties
{
	bOnClick=true
	ObjName="Wait for Player Input"
	ObjCategory="Outlast - Gameplay"
	MaxTime=-1

	bAutoActivateOutputLinks=false
	bCallHandler=false

	InputLinks(0)=(LinkDesc="Wait")
	OutputLinks.Empty
	OutputLinks(0)=(LinkDesc="Got It")
	OutputLinks(1)=(LinkDesc="Timed Out")
	VariableLinks.Empty()
}