//=============================================================================
// SASDoorMover.uc
//
// Base mover class for SAS doors.
//=============================================================================

class SASDoorMover extends Mover
	native;

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.

//-----------------------------------------------------------------------------
// Constants

// Door interaction point array enumeration
const DOORINTERACT_Front	= 0;
const DOORINTERACT_Behind	= 1;
const DOORINTERACT_Num		= 2;


//-----------------------------------------------------------------------------
// Enums

//-----------------------------------------------------------------------------
// Member Vars

var float							mHeight, mWidth, mThickness;	// Door dimensions
var vector							mBaseDir;			// Door facing direction when closed
var float							mShowMovingTimer;	// Timer used to periodically show self to AI controllers while moving.
var float							mLastOpenCloseTime;

var int								mPathbuildingSavedKeyFrame;	// Original keyframe of mover before being changed during pathing.

// Interaction points for pawns to stand at either side of door, auto created 
// in editor during build paths process.
var(SASDoor) edfindable				SASDoorInteractPoint	mInteractPoints[DOORINTERACT_Num];

var (SASDoor) bool					mbLocked;			// true if door is locked (and needs breaching)
var (SASDoor) SASDoorMover			mDoubleDoorLink;	// ID of other door if this is one of a pair

var(AI)	bool						mbAutoDoorIsEntryPoint;	// Use SASEntryPoint as the auto-door nav point.
var(AI) float						mSoundEffectiveDist;	// Additional dist added to dist from a sound when door is closed (for hearing detection). 

var (Health) int					mHingeHealth [3];
var (Health) int					mLockHealth;
var (Health) int					mGrenadeHealth;		// Health value used for grenade damage.
var (Health) bool					mbIsDamageable;
var (Health) StaticMesh				mDestroyedMesh;

var (Collision) bool				mAutoCalculateHinges;	// If set, hinge heights are overridden in code
var (Collision) Float				mHingeHeights [3];	// Hinge offsets from door
var (Collision) Vector				mLockOffset;		// Offset position of lock
var (Collision) float				mHingeLockRadius;	// Collision radius of lock and hinges
var vector lastImpact;

var(Health) class <SASGenericExplosion>		mExplosionType;

var(ActionEvent) Name				mOpenEvent;
var(ActionEvent) Name				mAssaultEvent;


var StaticMesh			mOriginalMesh;
var bool				mOriginalClosed;
var int					mOriginalKeyNum;
var bool				mOriginalAvoidMe;
var NavigationPoint		mOriginalMarker;
var bool				mOriginalLocked;
var int					mOriginalLockHealth;
var int					mOriginalGrenadeHealth;
var int					mOriginalHingeHealth[3];
var bool				mOriginalCollideWorld;

var bool				mbClientKillDoor;

replication
{
	reliable if ( Role == ROLE_Authority && bNetDirty )
		mbClientKillDoor;
}


//-----------------------------------------------------------------------------
// Exec Functions

//-----------------------------------------------------------------------------
// Native functions


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// PostBeginPlay
// 
event PostBeginPlay()
{
	local vector				tBoxMin, tBoxMax;
	local SASDoorInteractPoint	tSwapIP;

	Super.PostBeginPlay();

	// Hmm, Mover.PostBeginPlay() sets up the Leader/Follower vars using the Tag. Due to copying
	// and pasting of doors throughout our levels, the Tag data is frequently wrong. So... I'm going
	// to assume that Leader and Follower is never used.
	Leader = self;
	Follower = None;

	// Store base rotation as a vector
	mBaseDir = vector(BaseRot);

	if (StaticMesh != None)
	{
		GetLocalBoundingBox (tBoxMin, tBoxMax);

		// Doors are aligned with their hinge at their origin and then extending along their local
		// Y axis
		mHeight = ABS (tBoxMax.Z - tBoxMin.Z);
		mWidth = ABS (tBoxMax.Y - tBoxMin.Y);
		mThickness = ABS (tBoxMax.X - tBoxMin.X);
	}

	// Make sure interaction points are ordered correctly in the array.
	// Point on side of door in which door is facing should be first.
	if ((mInteractPoints[DOORINTERACT_Front] != None)
		&& !ActorInFront(mInteractPoints[DOORINTERACT_Front]))
	{
		// front IP on wrong side
		tSwapIP = mInteractPoints[DOORINTERACT_Front];
	}
	if (mInteractPoints[DOORINTERACT_Behind] != None)
	{
		if (ActorInFront(mInteractPoints[DOORINTERACT_Behind]))
		{
			// back IP on wrong side

			// If front IP also on wrong side then swap them
			if (tSwapIP != None)
			{
				mInteractPoints[DOORINTERACT_Front] = mInteractPoints[DOORINTERACT_Behind];
				mInteractPoints[DOORINTERACT_Behind] = tSwapIP;
			}
		}
	}

	// Check door has a nav point marker.
	if ( MyMarker == None )
	{
		LogHuman( "Door <"$self$" does not link to a nav point marker." );
	}

	// Get explosion - only if not already defined.
	if ( mExplosionType == None )
	{
		mExplosionType = class<SASGenericExplosion>( DynamicLoadObject( "SASEffects.Breach_Door", class'Class' ) );
	}

	// Work out hinge positions if necessary
	if (mAutoCalculateHinges)
	{
		mHingeHeights [0] = 27;
		mHingeHeights [1] = mHeight / 2;
		mHingeHeights [2] = mHeight - 27;

		// If door is upside down (origin at top) negate heights
		if (tBoxMax.Z < tBoxMin.Z)
		{
			mHingeHeights [0] *= -1;
			mHingeHeights [1] *= -1;
			mHingeHeights [2] *= -1;
		} // if
	} // if
}


