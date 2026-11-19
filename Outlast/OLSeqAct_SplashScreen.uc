
class OLSeqAct_SplashScreen extends SeqAct_Latent
	native(Sequence);

var() bool bPauseGame;
var() bool bAlwaysReady;
var bool bDone;

cpptext
{
	virtual void Activated();
	virtual UBOOL UpdateOp(FLOAT deltaTime);

	void Continue();
}

defaultproperties
{
	ObjName="Splash Screen"
	ObjCategory="Outlast - Systems"

	InputLinks(0)=(LinkDesc="Show")
	InputLinks(1)=(LinkDesc="Hide")
	InputLinks(2)=(LinkDesc="SetReady")
	OutputLinks(0)=(LinkDesc="Shown")
	OutputLinks(1)=(LinkDesc="Hidden")
	OutputLinks(2)=(LinkDesc="Continue")
	
	VariableLinks.Empty
	bAutoActivateOutputLinks=false
}
