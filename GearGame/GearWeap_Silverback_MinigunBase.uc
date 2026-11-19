
/**
 * GearWeap_Silverback_MinigunBase
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearWeap_Silverback_MinigunBase extends GearWeap_TroikaBase
	abstract;

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
	}
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

/** 
 * Tell the HUD to draw a heat bar 
 *
 * @return true to tell the UI we need a heat bar
 */
simulated function bool IsHeatLimited()
{
	return true;
}

/** The Silverback has overheated, stop firing */
simulated function ForceOverheat()
{
	bOverheated = TRUE;
	StopFire(0);
	WeaponPlaySound(FireStopCue_Overheat);
}

/** Silverback has notified us that the overheat is clear */
simulated function ClearOverheat()
{
	bOverheated = FALSE;
}

simulated state Active
{
	/** The Troika base class has some cooldown logic that we want to skip */
	simulated function Tick(float DeltaTime)
	{
		Global.Tick(DeltaTime);
	}
}

/** There is no equip animation for this weapon */
simulated function PlayEquipAnimation(float BlendInTime);

/** There is no holster animation for this weapon */
simulated function PlayHolsterAnimation();

/** @return TRUE to draw crosshair */
simulated function bool ShouldDrawCrosshair()
{
	return TRUE;
}

/** @return TRUE to prevent weapon switching */
simulated function bool ShouldPreventWeaponSwitch()
{
	return TRUE;
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

/**
 * All right-hand Silverback weapons need bUseTargetingCamera unset
 * They're not replicated so they need to be the defaults.
 */
defaultproperties
{
	bUseTargetingCamera=FALSE
	bOnlyRelevantToOwner=FALSE
}
	