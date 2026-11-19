//=============================================================================
// SASBoobyTrapDevice
// 
// Booby trap device class in SAS
//=============================================================================

class SASBoobyTrapDevice extends Actor
	native
	placeable;

var() SASBoobyTrapTrigger			mBoobyTrapTrigger;			// abstract trigger volume
var() SASBoobyTrapWire				mBoobyTrapWire;				// physical wire representation

var int								mExplosionsTriggered;		// internal counter
var bool							mbTriggered;				// internal flag

var() bool							mbArmed;					// armed status

var() class<Emitter>				mMarkerClass;				// Object used to mark this
var() class<SASGenericExplosion>	mExplosionClass;			// Generic xxplosion class
var() bool							mbExplosionUsesActorRot;						
//var Emitter							mMarker;

var() float							mTimeToExplode;				// Time to explode after triggered
var() int							mNumExplosions;				// Num explosions to fire off
var() Range							mTimeBetweenExplosions;		// Min/max time between explosions


var() float							mDisarmRadius;				// how far away to be able to disarm
var() float							mDisarmAngle;				// angle to look at this device to disarm
var() float							mDisarmAngleDegrees;			// angle to see disarm icon
var() float							mDisarmTime;				// how long it takes to disarm

var() Sound							mTriggeredSound;
var() float							mTriggeredSoundVolume;
var() float							mTriggeredSoundRadius;

var() Sound							mDisarmedSound;
var() float							mDisarmedSoundVolume;
var() float							mDisarmedSoundRadius;

var() Sound							mDisarmingSound;
var() float							mDisarmingSoundVolume;
var() float							mDisarmingSoundRadius;
var() float							mDisarmingSoundRepeatTime;
var   float							mDisarmingSoundTime;

var(EventThatTriggersMe) Name		mEventName;					// event name trigger

var(Events) name          MakeSafeEvent;         // The event that happens when it's made safe.
var(Events) name          GoOffEvent   ;         // The event that happens when it goes off

replication
{
	reliable if ( bNetInitial && (Role == ROLE_Authority) )
		mDisarmRadius,
		mDisarmAngleDegrees,	
		mDisarmTime;

	reliable if ( Role == ROLE_Authority )
		mbTriggered,
		mbArmed;
}

//-----------------------------------------------------------------------------
// PostBeginPlay
//
// Called after level has started and booby-trap has been spawned.
event PostBeginPlay ()
{
	Super.PostBeginPlay();

	SetbStatic(false);

	// Check time between explosions has sensible values
	if ( mNumExplosions > 1 )
	{
		if ( mTimeBetweenExplosions.Min <= 0.0 )
		{
			mTimeBetweenExplosions.Min = 0.05;
		}
		mTimeBetweenExplosions.Max = FMax ( mTimeBetweenExplosions.Min, mTimeBetweenExplosions.Max );
	}

	if ( mBoobyTrapTrigger != None )
	{
		mBoobyTrapTrigger.mBoobyTrapDevice = self;
	}
}

//-----------------------------------------------------------------------------
// DestroyDevice
//
// remove device and volume after exploding
function DestroyDevice ()
{
	local SASBoobyTrapMgr boobyTrapManager;

	boobyTrapManager = SASGameInfo( Level.Game ).mBoobyTrapManager;
	if ( boobyTrapManager != None )
	{
		boobyTrapManager.UnregisterDevice( self );
	}

	if ( mBoobyTrapTrigger != None )
	{
		mBoobyTrapTrigger.Destroy ();
		mBoobyTrapTrigger = None;
	}

	if ( mBoobyTrapWire != None )
	{
		mBoobyTrapWire.bHidden = true;
	}

	Destroy ();

	mbArmed = false;
}

//-----------------------------------------------------------------------------
// MakeSafe
//
// make the device safe but don't remove it
function MakeSafe (Pawn who_by)
{
	if ( mbTriggered || !mbArmed  )
	{
		return;
	}

	// set off marker
	Spawn ( mMarkerClass, self,, Location + ( Vect ( 0.0, 0.0, 1.0 ) * ( CollisionHeight / 2.0 + 0.25 ) ) );
	
	TriggerEvent(MakeSafeEvent, self, who_by);
	
	mbArmed = false;

	AmbientSound = None;
	PlaySound ( mDisarmedSound,,mDisarmedSoundVolume,,mDisarmedSoundRadius);

	if ( mBoobyTrapWire != None )
	{
		mBoobyTrapWire.bHidden = true;
	}
}

