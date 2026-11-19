/**
 * Used by GearDestructibleObject to setup cheap defaults.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 **/

class GDOStaticMeshComponent extends StaticMeshComponent
	native;

defaultproperties
{
	bAllowApproximateOcclusion=TRUE
	bForceDirectLightMap=TRUE
	bUsePrecomputedShadows=TRUE
	LightingChannels=(BSP=FALSE,Static=TRUE,Dynamic=FALSE,bInitialized=TRUE)
}


