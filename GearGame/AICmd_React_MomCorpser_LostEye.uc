/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_React_MomCorpser_LostEye extends AICommand_SpecialMove
	within GearAI_MomCorpser;

/** Whether the do the telegraph or not */
var bool bDoTelegraph;

/** Takes place of InitCommand because we need to know the location of the enemy who shot the eye */
static function bool InitLostEyeCommand(GameAIController AI, vector PawnShotLocation, optional bool bSuppressTelegraph)
{
	local AICmd_React_MomCorpser_LostEye Cmd;
	local GearAI_MomCorpser GAI;

	GAI = GearAI_MomCorpser(AI);
	if (GAI != None)
	{
		GAI.bSuppressNextChargeTelegraph = bSuppressTelegraph;
		GAI.EnemyWhoShotEyeLocation = PawnShotLocation;
		Cmd = new(GAI) class'AICmd_React_MomCorpser_LostEye';
		if (Cmd != None)
		{
			GAI.PushCommand(Cmd);
			return TRUE;
		}
	}

	return FALSE;
}

/** Overloaded to go to the special move state */
function Pushed()
{
	Super.Pushed();

	Corpser.UpdateLeftEyeStatus( TRUE, TRUE );
	Corpser.UpdateLeftMidEyeStatus( TRUE, TRUE );
	Corpser.UpdateRightEyeStatus( TRUE, TRUE );
	Corpser.UpdateRightMidEyeStatus( TRUE, TRUE );
	Corpser.StopStabAttack();
	Corpser.SetAvoidanceCylActive( FALSE );

	GotoState('Mad');
}

function Popped()
{
	Super.Popped();

	Corpser.UpdateLeftEyeStatus();
	Corpser.UpdateLeftMidEyeStatus();
	Corpser.UpdateRightEyeStatus();
	Corpser.UpdateRightMidEyeStatus();
}

state Mad
{
Begin:
	`AILog( "BEGIN TAG"@GetStateName(), 'State' );

	class'AICmd_Attack_MomCorpser_Charge'.static.InitCommand(Outer);
	Status = 'Success';
	PopCommand(self);
}

defaultproperties
{
}