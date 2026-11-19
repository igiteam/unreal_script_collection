
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_LambentDrudge_RegenTentacles extends GSM_BasePlaySingleAnim;

var transient bool bRightTentacle;
var BodyStance BS_RightTentacle, BS_LeftTentacle;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local GearPawn_LambentDroneMutatable Drudge;
	Drudge = GearPawn_LambentDroneMutatable(PawnOwner);
	bRightTentacle = (PawnOwner.SpecialMoveFlags == 1);
	
	if (bRightTentacle)
	{
		BS_Animation = BS_RightTentacle;
		Drudge.Mesh.UnHideBoneByName( Drudge.RightTentacleBone );
	}
	else
	{
		BS_Animation = BS_LeftTentacle;
		Drudge.Mesh.UnHideBoneByName( Drudge.LeftTentacleBone );
	}

	Super.SpecialMoveStarted(bForced, PrevMove);
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	local GearPawn_LambentDroneMutatable Drudge;
	local GearAI_LambentDrudge DrudgeAI;

	Drudge = GearPawn_LambentDroneMutatable(PawnOwner);
	DrudgeAI = GearAI_LambentDrudge(PawnOwner.Controller);
	if ( Drudge!=none )
	{
		if (bRightTentacle)
		{
			Drudge.bRightTentacleArmDestroyed = FALSE;
			Drudge.RightTentacleHealth = Drudge.TentacleHealth;
			Drudge.bRightTentacleArmRegenerate = FALSE;
		}
		else
		{
			Drudge.bLeftTentacleArmDestroyed = FALSE;
			Drudge.LeftTentacleHealth = Drudge.TentacleHealth;
			Drudge.bRightTentacleArmRegenerate = FALSE;
		}

		DrudgeAI.ResumeAttack();
	}
}

defaultproperties
{
	BS_RightTentacle=(Stance=((Slot=BS_Std_Up,AnimName="tentacle_regen_right")))
	BS_LeftTentacle=(Stance=((Slot=BS_Std_Up,AnimName="tentacle_regen_left")))
	bLockPawnRotation=TRUE
}