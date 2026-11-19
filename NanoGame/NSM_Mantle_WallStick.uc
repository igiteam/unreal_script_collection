/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_Mantle_WallStick extends NSM_Mantle_Base;

var float StickDuration;
var float VerticalBump;

protected function bool InternalCanDoSpecialMove()
{
	if( MyNP.MantleState == MANTLE_Jump )
	{
		return FALSE;
	}

	return Super.InternalCanDoSpecialMove();
}

simulated function float GetMantleDuration( float AnimTime )
{
	return StickDuration;
}

simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	if( bQueuedJump )
	{
		EndMantleUp(FALSE);
		bQueuedJump = FALSE;
	}
}

simulated function HandleJumpAfterMantle()
{
	local Vector JumpVel;
	local NanoSkill_Jump JumpSkill;
	local NanoPC PC;
	local Vector CamLoc;
	local Rotator CamRot;

	MyNP.MantleState = MANTLE_Jump;

	JumpSkill = MyNP.GetSkill(class'NanoSkill_Jump');
	if( JumpSkill != None )
	{
		if( MyNP.SuggestTossVelocity( JumpVel, JumpSkill.JumpOrigin, MyNP.Location, JumpSkill.JumpLevels[JumpSkill.SkillLevel].DashForwardVelocity ) )
		{
			MyNP.Velocity = JumpVel;
		}
		else
		{
			MyNP.Velocity = WallNorm * JumpSkill.JumpLevels[JumpSkill.SkillLevel].DashForwardVelocity;
		}
		// Small vertical bump
		MyNP.Velocity.Z += VerticalBump;

		PC = NanoPC(MyNP.Controller);
		if( PC != None )
		{
			if( PC.PlayerInput.RawJoyUp < -0.9f )
			{
				PC.GetActorEyesViewPoint( CamLoc, CamRot );
				CamRot.Yaw = Rotator(WallNorm).Yaw;
//				PC.InterpViewRotation( CamRot, 0.5f );
			}
		}
	}
}

defaultproperties
{
	WalkAnimNames=("NW_Jump_Fwd_Land")
	FallAnimNames=("NW_Jump_Fwd_Land")
	InputDirection=DIR_Up
	bCanBeUsedByAI=FALSE
	MantleType=MANTLE_WallStick
	MinAnimRate=0.8f
	MaxAnimRate=1.5f
	LowCheckDistance=30.f
	HighCheckDistance=30.f
	MinHeight=64.f
	MaxHeight=196.f
	RequiredPhysics=(PHYS_Falling)
	MinRequiredSpeed=10
	bAllowJump=TRUE
	bForceCenterView=TRUE
	bResetOnLanding=TRUE
	MaxVelocityZ=100
	BlendInTime=0.1f
	BlendOutTime=0.2f
	ClothBlend=1.0

	StickDuration=1.2f
	VerticalBump=100.f
	RequiredMinDistFromGround=384.f
}