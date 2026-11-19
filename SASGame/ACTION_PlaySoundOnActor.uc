//=============================================================================
// ACTION_PlaySoundOnActor.uc
//
// Script action to play a sound on another actor with a specified tag.
//=============================================================================

class ACTION_PlaySoundOnActor extends SASScriptAction;


//-----------------------------------------------------------------------------
// Member Vars

var(Action)	name	mActorTag;
var(Action)	Sound	mSound;
var(Action)	float	mVolume;
var(Action) float	mRadius;
var(Action)	float	mPitch;
var(Action)	bool	mbAttenuate;

var Actor			mTgtActor;


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// Init
//
function Init(
	SASScriptedSequence	aScript )
{
	Super.Init( aScript );

	if ( mTgtActor == None )
	{
		GetTargetActor( false );
	}
}


///////////////////////////////////////////////////////////////////////////////
// GetTargetActor
//
function GetTargetActor(
	bool	abRequireNow )
{
	// Get reference to actor to damage
	if ( mActorTag != 'None' )
	{
		foreach mOwnerScript.AllActors( class'Actor', mTgtActor, mActorTag )
		{
			break;
		}
	}

	if ( (mTgtActor == None) && abRequireNow )
	{
		LogHuman( "ACTION_PlaySoundOnActor: Could not find actor <" $mActorTag$ "> to play sound for "$self$" in "$mOwnerScript );
	}
}


///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction(
	SASScriptInterface	aInterface )
{
	local SASPawn	sourcePawn;

	// the volume and radius may not just be copied from the members.
	local float local_volume,
				local_radius;
	
	// normally, read out of the member variables
	local_volume = mVolume;
	local_radius = mRadius;
	
	if ( mSound != None )
	{
		if ( mTgtActor == None )
		{
			GetTargetActor( true );
		} 

		if ( mTgtActor != None )
		{
			// Don't play sounds on dead/incap pawns.
			sourcePawn = SASPawn( mTgtActor );
			if (	(sourcePawn != None) &&
					(!sourcePawn.IsAlive() || sourcePawn.mbIsIncapacitated) )
			{
				return true;
			}

			// I wonder if there's text for this.
			ShowSoundMessage(mSound.Name, mTgtActor, local_volume, local_radius);
			
			mTgtActor.PlaySound (
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
    mActionString="Play Sound on Actor"
}