// Called after PostBeginPlay.
//
simulated event SetInitialState()
{
	if ( InitialState == 'TriggerToggle' )
	{
		InitialState = 'TriggerControl';
	}

	if ( InitialState == 'TriggerControl' )
	{
		bTriggerOnceOnly = false;
	}

	Super.SetInitialState();
}


simulated function PostNetBeginPlay()
{
	local int i;

	Super.PostNetBeginPlay();
	
	mOriginalMesh			= StaticMesh;
	mOriginalClosed			= bClosed;
	mOriginalKeyNum			= KeyNum;
	mOriginalAvoidMe		= bAvoidMe;
	mOriginalMarker			= myMarker;

	mOriginalLocked			= mbLocked;
	mOriginalLockHealth		= mLockHealth;
	mOriginalGrenadeHealth	= mGrenadeHealth;
	for ( i = 0; i < 3; ++i )
	{
		mOriginalHingeHealth[i] = mHingeHealth[i];
	}

	mOriginalCollideWorld	= bCollideWorld;
}


///////////////////////////////////////////////////////////////////////////////
// Reset
//
// Put door back into original state on restarting level.
simulated function Reset()
{
	local int i;

	Super.Reset();

	bHidden			= false;
	SetDrawType( DT_StaticMesh );
	SetStaticMesh( mOriginalMesh );

	KeyNum			= mOriginalKeyNum;
	PrevKeyNum		= KeyNum;
	PhysAlpha		= 0.0;

	// Set initial location.
	Move( BasePos + KeyPos[KeyNum] - Location );

	// Initial rotation.
	SetRotation( BaseRot + KeyRot[KeyNum] );

	RealPosition	= Location;
	RealRotation	= Rotation;

	OldPos			= Location;
	OldRot			= Rotation;
	SimOldPos		= Location;
	SimOldRotPitch	= Rotation.Pitch;
	SimOldRotYaw	= Rotation.Yaw;
	SimOldRotRoll	= Rotation.Roll;
	SimInterpolate	= vect(0,0,0);

	if ( Role == ROLE_Authority )
	{
		ServerReset();
	}


	bInterpolating	= false;
	bOpening		= false;
	bDelaying		= false; 
	bClientPause	= false;
	bClosed			= mOriginalClosed;

	// Set antiportal state.
	for ( i = 0; i < AntiPortals.Length; ++i )
	{
		if ( bClosed )
		{
			if ( AntiPortals[i].DrawType != DT_None )
			{
				AntiPortals[i].SetDrawType( DT_None );
			}
		}
		else
		{
			if ( AntiPortals[i].DrawType != DT_AntiPortal )
			{
				AntiPortals[i].SetDrawType( DT_AntiPortal );
			}
		}
	}

	mbClientKillDoor = false;
	//AntiPortals.Length = 0;
}


function ServerReset()
{
	local int i;

	// Turn on all collision.
	bCollideWorld = mOriginalCollideWorld;
	SetCollision( true, true, true );

	// SAS stuff.
	mbLocked		= mOriginalLocked;
	mLockHealth		= mOriginalLockHealth;
	for ( i = 0; i < 3; ++i )
	{
		mHingeHealth[i] = mOriginalHingeHealth[i];
	}
	mLastOpenCloseTime = 0.0;

	// Mover stuff.
	bAvoidMe		= mOriginalAvoidMe;
	myMarker		= mOriginalMarker;
	if ( myMarker != None && Door( myMarker ) != None )
	{
		Door( myMarker ).MyDoor		= self;
		Door( myMarker ).bBlocked	= false;
	}
}


