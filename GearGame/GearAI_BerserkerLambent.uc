/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearAI_BerserkerLambent extends GearAI_BerserkerBase
	config(AI);

event NotifyEnemyHeard( Pawn HeardEnemy, Name NoiseType );

defaultproperties
{
	DefaultCommand=class'AICmd_Base_BerserkerLambent'
	bIsLambent=TRUE
}
