// extend UIAction if this action should be UI Kismet Action instead of a Level Kismet Action
class FHRelocatePlayerAction extends SequenceAction;

var Object pawn;

event Activated()
{
	local FHPlayerController player;

	player = FHPlayerController(pawn);
	if( player == none )
		return;

	if( FHPlayer(player.Pawn).Checkpoint != none )
	{
		// This code is to reset the player animations to deafult before relocating the player
		//foreach player.Pawn.Mesh.AllAnimNodes(class'AnimNodeBlend', animnode)
		//{
		//	animnode.SetBlendTarget(0, 0);
		//}

		//AnimNodeBlend(player.Pawn.Mesh.FindAnimNode('ClarkIdle')).SetBlendTarget(1, 0);
		
		FHPlayer(player.Pawn).SetLocation( FHPlayer(player.Pawn).Checkpoint.Location );
		FHPlayer(player.Pawn).SetRotation( FHPlayer(player.Pawn).Checkpoint.Rotation );
	}

}


// Decompiled with UE Explorer.
defaultproperties
{
    bCallHandler=false
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Player",LinkVar="None",PropertyName="Pawn",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="FHRelocatePlayerAction"
    ObjCategory="ForeverHunted Actions"
}