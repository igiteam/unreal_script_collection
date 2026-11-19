/**
 * AI to handle the Gunker being in close quarters battle
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearAI_GunkerCloseQuarters extends GearAI_Gunker;

/** Save off the initial location of the enemy being far melee'd */
var vector FarMeleeLocation;

/** @return the cached off initial location of the enemy being far melee'd */
function vector GetEnemyLocationForFarMelee()
{
	return FarMeleeLocation;
}

defaultproperties
{
	DefaultCommand=class'AICmd_Base_Gunker_CloseQuarters'
}