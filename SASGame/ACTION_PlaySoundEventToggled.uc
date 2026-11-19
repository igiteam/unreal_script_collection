//=============================================================================
// ACTION_PlaySound.uc
//
// Script action to play a sound - either attached to the scripted pawn or
// the location in the level of the owner script object.
//=============================================================================

class ACTION_PlaySoundEventToggled extends SASTriggeredScriptAction;


//-----------------------------------------------------------------------------
// Member Vars

var(Action)	Sound	mSound;
var(Action)	float	mVolume;
var(Action) float	mRadius;
var(Action)	float	mPitch;
var(Action)	bool	mbAttenuate;
var(Action) bool	mbOwnerIsPawn;

var(Action) Name	mEventToggle;		// Tag of event the condition triggers on
var(Action) bool	mbInitialState;		// Initial evaluation state
var(Action)	bool	mbCanBeUntriggered;	// If true then condition can be reset by untrigger event
var(Action) bool	mbTogglable;		// Flags if condition can be toggled

var bool mbEnabled;

//-----------------------------------------------------------------------------
// Functions
//
///////////////////////////////////////////////////////////////////////////////
// Init
//
// Called on script initialisation at start of level.
function Init(
	SASScriptedSequence	aOwnerScript )
{
	Super.Init( aOwnerScript );

	// Set initial condition evaluation state
	mbEnabled = mbInitialState;
}


///////////////////////////////////////////////////////////////////////////////
// NotifyEventTriggered
//
// Event received when a general level event is triggered.
event NotifyEventTriggered(
	name aEventName )
{
	if ( aEventName == mEventToggle )
	{
		if ( mbTogglable )
		{
			mbEnabled = !mbEnabled;
		}
		else
		{
			mbEnabled = !mbInitialState;
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction(
	SASScriptInterface	aInterface )
{
	local Actor	tSource;
 
	// the volume and radius may not just be copied from the members.
	local float local_volume;
	local float local_radius;
	
	// normally, read out of the member variables
	local_volume = mVolume;
	local_radius = mRadius;
	
	if ( !mbEnabled )
	{
		return false;	// not done, wait ...
	}

	if ( mbOwnerIsPawn && (aInterface.mAIController == None) )
	{
		return true;
	}
		Log ( self $".DoAction:" @mSound @mbEnabled );

	if ( mSound != None )
	{
		// Sound source is either script or pawn
		if ( mbOwnerIsPawn )
		{
			if ( aInterface.mAIController.Pawn != None )
			{
				tSource = aInterface.mAIController.Pawn;
			}
		}
		else
		{
			tSource = mOwnerScript;
				
			// I wonder if there's text for this.
			ShowSoundMessage ( mSound.Name, tSource, local_volume, local_radius );
		}

		if (tSource != None)
		{
			tSource.PlaySound (
				mSound,
				SLOT_Interact,
				local_volume,
				false,
				local_radius,
				mPitch,
				mbAttenuate);
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
    mbInitialState=true
    mActionString="Play Sound Event Toggled"
}