//=============================================================================
// ACTION_PlaySound.uc
//
// Script action to play a sound - either attached to the scripted pawn or
// the location in the level of the owner script object.
//=============================================================================

class ACTION_PlaySound extends SASScriptAction;


//-----------------------------------------------------------------------------
// Member Vars

var(Action)	Sound	mSound;
var(Action)	float	mVolume;
var(Action) float	mRadius;
var(Action)	float	mPitch;
var(Action)	bool	mbAttenuate;
var(Action) bool	mbOwnerIsPawn;


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction( 
	SASScriptInterface	aInterface )
{
	local Actor		sourceActor;
	local SASPawn	scriptedPawn;
	local float		local_volume,
					local_radius;
	
	// normally, read out of the member variables
	local_volume = mVolume;
	local_radius = mRadius;
	
	if ( mbOwnerIsPawn && (aInterface.mAIController == None) )
	{
		return true;
	}

	if ( mSound != None )
	{
		// Sound source is either script or pawn
		if ( mbOwnerIsPawn )
		{
			scriptedPawn = SASPawn( aInterface.mAIController.Pawn );
			if (	(scriptedPawn != None) &&
					scriptedPawn.IsAlive() && 
					!scriptedPawn.mbIsIncapacitated )
			{
				sourceActor = aInterface.mAIController.Pawn;
			}
		}
		else
		{
			sourceActor = mOwnerScript;
		}

		if ( sourceActor != None )
		{
			// I wonder if there's text for this.
			
			// also, we might play with the volume and radius a bit
			ShowSoundMessage( mSound.Name, sourceActor, local_volume, local_radius );

			sourceActor.PlaySound(
				mSound,
				SLOT_Interact,
				local_volume,
				false,
				local_radius,
				mPitch,
				mbAttenuate );
		}
	}

	return true;	
}


///////////////////////////////////////////////////////////////////////////////
// GetActionString
//
function string GetActionString()
{
	return mActionString@mSound;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mVolume=1.0000000
    mRadius=1.0000000
    mPitch=1.0000000
    mbAttenuate=true
    mbOwnerIsPawn=true
    mActionString="Play Sound"
}