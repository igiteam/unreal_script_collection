/**
 * AmmoBox component of heavy coop machine gun weapon.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearWeap_HeavyCoopMGAmmoBoxBase extends GearWeap_HeavyBase
	abstract;

var() float DebugARTime;

/** How much time to remove from the AR sweet spot after each successful AR */
var config const float AR_SweetSpotDurationReduction;

/** The smallest AR sweet spot possible */
var config const float AR_SweetSpotDurationMinimum;

/** How far the AR sweet spot should move after each successful AR */
var config const float AR_SweetSpotStartMovement;

/** The farthest AR sweet spot starting point */
var config const float AR_SweetSpotStartMaximum;

// Play Cranking
var transient bool    bPlayingCrank;
var array<BodyStance>           BS_CrankAnims; // 0 - standing 1- kneeled
var transient BodyStance        BS_CrankAnimPlayed;

/** Action icon for displaying coop reload opportunity */
var ActionInfo ActionCoopReload;

/** Set special action
    Called by GearPC.UpdateHUDActions()
	@PARAM MyGearPC is the player owning this weapon
	@RETURN true if action was set
	*/
simulated function bool SetSpecialAction(GearPC MyGearPC)
{
	if ( CanReload() )
	{
		MyGearPC.MyGearHud.SetActionInfo(AT_WeaponActions, ActionCoopReload);
		return true;
	}
	return false;
}

simulated protected function CoopMGSyncActor GetSyncActor()
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

/** Performs actual ammo reloading */
simulated function PerformReload()
{
	// pass reload notification back to the MG
	local GearPawn MGInstigator;

	MGInstigator = GearPawn(GetCoopWeaponCounterpart());
	if (MGInstigator != None)
	{
		GearWeap_HeavyCoopMGBase(MGInstigator.MyGearWeapon).PerformReload();
	}
}

simulated function bool HasAmmo( byte FireModeNum, optional int Amount )
{
	if (FireModeNum == RELOAD_FIREMODE)
	{
		return true;
	}

	return Super.HasAmmo(FireModeNum, Amount);
}

/**
 * Report having no ammo if our coop counterpart is gone
 *
 * @return TRUE if there's ammo
 */
simulated function bool HasAnyAmmo()
{
	local CoopMGSyncActor SyncActor;

	SyncActor = GetSyncActor();
	if (SyncActor != None && SyncActor.bDestroyingLinkedActors)
	{
		return FALSE;
	}

	if (GetCoopWeaponCounterpart() == None)
	{
		return FALSE;
	}

	return Super.HasAnyAmmo();
}


simulated function StartCrankAnimation()
{
	local GearPawn GP;

	GP  = GearPawn(Instigator);

	if (GP != none)
	{
		if (IsMounted())
		{
			BS_CrankAnimPlayed = BS_CrankAnims[1];
		}
		else
		{
			BS_CrankAnimPlayed = BS_CrankAnims[0];
		}

		// now play player
		GP.BS_Play(BS_CrankAnimPlayed, 1.f, 0.25f, 0.25f, TRUE);

		// play weapon
		PlayWeaponAnim('CM_AmmoBox_Crank', 1.f, 0.25, 0.25, TRUE, TRUE);
	}
}

simulated function StopCrankAnimation()
{
	local GearPawn GP;

	GP  = GearPawn(Instigator);

	if (bPlayingCrank == FALSE)
	{
		return;
	}

	if (GP == none)
	{
		return;
	}

	// stop
	StopWeaponAnim(0.25f);
	GP.BS_Stop(BS_CrankAnimPlayed, 0.25f);

	bPlayingCrank = FALSE;
}

simulated function TryCrankAnimation()
{
	if (bPlayingCrank == FALSE)
	{
		bPlayingCrank = TRUE;
		StartCrankAnimation();
	}
}

/** Tell the server that we're putting more ammo into the gun */
simulated function HitReload()
{
	ForceReload();
}

/**
 * Returns true if weapon can potentially be reloaded
 *
 * @return	true if weapon can be reloaded
 */
simulated function bool CanReload()
{
	local GearPawn GP, GunGP;
	local CoopMGSyncActor SyncActor;

	GP = GearPawn(Instigator);

	if (GP != None && GP.CanReloadWeapon() && !IsBeingMounted() && !IsBeingUnMounted())
	{
		SyncActor = GetSyncActor();
		if (SyncActor != None)
		{
			GunGP = GearPawn(SyncActor.GetCounterpart(GP));
			// only allow reload if someone's holding the gun part
			if (GunGP != None)
			{
				return (SyncActor.AmmoUsedCount > 0) && (SyncActor.SpareAmmoCount > 0);
			}
		}
	}

	return false;
}


/** overridden to allow reloadduration tweaks */
simulated function float PlayPawnReloadingAnimation(GearPawn GP)
{
	// start crank animation
	TryCrankAnimation();
	// setting stopping animation timer
	ClearTimer(nameof(StopCrankAnimation) );
	// if nothing happens within next 0.5 seconds, it will stop
	SetTimer(0.5f, FALSE, nameof(StopCrankAnimation), self);

	return 0.f;
}

simulated function float GetMagazineSizeForHUD()
{
	local GearPawn MGInstigator;

	// return mag size for the mg if some else is holding it
	MGInstigator = GearPawn(GetCoopWeaponCounterpart());
	if (MGInstigator != None)
	{
		return GearWeap_HeavyCoopMGBase(MGInstigator.MyGearWeapon).WeaponMagSize;
	}

	// else fall back to my own mag size (i.e. zero)
	return WeaponMagSize;
}

