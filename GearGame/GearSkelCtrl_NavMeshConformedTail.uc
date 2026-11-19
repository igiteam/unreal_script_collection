/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 * conforms a specified tail of bones to the world, and drags it behind the root (head) like a tail
 */
class GearSkelCtrl_NavMeshConformedTail extends SkelControlBase
	native(Anim);

struct native TailBoneDatum
{
	var() Name  BoneName;
	var() EAxis ForwardAxis;
	var() bool  bForwardInverted;
	var() EAxis UpAxis;
	var() bool  bUpInverted;
	var() bool  bDontAdjustThisBoneWhenMagicToggleIsOn;
};

/** ordered list of bones to be adjusted NOTE: assumes bone hierarchy is inverted, (e.g. head is at bottom of skeleton, tail is near root) */
var() editfixedsize array<TailBoneDatum> TailBones;

/** used to determine the height offsets for mesh conform raycasts */
var() float DownCheckOffset;

/** extent used for conform checks */
var() vector DownExtent;

/** speed at which to interpolate to new heights for tail positions (UU/sec) */
var() float HeightInterpSpeed;

/** the offset to enforce from the root to bone0 in the tailbones */
var vector RootBone0Offset;

/** whether or not to turn on debug drawing */
var() bool bDrawDebug;

/** when this is TRUE, bones marked with bDontAdjustThisBoneWhenMagicToggleIsOn=true will not be adjusted */
var() bool bOnlyAdjustSomeBones;

/** For ground position, use hit location rather than using desired offset position **/
var() bool bUseHitLocation;

/** Invert root up for hit check **/
var() bool bRootUpInverted;

struct native TailBonePosInfo
{
	var vector Pos;
	var vector Norm;
};

/** positions in world space of the tail bones (updated from TickSkelControl) */
var  transient array<TailBonePosInfo> TailBonePositions;

/** offsets of the reference mesh between the bones in the tail mesh */
var  transient array<float>  TailBaseOffsets;
/** list of bone indexes grabbed from TailBones array */
var  transient array<INT>    CachedBoneIndexes;

/** when you hit and clipping through geometry, apply this impulse to push away - this is right now arbitrary **/
var float   ClipAvoidanceImpulse;

/** TRUE if any segment is around obstacle mesh **/
var transient  bool AroundObstacleMesh;

cpptext
{
	// USkelControlBase interface
	virtual void TickSkelControl(FLOAT DeltaSeconds, USkeletalMeshComponent* SkelComp);
	virtual void GetAffectedBones(INT BoneIndex, USkeletalMeshComponent* SkelComp, TArray<INT>& OutBoneIndices);
	virtual void CalculateNewBoneTransforms(INT BoneIndex, USkeletalMeshComponent* SkelComp, TArray<FBoneAtom>& OutBoneTransforms);	
	
	// determine the proper positions for the tail bones
	void UpdateTailPositions(FLOAT dt,USkeletalMeshComponent* SkelComp);
	// get hit info from desired pos to -upoffset and return hit loc and hit norm
	UBOOL GetDesiredHitInfo( const FVector & DesiredPos, const FVector & Up, const FVector & Dir, FVector & HitLoc, FVector & HitNorm, UBOOL & bAroundObstacles);
	// adjust desired hit info to not overlap with its segment (later segment)
	// this means it's one frame delay - use previous frame info to calculate new one. 
	FVector AdjustDesiredHitInfo( const FVector & DesiredPos, const INT CurrentIndex );
}

defaultproperties
{
	bIgnoreWhenNotRendered=FALSE
	DownCheckOffset=75.0
	DownExtent=(X=5,Y=5,Z=10)
	HeightInterpSpeed=100
	ClipAvoidanceImpulse = 10
}
