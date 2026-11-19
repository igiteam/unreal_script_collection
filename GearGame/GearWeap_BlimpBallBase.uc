/**
 * Blimp Ball Turret Weapon
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearWeap_BlimpBallBase extends GearWeapon
	config(Weapon)
	abstract;

/** Number of shots fired in a row for one trigger press */
var() protected const config byte NumShotsPerBurst;
/** Counter for burst shots */
var protected transient	byte BurstCount;

/** SoundCue for firing. */
var protected const SoundCue FireCue;
/** SoundCue for firing. */
var protected const SoundCue FireCue_Player;
/** The AudioComponent that is used for the looping shot sound **/
var protected AudioComponent FireAC;

/** Smoke emitter at the muzzle */
var ParticleSystemComponent PSC_BarrelSmoke;

//The ready sound needs to start playing before the pistol is actually ready. This variable represents how much earlier.
var() protected const config float	ReadySoundOffset;
//Sound to play when the pistol is ready to be fired again
var protected const SoundCue ReadyToFireAgainSound;


simulated event PostBeginPlay()
{
	local Turret_BlimpBallBase BallTurret;

	BallTurret = Turret_BlimpBallBase(Instigator);
	if (BallTurret != None)
	{
		BallTurret.Mesh.AttachComponentToSocket(PSC_BarrelSmoke, BallTurret.MuzzleSocketName);
	}

	super.PostBeginPlay();
}

/** Ball turrets do not get active reloads **/
simulated event LocalActiveReloadSuccess( bool bDidSuperSweetReload );
simulated function ActiveReloadSuccess(bool bDidSuperSweetReload);
simulated function FailedActiveReload(bool bFailedActiveReload);

simulated event AttachMuzzleEffectsComponents(SkeletalMeshComponent SkelMesh)
{
	local Turret_BlimpBallBase BallTurret;

	if (SkelMesh != None)
	{
		BallTurret = Turret_BlimpBallBase(SkelMesh.Owner);
	}

	if (BallTurret != None)
	{
		// attach muzzle flash emitter, and position to fire offset
		if (MuzzleFlash.MuzFlashEmitter != None &&
			!SkelMesh.IsComponentAttached(MuzzleFlash.MuzFlashEmitter))
		{
			SkelMesh.AttachComponentToSocket(MuzzleFlash.MuzFlashEmitter, BallTurret.MuzzleSocketName);
			HideMuzzleFlashEmitter();
		}

		// Muzzle Flash dynamic light
		if (MuzzleFlash.MuzzleFlashLight != None &&
			!SkelMesh.IsComponentAttached(MuzzleFlash.MuzzleFlashLight))
		{
			SkelMesh.AttachComponentToSocket(MuzzleFlash.MuzzleFlashLight, BallTurret.MuzzleSocketName);
		}
	}
	else
	{
		// attach muzzle flash emitter, and position to fire offset
		if (MuzzleFlash.MuzFlashEmitter != None)
		{
			AttachComponent(MuzzleFlash.MuzFlashEmitter);
			HideMuzzleFlashEmitter();
		}

		// Muzzle Flash dynamic light
		if (MuzzleFlash.MuzzleFlashLight != None)
		{
			AttachComponent(MuzzleFlash.MuzzleFlashLight);
		}
	}
}

simulated function PerformWeaponAttachment(SkeletalMeshComponent MeshCpnt, optional Name BoneName)
{
	AttachMuzzleEffectsComponents(MeshCpnt);
}

simulated function DetachWeapon()
{
	local SkeletalMeshComponent	PawnMesh;

	Super.DetachWeapon();

	if (Instigator != None)
	{
		PawnMesh = Instigator.Mesh;
	}

	if (PawnMesh != None)
	{
		// shell eject particle system
		if (MuzzleFlash.MuzFlashEmitter != None &&
			PawnMesh.IsComponentAttached(MuzzleFlash.MuzFlashEmitter))
		{
			PawnMesh.DetachComponent(MuzzleFlash.MuzFlashEmitter);
		}

		if (MuzzleFlash.MuzzleFlashLight != None &&
			PawnMesh.IsComponentAttached(MuzzleFlash.MuzzleFlashLight))
		{
			PawnMesh.DetachComponent(MuzzleFlash.MuzzleFlashLight);
		}
	}
}

