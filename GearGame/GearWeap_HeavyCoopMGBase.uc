/**
 * Heavy Gatling Gun Weapon
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearWeap_HeavyCoopMGBase extends GearWeap_HeavyMiniGunBase
	abstract;

var() float PrototypeShoulderZHeight;

var transient float LastFireTime;

var protected transient AudioComponent AC_CasingImpactLoop;
var const protected SoundCue CasingImpactLoopCue;

var protected transient AudioComponent AC_ChainFeedLoop;
var const protected SoundCue ChainFeedLoopCue;

/** The number of faked tracers to spawn */
var const protected float DummyNetworkFlashesCount;

/** A custom spin up time if there's a partner working the reload */
var config float SpinUpTimeWithPartner;

simulated function CoopMGSyncActor GetSyncActor()
{
	local GearPawn InstigatorGP;

	InstigatorGP = GearPawn(Instigator);
	if (InstigatorGP != None)
	{
		return InstigatorGP.CoopWeaponSyncActor;
	}

	return None;
}

simulated protected function Actor GetCoopWeaponCounterpart()
{
	local GearPawn InstigatorGP;

	InstigatorGP = GearPawn(Instigator);

	if ( (InstigatorGP != None) && (InstigatorGP.CoopWeaponSyncActor != None) )
	{
		return InstigatorGP.CoopWeaponSyncActor.GetCounterpart(self);
	}

	return None;
}

function bool ModifyDamageScoring(GearPRI DamagedPRI, GearPRI InstigatorPRI, float Damage, class<GearDamageType> DamageType)
{
	local Pawn OtherPawn;

	OtherPawn = Pawn(GetCoopWeaponCounterpart());
	if (OtherPawn != None && GearPRI(OtherPawn.PlayerReplicationInfo) != None)
	{
		// assign half to each player
		DamagedPRI.AddPlayerDamage(GearPRI(OtherPawn.PlayerReplicationInfo), FMax(Damage * 0.5, 1.0), DamageType);
		DamagedPRI.AddPlayerDamage(InstigatorPRI, FMax(Damage * 0.5, 1.0), DamageType);
		return true;
	}
	else
	{
		return false;
	}
}

simulated function Tick(float DeltaTime)
{
	local CoopMGSyncActor SyncActor;
	Super.Tick(DeltaTime);

	// make sure coop sync actor has right ammo
	if ( (Role == ROLE_Authority) && !bSlaveWeapon )
	{
		SyncActor = GetSyncActor();
		if (SyncActor != None)
		{
			SyncActor.AmmoUsedCount = AmmoUsedCount;
			SyncActor.SpareAmmoCount = SpareAmmoCount;
		}
	}
}

// handle firing faster than 1 bullet per frame
simulated function TimeWeaponFiring( byte FireModeNum )
{
	LastFireTime = WorldInfo.TimeSeconds;
	super.TimeWeaponFiring(FireModeNum);
}

simulated state WeaponFiring
{
	/**
	 * fire as many shots as we need to catch up with time
	 */
	simulated function RefireCheckTimer()
	{
		local float UnsimulatedTime, Interval;
		local int ShotsToFire, ShotsFired, Idx;

		// if switching to another weapon, abort firing and put down right away
		if( bWeaponPutDown )
		{
			PutDownWeapon();
			return;
		}

		// If weapon should keep on firing, then do not leave state and fire again.
		UnsimulatedTime = WorldInfo.TimeSeconds - LastFireTime;
		Interval = GetFireInterval(CurrentFireMode);
		ShotsToFire = Min(FFloor(UnsimulatedTime / Interval), 5);

		if (ShotsToFire > 0)
		{
			for (Idx=0; Idx<ShotsToFire; ++Idx)
			{
				if( ShouldRefire() )
				{
					FireAmmunition();
					ShotsFired++;
				}
			}

			if (ShotsFired == ShotsToFire)
			{
				LastFireTime += ShotsToFire * Interval;
				return;
			}
		}
		else
		{
			// didn't call fireammunition above, so need to manually restart the firing timer
			ClearTimer(nameof(RefireCheckTimer));
			TimeWeaponFiring(CurrentFireMode);
			return;
		}

		// Otherwise we're done firing
		HandleFinishedFiring();
	}
}

/** No active cooling! */
simulated function BeginActiveCooling() {}
simulated function EndActiveCooling() {}


/** Overloaded to go back to normal ammo handling. */
function int AddAmmo( int Amount )
{
	// don't do the heavy minigun ammo handling
	return Super(GearWeapon).AddAmmo(Amount);
}

/** Overloaded to go back to normal ammo handling. */
simulated function int GetDefaultAmmoAmount()
{
	// don't do the heavy minigun ammo handling
	return Super(GearWeapon).GetDefaultAmmoAmount();
}

