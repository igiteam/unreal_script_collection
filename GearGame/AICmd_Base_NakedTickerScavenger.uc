/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class AICmd_Base_NakedTickerScavenger extends AICmd_Base_NakedTicker
	within GearAI_NakedTicker;

function Pushed()
{
	Super.Pushed();
	GotoState('InCombat');
}

state InCombat
{
Begin:

	if( !GearPawn_LocustNakedTickerBase(MyGearPawn).bEatenPickup && !Outer.bSeekingPickup )
	{
		//`log("--- SeekNearbyPickup  Focus:"@Focus@"  Focal Point:"@GetFocalPoint()@"  SearchTarget:"@SearchTarget@"  FireTarget:"@FireTarget);
		SeekNearbyPickup();
	}

	if( Enemy != None && GearPawn_LocustNakedTickerBase(MyGearPawn).bEatenPickup )
	{
		//`log("--- MoveAwayFromEnemy  Focus:"@Focus@"  Focal Point:"@GetFocalPoint()@"  SearchTarget:"@SearchTarget@"  FireTarget:"@FireTarget);
		MoveAwayFromEnemy();
		Sleep(RandRange(MinWait,MaxWait));
	}
	else
	{
		//`log("--- NewCoverSpot  Focus:"@Focus@"  Focal Point:"@GetFocalPoint()@"  SearchTarget:"@SearchTarget@"  FireTarget:"@FireTarget);
		NewCoverSpot();
		FinishRotation();
		Sleep(RandRange(MinWait, MaxWait));
	}

	Goto('Begin');
}

defaultproperties
{
	MinWait=1.0
	MaxWait=3.5

	Begin Object Name=CovGoal_MovDist0
		BestCoverDist=1024.0f
		MinCoverDist=512.0f
		MaxCoverDist=4096.0f
	End object
}
