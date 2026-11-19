/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_JumpFromReaver extends GSM_BaseVariableFall
	native(SpecialMoves);

/** Distance from landing point at which collision should be turned back on */
var() private const float CollisionEnableDistance;
/** Initial velocity of the jump */
var transient vector JumpVelocity;
/** Point where we should try to land */
var transient Actor LandingPoint;
/** Reaver we are jumping from */
var transient Vehicle_Reaver_Base Reaver;

// C++ functions
cpptext
{
	virtual void TickSpecialMove(FLOAT DeltaTime);
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	//Remove collision
	PawnOwner.SetCollision(PawnOwner.bCollideActors, FALSE);
	PawnOwner.bCollideWorld = FALSE;
	PawnOwner.ReaverDismount();

	Super.SpecialMoveStarted(bForced, PrevMove);
}

simulated function BS_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	local Vector LandingPointVel;

	if( MoveType == EMT_Jump )
	{
		//PawnOwner.WorldInfo.TimeDilation = 0.4f;
		// If we have a LandingPoint set, ignore passed in JumpVelocity and calculate one
		if( LandingPoint != None )
		{
			PawnOwner.CalculateMinSpeedTrajectory(JumpVelocity, LandingPoint.Location, PawnOwner.Location, 1500, 500, PawnOwner.GetCollisionExtent(), PawnOwner.GetTerminalVelocity(), PawnOwner.GetGravityZ());

			LandingPointVel = LandingPoint.GetAggregateBaseVelocity();
			if( VSizeSq(LandingPointVel) > 1.0f )
			{
				JumpVelocity += LandingPointVel;
			}
		}

		PawnOwner.Velocity = JumpVelocity;
		PawnOwner.SetCollision(PawnOwner.bCollideActors, FALSE, TRUE);
	}
	Super(GSM_BaseVariableFall).BS_AnimEndNotify(SeqNode, PlayedTime, ExcessTime);
}

function Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);

	// Force the velocity in the XY plane to stay constant
	if( MoveType == EMT_Fall )
	{
		PawnOwner.Velocity.X = JumpVelocity.X;
		PawnOwner.Velocity.Y = JumpVelocity.Y;
	}
	else if( MoveType == EMT_Jump)
	{
		PawnOwner.Velocity = Reaver.Velocity;
	}
}

simulated function PlayLand()
{
	// restore collision
	//PawnOwner.ZeroMovementVariables();
	PawnOwner.bCollideWorld = TRUE;
	PawnOwner.SetCollision( TRUE, TRUE, FALSE );
	PawnOwner.bInvalidMeleeTarget = FALSE;

	if( LandingPoint != None && LandingPoint.Base != None && LandingPoint.Base.IsA('InterpActor_GearBasePlatform') )
	{
		LandingPoint.Base.Attach(PawnOwner);
		PawnOwner.SetBase(LandingPoint.Base);
		PawnOwner.ClampedBase = LandingPoint.Base;
	}

	Super.PlayLand();
}

defaultproperties
{
	BS_Jump=(Stance=((Slot=BS_FullBody,AnimName="Emerge_Burst_start")))
	BS_Fall=(Stance=((Slot=BS_FullBody,AnimName="Emerge_Burst_fall")))
	BS_Land=(Stance=((Slot=BS_FullBody,AnimName="Emerge_Burst_land")))

	bDisableMovement=true
	PreImpactTime=0.0f
	CollisionEnableDistance=400.f

	JumpingPhysics=PHYS_Projectile
	FallingPhysics=PHYS_Falling
}