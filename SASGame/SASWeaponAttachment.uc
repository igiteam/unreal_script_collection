//=============================================================================
// SASWeaponAttachment.uc
//
// Abstract base class of all 3rd person weapon attachments (mesh and
// 3rd person effects).
//=============================================================================

class SASWeaponAttachment extends WeaponAttachment
	native
	nativereplication
	abstract;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

//-----------------------------------------------------------------------------
// Constants

// Audio
const NUM_FIRE_SOUNDS		= 7;

//-----------------------------------------------------------------------------
// Enums

//-----------------------------------------------------------------------------
// Member Variables

var EWeaponCategory			mCategory;		// Weapon type copied from our 1st person equivalent.
var class<Ammunition>		mAmmoClass;		// Copy of the 1st person weapon's ammo class - for shot replication
var E3PAnimSet				mWpnAnimSet;
var byte					mRepWpnAnim;
var byte					mLastRepWpnAnim;
var byte					mWeaponHandlingAnimRates[WPNHANDLINGANIM_NumTypes];
var float					mWeaponUpAnimRateScalar;
var float					mWeaponDownAnimRateScalar;
var bool					mbHasTorch;

// Muzzle flash
var class<SAS3PMuzzleFlash>	mMuzzleFlashClass;
var SAS3PMuzzleFlash		mMuzzleFlash;
var vector					mMuzzleRelativeLocation;
var rotator					mMuzzleRelativeRotation;

var SASTorchBeam			mTorchBeam;				// The torch beam attached to the gun
var SASTorchBeamProjector	mTorchProjector;		// The torch beam projector attached to the gun
var SASTorchBeamCorona		mTorchCorona;			// The torch corona attached to the gun
var SASTorchBeamCorona		mTorchCorona2;			// The second torch corona attached to the gun
var SASLaserBeam			mLaserBeam;				// The Laser beam attached to the gun
var SASLaserBeamProjector	mLaserProjector;		// The Laser beam projector attached to the gun
var SASLaserBeamCorona		mLaserCorona;			// The Laser corona attached to the gun
var SASLaserBeamCorona		mLaserCorona2;			// The second Laser corona attached to the gun

var bool					mbCreatedEffects;

var class<SASEmitter>		mMuzzleEffectClass;		// emitter class for 3rd person muzzle smoke/wisp
var float					mMuzzleEffectScale;
var Vector					mMuzzleEffectOffset;
var SASEmitter				mMuzzleEffectEmitter;

var SASEmitter				mShellEmitter;
var class<SASEmitter>		mShellClass;
var float					mShellScale;
var Vector					mShellOffset;					

// Sounds - JS the weapon attachment doesn't make sound any more

replication
{
	reliable if ( bNetInitial && Role == ROLE_Authority )
		mCategory,
		mAmmoClass,
		mWpnAnimSet,
		mWeaponHandlingAnimRates,
		mbHasTorch;

	reliable if ( bNetDirty && Role == ROLE_Authority )
		mRepWpnAnim;
}

//-----------------------------------------------------------------------------
// Native Functions

native(820) final function UpdateReplicationWeaponAnim(
	byte	aeType );

native(821) final function InitWeaponHandlingAnimRates(
	SASWeapon	aFirstPersonWpn );
	


//-----------------------------------------------------------------------------
// Exec Functions

//-----------------------------------------------------------------------------
// Functions


///////////////////////////////////////////////////////////////////////////////
// PostBeginPlay
//
simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	if ( mMuzzleFlashClass != None )
	{
		Spawn( mMuzzleFlashClass, self );
	}


}


///////////////////////////////////////////////////////////////////////////////
// InitFor
//
// Called on server when weapon is attached to pawn.
function InitFor(
	Inventory aInv )
{
	local SASWeapon	wpn;

	Super.InitFor( aInv );

	wpn = SASWeapon( aInv );
	if ( wpn != None )
	{
		// Copy the 1st person weapon's category and 3rd person anim set to use.
		mCategory	= wpn.mCategory;
		mWpnAnimSet = wpn.me3PAnimSet;
		mAmmoClass = wpn.AmmoName;
		mbHasTorch = wpn.mbHasTorch;

		if ( Instigator != None )
		{
			// Calculate the required anim rate to play various thrid person
			// pawn anims to match the first person weapon anim duration.
			InitWeaponHandlingAnimRates( wpn );
		}
	}

	// Set the owner's current third person weapon.
	if ( Instigator != None )
	{
		SASPawn( Instigator ).mThirdPersonWeapon = self;
	}
}


