
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_LambentHuman_Leap extends GSM_Leap;

var	GearPawn.BodyStance	BS_JumpAlt, BS_FallAlt, BS_LandAlt;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{	
	if( PawnOwner.SpecialMoveFlags == 1 )
	{
		BS_Jump = BS_JumpAlt;
		BS_Fall = BS_FallAlt;
		BS_Land = BS_LandAlt;
	}
	else
	{
		BS_Jump = default.BS_Jump;
		BS_Fall = default.BS_Fall;
		BS_Land = default.BS_Land;
	}

	Super.SpecialMoveStarted(bForced, PrevMove);
}

simulated function bool IsFallLooping()
{
	return FALSE;
}

simulated function PlayLand()
{
	local array<Vector> Positions;
	Super.PlayLand();
	if( PawnOwner.MyGearAI != none )
	{
		if( !PawnOwner.MyGearAI.NavigationHandle.ObstaclePointCheck(PawnOwner.Location,vect(0,0,0)) )
		{
			//native static function GetValidPositionsForBox(Vector Pos, float Radius, Vector Extent, bool bMustBeReachableFromStartPos, out Array<Vector> out_ValidPositions, optional int MaxPositions=-1, optional float MinRadius, optional vector ValidBoxAroundStartPos=vect(0,0,0));
			PawnOwner.MyGearAI.NavigationHandle.GetValidPositionsForBox(PawnOwner.Location,512,PawnOwner.GetCollisionExtent(),FALSE,Positions,1);
			if( Positions.length > 0)
			{
				PawnOwner.SetLocation(Positions[0]);
			}
		}
	}
}

defaultproperties
{
	BS_Jump=(Stance=((Slot=BS_FullBody,AnimName="platform_jump_start")))
	BS_Fall=(Stance=((Slot=BS_FullBody,AnimName="platform_jump_middle")))
	BS_Land=(Stance=((Slot=BS_FullBody,AnimName="platform_jump_end")))

	BS_JumpAlt=(Stance=((Slot=BS_FullBody,AnimName="platform_jump_up_start")))
	BS_FallAlt=(Stance=((Slot=BS_FullBody,AnimName="platform_jump_up_middle")))
	BS_LandAlt=(Stance=((Slot=BS_FullBody,AnimName="platform_jump_up_end")))

	PreImpactTime=0.0f
}