///////////////////////////////////////////////////////////////////////////////
// ActorInFront
// 
// Returns true if actor 'aOther' is located on the side of the door which the 
// door is facing when closed.
function bool ActorInFront (
	Actor		aOther)
{
	local float		dp;
	local vector	tVecDoorToActor;

	tVecDoorToActor = aOther.Location - mClosedWorldCentrePos;
	tVecDoorToActor.Z = 0.0;
	dp = tVecDoorToActor Dot mBaseDir;

	return (dp > 0.0);
}


///////////////////////////////////////////////////////////////////////////////
// GetInteractPointForPawn
// 
// Returns the door interact point for a pawn to move to depending on 
// which side of the door the pawn is located.
function SASDoorInteractPoint GetInteractPointForPawn (
	Pawn		aOther)
{
	if (ActorInFront(aOther))
	{
		return mInteractPoints[DOORINTERACT_Front];
	}

	return mInteractPoints[DOORINTERACT_Behind];
}

///////////////////////////////////////////////////////////////////////////////
// trivial test atm, awaiting further functionality
//
function bool IsOpen()
{
	return !bClosed;
}

///////////////////////////////////////////////////////////////////////////////
// Open the mover.
function DoOpen()
{
	Super.DoOpen();

	if ( bClosed )
	{
		// Reset timer used to periodically show self moving to AI.
		mShowMovingTimer = 0.0f;
	}
}

///////////////////////////////////////////////////////////////////////////////
function TriggerOpenEvent ( Pawn Other )
{
	TriggerEvent ( mOpenEvent, self, Other );
}

///////////////////////////////////////////////////////////////////////////////
function TriggerAssaultEvent ( Pawn Other )
{
	TriggerEvent ( mAssaultEvent, self, Other );
}

///////////////////////////////////////////////////////////////////////////////
// Close the mover.
function DoClose()
{
	Super.DoClose();

	if ( !bClosed )
	{
		// Reset timer used to periodically show self moving to AI.
		mShowMovingTimer = 0.0f;
	}
}

///////////////////////////////////////////////////////////////////////////////
// *TBD* implement individual hinges and lock damage
function TakeDamage(
	int					aDamage,
	Pawn				aInstigatedBy,
	Vector				aHitlocation,
	Vector				aMomentum,
	class<DamageType>	aDamageType,
	optional Weapon		wpn)
{
	local bool			hit;
	local int			i;
	local SASGameInfo	gi;

	if ( bHidden || !mbIsDamageable || !IsAlive() || (wpn == None && (aDamage < 1000000)) )
	{
		return;
	} // if

	// We're only affected by weapons that cause Assault damage or grenades.
	if ( aDamage < 1000000 )
	{
		if (	(SASGrenadeWeapon( wpn ) == None) &&
				((SASAmmo( wpn.AmmoType ) == None) || !SASAmmo( wpn.AmmoType ).mDamageStructures) )
		{
			return;
		} // if
	}

	lastImpact = aHitLocation;

	// For none-grenade weapons, must hit hinges to cause damage.
	if ( (aDamage >= 1000000) || (SASGrenadeWeapon( wpn ) != None) )
	{
		mGrenadeHealth -= aDamage;
	}
	else
	{
		// Check to see if the shot has hit any of the hinges
		for (i = 0; i < 3; i++)
		{
			if (VSizeSq (aHitlocation - getHingePosition (eDoorHinge (i))) < Square (mHingeLockRadius))
			{
				mHingeHealth [i] -= aDamage;
				hit = true;
				break;
			} // if
		} // for

		// If it didn't hit a hinge, maybe the lock ?
		if (!hit)
		{
			if (VSizeSq (aHitlocation - getLockPosition ()) < Square (mHingeLockRadius))
			{
				mLockHealth -= aDamage;
				hit = true;
			} // if
		} // if

		// Didn't hit anything
		if (!hit)
		{
			return;
		} // if
	}

	// If all three hinges are destroyed, door is destroyed
	if (!isAlive ())
	{
		KillDoor();
	
		// Tell squad manager what's happen to us.
		gi = SASGameInfo( Level.Game );
		if ( gi != None && gi.mSquadManager != None )
		{
			gi.mSquadManager.notifyDoorDestroyed (self);
		}
	} // if

	// If lock is destroyed, door becomes unlocked
	if (mLockHealth <= 0)
	{
		mbLocked = false;
	} // if
} // TakeDamage


