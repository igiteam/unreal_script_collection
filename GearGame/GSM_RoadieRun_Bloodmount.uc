/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_RoadieRun_Bloodmount extends GearSpecialMove;

protected function bool InternalCanDoSpecialMove()
{
	// AI charges through GearPawn_LocustBloodmountBase::NotifyCharging()
	return (PawnOwner.Controller == None || PlayerController(PawnOwner.Controller) != None);
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced, PrevMove);

	// make sure to maintain the ratio in case we're under a slow effect
	PawnOwner.GroundSpeed = (PawnOwner.GroundSpeed / PawnOwner.DefaultGroundSpeed) * GearPawn_LocustBloodmountBase(PawnOwner).ChargeSpeed;
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);

	PawnOwner.GroundSpeed = (PawnOwner.GroundSpeed / GearPawn_LocustBloodmountBase(PawnOwner).ChargeSpeed) * PawnOwner.DefaultGroundSpeed;
}

function PreProcessInput(GearPlayerInput Input)
{
	// force running forwards
	Input.aBaseY = 1.0;

	// strafe becomes turning
	Input.aTurn = Input.aStrafe * 0.33;
	Input.aStrafe = 0.0;
}
