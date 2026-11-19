//=============================================================================
// ScriptedTrigger
// replaces Counter, Dispatcher, SpecialEventTrigger
//=============================================================================
class ScriptedTrigger extends ScriptedSequence;

var() bool			bResetOnTrigger;
var ScriptedTriggerController	TriggerController;

#exec Texture Import File=..\engine\textures\TrigSpcl.dds Name=S_SpecialEvent Mips=Off MASKED=1

function PostBeginPlay()
{
	Super.PostBeginPlay();
	TriggerController = Spawn(class'ScriptedTriggerController');
	TriggerController.InitializeFor(self);
}

function bool ValidAction(Int N)
{
	if ( Actions[N] != None )
	{
		return Actions[N].bValidForTrigger;
	}

	return false;
}

function Trigger( Actor Other, Pawn EventInstigator )
{
	if( bResetOnTrigger )
		TriggerController.InitializeFor(self);
}


// Decompiled with UE Explorer.
defaultproperties
{
    bNavigate=false
    Texture=Texture'S_SpecialEvent'
}