//-----------------------------------------------------------------------------
// Explode
//
function Explode ()
{ 
	local Rotator	rot;
	// spawn the explosion effects, sound and damage
	if ( mExplosionClass != None )
	{
		if ( mbExplosionUsesActorRot )
		{
			rot = Rotation;
		}
		else
		{
			rot = Rot(16384,0,0);
		}
		Spawn ( mExplosionClass,,, Location, rot );
		mExplosionsTriggered++;
		
		// An event.
		TriggerEvent(GoOffEvent, self, None);

		// self destruction
		if ( mExplosionsTriggered >= mNumExplosions )
		{
 			DestroyDevice ();
		}
		else
		{
			SetTimer ( RandRange ( mTimeBetweenExplosions.Min, mTimeBetweenExplosions.Max ), false );
		}
	}
	else
	{
		DestroyDevice();
	}
}

//-----------------------------------------------------------------------------
// Timer
//
// Called when time to explosion has expired.
function Timer ()
{
	Explode ();
}

//-----------------------------------------------------------------------------
// TriggerTouched
//
// an actor has tripped the booby trap volume
function TriggerTouched ( Actor aTouched )
{
	local SASPawn				touchingPawn;
	local SASPlayerController	pc;
	local SASSoldier			soldier;

	touchingPawn = SASPawn( aTouched );

	if ( mbArmed )
	{
		if ( touchingPawn != None )
		{
			if ( (touchingPawn.Controller != None) && (touchingPawn.Controller.mType == CONTROLLER_Player) )
			{
				pc = SASPlayerController( touchingPawn.Controller );
			}

			if ( (pc == None)
				&& ((touchingPawn.mPawnType == PAWN_Soldier) || (touchingPawn.mPawnType == PAWN_Terrorist)) )
			{
				switch ( touchingPawn.mPawnType )
				{
				case PAWN_Soldier:
					soldier = SASSoldier ( aTouched );
					if ( soldier != None )
					{
						// Squad members mark it.
						MakeSafe(soldier);
						soldier.PlaySpeech (SPEECH_SquadDefusingBomb);
					}
					break;

				case PAWN_Terrorist:
					// Terrorists avoid it.
					touchingPawn.AvoidBoobyTrap ( Location );
					break;
				}
			}
			else if ( !mbTriggered )
			{
				// Player or hostage has tripped it!
				mbTriggered = true;

				AmbientSound = None;
				PlaySound ( mTriggeredSound,,mTriggeredSoundVolume,,mTriggeredSoundRadius);


				// remove the trigger (volume & maybe wire ...)
				if ( mBoobyTrapTrigger != None )
				{
					mBoobyTrapTrigger.Destroy();
					mBoobyTrapTrigger = None;
				}

				if ( mBoobyTrapWire != None )
				{
					mBoobyTrapWire.bHidden = true;
				}

				if ( mTimeToExplode > 0.0 )
				{
					// Initialise time to explosion
					SetTimer( mTimeToExplode, false );
				}
				else
				{
					// just go ahead and blow
					Explode();
				}
			}
		}
	}

	if ( !mbArmed && (touchingPawn != None) )
	{
		// just avoid it!
		touchingPawn.AvoidBoobyTrap( Location );
	}
}

//-----------------------------------------------------------------------------
// TriggerUntouched
//
// actor has left the booby trap volume
function TriggerUntouched ( Actor aUntouched )
{
	if ( !mbArmed && ( SASPawn ( aUntouched ) != None ) )
	{
		SASPawn ( aUntouched ).BoobyTrapAvoided ();
	}
}

//-----------------------------------------------------------------------------
// Default properties
//

// Decompiled with UE Explorer.
defaultproperties
{
    mbArmed=true
    mTimeToExplode=0.5000000
    mNumExplosions=1
    mDisarmRadius=90.0000000
    mDisarmAngleDegrees=10.0000000
    mDisarmTime=5.0000000
    mTriggeredSoundVolume=1.0000000
    mTriggeredSoundRadius=50.0000000
    mDisarmedSoundVolume=1.0000000
    mDisarmedSoundRadius=50.0000000
    mDisarmingSoundVolume=1.0000000
    mDisarmingSoundRadius=50.0000000
    mDisarmingSoundRepeatTime=1.0000000
}