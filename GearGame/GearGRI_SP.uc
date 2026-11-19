/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearGRI_SP extends GearGRI;

/** Chapter being played */
var int ChapterNum;

/** Whether players should draw the tower health during the tempest fight */
var bool bDrawTowerHealth;
/** Total amount of health the tower in the tempest fight has */
var int TotalTowerHealth;
/** Current amount of health the tower in the tempest fight has */
var int CurrTowerHealth;

replication
{
	if (bNetDirty)
		ChapterNum, bDrawTowerHealth, TotalTowerHealth, CurrTowerHealth;
}

defaultproperties
{
}
