/**
 * GearVWeap_RocketCannon
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearVWeap_ReaverCannonBase extends GearVehicleWeapon
	abstract
	config(Weapon);

/** Min time between rockets firing */
var()	float	MinTimeBetweenRockets;

var()   float   RocketTelegraphTime;

simulated function PlayShellCaseEject()
{
}


simulated function PlayMuzzleFlashEffect()
{
}

simulated function bool HasAmmo(byte FireModeNum, optional int Amount)
{
	return true;
}

simulated function float GetFireInterval( byte FireModeNum )
{
	if( MinTimeBetweenRockets > 0.f )
	{
		return MinTimeBetweenRockets;
	}
	return Super.GetFireInterval( FireModeNum );
}


simulated state WeaponFiring
{

	/**
	 * Timer event, call is set up in Weapon::TimeWeaponFiring().
	 * The weapon is given a chance to evaluate if another shot should be fired.
	 * This event defines the weapon's rate of fire.
	 */
	simulated function RefireCheckTimer()
	{
		// if switching to another weapon, abort firing and put down right away
		if( bWeaponPutDown )
		{
			`LogInv("Weapon put down requested during fire, put it down now");
			PutDownWeapon();
			return;
		}

		// If weapon should keep on firing, then do not leave state and fire again.
		if( ShouldRefire() )
		{
			SetTimer( RocketTelegraphTime, FALSE, nameof(ActuallyFireAmmunition) );
			TimeWeaponFiring( CurrentFireMode );
			return;
		}

		// Otherwise we're done firing
		HandleFinishedFiring();
	}

	simulated event BeginState( Name PreviousStateName )
	{
		`LogInv("PreviousStateName:" @ PreviousStateName);
		
		// Inc flash count to trigger the telegraph then timer to fire rocket
		IncrementFlashCount();
		SetTimer( RocketTelegraphTime, FALSE, nameof(ActuallyFireAmmunition) );

		TimeWeaponFiring( CurrentFireMode );
	}

	simulated event EndState( Name NextStateName )
	{
		Super.EndState( NextStateName );

		ClearTimer( nameof(ActuallyFireAmmunition) );
	}

	simulated function ActuallyFireAmmunition()
	{
		ClearTimer( nameof(ActuallyFireAmmunition) );
		FireAmmunition();
	}
}

defaultproperties
{
	bWeaponCanBeReloaded=true
	bIsSuppressive=true
	bInfiniteSpareAmmo=true

	WeaponFireTypes(0)=EWFT_Projectile
	InstantHitDamageTypes(0)=class'GDT_ReaverCannon'
	AmmoTypeClass=class'GearAmmoType_Boomer'

	FireOffset=(X=68,Y=0,Z=9)

	//LC_EmisDefaultCOG=(R=0.5,G=3.0,B=20.0,A=1.0)
	//LC_EmisDefaultLocust=(R=3.0,G=3.0,B=3.0,A=1.0)

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformShooting1
		Samples(0)=(LeftAmplitude=100,RightAmplitude=100,LeftFunction=WF_LinearDecreasing,RightFunction=WF_LinearDecreasing,Duration=0.600)
	End Object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1

	WeaponID=WC_Boomshot

	MaxFinalAimAdjustment=0.5

	RocketTelegraphTime=0.35f
}
