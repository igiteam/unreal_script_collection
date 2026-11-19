/** 
 * 
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoDecalInfo extends Object
	native
	hidecategories(Object)
	editinlinenew;

// this should be promoted to GameFramework. 


/** This is the version for the blood info.  This is primary used to have nice ordered BloodDecals as they are indexed by enum value **/
var int Version;


struct native NanoDecalDatum
{
	/** This is left for the sake of editing, knowing which entry is which weapon */
	var() editconst ENanoDecalType Type;

	/** This holds the decal data for this blood decal type **/
	var() editinline array<DecalData> DecalData;
};

/** This contains all of the types of blood decals that we can place in the world **/
var() editinline array<NanoDecalDatum> DecalInfo;   



cpptext
{
	virtual void PostLoad();
}



defaultproperties
{
	Version=4


	DecalInfo(NDTT_Blood_GenericSplat)=(Type=NDTT_Blood_GenericSplat)
	DecalInfo(NDTT_ExitWoundSplatter)=(Type=NDTT_ExitWoundSplatter)
	DecalInfo(NDTT_GibExplode_Ceiling)=(Type=NDTT_GibExplode_Ceiling)
	DecalInfo(NDTT_GibExplode_Ground)=(Type=NDTT_GibExplode_Ground)
	DecalInfo(NDTT_GibExplode_Ground_SmallSplat)=(Type=NDTT_GibExplode_Ground_SmallSplat)
	DecalInfo(NDTT_GibExplode_Wall)=(Type=NDTT_GibExplode_Wall)
	DecalInfo(NDTT_GibImpact)=(Type=NDTT_GibImpact)
	DecalInfo(NDTT_GibTrail)=(Type=NDTT_GibTrail)
	DecalInfo(NDTT_HitByBulletSmallSplat)=(Type=NDTT_HitByBulletSmallSplat)
	DecalInfo(NDTT_LimbBreak)=(Type=NDTT_LimbBreak)
	DecalInfo(NDTT_NeckSpurt)=(Type=NDTT_NeckSpurt)
	DecalInfo(NDTT_PawnIsReallyHurtSmallSplat)=(Type=NDTT_PawnIsReallyHurtSmallSplat)
	// specialized for nano
	DecalInfo(NDTT_SwordSlice)=(Type=NDTT_SwordSlice)
	DecalInfo(NDTT_SwordSliceBloodDrops)=(Type=NDTT_SwordSliceBloodDrops)
	DecalInfo(NDTT_SwordSliceBloodSprayBackSplash)=(Type=NDTT_SwordSliceBloodSprayBackSplash)
	DecalInfo(NDTT_SwordSliceBloodSprayLanding)=(Type=NDTT_SwordSliceBloodSprayLanding)
	DecalInfo(NDTT_BloodPool)=(Type=NDTT_BloodPool)
}



