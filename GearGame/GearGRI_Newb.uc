/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearGRI_Newb extends GearGRI_MP;

/** number of kills required to win the round */
var int GoalKills;

replication
{
	if (bNetInitial)
		GoalKills;
}
