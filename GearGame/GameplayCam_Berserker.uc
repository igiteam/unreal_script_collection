/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GameplayCam_Berserker extends GearGameplayCameraMode
	config(Camera);

/** The depth of field to use for this camera mode */
var(DepthOfField) float DepthOfField;

/** Gives mode a chance to adjust/override postprocess as desired. */
simulated function UpdatePostProcess(const out TViewTarget VT, float DeltaTime)
{
	bDOFUpdated = bAdjustDOF;
}

simulated function ModifyPostProcessSettings(out PostProcessSettings PP)
{
	if (bDOFUpdated)
	{
		PP.bEnableDOF = TRUE;
		PP.DOF_FalloffExponent = DOF_FalloffExponent;
		PP.DOF_BlurKernelSize = DOF_BlurKernelSize;
		PP.DOF_MaxNearBlurAmount = DOF_MaxNearBlurAmount;
		PP.DOF_FocusType = FOCUS_Distance;
		PP.DOF_FocusDistance = DepthOfField;
		PP.DOF_FocusInnerRadius = DOF_FocusInnerRadius;
		PP.DOF_MaxFarBlurAmount = DOF_MaxFarBlurAmount;

		bDOFUpdated = FALSE;
	}
}

defaultproperties
{
	WorstLocOffset=(X=-8,Y=25,Z=150)
	bValidateWorstLoc=FALSE

	ViewOffset={(
		OffsetHigh=(X=-250,Y=100,Z=100),
		OffsetLow=(X=-100,Y=48,Z=56),
		OffsetMid=(X=-250,Y=70,Z=16),
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

	bUsePerAxisOriginLocInterp=true
	PerAxisOriginLocInterpSpeed=(X=5.f,Y=20.f,Z=20.f)

	PerPawnViewOffsetAdjustments.Empty

	BlendTime=0.25

	bAdjustDOF=true
	DepthOfField=512
	DOF_BlurKernelSize=20
	DOF_FalloffExponent=1
	DOF_FocusInnerRadius=1200
	DOF_MaxNearBlurAmount=1
	DOF_MaxFarBlurAmount=1
}
