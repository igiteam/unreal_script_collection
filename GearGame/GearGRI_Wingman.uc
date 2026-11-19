/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearGRI_Wingman extends GearGRI_MP;


/** Whether the game must go another round because two or more teams are tied after reaching the goal score */
var repnotify bool bOverTime;


replication
{
 	if (bNetDirty)
 		bOverTime;
}


simulated event ReplicatedEvent( name VarName )
{
	local GearPC PC;

	switch (VarName)
	{
		case 'bOverTime':
			if (bOverTime)
			{
				foreach LocalPlayerControllers(class'GearPC',PC)
				{
					if (PC.MyGearHud != None)
					{
						PC.MyGearHud.DrawOverTime();
					}
				}
			}
			break;
		default:
			Super.ReplicatedEvent(VarName);
			break;
	}
}