simulated function CreateShotEffects()
{
	local int	numEmtrs;

	// Create muzzle smoke emitter (also includes muzzle flash effect these days).
	if (	mMuzzleEffectEmitter == None &&
			mMuzzleEffectClass != None )
	{
		mMuzzleEffectEmitter = Spawn( mMuzzleEffectClass, self );

		if ( !Instigator.AttachToBone( mMuzzleEffectEmitter, WEAPNODE ))
		{
			mMuzzleEffectEmitter.SetLocation( Instigator.Location );
			mMuzzleEffectEmitter.SetBase( Instigator );
		}

		numEmtrs = mMuzzleEffectEmitter.Emitters.Length;
		while (--numEmtrs >= 0 )
		{
			mMuzzleEffectEmitter.Emitters[numEmtrs].StartSizeRange.X.Min *= mMuzzleEffectScale;
			mMuzzleEffectEmitter.Emitters[numEmtrs].StartSizeRange.X.Max *= mMuzzleEffectScale;
			mMuzzleEffectEmitter.Emitters[numEmtrs].StartLocationOffset = 
					mMuzzleEffectOffset + 
					mMuzzleEffectEmitter.Emitters[numEmtrs].RelativeStartLocationOffset;
		}
	}

	// Create shell emitter
	if (	mShellEmitter == None &&
			mShellClass != None )
	{
		mShellEmitter = Spawn( mShellClass, self );

		if( !Instigator.AttachToBone( mShellEmitter, WEAPNODE ) )
		{
			mShellEmitter.SetLocation( Instigator.Location );
			mShellEmitter.SetBase( Instigator );
		}

		mShellEmitter.Emitters[0].StartSizeRange.X.Min *= mShellScale;
		mShellEmitter.Emitters[0].StartSizeRange.X.Max *= mShellScale;
		mShellEmitter.Emitters[0].StartSizeRange.Y.Min *= mShellScale;
		mShellEmitter.Emitters[0].StartSizeRange.Y.Max *= mShellScale;
		mShellEmitter.Emitters[0].StartSizeRange.Z.Min *= mShellScale;
		mShellEmitter.Emitters[0].StartSizeRange.Z.Max *= mShellScale;

		mShellEmitter.Emitters[0].StartLocationOffset = mShellOffset;
	}
}


///////////////////////////////////////////////////////////////////////////////
// HandleAttachment
//
// TODO_KW: should this be simulated?
simulated function HandleAttachment(){
	local name		boneName;

	if ( Instigator != None )
	{
		boneName = Instigator.GetWeaponBoneFor( Instigator.Weapon );
		
		if ( boneName == '' )
		{
			mMuzzleFlash.SetLocation( Instigator.Location );
			mMuzzleFlash.SetBase( Instigator );
		}
		else
		{
			Instigator.AttachToBone( mMuzzleFlash, boneName );
		}

		mMuzzleFlash.SetRelativeLocation( mMuzzleRelativeLocation );
		mMuzzleFlash.SetRelativeRotation( mMuzzleRelativeRotation );
	}
}


///////////////////////////////////////////////////////////////////////////////
// Switch torch on and off
//

