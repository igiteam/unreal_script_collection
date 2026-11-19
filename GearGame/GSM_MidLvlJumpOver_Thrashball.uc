/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_MidLvlJumpOver_Thrashball extends GSM_NonCoverUserMantleOverCover;

// need to save MantleDir for GetCoverNormal to use
// player rotation will follow this normal
var transient vector MantleDir;

// This special move is triggered forcefully, so CanDoSpecialMove isn't getting called
// Since it's confusing, removed the function
function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	FindMantleDistance();
	Super.SpecialMoveStarted(bForced, PrevMove);
}

simulated function GetMantleInformation( out BasedPosition InMantleStartLoc, out BasedPosition InMantleEndLoc, out float InMantleDistance)
{
	local ThrashballMantleVolume Vol;

	foreach PawnOwner.TouchingActors( class'ThrashballMantleVolume', Vol )
	{
		break;
	}

	MantleDir = Vector(PawnOwner.Rotation);
	PawnOwner.SetDesiredRotation(PawnOwner.Rotation);
	InMantleDistance = class'GearScout'.default.MaxMantleLateralDist;
	Vect2BP( InMantleStartLoc, PawnOwner.Location );
	Vect2BP( InMantleEndLoc, PawnOwner.Location + MantleDir * InMantleDistance );
}

simulated function vector GetCoverNormal()
{
	return -MantleDir;
}

simulated function PreProcessInput(GearPlayerInput Input)
{
	Input.aTurn = 0.f;
}

defaultproperties
{
  	BSList_Jump(0)=(Stance=((Slot=BS_FullBody,AnimName="Thrashball_Hurdle_Start")))
  	BSList_Fall(0)=(Stance=((Slot=BS_FullBody,AnimName="Thrashball_Hurdle_Mid")))
  	BSList_Land(0)=(Stance=((Slot=BS_FullBody,AnimName="Thrashball_Hurdle_End")))

	bCheckForMirrorTransition=FALSE
	DefaultMantleDistance=165.f	// default mantle over distance in POC_CoverTest

	JumpBlendOutTime = 0.f
}
