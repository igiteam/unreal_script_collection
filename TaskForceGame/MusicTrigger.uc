class MusicTrigger extends Triggers;

var(Depricated)				string		Song;
var(Depricated)				float		FadeInTime;
var(Depricated)				float		FadeOutTime;
var(Depricated)				bool		FadeOutAllSongs;

var()	editinline	IMusicDesc	MusicDesc;

var		transient	bool		Triggered;

function Trigger( Actor Other, Pawn EventInstigator )
{
	Local IMusicPiece IMP;
	if(MusicDesc.MusicPieces.Length == 0)
	{
		IMP.Piece = Song;
		MusicDesc.MusicPieces[0] = IMP;
	}

	if(!IsXBox())
	{
		StopMusic(Level.SongHandle,0.5);
	}

	Level.SongHandle = PlayMusic( MusicDesc, FadeInTime );
	if ( Level.SongHandle == 0 )
	{
		//log ( "setting timer for MusicTrigger.. songhandle invalid" );
		SetTimer ( 1.0, false );
	}
}

function Timer ( )
{
	Level.SongHandle = PlayMusic ( MusicDesc, FadeInTime );
	if ( Level.SongHandle == 0 )
	{
		//log ( "setting timer for MusicTrigger.. songhandle invalid" );
		SetTimer ( 1.0, false );
	}
}


// Decompiled with UE Explorer.
defaultproperties
{
    MusicDesc=(MusicPieces=none,Transition="",SongLoops=2,TimeBetweenLoops=30)
    bCollideActors=false
}