/** Overloaded to go back to normal ammo handling. */
simulated function bool CanPickupAmmo()
{
	return Super(GearWeapon).CanPickupAmmo();
}

/** Overloaded to go back to normal ammo handling. */
simulated function float GetRateOfFire()
{
	return Super(GearWeapon).GetRateOfFire();
}

/** Overloaded to go back to normal ammo handling. */
simulated function ConsumeAmmo(byte FireModeNum)
{
	Super(GearWeapon).ConsumeAmmo(FireModeNum);
}

/** Overloaded to go back to normal ammo handling. */
simulated function bool IsCriticalAmmoCount()
{
	return Super(GearWeapon).IsCriticalAmmoCount();
}

/** Overloaded to go back to normal ammo handling. */
function DropFrom(vector StartLocation, vector StartVelocity)
{
	local GearPawn AmmoBoxInstigator;

	AmmoBoxInstigator = GearPawn(GetCoopWeaponCounterpart());

	// set it straight down.
	StartVelocity = vect(0,0,-50);

	Super(GearWeapon).DropFrom(StartLocation, StartVelocity);

	// if an AI is using the ammo box, tell it to put us down now
	if (AmmoBoxInstigator != None && GearAI(AmmoBoxInstigator.Controller) != None)
	{
		AmmoBoxInstigator.ThrowActiveWeapon();
	}
}

/** Overloaded to go back to normal ammo handling. */
simulated function float GetAmmoIconCount()
{
	return Super(GearWeapon).GetAmmoIconCount();
}

simulated function bool IsHeatLimited()
{
	return FALSE;
}

simulated function bool ShouldAutoReload()
{
	local GearPawn AmmoBoxInstigator;

	// pass reload to the ammobox
	AmmoBoxInstigator = GearPawn(GetCoopWeaponCounterpart());
	if (AmmoBoxInstigator != None)
	{
		return FALSE;
	}

	return Super.ShouldAutoReload();
}

simulated function Overheated()
{
	// nothing
}
reliable server function ServerOverheated()
{
	// nothing
}

/**
 * Disallow self-reloading if we have a partner
 *
 * @param FiringModeNum - the desired firing mode
 */
simulated function SetCurrentFireMode(byte FiringModeNum)
{
	local GearPawn AmmoBoxInstigator;

	AmmoBoxInstigator = GearPawn(GetCoopWeaponCounterpart());
	if (AmmoBoxInstigator != None)
	{
		if (FiringModeNum == RELOAD_FIREMODE)
		{
			GotoState('Active');
			return;
		}
	}

	super.SetCurrentFireMode(FiringModeNum);
}

/** Disallow force reloading if we have a partner */
simulated function ForceReload()
{
	local GearPawn AmmoBoxInstigator;

	AmmoBoxInstigator = GearPawn(GetCoopWeaponCounterpart());
	if (AmmoBoxInstigator != None)
	{
		return;
	}

	Super.ForceReload();
}

simulated function FireModeUpdated(byte FiringMode, bool bViaReplication)
{
	local bool bNormalReload;
	local GearPawn AmmoBoxInstigator;

	bNormalReload = true;
	AmmoBoxInstigator = GearPawn(GetCoopWeaponCounterpart());
	if (AmmoBoxInstigator != None)
	{
		bNormalReload = FALSE;
	}

	super.FireModeUpdated(FiringMode, bViaReplication);

	// we need to leave the ar firemodes, and the normal way isn't going to work since
	// we don't go into reloading state
	if (!bNormalReload)
	{
		if ( (FiringMode == FIREMODE_ACTIVERELOADSUCCESS) || (FiringMode == FIREMODE_ACTIVERELOADSUPERSUCCESS) || (FiringMode == RELOAD_FIREMODE) )
		{
			SetCurrentFireMode(0);
		}
	}
}

/** Do a little clean up.  Audio Components to none!.  **/
simulated function Destroyed()
{
	local CoopMGSyncActor SyncActor;

	SyncActor = GetSyncActor();
	if (SyncActor != None)
	{
		SyncActor.UpdateLink(self, None);
		SyncActor.Destroy();
	}

	StopCasingImpactLoop();

	super.Destroyed();
}

simulated protected function StartFiringEffects()
{
	local GearPawn MGInstigator;

	super.StartFiringEffects();
	SetTimer(0.7f, false, nameof(StartCasingImpactLoop));
	AC_ChainFeedLoop = GearWeaponPlaySoundLocalEx(ChainFeedLoopCue,,, AC_ChainFeedLoop, 0.2f);

	DoFiringScream();

	// The coop weapon is being held by a pawn, speed up rotation accel
	MGInstigator = GearPawn(GetCoopWeaponCounterpart());
	if (MGInstigator != None)
	{
		CurrentBarrelRotAccel = BarrelRotRateFiringThreshold / SpinUpTimeWithPartner;
	}
}

