/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Hover_MoveToGoal extends GameAICmd_Hover_MoveToGoal within GearAI;


function Pushed()
{
	bWasFiring = (bWeaponCanFire && bFire == 1);

	Super.Pushed();
}


/** Allows subclasses to determine if our enemy is based on an interp actor or not **/
function bool IsEnemyBasedOnInterpActor( Pawn InEnemy )
{
	if( GearInterActorAttachableBase(InEnemy.Base) != None )
	{
		return TRUE;
	}

	return FALSE;
}



defaultproperties
{
	SubGoalReachDist=768.f
}
