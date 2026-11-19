/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Base_CoverAI_vsTempest extends AICmd_Base_CoverAI
	within GearAI_Cover;


/** Overloaded so the AI only attacks the Tempest when it makes sense to (when vulnerable) */
function AdjustEnemyRating(out float out_Rating, Pawn EnemyPawn)
{
	local GearPawn_LocustTempestBase Tempest;

	// If this is the Tempest
	Tempest = GearPawn_LocustTempestBase(EnemyPawn);
	if (Tempest != None)
	{
		// If we're turtling (Tempest tells us to do this when the beam is near us!)
		if (bTurtle)
		{
			// Make the Tempest our enemy so they take cover away from it
			out_Rating = 9999;
		}
		else
		{
			// Return lowest priority if:
			// 1) the Tempest is available to take mouth (mouth component turned on)
			// 2) the Tempest is available to take back damage (bOnTower)
			if (Tempest.bOnTower ||
				(Tempest.MouthComp != None && Tempest.MouthComp.CollideActors))
			{
				out_Rating = 0;
			}
			// Else ignore the Tempest as an enemy!
			else
			{
				out_Rating = -1;
			}
		}

		return;
	}

	Super.AdjustEnemyRating(out_Rating, EnemyPawn);
}

defaultproperties
{
}
