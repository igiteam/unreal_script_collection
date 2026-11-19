
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Leap extends GSM_BaseVariableFall;

var transient vector JumpVelocity;

simulated function SetJumpVelocity(vector NewJumpVel)
{
	JumpVelocity = NewJumpVel;
}

simulated function bool IsFallLooping()
{
	return TRUE;
}

simulated function BS_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	if( MoveType == EMT_Jump )
	{
		PawnOwner.Velocity = JumpVelocity;
		PawnOwner.SetCollision(PawnOwner.bCollideActors, false, true);
	}
	Super.BS_AnimEndNotify(SeqNode, PlayedTime, ExcessTime);
}

simulated function PlayJump()
{
	Super.PlayJump();

	PawnOwner.SetCollisionSize(PawnOwner.default.CylinderComponent.CollisionRadius, PawnOwner.default.CylinderComponent.CollisionHeight * 0.5f);
}

simulated function PlayFall()
{
	Super.PlayFall();

	PawnOwner.SetCollisionSize(PawnOwner.default.CylinderComponent.CollisionRadius, PawnOwner.default.CylinderComponent.CollisionHeight);
}

simulated function PlayLand()
{
	Super.PlayLand();
	PawnOwner.ZeroMovementVariables();
	PawnOwner.SetCollision(PawnOwner.bCollideActors, PawnOwner.default.bBlockActors, PawnOwner.default.bIgnoreEncroachers);
	PawnOwner.SetCollisionSize(PawnOwner.default.CylinderComponent.CollisionRadius, PawnOwner.default.CylinderComponent.CollisionHeight);
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
}

defaultproperties
{
	BS_Jump=(Stance=((Slot=BS_FullBody,AnimName="Emerge_Burst_start")))
	BS_Fall=(Stance=((Slot=BS_FullBody,AnimName="Emerge_Burst_fall")))
	BS_Land=(Stance=((Slot=BS_FullBody,AnimName="Emerge_Burst_land")))

	bDisableMovement=true
	PreImpactTime=0.0f

	JumpingPhysics=PHYS_Flying
	FallingPhysics=PHYS_Falling
}
