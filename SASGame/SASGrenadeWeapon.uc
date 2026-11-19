//=============================================================================
// SASGrenadeWeapon.uc
//
// Abstract base class for all hand-grenade weapons in SAS.
//=============================================================================

class SASGrenadeWeapon extends SASWeapon
	native
	abstract;


//-----------------------------------------------------------------------------
// Constants

//-----------------------------------------------------------------------------
// Member variables

var const name				mGrenadeAttachBone;		// Bone to attach grenade projectile to
var bool					mbCanThrow;				// Throw stage of firing can go ahead (fire button has been released)
var bool					mbPinPulled;
var bool					mbThrown;

replication
{
	reliable if ( Role < ROLE_Authority )
		ServerThrowGrenade;
}

//-----------------------------------------------------------------------------
// Functions

//------------------------------------------------------------------------------
// GiveAmmo
//
function GiveAmmo(
	Pawn	aOther )
{
	if ( AmmoName == None )
	{
		return;
	}

	Super.GiveAmmo( aOther );
	AmmoType.AddAmmo( AmmoType.MaxAmmo );
}


//------------------------------------------------------------------------------
// ShowFPGrenadeMesh
//
// Show/hide grenade mesh in first person hands.
simulated function ShowFPGrenadeMesh(
	bool abShow )
{
	if ( mFPWeaponMeshActor != None )
	{
		mFPWeaponMeshActor.bHidden = !abShow;
	}
}


//------------------------------------------------------------------------------
// FireProjectileSlow
//
function FireProjectileSlow()
{
	Warn( "FireProjectileSlow should not be called for grenade throwing." );
}

//------------------------------------------------------------------------------
// Fire
//
// overrides Weapon.Fire to start grenade throwing process
simulated function Fire(
	float	aValue )			// Unused
{
	// Can't fire if out of ammo
	// TODO - play empty mag sound 
	if ( !HasAmmo() )
	{
		return;
	}

	// Server side firing (change to firing state)
	ServerFire();

	if ( Role < ROLE_Authority )
	{
		LocalFire();
		GotoState ( 'NormalFire' );
	}
}

//------------------------------------------------------------------------------
//
//
function ServerFire()
{
	GotoState( 'NormalFire' );
	LocalFire ();
}

//------------------------------------------------------------------------------
//
//
simulated function LocalFire()
{
	bPointing = true;

	// Trigger pulling pin animation
	PlayPullPin ();
}

//------------------------------------------------------------------------------
//
//
simulated function ThrowGrenade()
{
	ServerThrowGrenade();

	if ( Role < ROLE_Authority )
	{
		LocalThrowGrenade();
	}
}


//------------------------------------------------------------------------------
//
//
function ServerThrowGrenade()
{
	LocalThrowGrenade();
}


//------------------------------------------------------------------------------
//
//
simulated function LocalThrowGrenade()
{
	PlayThrowing();
	DecrementAmmo( 1 );
	mNumInMag = 0;
	GotoState( 'GrenadeThrowing' );
}


//------------------------------------------------------------------------------
//
//
simulated function DropGrenade()
{
	local Coords			spawnCoords;
	local Vector			spawnLoc;

	if ( Instigator.IsLocallyControlled() )
	{
		// Hide grenade mesh attached to hands.
		ShowFPGrenadeMesh( false );

		// Hide third person grenade mesh.
		ThirdPersonActor.bHidden = true;

		// Get spawn location and rotation depending on whether throwing in 3rd or 1st person.
		if ( Instigator.IsFirstPerson() )
		{
			spawnCoords = GetBoneCoords( ATTACHBONE_HandsToGrenade );
			spawnLoc = spawnCoords.Origin;
		}
		else
		{
			spawnCoords = Instigator.GetBoneCoords( GRENADE_BONE );
			spawnLoc = spawnCoords.Origin;

			// 3rd person attachment also has position offset...
			
		}

		SASGrenadeAmmo( AmmoType ).SpawnGrenade( self, spawnLoc, true, true );
	}

	Finish();
	if ( Role < ROLE_Authority )
	{
		ClientFinish();
	}
}


//------------------------------------------------------------------------------
//
//
simulated function GrenadeThrown ()
{
	if ( AmmoType.AmmoAmount <= 0 )
	{
		ShowFPGrenadeMesh(false);
	}

	ServerGrenadeThrown ();

	if ( Role < ROLE_Authority )
	{
		ClientFinish();
	}
}

