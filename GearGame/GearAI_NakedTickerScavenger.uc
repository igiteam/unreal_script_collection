/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearAI_NakedTickerScavenger extends GearAI_NakedTicker
	config(AI);

function bool CanEngageMelee()
{
	return false;
}

defaultproperties
{
	DefaultCommand=class'AICmd_Base_NakedTickerScavenger'

	bCanEatPickupFactory=true

	DefaultReactConditions.Empty
	DefaultReactConditions.Add(ExecutEnemyReaction0)
	DefaultReactConditions.Add(HideFromNewEnemy0)
	DefaultReactConditions.Add(NewEnemy0)
}
