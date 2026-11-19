//=============================================================================
// MusicEvent.
// OBSOLETE - superceded by ScriptedTrigger
//=============================================================================
class MusicEvent extends Triggers
	notplaceable;

// Variables.
var() string           Song;
var() EMusicTransition Transition;
var() bool             bSilence;
var() bool             bOnceOnly;
var() bool             bAffectAllPlayers;

var() editinline	IMusicDesc	MusicDesc; 

// When gameplay starts.
function BeginPlay()
{	
	
	if(MusicDesc.MusicPieces.Length == 0)
	{
		MusicDesc = Level.Song;
	}
}

// When triggered.
function Trigger( actor Other, pawn EventInstigator )
{
	local PlayerController P;
	local Controller A;

	if( bAffectAllPlayers )
	{
		For ( A=Level.ControllerList; A!=None; A=A.nextController )
			if ( A.IsA('PlayerController') )
				PlayerController(A).ClientSetMusic( MusicDesc, Transition );
	}
	else
	{
		// Only affect the one player.
		P = PlayerController(EventInstigator.Controller);
		if( P==None )
			return;
			
		// Go to music.
		P.ClientSetMusic( MusicDesc, Transition );
	}	

	// Turn off if once-only.
	if( bOnceOnly )
	{
		SetCollision(false,false,false);
		disable( 'Trigger' );
	}
}


// Decompiled with UE Explorer.
defaultproperties
{
    Transition=3
    bAffectAllPlayers=true
    MusicDesc=(MusicPieces=none,Transition="",SongLoops=2,TimeBetweenLoops=30)
    bObsolete=true
}