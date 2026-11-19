// extend UIAction if this action should be UI Kismet Action instead of a Level Kismet Action
class FHSetCheckpointAction extends SequenceAction;

var Object pawn;
var Object checkpoint;

event Activated()
{
	local FHPlayerController player;

	player = FHPlayerController(pawn);
	if( player == none )
		return;

	FHPlayer(player.Pawn).Checkpoint = Actor(checkpoint);
}


// Decompiled with UE Explorer.
defaultproperties
{
    bCallHandler=false
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Player",LinkVar="None",PropertyName="Pawn",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Checkpoint",LinkVar="None",PropertyName="Checkpoint",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="FHSetCheckpointAction"
    ObjCategory="ForeverHunted Actions"
}