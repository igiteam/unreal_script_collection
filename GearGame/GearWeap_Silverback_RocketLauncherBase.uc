/**
 * Silverback Rocket Launcher base class
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearWeap_Silverback_RocketLauncherBase extends GearWeap_HeavyBase
	abstract;

/** Allow this gun to overheat with the Silverback */
var protected transient bool		bOverheated;

/** How long reload should take */
var config float ReloadTime;

/** Sound to play when reload is complete */
var SoundCue RocketReloadSound;

simulated event PreBeginPlay()
{
	// bit of a hack to have different MP and Horde settings without adding yet another .ini file
	if (Role == ROLE_Authority && WorldInfo.GRI.IsMultiplayerGame() && !WorldInfo.GRI.IsCoopMultiplayerGame())
	{
		WeaponMagSize = 2;
	}

	Super.PreBeginPlay();
}

/** Attach to the Silverback as soon as we spawn */
simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	AttachToSilverback();
}

/** Instigator may not have replicated yet, repeat until he shows up */
simulated function AttachToSilverback()
{
	local GearPawn  GP;

	if (Instigator == none)
	{
		SetTimer(0.2f, FALSE, nameof(AttachToSilverback));
	}
	else
	{
		GP = GearPawn(Instigator);
		if (GP != none)
		{
			AttachWeaponTo(GP.Mesh, GetDefaultHandSocketName(GP));
			
			GP.UpdateWeaponSkinForMesh(Class, Mesh, MIC_WeaponSkin);
		}

		// There's not always a controller, so bNetOwner can be a false negative and Owner won't be replicated.
		SetOwner(Instigator);

		// bit of a hack to have different MP and Horde settings without adding yet another .ini file
		HUDDrawData.DisplayCount = WeaponMagSize;
		HUDDrawDataSuper.DisplayCount = WeaponMagSize;
		HUDDrawData.AmmoIcon.UL = WeaponMagSize * HUDDrawData.ULPerAmmo;
		HUDDrawDataSuper.AmmoIcon.UL = WeaponMagSize * HUDDrawData.ULPerAmmo;
	}
}

simulated function AttachMuzzleEffectsComponents(SkeletalMeshComponent SkelMesh)
{
	// use base Silverback mesh instead of own
	Super.AttachMuzzleEffectsComponents(Instigator.Mesh);
}

/**
 * Give the HUD our heat bar progress
 *
 * @return the percentage of the heat bar the UI should fill
 */
simulated function float GetCurrentBarrelHeat()
{
	return GearPawn_SilverbackArmedBase(Instigator).CurrentBarrelHeat;
}

/** Mark the weapon equipped next frame, doing it this frame causes infinite looping */
simulated function TimeWeaponEquipping()
{
	SetTimer(0.01, false, 'WeaponEquipped');
}

/** Put the weapon down immediately */
simulated function TimeWeaponPutDown()
{
	WeaponIsDown();
}

/** There is no equip animation for this weapon */
simulated function PlayEquipAnimation(float BlendInTime);

/** There is no holster animation for this weapon */
simulated function PlayHolsterAnimation();

/**
 * Return how fast we should reload
 *
 * @param GP - the pawn reloading the gun
 *
 * @return the time it takes to reload
 */
simulated function float PlayPawnReloadingAnimation(GearPawn GP)
{
	SetTimer(ReloadTime - 2.0f, FALSE, nameof(PlayReloadSound));

	return ReloadTime;
}

/** Play a sound when reload is complete */
simulated function PlayReloadSound()
{
	PlaySound(RocketReloadSound, TRUE);
}

/** @return TRUE to prevent weapon switching */
simulated function bool ShouldPreventWeaponSwitch()
{
	return TRUE;
}

/** @return FALSE to stop refiring */
simulated function bool ShouldRefire()
{
	if (Instigator.Weapon != Self)
	{
		EndFire(0);
		return FALSE;
	}

	return Super.ShouldRefire();
}

defaultproperties
{
	bUseTargetingCamera=false
	bOnlyRelevantToOwner=false
	bCanActiveReload=false
	bEnableProjCorrectionForAI=true
}
