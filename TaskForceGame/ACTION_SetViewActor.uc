class ACTION_SetViewActor extends ScriptedAction;

var(Action) edfindable actor 	ViewActor;
var(Action) bool 		bHead;
var(Action) bool 		bTorso;

function bool InitActionFor(ScriptedController C)
{
	local ZombieBipedPawn MyPawn;
	MyPawn = ZombieBipedPawn ( C.Pawn );
	if ( MyPawn != None )
	{
		if ( ViewActor != None )
		{
			MyPawn.SetLookAtActor( ViewActor, false, bHead, bTorso );
		}
		else
		{
			MyPawn.StopLookAt ( true, true, true );
		}
	}

	return false;	
}

	

// Decompiled with UE Explorer.
defaultproperties
{
    bTorso=true
    ActionString="set view actor"
    bValidForTrigger=false
}