simulated function ReleaseGrenade();

//------------------------------------------------------------------------------
// ServerGrenadeThrown
//
// puts server-side pawn into 'NormalThrow' state
function ServerGrenadeThrown ()
{
	// set server-side and replicated to clients: forces weapon to reload
	mNumInMag = 0;		// TODO: ascertain number of grenades issued and
						// what to do when they run out ...
	Finish();

	StopFiringTime = Level.TimeSeconds;
	if ( Instigator != None )
	{
		Instigator.Controller.StopFiring();
	}
}

//------------------------------------------------------------------------------
// PlayFiring
//
simulated function PlayPullPin()
{
	PlayWeaponAnim( WPNANIM_PullPin );
	SASPawn ( Instigator ).PlayPullPinGrenade();
}

//------------------------------------------------------------------------------
// PlayThrowing
//
simulated function PlayThrowing()
{
	PlayWeaponAnim( WPNANIM_ThrowGrenade,, 0.1 );	// NOTE: Blend time is important as it is set to make the first and third person anims play roughly in synch.
	SASPawn ( Instigator ).PlayThrowGrenade ();
}

//------------------------------------------------------------------------------
// AnimNotifyPullPin
//
// Animation callback when pin is pulled.
simulated event AnimNotifyPullPin()
{
	Warn( "SASGrenadeWeapon.AnimNotifyPullPin() called when not in NormalFire state." );
}

//------------------------------------------------------------------------------
// AnimNotifyThrow
//
// This animation callback occurs when the held grenade should be released.
simulated event AnimNotifyThrow()
{
	Warn( "SASGrenadeWeapon.AnimNotifyThrow() called when not in Throwing state." );
}


//------------------------------------------------------------------------------
// AnimNotifyThrowOverarm
//
simulated event AnimNotifyThrowOverarm()
{
	Warn( "SASGrenadeWeapon.AnimNotifyThrowOverarm() called when not in Throwing state." );
}


//-----------------------------------------------------------------------------
// GetWeaponBoneFor
//
// Called when attaching 3rd person weapons to model.
//::function name GetWeaponBoneFor (	// Returns name of attachment weapon bone
//::	Inventory	inv)				// Ignored.
//::{
//::	return mGrenadeAttachBone;
//::}

//------------------------------------------------------------------------------
// HandleAttach
// 
// Called by spawned grenade projectile to attach itself to the first or third
// person model depending on view.
/*simulated function HandleAttach(
	SASGrenadeProjectile	aAttached )
{
	local Rotator rotOfs;

	if ( Instigator == None )
	{
		return;
	}

//	aAttached.bHidden = true;

	if ( Instigator.IsFirstPerson() )
	{
		aAttached.bHardAttach = true;
		AttachToBone( aAttached, mGrenadeAttachBone );

		// Hack: Rotate yaw 180deg
		rotOfs.Yaw = 37767;
		aAttached.SetRelativeRotation( rotOfs );
	}
	else
	{
		aAttached.bHardAttach = true;
		Instigator.AttachToBone( aAttached, GRENADE_BONE );
		//aAttached.SetHandOffset();
	}
}*/

//------------------------------------------------------------------------------
//
//
//::simulated function HandleDetach (
//::	SASGrenadeProjectile	aAttached )
//::{
//::	if ( aAttached.Base != None )
//::	{
//::		aAttached.Base.DetachFromBone( aAttached );
//::	}
//::}


//------------------------------------------------------------------------------
// PlaySelect
//
// Spawn new grenade projectile, play weapon select animation and sound.
simulated function PlaySelect()
{
	bForceFire		= false;
	bForceAltFire	= false;

	mbPinPulled = false;

	if ( AmmoType == None )
	{
		// TODO: ( AmmoType sometimes== None ) - Why?
		Warn ( "SASGrenadeWeapon.PlaySelect, error AmmoType is None! " @self );
		return;
	}

	
	// 1st person grenade is shown from start of select anim.
	ShowFPGrenadeMesh( true );
	
	// Make sure grenade is in resting anim.
	if ( mFPWeaponMeshActor != None )
	{
		mFPWeaponMeshActor.TweenToIdle( 0.0 );
	}

	// Hide third person weapon (grenade) mesh until anim notifier on the pawn.
	if ( ThirdPersonActor != None )
	{
		ThirdPersonActor.bHidden = false;
		}

	Super.PlaySelect();
}

