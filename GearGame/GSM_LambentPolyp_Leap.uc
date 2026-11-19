
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_LambentPolyp_Leap extends GSM_Leap;


function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{	
	
	Super.SpecialMoveStarted(bForced, PrevMove);
}

simulated function bool IsFallLooping()
{
	return FALSE;
}

simulated function SetJumpVelocity(vector NewJumpVel)
{
	JumpVelocity = NewJumpVel;
	PawnOwner.Velocity = JumpVelocity;
	PawnOwner.SetPhysics(JumpingPhysics);
	PawnOwner.SetBase( PawnOwner.ClampedBase );
}

/** Play Land */
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
	PawnOwner.EndSpecialMove();
}

defaultproperties
{
	PreImpactTime=0.1f
	JumpingPhysics=PHYS_Falling
}
