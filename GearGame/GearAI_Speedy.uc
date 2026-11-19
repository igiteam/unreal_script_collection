/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*
*/
class GearAI_Speedy extends GearAI_LocustDrone;

function ClearMoveAction()
{
	Super.ClearMoveAction();
	bShouldRoadieRun=true;
}

function bool ShouldRoadieRun()
{
	return !MyGearPawn.IsDBNO();
}

function BanzaiAttack()
{
	Super.BanzaiAttack();

	GearPawn_LocustDroneBase(Pawn).PlayBanzaiChargeScream();
}

defaultproperties
{
	bShouldRoadieRun=true
	bCanRevive=false

	// leave cover more
	DefaultReactConditionClasses.Remove(class'AIReactCond_DmgLeaveCover')
	Begin Object class=AIReactCond_DmgLeaveCover Name=LeaveCoverReaction0
		DamageThreshPct=0.1f
	End object
	DefaultReactConditions.Add(LeaveCoverReaction0)
	// crank rotation rate to get roadie runs looking better
	RotationRate=(Yaw=90000)
}