simulated function float GetRemainingAmmoForHUD()
{
	local CoopMGSyncActor SyncActor;

	SyncActor = GetSyncActor();
	if (SyncActor != None)
	{
		return GetMagazineSizeForHUD() - SyncActor.AmmoUsedCount;
	}

	return 0.f;
}
simulated function float GetTotalRemainingAmmoForHUD()
{
	local CoopMGSyncActor SyncActor;

	SyncActor = GetSyncActor();
	if (SyncActor != None)
	{
		return GetMagazineSizeForHUD() - SyncActor.AmmoUsedCount + SyncActor.SpareAmmoCount;
	}

	return 0.f;
}
simulated function bool IsCriticalAmmoCount()
{
	local CoopMGSyncActor SyncActor;

	SyncActor = GetSyncActor();
	if (SyncActor != None)
	{
		return SyncActor.SpareAmmoCount == 0;
	}

	return false;
}

simulated function float GetAmmoIconCount()
{
	local GearPawn MGInstigator;

	// pass through to the mg if someone's holding it
	MGInstigator = GearPawn(GetCoopWeaponCounterpart());
	if (MGInstigator != None)
	{
		return GearWeap_HeavyCoopMGBase(MGInstigator.MyGearWeapon).GetAmmoIconCount();
	}

	// else fall back to my own
	return GetAmmoIconCount();
}

/**
 * Reload when the A button is released
 *
 * @param ButtonName - the name of the button released
 *
 * @return TRUE if no further processing of the button release should occur
 */
simulated function bool HandleButtonRelease(coerce Name ButtonName)
{
	if (ButtonName == 'A' || ButtonName == 'R2')
	{
		HitReload();
	}

	return Super.HandleButtonRelease(ButtonName);
}

/** Overridden to handle AI weapon firing */
simulated function StartFire( byte FireModeNum )
{
	// only allow reload
	if (FireModeNum == RELOAD_FIREMODE)
	{
		Super.StartFire ( FireModeNum );
	}
}

/** needed to be visible at the GearWeapon scope.  Only ever used in state Reloading **/
simulated function EndOfReloadTimer();

simulated function TimeWeaponEquipping()
{
	Super.TimeWeaponEquipping();

	bPlayingCrank = FALSE;
}

simulated function float GetWeaponRating()
{
	local GearPawn OtherPawn;

	// get rid of the box if no one is holding the gun
	if (GearAIController != None)
	{
		OtherPawn = GearPawn(GetCoopWeaponCounterpart());
		if (OtherPawn == None)
		{
			return -1.0;
		}
	}

	return Super.GetWeaponRating();
}

simulated function DropFrom(vector StartLocation, vector StartVelocity)
{
	if (GearAIController != None)
	{
		GearAIController.ClearTether();
	}

	Super.DropFrom(StartLocation, StartVelocity);
}

simulated state Active
{
	simulated event Tick(float DeltaTime)
	{
		local GearPawn OtherPawn;
		local GearWeapon OtherWeapon;

		Global.Tick(DeltaTime);

		// have AI reload whenever necessary
		if (GearAIController != None)
		{
			OtherPawn = GearPawn(GetCoopWeaponCounterpart());
			if (OtherPawn != None)
			{
				OtherWeapon = GearWeapon(OtherPawn.Weapon);
				if (OtherWeapon != None && OtherWeapon.AmmoUsedCount > 0)
				{
					HitReload();
				}
				if (GearAIController.GetTetherActor() == None)
				{
					GearAIController.SetTether(OtherPawn.Location, OtherPawn, OtherPawn.GetCollisionRadius() * 1.5, true, -1.0, false, false);
				}
			}
		}
	}
}

simulated state Inactive
{
	/**
	 * Make sure the instigator is not still playing the crank animation
	 * 
	 * @param PreviousStateName - the name of the previous state
	 */
	simulated function BeginState(Name PreviousStateName)
	{
		Super.BeginState(PreviousStateName);

		StopCrankAnimation();
	}
}

/** @return TRUE to zoom when targeting */
simulated function bool ShouldTargetingModeZoomCamera()
{
	local GearPawn P;

	P = GearPawn(Instigator);
	if (P == None)
	{
		return Super.ShouldTargetingModeZoomCamera();
	}

	return P.bIsTargeting;
}

defaultproperties
{
	// Weapon Mesh
	Begin Object Name=WeaponMesh
	End Object
	Mesh=WeaponMesh
	DroppedPickupMesh=WeaponMesh

	DebugARTime=0.77
	RespawnTime=60.0

	BS_CrankAnims= {(
			(Stance=((Slot=BS_Std_Up,AnimName="CM_AmmoBox_Crank"), (Slot=BS_Std_Idle_Lower,AnimName="CM_AmmoBox_Crank"))),
			(Stance=((Slot=BS_FullBody,AnimName="CM_AmmoBox_Kneel_Crank")))
		)}

	bUseHeavySkelControl=false

	bCanActiveReload=false
	bAIAvoidsTaking=true //@note: AI has override for squadmate using linked gun
	bReloadingWeaponPreventsTargeting=FALSE

	ActionCoopReload={(
		ActionName=CoopReload,
		bCenterY=true,
		IconAnimationSpeed=0.1f,
		ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=212,V=314,UL=35,VL=43),	// mash A button
		(Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=248,V=314,UL=35,VL=43))),
		(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=360,V=0,UL=58,VL=55))),
		(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=156,V=233,UL=34,VL=56)))	),
		)}
}