simulated function WeaponStoppedFiring(byte FiringMode)
{
	Super.WeaponStoppedFiring(FiringMode);

	// maybe turn on barrel smoke
	PSC_BarrelSmoke.ActivateSystem(TRUE);
}

// no reload anim right now
simulated function PlayWeaponReloading();

/** Can never be reloaded */
simulated function bool CanReload()
{
	return TRUE;
}

/**
 * Extended so we don't relying on active reload to exit state.
 */
simulated state Reloading
{
	ignores ForceReload;

	simulated function BeginState(Name PreviousStateName)
	{
		super.BeginState(PreviousStateName);
		SetTimer(GetReloadDuration(), FALSE, nameof(EndOfReloadTimer));
	}

	simulated function EndState(Name NextStateName)
	{
		WeaponMagSize = default.WeaponMagSize;
		Super.EndState(NextStateName);
	}
}

/** Do a little clean up.  Audio Components to none!.  **/
simulated event Destroyed()
{
	if (FireAC != none)
	{
		FireAC.FadeOut( 0.1f, 0.0f );
		FireAC = None;
	}

	Super.Destroyed();
}

simulated function InstantFire()
{
	local Turret_BlimpBallBase BlimpTurret;

	BlimpTurret = Turret_BlimpBallBase(Instigator);

	// Disabling collision on the turret for weapon trace.
	if (BlimpTurret != None)
	{
		BlimpTurret.Mesh.SetTraceBlocking(FALSE, BlimpTurret.Mesh.BlockNonZeroExtent);
	}

	Super.InstantFire();

	if (BlimpTurret != None)
	{
		BlimpTurret.Mesh.SetTraceBlocking(TRUE, BlimpTurret.Mesh.BlockNonZeroExtent);
	}
}

simulated state Active
{
	/** Override BeginFire so we can stop it from firing if unpossessed */
	simulated function BeginFire(byte FireModeNum)
	{
		if (GetWeaponController() != None || bDummyFireWeapon)
		{
			Super.BeginFire(FireModeNum);
		}
	}
}

/** this weapon has no team based colors **/
simulated function SetMaterialBasedOnTeam( MeshComponent TheMesh, int TeamNum );

simulated state WeaponFiring
{
	simulated function BeginState(Name PreviousStateName)
	{
		BurstCount = 0;

		// play force feedback here so it is once per burst
		if( GearPC(GetWeaponController()) != none )
		{
			GearPC(GetWeaponController()).ClientPlayForceFeedbackWaveform( WeaponFireWaveForm );
		}

		super.BeginState(PreviousStateName);
	}

	/**
 	 * Timer event, call is set up in Weapon::TimeWeaponFiring().
	 * The weapon is given a chance to evaluate if another shot should be fired.
	 * This event defines the weapon's rate of fire.
	 */
	simulated function RefireCheckTimer()
	{
		// If weapon should keep on firing, then do not leave state and fire again.
		if( ShouldRefire() )
		{
			FireAmmunition();
			return;
		}

		// Force player to wait before re-firing
		GotoState('BurstDelaying');
	}
}

/**
 * handle burst refiring.
 */
simulated function bool ShouldRefire()
{
	// if doesn't have ammo to keep on firing, then stop
	if( !HasAmmo(CurrentFireMode) )
	{
		return FALSE;
	}

	if( BurstCount < NumShotsPerBurst )
	{
		return TRUE;
	}

	return FALSE;
}

simulated function EndOfBurstDelay();

simulated function float GetReloadDuration()
{
	local GearAI AI;
	local Turret_BlimpBallBase BallTurret;

	BallTurret = Turret_BlimpBallBase(Instigator);
	AI = GearAI(GetWeaponController());
	if (AI != None)
	{
		return BallTurret.MinAIBurstDelay + (FRand() * (BallTurret.MaxAIBurstDelay - BallTurret.MinAIBurstDelay));
	}
	else
	{
		return BallTurret.BurstDelay;
	}

	return ReloadDuration;
}

