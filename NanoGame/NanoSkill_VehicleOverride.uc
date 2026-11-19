/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoSkill_VehicleOverride extends NanoSkill;

/** Number of seconds the pawn should be able to fly for before activating the skill (i.e. they should have 2 seconds worth of juice before they can activate the skill) */
var float   PrerequisiteSecondsOfActivation;

/** The vehicle that the pawn is riding */
var transient NanoVehicleAgent Vehicle;

/** If true, the player is using the gravity assist charge, and nano should be replenished per tick */
var transient bool bIsCharging;

simulated function float GetNanoCostPerSecond()
{
	local float ConsumptionRateModifier;

	if( Vehicle != None )
	{
		// See if this vehicle wants to change the rate of consumption of nano power
		ConsumptionRateModifier = Vehicle.OverrideNanoRateModifier;
	}
	else
	{
		ConsumptionRateModifier = 1.f;
	}

	// If the player is charging using the gravity assist, replenish nano
	return (bIsCharging ? -ConsumptionRateModifier : ConsumptionRateModifier) * Super.GetNanoCostPerSecond();
}

simulated function SetGravityCharging(bool bNewCharging )
{
	bIsCharging = bNewCharging;
}

simulated event bool ActivateSkill()
{
	// Reset charging here, so that we can test nano activation power against a burn rate, and not a charge rate
	bIsCharging = FALSE;

	// Make sure that the pawn has enough juice to override for a few seconds before we let them activate
	if( PawnOwner.HasEnoughNanoPower(PrerequisiteSecondsOfActivation * GetNanoCostPerSecond(), TRUE) )
	{
		return Super.ActivateSkill();
	}
	else
	{
		return FALSE;
	}

}

simulated protected function InternalActivated()
{
	Super.InternalActivated();

	// Cache the vehicle that the pawn is on
	Vehicle = NanoVehicleAgent(PawnOwner.Base);

	if( Vehicle != None )
	{
		Vehicle.SetVehicleOverride(TRUE);
	}
}

simulated protected function InternalDeactivated()
{
	if( Vehicle != None )
	{
		Vehicle.SetVehicleOverride(FALSE);
	}
}

simulated function bool ShouldConsumeNanoPower()
{
	return ( ( Vehicle != None ) && Super.ShouldConsumeNanoPower() );
}


defaultproperties
{
	bHideFromSkillUI=TRUE

	SkillType=NS_VehicleOverride


	SkillIconOrigin=(X=192)
	SkillIconSize=(X=64,Y=64)

	PrerequisiteSecondsOfActivation=1.f;
}