// TODO_KW: should this be simulated?
simulated event SwitchTorchOn(bool on)
{
	local name		boneName;

	boneName = Instigator.GetWeaponBoneFor( Instigator.Weapon );

	if (on)
	{
		if (mTorchBeam == None)
		{
			mTorchBeam = Spawn(Class'SASTorchBeam');
			if (boneName == '')
			{
				// Put the torch beam where we want it
				mTorchBeam.SetLocation( Instigator.Location );
				mTorchBeam.SetBase( Instigator );
			}
			else
			{
				if (!Instigator.AttachToBone(mTorchBeam, boneName))
				{
					// Cope with no muzzle bone
					mTorchBeam.Destroy();
					mTorchBeam = None;
				}
			}
		}
		if (mTorchProjector == None)
		{
			mTorchProjector = Spawn(class'SASTorchBeamProjector', Instigator);
			mTorchProjector.SetDrawScale(0.05);
			//mTorchProjector.SetAttachBone(Instigator, boneName);
		}
		if (mTorchCorona == None)
		{
			mTorchCorona = Spawn(class'SASTorchBeamCorona');
			mTorchCorona.SetSkin(Texture'SfxTx.lights.FxL_torch_Flare_small',0);
			mTorchCorona.SetAttachBone(Instigator, boneName, mMuzzleRelativeLocation);
			
			// add the second corona
			mTorchCorona2 = Spawn(class'SASTorchBeamCorona');
			mTorchCorona2.SetSkin(Texture'SfxTx.lights.FxL_torch_Flare',1);
			mTorchCorona2.SetAttachBone(Instigator, boneName, mMuzzleRelativeLocation);
		}
	}
	else // off
	{
		if (mTorchBeam != None)
		{
			if (boneName != '')
			{
				DetachFromBone( mTorchBeam );
			}
			mTorchBeam.Destroy();
			mTorchBeam = None;
		}
		if (mTorchProjector != None)
		{
			if (boneName == '')
			{
				mTorchProjector.UnsetAttachPoint();
			}
			else
			{
				mTorchProjector.UnsetAttachBone();
			}
			mTorchProjector.Destroy();
			mTorchProjector = None;
		}
		if (mTorchCorona != None)
		{
			mTorchCorona.UnsetAttachBone();

			// ROBHACK - They made me do it.  :-(
			// Hide the corona rather than destroy it
			//mTorchCorona.Destroy();
			mTorchCorona.bCorona = False;
			mTorchCorona.bHidden = True;

			mTorchCorona = None;
			mTorchCorona2.bCorona = False;
			mTorchCorona2.bHidden = True;
			mTorchCorona2 = None;
		}
	}
}
///////////////////////////////////////////////////////////////////////////////
// Switch Laser on and off
//
// TODO_KW: should this be simulated?
simulated function SwitchLaserOn(bool on)
{
	local name		boneName;
	boneName = Instigator.GetWeaponBoneFor( Instigator.Weapon );
	if (on)
	{
		if (mLaserBeam == None)
		{
			/*mLaserBeam = Spawn(Class'SASLaserBeam');
			if (boneName == '')
			{
				// Put the Laser beam where we want it
				mLaserBeam.SetLocation( Instigator.Location );
				mLaserBeam.SetBase( Instigator );
			}
			else
			{
				if (!Instigator.AttachToBone(mLaserBeam, boneName))
				{
					// Cope with no muzzle bone
					mLaserBeam.Destroy();
					mLaserBeam = None;
				}
			}*/
		}
		if (mLaserProjector == None)
		{
			mLaserProjector = Spawn(class'SASLaserBeamProjector');
			mLaserProjector.SetDrawScale(0.05);
			if (boneName == '')
			{
				mLaserProjector.SetAttachPoint(Instigator, mMuzzleRelativeLocation, mMuzzleRelativeRotation);
			}
			else
			{
				mLaserProjector.SetAttachBone(Instigator, boneName);
			}
		}
		if (mLaserCorona == None)
		{
			mLaserCorona = Spawn(class'SASLaserBeamCorona');
			mLaserCorona.SetSkin(Texture'SfxTx.lights.FxL_LaserFlare_Small',0);
			mLaserCorona.SetAttachBone(Instigator, boneName, mMuzzleRelativeLocation);
			
			// add the second corona
			mLaserCorona2 = Spawn(class'SASLaserBeamCorona');
			mLaserCorona2.SetSkin(Texture'SfxTx.lights.FxL_LaserFlare',1);
			mLaserCorona2.SetAttachBone(Instigator, boneName, mMuzzleRelativeLocation);
		}
	}
	else // off
	{
		if (mLaserBeam != None)
		{
			/*if (boneName != '')
			{
				DetachFromBone( mLaserBeam );
			}
			mLaserBeam.Destroy();
			mLaserBeam = None;*/
		}
		if (mLaserProjector != None)
		{
			if (boneName == '')
			{
				mLaserProjector.UnsetAttachPoint();
			}
			else
			{
				mLaserProjector.UnsetAttachBone();
			}
			mLaserProjector.Destroy();
			mLaserProjector = None;
		}
		if (mLaserCorona != None)
		{
			mLaserCorona.UnsetAttachBone();
			// ROBHACK - They made me do it.  :-(
			// Hide the corona rather than destroy it
			//mLaserCorona.Destroy();
			mLaserCorona.bCorona = False;
			mLaserCorona.bHidden = True;
			mLaserCorona = None;
			mLaserCorona2.bCorona = False;
			mLaserCorona2.bHidden = True;
			mLaserCorona2 = None;
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// Destroyed
//
simulated event Destroyed()
{
	if ( mMuzzleFlash != None )
	{
		mMuzzleFlash.Destroy();
		mMuzzleFlash = None;
	}
	if (mTorchBeam != None)
	{
		mTorchBeam.Destroy();
		mTorchBeam = None;
	}
	if (mTorchProjector != None)
	{
		mTorchProjector.Destroy();
		mTorchProjector = None;
	}
	if (mTorchCorona != None)
	{
		// ROBHACK - They made me do it.  :-(
		// Hide the corona rather than destroy it
		//mTorchCorona.Destroy();
		mTorchCorona.bCorona = False;
		mTorchCorona.bHidden = True;
		mTorchCorona = None;
	}
	if (mLaserBeam != None)
	{
		mLaserBeam.Destroy();
		mLaserBeam = None;
	}
	if (mLaserProjector != None)
	{
		mLaserProjector.Destroy();
		mLaserProjector = None;
	}
	if (mLaserCorona != None)
	{
		// ROBHACK - They made me do it.  :-(
		// Hide the corona rather than destroy it
		//mLaserCorona.Destroy();
		mLaserCorona.bCorona = False;
		mLaserCorona.bHidden = True;
		mLaserCorona = None;
	}	
	Super.Destroyed();
}


///////////////////////////////////////////////////////////////////////////////
// ThirdPersonEffects
//
// ThirdPersonEffects called by Pawn's C++ tick if FlashCount incremented
// OR called locally for local player.
simulated event ThirdPersonEffects()
{
	if ( Instigator == None )
	{
		return;
	}

	// Spawn 3rd person effects.
	if ( Level.NetMode != NM_DedicatedServer )
	{
		if ( mMuzzleFlash != None )
		{
			// ICHACK Location not updated when in first person mode
			if ( Instigator.IsFirstPerson() && (Instigator.Weapon != None) )
			{
				mMuzzleFlash.SetLocation( Instigator.Weapon.Location );
			}
			mMuzzleFlash.Flash();
		}

		if ( !Instigator.IsLocallyControlled() || !Instigator.IsFirstPerson() )
		{
			if ( !mbCreatedEffects )
			{
				CreateShotEffects();
				mbCreatedEffects = true;
			}

			DoMuzzleSmoke();
			EjectShellCase();
		}

		// JS no sound playing code in here any more.
	}

	Instigator.PlayFiring( 1.0, FiringMode );
}


///////////////////////////////////////////////////////////////////////////////
// ThirdPersonEffects
//
// ThirdPersonEmptyFireEffects called by Pawn's C++ tick if EmptyFireCount incremented
// OR called locally for local player.
simulated event ThirdPersonEmptyFireEffects()
{
	if ( Instigator != None )
	{
		Instigator.PlayFiring( 1.0, FiringMode );
	}
}


///////////////////////////////////////////////////////////////////////////////
// DoMuzzleSmoke
//
simulated function DoMuzzleSmoke()
{
	local int numEmtr;

	if ( mMuzzleEffectEmitter != None )
	{
		for ( numEmtr = 0; numEmtr < mMuzzleEffectEmitter.Emitters.Length; numEmtr++ )
		{
			mMuzzleEffectEmitter.Emitters[numEmtr].SpawnParticle( 
				mMuzzleEffectEmitter.Emitters[numEmtr].ParticlesPerShot );
			mMuzzleEffectEmitter.Emitters[numEmtr].AllParticlesDead = false;
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// EjectShellCase
//
simulated function EjectShellCase()
{
	if ( mShellEmitter != None )
	{
		if( Owner != None )
		{
			if ( Owner.GroundMaterial != None )
			{
				mShellEmitter.Emitters[0].DeathSoundIndex.Min = Owner.GroundMaterial.mMaterialType;
				mShellEmitter.Emitters[0].DeathSoundIndex.Max = Owner.GroundMaterial.mMaterialType;
			}
		}

		mShellEmitter.Emitters[0].StartVelocityRange.X.Min = 0.0;
		mShellEmitter.Emitters[0].StartVelocityRange.X.Max = 0.0;
		mShellEmitter.Emitters[0].StartVelocityRange.Y.Min = 70.0;
		mShellEmitter.Emitters[0].StartVelocityRange.Y.Max = 100.0;
		mShellEmitter.Emitters[0].StartVelocityRange.Z.Min = 70.0;
		mShellEmitter.Emitters[0].StartVelocityRange.Z.Max = 100.0;
		mShellEmitter.TriggerParticle();
	}
}

function SetPawnWeaponHandlingAnim(
	byte	aWpnAnimType )
{
	// Server sets a new wpn anim to send to clients.
	UpdateReplicationWeaponAnim( aWpnAnimType );
}

simulated event PlayPawnWeaponHandlingAnim(
	byte	aWpnAnimType )
{
	if ( Instigator != None )
	{
		//Instigator.PlayAnim( 'Stand_Reload_MP5' );

		SASFighter( Instigator ).PlayWeaponHandlingAnim( 
			aWpnAnimType,
			self );
	}
}


//-----------------------------------------------------------------------------
// States


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mWeaponUpAnimRateScalar=1.0000000
    mWeaponDownAnimRateScalar=1.0000000
    mMuzzleEffectScale=1.0000000
    mShellScale=1.0000000
    DrawType=8
}