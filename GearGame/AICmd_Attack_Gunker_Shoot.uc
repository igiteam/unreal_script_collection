/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Attack_Gunker_Shoot extends AICommand_SpecialMove
	within GearAI;


/** Takes place of InitCommand because we need to know who to shoot */
static function bool InitShootCommand(GameAIController AI, Actor TargetToAttack)
{
	local AICmd_Attack_Gunker_Shoot Cmd;
	local GearAI_Gunker GAI;
	local GearPawn_LocustGunkerBase GunkerPawn;

	GAI = GearAI_Gunker(AI);
	if (GAI != None &&
		TargetToAttack != None)
	{
		Cmd = new(GAI) class'AICmd_Attack_Gunker_Shoot';
		if (Cmd != None)
		{
			GunkerPawn = GearPawn_LocustGunkerBase(AI.Pawn);
			if( GunkerPawn != None )
			{
				GunkerPawn.GunkTarget = TargetToAttack;
				GAI.PushCommand(Cmd);
				return TRUE;
			}			
		}
	}

	return FALSE;
}


/** Overloaded to go to the special move state */
function Pushed()
{
	Super.Pushed();
	InvalidateCover();
	SetFocalPoint(FireTarget.Location);
	SetDesiredRotation(Rotator(FireTarget.Location - Pawn.Location));
	bWantsLedgeCheck = TRUE;
	GotoState( 'Command_SpecialMove' );
}

function Popped()
{
	local GearPawn_LocustGunkerBase GunkerPawn;

	Super.Popped();
	bWantsLedgeCheck = FALSE;
	// Allow normal rotation again
	if (Pawn != None)
	{
		Pawn.LockDesiredRotation(FALSE);
	}

	// clear shoot target, so that head can go back to original 
	GunkerPawn = GearPawn_LocustGunkerBase(Pawn);
	if (GunkerPawn != None)
	{
		GunkerPawn.GunkTarget = None;
	}
}

state Command_SpecialMove
{
	function ESpecialMove GetSpecialMove()
	{
		return GSM_Gunker_Shoot;
	}

	function bool ShouldFinishRotation() { return TRUE; }
}

defaultproperties
{
}