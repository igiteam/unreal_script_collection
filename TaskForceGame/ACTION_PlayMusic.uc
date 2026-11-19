class ACTION_PlayMusic extends ScriptedAction;

var(Action) string				Song;
var(Action) Actor.EMusicTransition	Transition;
var(Action) bool				bAffectAllPlayers;

var()	editinline	Actor.IMusicDesc	MusicDesc;

function bool InitActionFor(ScriptedController C)
{
	local PlayerController P;
	local Controller A;
	Local Actor.IMusicPiece IMP;
	
	if(MusicDesc.MusicPieces.Length == 0)
	{
		IMP.Piece = Song;
		MusicDesc.MusicPieces[0] = IMP;
	}

	if( bAffectAllPlayers )
	{
		For ( A=C.Level.ControllerList; A!=None; A=A.nextController )
			if ( A.IsA('PlayerController') )
				PlayerController(A).ClientSetMusic( MusicDesc, Transition );
	}
	else
	{
		// Only affect the one player.
		P = PlayerController(C.GetInstigator().Controller);
		if( P==None )
			return false;
			
		// Go to music.
		P.ClientSetMusic( MusicDesc, Transition );
	}	
	return false;	
}

function string GetActionString()
{
	return ActionString@Song;
}


// Decompiled with UE Explorer.
defaultproperties
{
    Transition=3
    bAffectAllPlayers=true
    MusicDesc=(MusicPieces=none,Transition="",SongLoops=2,TimeBetweenLoops=30)
    ActionString="play song"
}