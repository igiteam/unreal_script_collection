class SASTriggerVolume extends Volume
	native
	hidecategories(Volume);

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

enum eVolumeTriggerType
{
	VTT_AnyPawnProximity,	
	VTT_NamedPawnProximity,
	VTT_HumanPlayerProximity,
	VTT_SoldierProximity,
	VTT_TerroristProximity,
	VTT_HostageProximity,
	VTT_Damaged,			
};

struct native sTriggerSoundParams
{
	var() Sound		Snd;
	var() float		Volume;
	var() float		Pitch;
	var() float		Radius;
	var() bool		bAttenuate;
};

var() eVolumeTriggerType	meTriggerType;
var() bool					mbTriggerOnceOnly;
var() float					mReTriggerDelay;
var() name					mNamedPawnTag;
var() int					mDamageThreshold;
var() localized string		mMessage;
var() array<sTriggerSoundParams>	mTriggerSounds;
var() array<sTriggerSoundParams>	mUntriggerSounds;

var bool					mbSavedInitialCollision;
var float					mLastTriggerTime;
var float					mLastDamageTime;

function PreBeginPlay ()
{
	local int i, numSounds;

	Super.PreBeginPlay();

	if (meTriggerType != VTT_Damaged)
	{
		// Use optimisation in collision code to only check against pawns
		OnlyAffectPawns (true);
	}

	// Remove any trigger/untrigger sound array slots without a sound specified
	
	numSounds = mTriggerSounds.Length;
	for ( i = 0; i < numSounds; ++i )
	{
		if ( mTriggerSounds[i].Snd == None )
		{
			mTriggerSounds.Remove( i, 1 );
			--i;
		}
	}

	numSounds = mUntriggerSounds.Length;
	for ( i = 0; i < numSounds; ++i )
	{
		if ( mUntriggerSounds[i].Snd == None )
		{
			mUntriggerSounds.Remove( i, 1 );
			--i;
		}
	}
}


event PostBeginPlay ()
{
	if (meTriggerType == VTT_Damaged)
	{
		bHidden			= false;
		bProjTarget		= true;
		SetDrawType (DT_None);
	}

	mbSavedInitialCollision = bCollideActors;
	
	AssociatedActorTag = '';
	Super.PostBeginPlay();
}

/* Reset() 
reset actor to initial state - used when restarting level without reloading.
*/
function Reset()
{
	Super.Reset();

	// collision, bInitiallyactive
	SetCollision (mbSavedInitialCollision, bBlockActors, bBlockPlayers);
}	


function bool IsRelevant (
	Actor	aOther)
{
	switch (meTriggerType)
	{
	case VTT_AnyPawnProximity:
		return (SASPawn(aOther) != None);

	case VTT_NamedPawnProximity:
		return ((SASPawn(aOther) != None) && (aOther.Tag == mNamedPawnTag));

	case VTT_HumanPlayerProximity:
		return (SASPawn(aOther) != None) && SASPawn(aOther).IsHumanControlled();

	case VTT_SoldierProximity:
		return (SASSoldier(aOther) != None);

	case VTT_TerroristProximity:
		return (SASTerrorist(aOther) != None);

	case VTT_HostageProximity:
		return (SASHostage(aOther) != None);
	
	default:
		return false;
	}
}


//
// Called when something touches the trigger.
//
event Touch (
	Actor	aTouched)
{
	local int	sndIdx;

	if (IsRelevant (aTouched))
	{
		if (mReTriggerDelay > 0)
		{
			if (Level.TimeSeconds - mLastTriggerTime < mReTriggerDelay)
			{
				return;
			}
			mLastTriggerTime = Level.TimeSeconds;
		}

		// Broadcast the Trigger message to all matching actors
		TriggerEvent(Event, self, aTouched.Instigator);

		// Notify scripts of event
		if (Level.Game != None)
		{
			Level.Game.EventTriggered (Event);
		}
		// notify objective manager of event
		if ( Level.GetLocalPlayerController () != None )
		{
			SASGRI ( Level.GetLocalPlayerController ().GameReplicationInfo ).EventTriggered ( Event );
		}
				
		// GP: Removed as they were only used for debug.
		//if ((mMessage != "") && (aTouched.Instigator != None))
		//{
			// Send a string message to the toucher
			//aTouched.Instigator.ClientMessage (mMessage);

			// Massage only used for debugging purposes - send to local player.
			//Level.GetLocalPlayerController().Pawn.ClientMessage( mMessage );
		//}

		// Play random trigger sound
		if ( mTriggerSounds.Length > 0 )
		{
			sndIdx = Rand( mTriggerSounds.Length );
			PlaySound( 
				mTriggerSounds[sndIdx].Snd, 
				SLOT_Interact,
				mTriggerSounds[sndIdx].Volume,
				true,
				mTriggerSounds[sndIdx].Radius,
				mTriggerSounds[sndIdx].Pitch,
				mTriggerSounds[sndIdx].bAttenuate );
		}

		if (mbTriggerOnceOnly)
		{
			// Ignore future touches
			SetCollision(false);
		}
	}
}

event Untouch (
   Actor	aUntouched)
{	
	local int	sndIdx;

	if (IsRelevant (aUntouched))
	{
		UntriggerEvent (Event, self, aUntouched.Instigator);

		// Notify scripts of event
		if (Level.Game != None)
		{
			Level.Game.EventUntriggered (Event);
		}
		// notify objective manager of event
		if ( Level.GetLocalPlayerController () != None )
		{
			SASGRI ( Level.GetLocalPlayerController ().GameReplicationInfo ).EventUntriggered ( Event );
		}

		// Play untrigger sound
		if ( mUntriggerSounds.Length > 0 )
		{
			sndIdx = Rand( mUntriggerSounds.Length );
			PlaySound( 
				mUntriggerSounds[sndIdx].Snd, 
				SLOT_Interact,
				mUntriggerSounds[sndIdx].Volume,
				true,
				mUntriggerSounds[sndIdx].Radius,
				mUntriggerSounds[sndIdx].Pitch,
				mUntriggerSounds[sndIdx].bAttenuate );
		}
	}
}

function TakeDamage ( 
	int					aDamage, 
	Pawn				aInstigatedBy,
	Vector				aHitlocation, 
	Vector				aMomentum, 
	class<DamageType>	aDamageType,
	optional Weapon		wpn)
{
	mLastDamageTime = Level.TimeSeconds;

	if ((meTriggerType == VTT_Damaged) && (aDamage >= mDamageThreshold) && (aInstigatedBy != None))
	{
		if (mReTriggerDelay > 0)
		{
			if (Level.TimeSeconds - mLastTriggerTime < mReTriggerDelay)
			{
				return;
			}
			mLastTriggerTime = Level.TimeSeconds;
		}

		// Broadcast the Trigger message to all matching actors.
		TriggerEvent (Event, self, aInstigatedBy);

		// Notify scripts of event
		if (Level.Game != None)
		{
			Level.Game.EventTriggered (Event);
		}

		// GP: Removed as they were only used for debug.
		//if (mMessage != "")
		//{
		//	// Send a string message to the toucher.
		//	aInstigatedBy.Instigator.ClientMessage (mMessage);
		//}

		if (mbTriggerOnceOnly)
		{
			// Ignore future touches.
			SetCollision(false);
		}
	}
}


state AssociatedTouch
{
	function BeginState()
	{
		warn("SASVolume in AssociatedTouch state - should not happen.");
		GotoState('');
	}
}


