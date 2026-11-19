
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_LambentPolyp_Spit extends GSM_BasePlaySingleAnim;

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);
	if( PawnOwner.Controller != None )
	{
		GearAI_LambentPolyp(PawnOwner.Controller).StopFiring();
	}
}

function PlayAnimation()
{
	local GearPawn_LambentPolypBase Polyp;

	Super.PlayAnimation();

	Polyp = GearPawn_LambentPolypBase(PawnOwner);
	if( Polyp != None )
	{
		Polyp.StartSpitBuildup();
	}
}

function Tick(float DeltaTime)
{
	local GearPawn_LambentPolypBase Polyp;

	Super.Tick(DeltaTime);

	Polyp = GearPawn_LambentPolypBase(PawnOwner);
	if( Polyp != None )
	{
		Polyp.SpitBuildupPct += DeltaTime;
		Polyp.SpitBuildupPct = FClamp(Polyp.SpitBuildupPct, 0.f, 1.f);
		Polyp.Spit_MIC.SetScalarParameterValue('Explo',Polyp.SpitBuildupPct);
	}
}

defaultproperties
{
	BS_Animation=(Stance=((Slot=BS_FullBody,AnimName="spit_attack")))
}