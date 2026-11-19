/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
class HDProj_35mmGrenadelauncher extends HDBaseProjectile
	native(HDWeapon);

simulated function PostBeginPlay()
{
	// force ambient sound if not vehicle game mode
	bImportantAmbientSound = !WorldInfo.bDropDetail;
	Super.PostBeginPlay();
}

