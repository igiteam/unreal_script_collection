
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Wretch_DropFromCeiling extends GSM_BaseVariableFall;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced,PrevMove);

	PawnOwner.Mesh.RootMotionMode = RMM_Ignore;
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);

	PawnOwner.LastEvadeTime = PawnOwner.WorldInfo.TimeSeconds;
	PawnOwner.Mesh.RootMotionMode = PawnOwner.default.Mesh.RootMotionMode; 
}

simulated function PlayFall()
{
	local GearAI_Wretch AI;

	super.PlayFall();

	AI = GearAI_Wretch(PawnOwner.Controller);
	if( AI != None )
	{		
		AI.NotifyCeilingTransitionFall();
	}
}

defaultproperties
{
	BS_Jump=(Stance=((Slot=BS_FullBody,AnimName="Ceiling_Drop_Start")))
	BS_Fall=(Stance=((Slot=BS_FullBody,AnimName="ceiling_drop_fall")))
	BS_Land=(Stance=((Slot=BS_FullBody,AnimName="ceiling_drop_land")))

	PreImpactTime=0.35f

	JumpingPhysics=PHYS_None
}
