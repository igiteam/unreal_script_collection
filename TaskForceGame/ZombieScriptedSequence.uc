class ZombieScriptedSequence extends ScriptedSequence;

var ( AIScript ) bool	bClearAnims;

function TakeOver ( Pawn P )
{
	local ZombieBipedPawn	CheckPawn;
	
	// latch on and clear his anims 
	CheckPawn = ZombieBipedPawn ( P );
	if ( CheckPawn != None && bClearAnims )
	{
		// clear all anims except base
		// TODO - Might be worth it to move BlendOutAnims down to Pawn.uc
		CheckPawn.BlendOutAnims ( 1, 25 );
	}

	// call the super
	Super.TakeOver ( P );
}


// Decompiled with UE Explorer.
defaultproperties
{
    bClearAnims=true
    bNavigate=false
    bStatic=false
}