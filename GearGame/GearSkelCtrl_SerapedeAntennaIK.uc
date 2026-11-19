
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearSkelCtrl_SerapedeAntennaIK extends SkelControlLimb
	native(Anim);

/** Trace start point **/
var() name StarTraceBoneName;

/** If this has active hit now **/
/** This hit is forward hit. If you have forward hit, it will set this flag, so that in serapede, it can widen the angle of antenna
 *  if this hits on the side, this flag won't be set. **/
var transient bool bHaveHit;
var transient float LastUpdateTime;

cpptext
{
	virtual void CalculateNewBoneTransforms(INT BoneIndex, USkeletalMeshComponent* SkelComp, TArray<FBoneAtom>& OutBoneTransforms);
}

defaultproperties
{
}