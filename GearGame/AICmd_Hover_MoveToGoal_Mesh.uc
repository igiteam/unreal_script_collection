/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Hover_MoveToGoal_Mesh extends GameAICmd_Hover_MoveToGoal_Mesh within GearAI;


function Pushed()
{
	bWasFiring = (bWeaponCanFire && bFire == 1);

	Super.Pushed();
}



defaultproperties
{

}
