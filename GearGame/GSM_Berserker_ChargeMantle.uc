/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Berserker_ChargeMantle extends GSM_NonCoverUserMantleOverCover;


/** Move started so clear the destination flag */
function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced,PrevMove);

	PawnOwner.Mesh.RootMotionDelta.Translation = vect(0,0,0);
	PawnOwner.Mesh.RootMotionDelta.Scale = 0.0f;
	PawnOwner.Mesh.RootMotionDelta.Rotation.X = 0.0f;
	PawnOwner.Mesh.RootMotionDelta.Rotation.Y = 0.0f;
	PawnOwner.Mesh.RootMotionDelta.Rotation.Z = 0.0f;
	PawnOwner.Mesh.RootMotionDelta.Rotation.W = 0.0f;
	PawnOwner.Mesh.RootMotionVelocity = vect(0,0,0);
}

/** Hack around the controller pressing up code for the berserker */
protected function bool InternalCanDoSpecialMove()
{
	local GearPC PC;
	local bool bResult;

	PC = GearPC(PawnOwner.Controller);
	if (PC != None)
	{
		PC.bForcedRoadieRun = true;
	}

	bResult = Super.InternalCanDoSpecialMove();

	if (PC != None)
	{
		PC.bForcedRoadieRun = false;
	}

	return bResult;
}

/**
 * Can the special move be chained after the current one finishes?
 */
function bool CanChainMove(ESpecialMove NextMove)
{
	return (NextMove == SM_Berserker_Charge);
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	local GearPC PC;

	Super.SpecialMoveEnded(PrevMove, NextMove);

	PC = GearPC(PawnOwner.Controller);
	if (PawnOwner.CanDoSpecialMove(SM_Berserker_Charge))
	{
		if (PC == None)
		{
			PawnOwner.DoSpecialMove(SM_Berserker_Charge, true,,1);
		}
		else if (PC.IsHoldingRoadieRunButton())
		{
			PC.DoSpecialMove(SM_Berserker_Charge, true,,1);
		}
	}
}

defaultproperties
{
	DefaultMantleDistance=260.0f
	FallForwardVelocity=0.f
	GravityScale=4.f
	bCheckForMirrorTransition=FALSE
	BSList_Jump(0)=(Stance=((Slot=BS_FullBody,AnimName="Mantle_Charge_Start")))
	BSList_Fall(0)=(Stance=((Slot=BS_FullBody,AnimName="Mantle_Charge_Mid")))
	BSList_Land(0)=(Stance=((Slot=BS_FullBody,AnimName="Mantle_Charge_End")))
	bLockPawnRotation=TRUE
}
