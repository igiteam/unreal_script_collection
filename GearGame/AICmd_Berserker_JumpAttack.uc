/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Berserker_JumpAttack extends AICmd_Base_UtilitySelectedCmd;


/**
 * this function will be called to evaluate whether or not this command should be activated 
 * @param ActivationData - the meta data packet for this command activation history, etc..
 * @return - float indicating the utility value of activation this action right now (-1 means not suitable to activate)
 */
static function float EvaluateActivation(GearAI AI, UtilBasedAICmdMetaDataPacket ActivationData)
{
	local GearPawn_LocustBerserkerLambentBase BerserkerPawn;
	local GearAI_BerserkerLambent BerserkerAI;

	BerserkerAI = GearAI_BerserkerLambent(AI);
	if (BerserkerAI != None)
	{
		// If the berserker knows of an enemy, and she is lambent
		if (BerserkerAI.Enemy != None)
		{
			BerserkerPawn = GearPawn_LocustBerserkerLambentBase(BerserkerAI.Pawn);
			if (BerserkerPawn != None &&
				BerserkerPawn.IsReadyForJumpAttack() &&
				BerserkerPawn.PrepareForJumpAttack(BerserkerAI.bForceJumpAttack))
			{
				// Must return less than 1.0f in case the kamikaze wants to activate
				return (BerserkerAI.bForceJumpAttack ? 2.0f : 0.95f);
			}
		}

		// Unforce the jump
		BerserkerAI.bForceJumpAttack = false;
	}

	return -1.0f;
}

/** Overloaded to go to the state for searching */
function Pushed()
{
	Super.Pushed();

	Focus = None;
	SetFocalPoint(Enemy.Location);
	StopFiring();

	// Tell Pawn in which direction we'd like to launch our attack
	Pawn.SetDesiredRotation(rotator(Enemy.Location - Pawn.Location));
	Pawn.SetAnchor( None );

	GotoState('DoJump');
}

/** State used for jumping after the berserker's enemy */
state DoJump
{
	function int GetSpecialMoveFlags()
	{
		local GearAI_BerserkerLambent BerserkerAI;

		BerserkerAI = GearAI_BerserkerLambent(AIOwner);
		if (BerserkerAI != None && BerserkerAI.bForceJumpAttack)
		{
			return 1;
		}
		return 0;
	}

Begin:
	// Have berserker rotate towards pawn first, then jump.
	FinishRotation();

	// Play the special move for jumping
	if (MyGearPawn != None)
	{
		MyGearPawn.DoSpecialMove(SM_Berserker_Jump, true, None, GetSpecialMoveFlags());
	}

	// Stay in this command until the special move is finished
	while (MyGearPawn.IsDoingSpecialMove(SM_Berserker_Jump))
	{
		Sleep(0.1f);
	}

	// End the command
	CheckCombatTransition();
	PopCommand(self);
};