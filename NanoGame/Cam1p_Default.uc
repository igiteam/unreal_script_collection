/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class Cam1p_Default extends NanoFirstPersonCameraMode
	config(Camera)
	native(Camera);

cpptext
{
	virtual void GetCameraOrigin(class APawn* TargetPawn, FVector& OriginLoc, FRotator& OriginRot);
}

/** Returns FOV that this camera mode desires. */
function float GetDesiredFOV( Pawn ViewedPawn )
{
	local NanoPawn NP;
	local NanoSkill_Dash DashSkill;
	local float SpeedPct, MaxSpeed;
	local float DesiredFOV;
	local Vector2D FOVRange, SpeedRange;
	local int MaxPip;

	DesiredFOV = Super.GetDesiredFOV( ViewedPawn );

	NP = NanoPawn(ViewedPawn);
	if( NP != None )
	{
		DashSkill = NP.GetSkill(class'NanoSkill_Dash');
		if( DashSkill != None && DashSkill.bActive )
		{
			MaxPip = DashSkill.DashLevels[DashSkill.SkillLevel].MaxDashPips - 1;
			MaxSpeed = DashSkill.GetMaxSpeed( NP );
			SpeedRange.X = NP.GroundSpeed;
			SpeedRange.Y = MaxSpeed;
			SpeedPct = FClamp( GetRangePctByValue( SpeedRange, VSize(NP.Velocity) ), 0.f, 1.f );

			FOVRange.X = DesiredFOV;
			FOVRange.Y = DashSkill.DashPips[MaxPip].FOV;
			DesiredFOV = GetRangeValueByPct( FOVRange, SpeedPct );
		}
	}
	return DesiredFOV;
}

defaultproperties
{
	BlendTime=0.25
	bSlideOffsetOnCamModeChange=FALSE
}
