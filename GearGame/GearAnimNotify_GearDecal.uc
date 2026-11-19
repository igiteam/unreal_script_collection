
/**
 * GearAnimNotify_GearDecal
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearAnimNotify_GearDecal extends AnimNotify
	native(Anim);

// Optimization
var() bool bIgnoreIfActorHidden;
/** If this effect should be considered extreme content **/
var() bool bIsExtremeContent;

/** BoneName or SocketName to use */
var() Name BoneOrSocketName;
/** Relative Location for Trace Direction */
var() Vector RelativeLocation;
/** Relative Rotation for Trace Direction */
var() Rotator RelativeRotation;
/** How far to trace in the specified direction */
var() float TraceDistance;
/** The material to use for the decal */
var() DecalData Decal;

/** List of parameters to set to random values between a min/max range */
var() Array<GearDecalParam> Params;
/** Arrow Component to visualize in editor */
var editoronly ArrowComponent MyArrowComponent;

cpptext
{
	// AnimNotify interface.
	virtual void Notify( class UAnimNodeSequence* NodeSeq );
	virtual FString GetEditorComment() { return TEXT("Decal"); }
}

event SpawnDecal(Actor Owner, vector TraceLocation, vector TraceDir)
{
	local Actor HitActor;
	local vector HitLocation, HitNormal;
	local TraceHitInfo HitInfo;
	local GearDecal GD;
	local GearDecalParam Param;

	// do not spawn extreme content if gore is disabled
	if ( bIsExtremeContent && Owner.WorldInfo.GRI.ShouldShowGore()==FALSE )
	{
		return;
	}

	HitActor = Owner.Trace(HitLocation, HitNormal, TraceLocation + TraceDir * TraceDistance, TraceLocation, false,, HitInfo);
	if( HitActor != None )
	{
		GD = CreateDecal(Owner, Decal, HitActor, HitLocation, HitNormal, HitInfo);
		// Set each artist param with a random value between the specified range
		foreach Params(Param)
		{
			GD.MITV_Decal.SetScalarParameterValue(Param.ParamName, RandRange(Param.Min,Param.Max));
		}
	}
}

/** helper for SpawnExplosionDecal() to perform the actual creation of the object */
simulated function GearDecal CreateDecal(Actor Owner, const out DecalData DecalData, Actor HitActor, vector HitLocation, vector HitNormal, const out TraceHitInfo HitInfo)
{
	local float RandomScale, Width, Height;
	local GearDecal GD;
	local bool bIsHorde, bIsSplitScreen;

	RandomScale = GetRangeValueByPct(DecalData.RandomScalingRange, FRand());
	Width = DecalData.Width * RandomScale;
	Height = DecalData.Height * RandomScale;

	// if horde or splitscreen then fade decals out instead of leaving them around for ever
	bIsHorde = Owner.WorldInfo.GRI.IsCoopMultiplayerGame();
	bIsSplitScreen = class'Engine'.static.IsSplitScreen();
	if( Owner.WorldInfo.MyDecalManager != None )
	{
		GD = GearDecalManager(Owner.WorldInfo.MyDecalManager).SpawnDecalMinimal(HitLocation, DecalData.LifeSpan);
	}
	if (GD != None)
	{
		GD.MITV_Decal.SetParent(DecalData.DecalMaterial);

		// @TODO:  pass in a struct with the decal params you want to use
		Owner.WorldInfo.MyDecalManager.SetDecalParameters(
			GD,
			GD.MITV_Decal,
			HitLocation,
			rotator(-HitNormal),
			bIsHorde ? (Width * 0.80) : Width,
			bIsHorde ? (Height * 0.80) : Height,
			Max(DecalData.Thickness, class'GearDecal'.default.MinExplosionThickness),
			!bIsHorde && !bIsSplitScreen && !DecalData.ClipDecalsUsingFastPath,
			(FRand() * 360.0),
			HitInfo.HitComponent,
			true,
			false,
			HitInfo.BoneName,
			INDEX_NONE,
			INDEX_NONE,
			INDEX_NONE,
			class'GearDecal'.default.DepthBias,
			DecalData.BlendRange
			);

		HitActor.AttachComponent(GD);
	}
	return GD;
}

defaultproperties
{
	bIgnoreIfActorHidden=TRUE
	TraceDistance=128.f

	// To visualize in editor
	Begin Object Class=ArrowComponent Name=ArrowComponent0
		bTreatAsASprite=True
		HiddenGame=true
	End Object
	MyArrowComponent=ArrowComponent0
}