simulated state BurstDelaying
{
	simulated function BeginState(Name PreviousStateName)
	{
		local GearAI AI;
		local float DelayToUse;
		local Turret_BlimpBallBase BallTurret;

		if( !HasAmmo(CurrentFireMode) )
		{
			// end prematurely so we can reload
			EndOfBurstDelay();
		}
		else
		{
			BallTurret = Turret_BlimpBallBase(Instigator);
			AI = GearAI(GetWeaponController());
			if (AI != None)
			{
				DelayToUse = BallTurret.MinAIBurstDelay + (FRand() * (BallTurret.MaxAIBurstDelay - BallTurret.MinAIBurstDelay));
			}
			else
			{
				DelayToUse = BallTurret.BurstDelay;
			}
			SetTimer( DelayToUse - ReadySoundOffset, false, nameof(PlayReadySound));
			SetTimer( DelayToUse, FALSE, nameof(EndOfBurstDelay) );
		}

		if( Instigator.IsHumanControlled() )
		{
			// must release trigger and refire
			EndFire( CurrentFireMode );
			GetWeaponController().bFire = 0;
		}
	}

	simulated function EndState(Name NextStateName)
	{
		ClearTimer('EndOfBurstDelay');
		ClearTimer('PlayReadySound');

		// stop the force feedback here so we get a semi clear separation between burst force feedbacks
		if( GearPC(GetWeaponController()) != none )
		{
			GearPC(GetWeaponController()).ClientStopForceFeedbackWaveform( WeaponFireWaveForm );
		}
	}

	simulated function PlayReadySound()
	{
		GearWeaponPlaySoundLocalEx( None, ReadyToFireAgainSound );
	}

	simulated function EndOfBurstDelay()
	{
		GotoState('Active');
	}

	simulated function StartFire(byte FireModeNum)
	{
		if (FireModeNum == 0)
		{
			// no firing in this state.  make player repress trigger.
			EndFire( CurrentFireMode );
			GetWeaponController().bFire = 0;
		}
		else
		{
			// end prematurely so we can reload
			EndOfBurstDelay();
			Super.StartFire(FireModeNum);
		}
	}
}

simulated function FireAmmunition()
{
	BurstCount++;
	FireAC = GearWeaponPlaySoundLocalEx(FireCue, FireCue_Player);
	super.FireAmmunition();
}

/** Returns the number of ammo icons this weapon will display in a clip */
simulated function float GetAmmoIconCount()
{
	return 3;
}

defaultproperties
{
	FiringStatesArray(0)="WeaponFiring"

	bInfiniteSpareAmmo=TRUE
	bWeaponCanBeReloaded=TRUE
	bCanThrow=FALSE

	NoAmmoFireSoundDelay=0.25f

	InstantHitDamageTypes(0)=class'GDT_BlimpBall'

	FireOffset=(X=0,Y=0,Z=0)

	TracerType=WTT_Reaver
	TracerTypeAR=WTT_Reaver

	bKillDuringLevelTransition=TRUE

    WeaponID=WC_BlimpBallTurret

	bAllowTracers=TRUE
	bUseMuzzleLocForPhysicalFireStartLoc=TRUE

	Begin Object Class=ParticleSystemComponent Name=PSC_BarrelSmoke0
		bAutoActivate=FALSE
		TickGroup=TG_PostUpdateWork
	End Object
	PSC_BarrelSmoke=PSC_BarrelSmoke0

	DamageTypeClassForUI=class'GDT_BlimpBall'
	WeaponIcon=(Texture=Texture2D'Warfare_HUD.HUD.Gears_WeaponIcons',U=146,V=0,UL=143,VL=46)
	HUDDrawData			= (DisplayCount=3,AmmoIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=0,V=265,UL=45,VL=7),ULPerAmmo=15)
	HUDDrawDataSuper	= (DisplayCount=3,AmmoIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=0,V=265,UL=45,VL=7),ULPerAmmo=15)
}