function KillDoor()
{
	if ( mExplosionType != None )
	{
		Spawn( mExplosionType,,, Location, Rotation );
	}

	// Don't make AI avoid me on bumping (shouldn't happen with ne wcollision settings anyway).
	bAvoidMe = false;	

	// Remove from entry points otherwise AI will still attempt to interact
	if ( myMarker != None )
	{
		if ( Door(myMarker) != None )
		{
			Door(myMarker).MyDoor = None;

			// Unblock nav point.
			Door(myMarker).bBlocked = false;
		}

		myMarker = None;
	}

	ClientKillDoor();
	
	// And tell remote clients to do this too.
	mbClientKillDoor = true;
}


simulated event ClientKillDoor()
{
	local int i;

	if ( mDestroyedMesh == None )
	{
		// Make door invisible.
		bHidden = true;
	}
	else
	{
		SetStaticMesh( mDestroyedMesh );
	}

	// Turn off all collision.
	bCollideWorld = false;
	SetCollision( false, false, false );

	// Turn off antiportals
	for ( i = 0; i < AntiPortals.Length; ++i )
	{
		if ( AntiPortals[i].DrawType != DT_None )
		{
			AntiPortals[i].SetDrawType( DT_None );
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
function bool isAlive ()
{
	local int i;

	if ( mGrenadeHealth <= 0 )
	{
		return false;
	}

	for (i = 0; i < 3; i++)
	{
		if (mHingeHealth [i] > 0)
		{
			return true;
		} // if
	} // for

	return false;
} // isAlive

///////////////////////////////////////////////////////////////////////////////
// Gets position of the specified hinge
function vector getHingePosition (eDoorHinge hinge)
{
	local vector hp;

	if (SASHingedDoorMover (self) != None && SASHingedDoorMover (self).mbHingeOnLeft)
	{
		hp = vect (0, 0, 0);
		hp.y = mWidth;

		// RotateZ uses radians, not UnReal units ....
		hp = RotateZ (hp, Unreal2Rad (Rotation.Yaw));
		hp = Location + hp;
	} // if
	else
	{
		hp = Location;
	} // else

	hp.Z += mHingeHeights [hinge];

	return hp;
} // getHingePosition

///////////////////////////////////////////////////////////////////////////////
// Gets position of the lock when door is closed
// *TBD* - allow for open / partially open doors
function vector getLockPosition ()
{
	local vector lp;

	if (SASHingedDoorMover (self) != None && SASHingedDoorMover (self).mbHingeOnLeft)
	{
		lp.y = mWidth - mLockOffset.y;
	} // if
	else
	{
		lp.y = mLockOffset.y;
	} // else
	lp.z = mLockOffset.z;

	lp = Location + (lp >> Rotation);

	return lp;
} // getLockPosition

///////////////////////////////////////////////////////////////////////////////
function drawDebug (HUD aHUD)
{
	local Color liveColour, deadColour, Colour;
	local Vector dir;
	local int i;

	dir = vect (0, 0, 1);

	if (mbLocked)
	{
		Colour = class'Canvas'.Static.MakeColor (255, 128, 128);
	} // if
	else
	{
		Colour = class'Canvas'.Static.MakeColor (128, 255, 128);
	} // else
	aHUD.Draw3DCylinder (getLockPosition () + dir * mHingeLockRadius, dir, mHingeLockRadius, mHingeLockRadius * 2, 12, Colour);

	liveColour = class'Canvas'.Static.MakeColor (0, 255, 0);
	deadColour = class'Canvas'.Static.MakeColor (255, 0, 0);
	for (i = 0; i < 3; i++)
	{
		if (mHingeHealth [i] > 0)
		{
			aHUD.Draw3DCylinder (getHingePosition (eDoorHinge (i)) + dir * mHingeLockRadius, dir, mHingeLockRadius, mHingeLockRadius * 2, 12, liveColour);
		} // if
		else
		{
			aHUD.Draw3DCylinder (getHingePosition (eDoorHinge (i)) + dir * mHingeLockRadius, dir, mHingeLockRadius, mHingeLockRadius * 2, 12, deadColour);
		} // else
	} // for

	Colour = class'Canvas'.Static.MakeColor (255, 255, 0);
	aHUD.Draw3DCylinder (lastImpact + dir * mHingeLockRadius , dir, mHingeLockRadius, mHingeLockRadius * 2, 12, Colour);
	//Colour = class'Canvas'.Static.MakeColor (0, 0, 255);
	//aHUD.Draw3DCylinder (Location + dir * mHeight / 2, dir, 10, mHeight, 12, Colour);
} // drawDebug

//-----------------------------------------------------------------------------
function bool TriggerableCheck ()
{
	return mbLocked;
} // TriggerableCheck
//-----------------------------------------------------------------------------
function resetHealth ()
{
	mHingeHealth [0] = default.mHingeHealth [0];
	mHingeHealth [1] = default.mHingeHealth [1];
	mHingeHealth [2] = default.mHingeHealth [2];
	mLockHealth = default.mLockHealth;
} // resetHealth


function ServerEncroachWait()
{
	SimInterpolate.X = 100 * PhysAlpha;
	SimInterpolate.Y = 0.f;
	SimInterpolate.Z = 256 * PrevKeyNum + KeyNum;
}

function ServerEncroachCommence()
{
	SimInterpolate.X = 100 * PhysAlpha;
	SimInterpolate.Y = 100 * FMax(0.01, PhysRate);
	SimInterpolate.Z = 256 * PrevKeyNum + KeyNum;
}

//-----------------------------------------------------------------------------
// States

///////////////////////////////////////////////////////////////////////////////
// STATE TriggerToggle
// 
auto state() TriggerControl
{
	event BeginState ()
	{
		SetTimer ( 0.0, false );
	}

	function bool EncroachingOn( 
		Actor	aOther )
	{
		if ( Super.EncroachingOn( aOther ) )
		{
			// If other is an AI controlled pawn tell it to avoid.
			if ( (aOther != None) 
				&& (Pawn( aOther ) != None)
				&& (Pawn( aOther ).Controller != None) 
				&& (Pawn( aOther ).Controller.mType != CONTROLLER_Player) )
			{
				if ( SASAIController( Pawn( aOther ).Controller ).AllowDoorEncroach( self ) )
				{
					return false;
					
				}

				SASAIController( Pawn( aOther ).Controller ).NotifyBump( self );
			}

			if ( !aOther.IsA( 'Projectile' ) )
			{
				// Try to move again later.
				GotoState( , 'EncroachWait' );
				ServerEncroachWait();
				return true;
			}
		}

		return false;
	}

	function Trigger(
		Actor	aOther,
		Pawn	aEventInstigator )
	{
		local Controller	C;

		if ( TriggerableCheck() )
		{
			return;
		}

		if ( Controller( aOther ) != None && Controller( aOther ).mType == CONTROLLER_Player )
		{
			if ( mLastOpenCloseTime > Level.TimeSeconds - 0.5 )
			{
				return;
			}
		}
		mLastOpenCloseTime = Level.TimeSeconds;

		// Tell AI it's openning.
		for ( C = Level.ControllerList; C != None; C = C.nextController )
		{
			if ( C.mType != CONTROLLER_Player )
			{
				SASAIController( C ).NotifyDoorOpening( self, aEventInstigator );
			}
		}

		SavedTrigger	= aOther;
		Instigator		= aEventInstigator;
		SavedTrigger.BeginEvent();
		GotoState( , 'Open' );
	}

	function Untrigger(
		Actor	aOther,
		Pawn	aEventInstigator )
	{
		if ( Controller( aOther ) != None && Controller( aOther ).mType == CONTROLLER_Player )
		{
			if ( mLastOpenCloseTime > Level.TimeSeconds - 0.5 )
			{
				return;
			}
		}
		mLastOpenCloseTime = Level.TimeSeconds;

		SavedTrigger	= aOther;
		Instigator		= aEventInstigator;
		SavedTrigger.BeginEvent();
		GotoState( , 'Close' );
	}

EncroachWait:
	// Sleep before trying to move again.
	Sleep( 0.1 );
	ServerEncroachCommence();
	Goto( 'Open' );
}
 

//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mbAutoDoorIsEntryPoint=true
    mSoundEffectiveDist=500.0000000
    mHingeHealth[0]=20
    mHingeHealth[1]=20
    mHingeHealth[2]=20
    mLockHealth=40
    mGrenadeHealth=999
    mbIsDamageable=true
    mHingeHeights[0]=27.0000000
    mHingeHeights[1]=56.0000000
    mHingeHeights[2]=85.0000000
    mLockOffset=(X=0.0000000,Y=57.0000000,Z=43.0000000)
    mHingeLockRadius=15.0000000
    MoverEncroachType=0
    MoveTime=0.5000000
    bTriggerOnceOnly=true
    OpeningLoudness=0.1000000
    ClosingLoudness=0.1000000
    bAvoidMe=true
    bAutoDoor=true
    InitialState="TriggerControl"
}