//------------------------------------------------------------------------------
// PlayReloading
// 
// Play reloading animation and sound
simulated function PlayReloading()
{
	PlaySelect();
}

//-----------------------------------------------------------------------------
// States
//

//------------------------------------------------------------------------------
// STATE Idle
// 
state Idle
{
	simulated event BeginState()
	{
		// If out of ammo then switch to best weapon with ammo.
		if ( !AmmoType.HasAmmo() )
		{
			Instigator.Controller.SwitchToBestWeapon();
			return;
		}

		// Make sure FP grenade is visible.
		ShowFPGrenadeMesh( true );
		if ( ThirdPersonActor != None )
		{
			ThirdPersonActor.bHidden = false;
		}

		
		// Make sure grenade is in resting anim.
		if ( mFPWeaponMeshActor != None )
		{
			mFPWeaponMeshActor.TweenToIdle( 0.0 );
		}

		mbPinPulled = false;

		Super.BeginState();
	}
}

//------------------------------------------------------------------------------
// STATE NormalFire
// 
// Used for pull-pin stage of throwing grenade.
state NormalFire
{
	function Fire(float F) {}
	function AltFire(float F) {} 

	simulated function MoveOutOfView();


	///////////////////////////////////////////////////////////////////////////////
	// BeginState
	// 
	simulated function BeginState()
	{
		mbCanThrow = false;
		mbPinPulled = false;

		if ( Instigator.IsHumanControlled() )
		{
			Enable( 'Tick' );
		}
	}

	///////////////////////////////////////////////////////////////////////////////
	// EndState
	// 
	simulated function EndState()
	{
		Disable( 'Tick' );
	}


	///////////////////////////////////////////////////////////////////////////////
	// PutDown
	// 
	// Allow weapon change if pin pull anim has completed.
	simulated function bool PutDown()
	{
		// If pin pulled put down immediately, else wait until pin pulled and
		// then put down.
		if ( mbPinPulled )
		{
			Instigator.Controller.bFire = 0;
			GotoState('DownWeapon');
		}
		else
		{
			bChangeWeapon = true;
		}
		return true;
	}


	///////////////////////////////////////////////////////////////////////////////
	// HolderDied
	// 
	function HolderDied()
	{
		DecrementAmmo( 1 );
		mNumInMag = 0;
		DropGrenade();
	}


	///////////////////////////////////////////////////////////////////////////////
	// AnimEnd
	// 
	simulated function AnimEnd(
		int aChannel )
	{
		if ( bChangeWeapon )
		{
			GotoState( 'DownWeapon' );
			return;
		}

		mbPinPulled = true;

		if (	mbCanThrow || 
				( Instigator.IsLocallyControlled() && !Instigator.PressingFire() ) )
		{
			ThrowGrenade();
			mbCanThrow = false;
			Disable( 'Tick' );
		}
		else
		{
			if ( Instigator.Controller != None )
			{
				Instigator.Controller.GrenadeReadyToThrow();
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////
	// Tick
	// 
	simulated function Tick(
		float	aDeltaTime )
	{
		if ( Instigator.IsLocallyControlled() && !Instigator.PressingFire() )
		{
			Disable('Tick');

			if ( IsAnimating() )
			{
				mbCanThrow = true;
			}
			else
			{
				ThrowGrenade();
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////
	// AnimNotifyPullPin
	//
	// Animation callback when pin is pulled.
	simulated event AnimNotifyPullPin ()
	{
	}

Begin:
	Sleep( 0.0 );
}


//------------------------------------------------------------------------------
// state GrenadeThrowing
// 
// Throw stage of throwing grenade. After pull-pin stage and fire button released.
state GrenadeThrowing
{
	function Fire(float F) {}
	function AltFire(float F) {} 

	simulated function MoveOutOfView();

	///////////////////////////////////////////////////////////////////////////////
	// BeginState
	// 
	function BeginState()
	{
		Super.BeginState();
		mbThrown = false;
	}

	simulated function bool PutDown()
	{
		bChangeWeapon = true;
		return true;
	}

	///////////////////////////////////////////////////////////////////////////////
	// HolderDied
	// 
	function HolderDied()
	{
		if ( !mbThrown )
		{
			DropGrenade();
		}
	}

	///////////////////////////////////////////////////////////////////////////////
	// AnimEnd
	// 
	simulated function AnimEnd(
		int aChannel )
	{
		GrenadeThrown ();
	}

	///////////////////////////////////////////////////////////////////////////////
	// CheckAnimating
	// 
	simulated function CheckAnimating()
	{
		if ( !IsAnimating() )
		{
			Warn( self$" stuck in Throwing state and not animating!" );
		}
	}

	///////////////////////////////////////////////////////////////////////////////
	// ServerFire
	// 
	function ServerFire()
	{
		bForceFire = true;
	}

	///////////////////////////////////////////////////////////////////////////////
	// ServerAltFire
	// 
	function ServerAltFire()
	{
		bForceAltFire = true;
	}


	///////////////////////////////////////////////////////////////////////////////
	// ReleaseGrenade
	//
	simulated function ReleaseGrenade()
	{
		local Coords			spawnCoords;
		local Vector			spawnLoc;
		local SASAIController	C;

		if ( Instigator.IsLocallyControlled () )
		{
			// Hide grenade mesh attached to hands.
			ShowFPGrenadeMesh( false );

			// Hide third person grenade mesh.
			ThirdPersonActor.bHidden = true;

			// Get spawn location and rotation depending on whether throwing in 3rd or 1st person.
			if ( Instigator.IsFirstPerson() )
			{
				spawnCoords = GetBoneCoords( ATTACHBONE_HandsToGrenade );
				spawnLoc = spawnCoords.Origin;
			}
			else
			{
				spawnCoords = Instigator.GetBoneCoords( GRENADE_BONE );
				spawnLoc = spawnCoords.Origin;

				// 3rd person attachment also has position offset...
				
			}

			// spawn a 'thrown' grenade.
			SASGrenadeAmmo ( AmmoType ).SpawnGrenade( self, spawnLoc );
			
			if ( Instigator.Controller != None )
			{
				C = SASAIController( Instigator.Controller );
				if ( C != None )
				{
					C.NotifyWeaponFired(); 
				}
			}

			mbThrown = true;
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// AnimNotifyThrow
	//
	// This animation callback occurs when the held live grenade should be released.
	simulated event AnimNotifyThrow()
	{
		if ( Instigator.IsLocallyControlled() && Instigator.mPawnType != PAWN_Terrorist )
		{
			ReleaseGrenade();
		}
	}

	///////////////////////////////////////////////////////////////////////////////
	// AnimNotifyThrowOverarm
	//
	// Throw notifier used when throwing overarm.
	simulated event AnimNotifyThrowOverarm()
	{
		if ( Instigator.IsLocallyControlled() && (Instigator.mPawnType == PAWN_Terrorist) && !mbThrown )
		{
			ReleaseGrenade();
		}
	}

Begin:
	Sleep( 0.0 );
}

//------------------------------------------------------------------------------
//
//
state Active
{
	simulated function BeginState()
	{
		Super.BeginState();
	}
}

//------------------------------------------------------------------------------
//
//
state DownWeapon
{
	simulated function BeginState()
	{
		if ( AmmoType.AmmoAmount == 0 )
		{
			DetachFromPawn( Instigator );
			ShowFPGrenadeMesh( false );
		
			// Change weapon immediately if just thrown last grenade.
			OldWeapon = None;
			bChangeWeapon = false;
			bMuzzleFlash = false;
			AnimEnd( 0 );
		}

		Super.BeginState();
	}

	simulated event AnimEnd(
		int aChannel )
	{
		Super.AnimEnd( aChannel );
		
		// GP: If switching from DownWeapon to Idle state this function seems 
		// to get called immediately after the state change - no idea why, should call
		// the Idle state version.
		if ( GetStateName() == 'DownWeapon' )
		{
			ShowFPGrenadeMesh( false );
		}
	}
}

state Reloading
{
	simulated event BeginState()
	{
		Super.BeginState();
		Enable( 'Tick' );
	}

	simulated event EndState()
	{
		Super.EndState();
		Disable( 'Tick' );
	}

	simulated event Tick(float dt)
	{
		// Make sure FP grenade is visible.
		ShowFPGrenadeMesh( true );
		
		// Make sure grenade is in resting anim.
		if ( mFPWeaponMeshActor != None )
		{
			mFPWeaponMeshActor.TweenToIdle( 0.0 );
		}
	}
}


//------------------------------------------------------------------------------
// Default Properties
//


// Decompiled with UE Explorer.
defaultproperties
{
    mGrenadeAttachBone="Grenade"
    mCategory=4
    mGrenadeCategory=5
    me3PAnimSet=4
    mMagSize=1
    mAllowedFireModes=1
    mUnsightedFireAnim="1st_PullPin"
}