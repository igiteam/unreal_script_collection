/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearGRI_Lambent extends GearGRI_MP;

/** aggregate scores for all Lambent */
var int LambentKills, LambentDowns, LambentScore;

/** class of last Lambent killed in a round since we might not have the PRI anymore */
var class<GearPawn> FinalLambent;

replication
{
	if (bNetDirty)
		LambentKills, LambentDowns, LambentScore, FinalLambent;
}
