
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_LambentDrudge_Spew extends GSM_BasePlaySingleAnim;

var BodyStance BS_SpewAttack, BS_SpewAttackTrunk;

protected function bool InternalCanDoSpecialMove()
{
	local GearPawn_LambentDroneMutatable DrudgePawn;

	DrudgePawn = GearPawn_LambentDroneMutatable(PawnOwner);
	if( DrudgePawn != None && DrudgePawn.Transforms[ETS_HEAD].Mutated )
	{
		return false;
	}
	return Super.InternalCanDoSpecialMove();
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local GearAI_LambentDrudge DrudgeAI;
	DrudgeAI = GearAI_LambentDrudge(PawnOwner.Controller);

	if (DrudgeAI != none)
	{
		// pause tentacle fire or any fire
		DrudgeAI.PauseAttack();
	}
 	
	Super.SpecialMoveStarted(bForced, PrevMove);
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	local GearAI_LambentDrudge DrudgeAI;
	DrudgeAI = GearAI_LambentDrudge(PawnOwner.Controller);

	if (DrudgeAI != none)
	{
		// resume tentacle fire or any fire
		DrudgeAI.ResumeAttack();
	}

	Super.SpecialMoveEnded(PrevMove, NextMove);
}   

function PlayAnimation()
{
 	local GearPawn_LambentDroneMutatable Drudge;
 
 	Drudge = GearPawn_LambentDroneMutatable(PawnOwner);
 
 	if ( Drudge!=none && Drudge.Transforms[ETS_LEGS].Mutated )
 	{
		BS_Animation = BS_SpewAttackTrunk;
 	}
	else
	{
		BS_Animation = BS_SpewAttack;
	}

	Super.PlayAnimation();
}

defaultproperties
{
	BS_SpewAttack=(Stance=((Slot=BS_FullBody,AnimName="spew_attack")))
	BS_SpewAttackTrunk=(Stance=((Slot=BS_FullBody,AnimName="spew_attack_trunk")))

	bLockPawnRotation=TRUE
}