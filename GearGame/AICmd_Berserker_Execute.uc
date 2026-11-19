/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Berserker_Execute extends AIcmd_Base_UtilActionSelector
	within GearAI_BerserkerBase;


/** Pawn to execute */
var GearPawn PawnToExecute;

/**
 * this function will be called to evaluate whether or not this command should be activated 
 * @param ActivationData - the meta data packet for this command activation history, etc..
 * @return - float indicating the utility value of activation this action right now (-1 means not suitable to activate)
 */
static function float EvaluateActivation(GearAI AI, UtilBasedAICmdMetaDataPacket ActivationData)
{
	local GearPawn GP;

	GP = FindPawnToExecute(AI);
	if (GP != None)
	{
		return 2.0f;
	}

	return -1.0f;
}

/** Returns a pawn to execute if there is one */
static function GearPawn FindPawnToExecute(GearAI AI)
{
	local GearPawn P;

	// check for enemies to execute
	if (AI.bCanExecute && AI.Squad != None)
	{
		// first check the berserker's enemy
		P = GearPawn(AI.Enemy);
		if (P != None &&
			AI.CanExecutePawn(P) &&
			!AI.Squad.IsTryingToExecute(P))
		{
			return P;
		}

		// then check for any other DBNO players
		foreach AI.Squad.AllEnemies(class'GearPawn', P)
		{
			if (VSize(P.Location - AI.Pawn.Location) < AI.GetReviveOrExecuteInterruptDist() &&
				AI.CanExecutePawn(P) &&
				!AI.Squad.IsTryingToExecute(P))
			{
				return P;
			}
		}
	}

	return none;
}

/** Overloaded to go to the state we need it in */
function Pushed()
{
	Super.Pushed();

	PawnToExecute = FindPawnToExecute(Outer);
	GotoState('Execute');
}

auto state Execute
{
Begin:
	// Make sure there is a pawn to execute
	if (PawnToExecute != None )
	{
		class'AICmd_Execute'.static.Execute(Outer, PawnToExecute);
	}

	PopCommand(self);
}
