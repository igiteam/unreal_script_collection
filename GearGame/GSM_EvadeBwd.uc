
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_EvadeBwd extends GSM_Evade;

protected function bool InternalCanDoSpecialMove()
{
	return InternalCanDoSpecialMoveEvade_Worker(SM_EvadeBwd);
}

simulated function PreProcessInput(GearPlayerInput Input)
{
	// call the super class's version
	Super.PreProcessInput(Input);

	// force running backwards
	Input.aBaseY	= -default.AccelScale;
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local Vector	Direction, X, Y, Z;

	Super.SpecialMoveStarted(bForced,PrevMove);

	// for players, turn to face direction he's trying to move
	// @fixme, do this for AI too?
	if (PCOwner != None && PCOwner.bAllow360Evade)
	{
		GetAxes( PCOwner.Rotation, X, Y, Z );

		// go in direction stick is pointing, adjusted for fact we're going backward
		Direction = Normal((PCOwner.RemappedJoyUp * -X) + (PCOwner.RemappedJoyRight * -Y) );
		if( !IsZero(Direction) )
		{
			SetLockPawnRotation(false);
			PawnOwner.FaceRotation(Rotator(Direction), 9999.f);		// large val to snap
			SetLockPawnRotation(true);
		}
	}
}



defaultproperties
{
	BS_EvadeStart=(Stance=((Slot=BS_FullBody,AnimName="AR_Evade_Bwd_Start")))
	BS_EvadeEnd=(Stance=((Slot=BS_FullBody,AnimName="AR_Evade_Bwd_End")))
}
