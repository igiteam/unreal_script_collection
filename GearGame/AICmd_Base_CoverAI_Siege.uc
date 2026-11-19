/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class AICmd_Base_CoverAI_Siege extends AICmd_Base_CoverAI
	within GearAI_SiegeCOG;

state InCombat
{
	function CheckForVehicle()
	{
		local GearGRI_Horde GRI;
		local GearFortification Fort;
		local bool bFoundFort;

		// also check for fortifications to activate
		if (bCanActivateFortifications)
		{
			GRI = GearGRI_Horde(WorldInfo.GRI);
			if (GRI != None)
			{
				foreach GRI.Fortifications(Fort)
				{
					if (Fort.ShouldBeUsedBy(Outer))
					{
						class'AICmd_ActivateFortification'.static.ActivateFortification(Outer, Fort);
						bFoundFort = true;
						break;
					}
				}
			}
		}

		if (!bFoundFort)
		{
			Super.CheckForVehicle();
		}
	}
Begin:
	if (ShouldReturnToBase())
	{
		bShouldRoadieRun = true;
		MoveToNearestCoverIdle();
	}
	// this will go to the label in the super class
	Goto('CheckDBNO');
}
