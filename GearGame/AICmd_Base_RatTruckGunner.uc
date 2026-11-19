/**
 * Base class for behavior of Gunners mounted to the Rat Truck
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class AICmd_Base_RatTruckGunner extends AICmd_Base_MountedGunner;

/** Simple constructor that pushes a new instance of the command for the AI */
static function bool InitCommand( GameAIController GameAI )
{
	local AICmd_Base_RatTruckGunner Cmd;
	local GearAI AI;

	AI = GearAI(GameAI);
	if (AI != None)
	{
		Cmd = new(AI) class'AICmd_Base_RatTruckGunner';
		if (Cmd != None)
		{
			Cmd.Mount = Pawn(AI.MyGearPawn.Base);
			AI.PushCommand(Cmd);
			return true;
		}
	}
	return false;
}

/** Throws out targets that are behind the Rat Truck */
function AdjustEnemyRating(out float out_Rating, Pawn EnemyPawn)
{
	local vector FireDir2D;

	if (CachedGearChildCommand != None)
	{
		CachedGearChildCommand.AdjustEnemyRating(out_Rating, EnemyPawn);
	}
	else if (out_Rating > 0.0)
	{
		FireDir2D = EnemyPawn.Location - Pawn.Location;
		FireDir2D.Z = 0.0;

		// Check if the target is within the yaw limits of GSM_RidingRatTruck
		if (GSM_RidingRatTruck(MyGearPawn.SpecialMoves[SM_RidingRatTruck]) != None &&
			Normal(FireDir2D) dot vector(Mount.Rotation) < Cos(GSM_RidingRatTruck(MyGearPawn.SpecialMoves[SM_RidingRatTruck]).MaxYawRotation * UnrRotToRad))
		{
			//debug
			`AILog("- can't fire at (facing wrong way):" @ EnemyPawn, 'Enemy');
			out_Rating = -1.0;
		}
	}

	Super.AdjustEnemyRating(out_Rating, EnemyPawn);
}

defaultproperties
{
}
