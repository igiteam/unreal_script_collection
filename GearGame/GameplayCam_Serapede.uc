/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GameplayCam_Serapede extends GearGameplayCameraMode
	config(Camera)
	native(Camera);

var name OriginBoneName;

cpptext
{
	/**
	* Returns location and rotation, in world space, of the camera's basis point.  The camera will rotate
	* around this point, offsets are applied from here, etc.
	*/
	virtual void GetCameraOrigin(class APawn* TargetPawn, FVector& OriginLoc, FRotator& OriginRot);

	UBOOL ShouldIgnorePenetrationHit(FCheckResult const* Hit, APawn* TargetPawn) const;
}

/**
 * Worst location needs to base off the origin bone
 * 
 * @param TargetPawn - the serapede that we're viewing
 * 
 * @return the worst location coordinates in world space
 */
simulated event vector GetCameraWorstCaseLoc(Pawn TargetPawn, TViewTarget CurrentViewTarget)
{
	local vector OriginBoneLoc;

	OriginBoneLoc = TargetPawn.Mesh.GetBoneLocation(OriginBoneName);

	return OriginBoneLoc + (WorstLocOffset >> TargetPawn.Rotation);
}

defaultproperties
{
	WorstLocOffset=(X=-25,Y=0,Z=47)
	bValidateWorstLoc=FALSE

	// smooth out steering slightly
	bInterpRotation=true
	OriginRotInterpSpeed=12.f
	OriginLocInterpSpeed=8

	ViewOffset={(
		OffsetHigh=(X=-100,Y=0,Z=65),
		OffsetLow=(X=-50,Y=0,Z=200),
		OffsetMid=(X=-100,Y=0,Z=65),
		)}
	ViewOffset_ViewportAdjustments(CVT_16to9_HorizSplit)={(
		OffsetHigh=(X=0,Y=0,Z=-12),
		OffsetLow=(X=0,Y=0,Z=-12),
		OffsetMid=(X=0,Y=0,Z=-12),
		)}
	ViewOffset_ViewportAdjustments(CVT_16to9_VertSplit)={(
		OffsetHigh=(X=0,Y=-20,Z=0),
		OffsetLow=(X=0,Y=-20,Z=0),
		OffsetMid=(X=0,Y=-20,Z=0),
		)}
	ViewOffset_ViewportAdjustments(CVT_4to3_Full)={(
		OffsetHigh=(X=0,Y=0,Z=17),
		OffsetLow=(X=0,Y=0,Z=17),
		OffsetMid=(X=0,Y=0,Z=17),
		)}
	ViewOffset_ViewportAdjustments(CVT_4to3_HorizSplit)={(
		OffsetHigh=(X=0,Y=0,Z=-15),
		OffsetLow=(X=0,Y=0,Z=-15),
		OffsetMid=(X=0,Y=0,Z=-15),
		)}
	ViewOffset_ViewportAdjustments(CVT_4to3_VertSplit)={(
		OffsetHigh=(X=0,Y=0,Z=0),
		OffsetLow=(X=0,Y=0,Z=0),
		OffsetMid=(X=0,Y=0,Z=0),
		)}

	PerPawnViewOffsetAdjustments.Empty

	BlendTime=0.3

	OriginBoneName=Segment_headoffset
	//OriginBoneName=Teeth_UpperMid
}
