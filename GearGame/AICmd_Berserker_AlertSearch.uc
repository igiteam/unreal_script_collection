/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Berserker_AlertSearch extends AICmd_Base_UtilitySelectedCmd;


/**
 * this function will be called to evaluate whether or not this command should be activated 
 * @param ActivationData - the meta data packet for this command activation history, etc..
 * @return - float indicating the utility value of activation this action right now (-1 means not suitable to activate)
 */
static function float EvaluateActivation(GearAI AI, UtilBasedAICmdMetaDataPacket ActivationData)
{
	// If the berserker knows of an enemy, have her search for it
	if (AI.Enemy != None)
	{
		// Must return less than 1.0f in case the kamikaze wants to activate
		return 0.8f;
	}

	return -1.0f;
}

/** Overloaded to go to the state for searching */
function Pushed()
{
	Super.Pushed();
	GotoState('DoSearch');
}

/** State used for searching for the berserker's enemy */
state DoSearch
{
	function AbortSearch()
	{
		AbortCommand(None, class'AICmd_Berserker_AlertSearch');
	}

Begin:
	FireTarget = None;

	// Play the special move for being alert
	if (MyGearPawn != None)
	{
		MyGearPawn.DoSpecialMove(SM_Berserker_Alert, true);
	}

	// Push the move command and have her move toward the enemy (but quit after a few seconds to allow the system to potentially find a better action)
	SetTimer(3.0f, false, nameof(AbortSearch), self);
	class'AICmd_MoveToEnemy'.static.MoveToEnemy(Outer, TRUE, 512.0, 0.f);
	ClearTimer(nameof(AbortSearch), self);

	// Stop the alert special move
	if( MyGearPawn != None &&
		MyGearPawn.IsDoingSpecialMove(SM_Berserker_Alert) )
	{
		MyGearPawn.EndSpecialMove();
	}

	// End the command
	if( !class'GearAI_BerserkerBase'.static.ChargeLocationReachable(AIOwner, Enemy.Location) )
	{
		Sleep(1.0f);
	}

	CheckCombatTransition();
	PopCommand(self);
};