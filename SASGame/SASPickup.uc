//=============================================================================
// SASPickup.uc
//
// Weapon pickup class in SAS.
//=============================================================================

class SASPickup extends Actor
	native;


//-----------------------------------------------------------------------------
// Member Vars

var class<Inventory>	mInventoryClass;			

// Delayed release from hand params
var float				mReleaseTimer;		// Countdown time before releasing pickup from pawns grasp
var const vector		mReleaseCachedPos;	// Prev frame position for calculating release vel
var const rotator		mReleaseCachedRot;	// Prev frame rotation for calculating release rot vel
var const vector		mReleaseAngVel;		// Release rot vel, in karma-friendly units (rad/s * mathengine to unreal scale)

var float				mLastImpactSoundTime;

//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// InitDroppedPickupFor
//
// Called to initialise the pickup when it is created by dropping a weapon.
function InitDroppedPickupFor(
	Inventory	aInv,
	bool		abInstantDrop )
{
	local name attachBoneName;

	GotoState( '' );

	// Copy draw params from inventory third person actor
	SetDrawType( DT_StaticMesh );
	if ( aInv.ThirdPersonActor != None )
	{
		SetStaticMesh( aInv.ThirdPersonActor.StaticMesh );
		SetDrawScale( aInv.ThirdPersonActor.DrawScale );
	}

	// TODO: Need to add attachments.
	// Perhaps just attach third person actor to pickup object
	// rather than setting up pickup object draw params.

	SetCollision( false, false, false );

	// Store actual weapon as our inventory item.
	Inventory = aInv;

	if ( abInstantDrop )
	{
		Instigator = None;
		Velocity = aInv.Velocity;
	}
	else
	{
		// Attempt to attach pickup to hand of instigator for 
		// delayed release from hand. Used when pickup created when 
		// a pawn dies or surrenders.

		Instigator = aInv.Instigator;
		if ( Instigator != None )
		{
			attachBoneName = Instigator.GetWeaponBoneFor( aInv );
			if ( attachBoneName != '' )
			{
				// Attach to weapon bone of instigator
				Instigator.AttachToBone( self, attachBoneName );

				// Set release timer
				mReleaseTimer = RandRange( 0.2, 0.5 );
			}
			else
			{
				Instigator = None;
			}
		}
	}

	if ( Instigator == None )
	{
		Release();
	}
	else
	{
		GotoState( '' );
	}
}


///////////////////////////////////////////////////////////////////////////////
// Release
//
// Release from being attached to instigator and karma-ize. 
event Release()
{
	// Detach from instigator
	if ( Instigator != None )
	{
		Instigator.DetachFromBone( self );
	}

	// Set up karma
	KParams = new(Outer)class'KarmaParams';
	if ( KParams != None )
	{
		KarmaParams( KParams ).bDestroyOnSimError = FALSE;
		KarmaParams( KParams ).KSTartEnabled = TRUE;
		KarmaParams( KParams ).KMass = 0.1;
		KParams.KFriction = 0.6;
		KParams.KRestitution = 0.15;
		KarmaParams( KParams ).KStartLinVel = Velocity;
		KarmaParams( KParams ).KStartAngVel = mReleaseAngVel; 
		KarmaParams( KParams ).KImpactThreshold = 16.0;
		KarmaParams( KParams ).SafeTimeMode = KST_Always;
	}


	SetCollision( true, false, false );
	KSetBlockKarma( true );
	bCollideWorld = true;
	SetPhysics( PHYS_Karma );


	if (Physics != PHYS_Karma)
	{
		// Karma not possible - probably PS2.
		SetPhysics(PHYS_Falling);
	}
	else
	{
		KSetMass( 0.1 );
		KSetImpactThreshold( 5 );
	}

	GotoState( 'Dropped' );
}


///////////////////////////////////////////////////////////////////////////////
// SpawnCopy
//
// Either give this inventory to player aOther, or spawn a copy
// and give it to the player aOther.
function Inventory SpawnCopy( 
	SASPawn aOther )
{
	local Inventory copy;

	if ( Inventory != None )
	{
		copy = Inventory;
		Inventory = None;
	}
	else
	{
		copy = Spawn ( mInventoryClass,,,, rot(0,0,0) );
	}

	if ( copy != None )
	{
		copy.SetOwner ( aOther );
		copy.GiveTo ( aOther );
	}

	return copy;
}


// SAS - Do whatever we do when picking up weapon
function doPickup ( SASPawn aOther )
{
	local Inventory pickedUp;

	pickedUp = SpawnCopy ( aOther );
	if ( pickedUp != None )
	{
		pickedUp.PickupFunction ( aOther );
	} // if

	Destroy ();
} // doPickup

//-----------------------------------------------------------------------------
// States