/** Speed up the spin up if you have a buddy */
simulated protected function StartSpinUpEffects()
{
	local GearPawn MGInstigator;

	Super.StartSpinUpEffects();

	// The coop weapon is being held by a pawn, speed up rotation accel
	MGInstigator = GearPawn(GetCoopWeaponCounterpart());
	if (MGInstigator != None)
	{
		CurrentBarrelRotAccel = BarrelRotRateFiringThreshold / SpinUpTimeWithPartner;
	}
}

simulated protected function DoFiringScream()
{
	local GearPawn InstigatorGP;

	InstigatorGP = GearPawn(Instigator);
	if (InstigatorGP != None)
	{
		InstigatorGP.SoundGroup.PlayEffort(InstigatorGP, GearEffort_ChainSawAttackEffort, true);
	}

	SetTimer(8.f, FALSE, nameof(DoFiringScream));
}

simulated protected function StartSpinDownEffects()
{
	super.StartSpinDownEffects();
	SetTimer(0.7f, false, nameof(StopCasingImpactLoop));
	if (AC_ChainFeedLoop != None)
	{
		AC_ChainFeedLoop.FadeOut(0.3f, 0.f);
	}

	ClearTimer(nameof(DoFiringScream));
}

simulated protected function StartCasingImpactLoop()
{
	AC_CasingImpactLoop = GearWeaponPlaySoundLocalEx(None, CasingImpactLoopCue,, AC_CasingImpactLoop, 0.f);
}

simulated protected function StopCasingImpactLoop()
{
	if (AC_CasingImpactLoop != None)
	{
		AC_CasingImpactLoop.FadeOut(0.25f, 0.f);
		AC_CasingImpactLoop = None;
	}
}

/**
 * Add some fake flash locations to make up for not being able to replicate every one since it fires multiple times a frame
 *
 * @param FiringMode - the firing mode the weapon was in when flash location was updated
 *
 * @param FlashLocation - the location where the flash hit
 *
 * @param bViaReplication - whether this came from the network or was generated locally
 */
simulated function FlashLocationUpdated(byte FiringMode, vector FlashLocation, bool bViaReplication)
{
	local vector FillerFlashLocation;
	local int NumDummyFlashes;

	if (bViaReplication && !IsZero(FlashLocation) && FiringMode != RELOAD_FIREMODE)
	{
		NumDummyFlashes = DummyNetworkFlashesCount;
		while (NumDummyFlashes-- > 0)
		{
			FillerFlashLocation = VRand();			
			FillerFlashLocation = Normal(FillerFlashLocation) * 20.0f;
			FillerFlashLocation = FlashLocation + (FillerFlashLocation >> Instigator.Rotation);
			Super.FlashLocationUpdated(FiringMode, FillerFlashLocation, bViaReplication);
		}
	}

	Super.FlashLocationUpdated(FiringMode, FlashLocation, bViaReplication);
}

/** Performs actual ammo reloading */
simulated function PerformReload()
{
	local int AmountToReload;
	local GearPawn AmmoBoxInstigator;

	AmmoBoxInstigator = GearPawn(GetCoopWeaponCounterpart());

	if (AmmoBoxInstigator != none)
	{
		AmountToReload = Min(AmmoUsedCount, Min(CoopReloadAmount, SpareAmmoCount));
		AmmoUsedCount -= AmountToReload;
		SpareAmmoCount -= AmountToReload;

		if (CurrentFireMode == class'GearWeapon'.const.FIREMODE_FAILEDACTIVERELOAD)
		{
 			SetCurrentFireMode(class'GearWeapon'.const.DEFAULT_FIREMODE);
		}
	}
	else
	{
		Super.PerformReload();
	}
}

/** overridden to allow reloadduration tweaks */
simulated function float PlayPawnReloadingAnimation(GearPawn GP)
{
	if ( IsMounted() )
	{
		// FIXME: this is temporary solution until we decide what to do with auto solo reload
		// reload time when mounted
		// don't play animation yet
		return 0.5f;
	}

	return Super.PlayPawnReloadingAnimation(GP);
}

static function float DetourWeight(Pawn Other, float PathWeight)
{
	local GearAI_TDM AI;

	AI = GearAI_TDM(Other.Controller);
	// if there are no more enemies then don't pick it up because we'll be stuck in a dead area
	if (AI.bHadCombatThisLife && AICommand_Base_Combat(AI.CommandList) == None)
	{
		return 0.0;
	}
	else
	{
		return Super.DetourWeight(Other, PathWeight);
	}
}

defaultproperties
{
	WeaponStatName="CoopMinigun"

	WeaponID=WC_CoopMinigun

	bWeaponCanBeReloaded=true
	bCanActiveReload=false

	DummyNetworkFlashesCount=4

	bAllowTracers=true
	TracerType=WTT_Coop_Minigun
	TracerTypeAR=WTT_Coop_Minigun

	bUseHeavySkelControl=false
}
