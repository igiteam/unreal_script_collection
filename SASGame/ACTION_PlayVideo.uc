//=============================================================================
// ACTION_PlayVideo.uc
//
// Script action to pauses the mission and level script (thereby removing
// player control), and play the a bink video. After the bink video is done it
// un-pauses the mission (and thus finishes executing the script that
// triggered it).
//=============================================================================

class ACTION_PlayVideo extends SASLatentScriptAction;

//-----------------------------------------------------------------------------
// Member Vars
var() name				mVideoName;	// Name of the video to play

//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction(
	SASScriptInterface	aInterface )
{
	local String videoNameString;
	local SASPLayerController PC;

	Super.DoAction( aInterface );

	if ( mVideoName != 'None' )
	{
		videoNameString = String(mVideoName);
		PC = SASPLayerController( mOwnerScript.Level.GetLocalPlayerController() );

		//mOwnerScript.bTickEvenWhenPaused=true;
		PC.PlayScriptedMovie( videoNameString );

		// Action is not complete yet.
		return false;
	}

	// Action is complete.
	return true;
}

///////////////////////////////////////////////////////////////////////////////
// TickedAction
//
// Returns true if action uses Tick event to move latent action forward.
function bool TickedAction()
{
	return true;
}


///////////////////////////////////////////////////////////////////////////////
// StillTicking
//
// Returnss true if action is a ticked action that is still in progress.
function bool StillTicking(
	SASScriptInterface	aInterface, 
	float				aDeltaTime )
{
	local SASPLayerController PC;
	PC = SASPLayerController( mOwnerScript.Level.GetLocalPlayerController() );
	if( PC.IsScriptedMoviePlaying() )
	{
		// Still playing the movie.
		return true;
	}
	else
	{
		// We're done playing the movie.
		//mOwnerScript.bTickEvenWhenPaused=false;
		return false;
	}
}

//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="PlayVideo"
}