///////////////////////////////////////////////////////////////////////////////
// STATE Droppped
//
state Dropped
{
	ignores Touch;

	event BeginState()
	{
		// Set timer before becoming pickup-able
		SetTimer( 3.0, true );
	}

	event EndState()
	{
		// Turn off timer
		SetTimer( 0.0,false );
	}

	event Timer()
	{
		GotoState( 'Resting' );
	}

	event KImpact(
		Actor	aOther, 
		Vector	aHitPos, 
		Vector	aImpactVel, 
		Vector	aImpactNorm )
	{
		local SASWeapon	wpn;
		local float		impactSpeed,
						volume;
		local Sound		impactSound;

		wpn = SASWeapon( Inventory );
		if ( wpn == None || wpn.mPickupImpactSounds.Length == 0 )
		{
			return;
		}

		//KSetImpactThreshold(32.0);

		if ( Level.TimeSeconds - mLastImpactSoundTime > 1.0 )
		{
			mLastImpactSoundTime = Level.TimeSeconds;

			// Scale volume with impact speed.
			impactSpeed = VSize( aImpactVel );
			volume = impactSpeed / 100.0;
			if ( volume > 1.0 )
			{
				volume = 1.0;
			}

			// Pick random sound.
			impactSound = wpn.mPickupImpactSounds[Rand(wpn.mPickupImpactSounds.Length)];
			if ( impactSound != None )
			{
				PlaySound( impactSound, SLOT_Misc, volume,, 20,, true);
			}
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// STATE Resting
//

function CheckTouching();
function bool ValidTouch(
	Actor	aOther );

auto state Resting
{
	event BeginState()
	{
		CheckTouching();
	}

	function CheckTouching()
	{
		local SASPawn	P;

		foreach TouchingActors( class'SASPawn', P )
		{
			Touch( P );
		}
	}

	// Touch now automagically picks up spare ammo if appropriate
	event Touch(
		Actor	aOther )
	{
		local SASWeapon		wpn,
							other;
		local SASPawn		touchedPawn;

		touchedPawn = SASPawn( aOther );
		if (	touchedPawn == None || 
				touchedPawn.Controller == None ||
				touchedPawn.Controller.mType != CONTROLLER_Player )
		{
			return;
		}

		wpn = SASWeapon( Inventory );
		if ( wpn != None )
		{
			other = touchedPawn.GetWeaponOfCategory ( wpn.mCategory );

			if ( ( other != None ) && ( wpn.Class == other.Class ) )
			{
				wpn.stripAmmo ( other );
			} // if
		} // if

		// If this has stripped the weapon of all ammo, destroy the pickup
//		if (wpn.AmmoType.AmmoAmount == 0)
		if ( ( wpn.AmmoType != None ) && ( wpn.AmmoType.AmmoAmount == 0 ) )
		{
			Destroy ();
		} // if
	} // Touch

	function bool ValidTouch(
		Actor	aOther )
	{
		local bool						bValid;
		local SASPawn					touchingPawn;
		local class<Inventory>			myInvClass;
		local class<SASWeapon>			myWeaponClass;

		bValid = false;

		touchingPawn = SASPawn( aOther );
		if ( (touchingPawn != None) 
			&& (touchingPawn.Controller != None)
			&& (SASPlayerController( touchingPawn.Controller ) != None) )
		{
			if ( Inventory != None )
			{
				myInvClass = Inventory.Class;
			}
			else
			{
				myInvClass = mInventoryClass;
			}

			myWeaponClass = class<SASWeapon>( myInvClass );
			if ( myWeaponClass != None )
			{
				// For weapon pickups, can only pick them up if player
				// is not already in possession of a weapon of the same
				// category.
				if ( touchingPawn.GetWeaponOfMatchingCategory( myWeaponClass ) != None )
				{
					bValid = true;
				}
			}
			else
			{
				// For non-weapon items, only pickup if item is not in inventory
				if ( touchingPawn.FindInventoryType( myInvClass ) == None )
				{
					bValid = true;
				}
			}

			// Make sure not touching through wall
			/*if ( bValid )
			{
				bValid = FastTrace( aOther.Location, Location );
			}*/
		}

		return bValid;
	}
}


////////////////////////////////////////////////////////////////////////////////
// drawDebug 
//
simulated function drawDebug (
		HUD aHUD)			// HUD object which handles the drawing
{
	local Color Colour;
	local Vector dir;

	dir = vect (0, 0, 1);

	Colour = class'Canvas'.Static.MakeColor (0, 255, 255);
	aHUD.Draw3DCylinder (Location, dir, 5, 10, 12, Colour);
} // drawDebug

//-----------------------------------------------------------------------------
// Default Properties




// Decompiled with UE Explorer.
defaultproperties
{
    bProjTarget=true
}