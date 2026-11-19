/** 
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoBombTarget_MetaCorpSatelliteDish extends NanoBombTarget;



/** This will return the struct that holds all of the values for this specific pawn **/
simulated function NanoCausingChaosValueDatum GetDeathChaosValue()
{
	return class'NanoCausingChaosValues'.default.BlowUpLowLevelTarget;
}


defaultproperties
{
	Begin Object Name=NanoPawnMesh
		SkeletalMesh=SkeletalMesh'COG_Mortar.Mesh.COG_Mortar_SK'
		PhysicsAsset=PhysicsAsset'COG_Mortar.Mesh.COG_Mortar_SK_Physics'
	End Object
}