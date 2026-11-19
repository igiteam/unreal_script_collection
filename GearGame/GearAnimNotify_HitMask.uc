
/**
 * GearAnimNotify_GearDecal
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearAnimNotify_HitMask extends AnimNotify
	native(Anim);

// Optimization
var() bool bIgnoreIfActorHidden;

/** BoneName or SocketName to use */
var() Name BoneOrSocketName;
/** Relative Location for Trace Direction */
var() Vector RelativeLocation;
/** Relative Rotation for Trace Direction */
var() Rotator RelativeRotation;

/** How large you want the radius to be */
var() float HitRadius;
/** Index of Material that has 'GoreMirror' Texture Parameter. **/
var() int MaterialIndex;
/** Texture Size (width = height) **/
var() int TextureSize;

/** Fade Start Time Since Hit **/
var() float FadingStartTimeSinceHit;
/** Fading Duration **/
var() float FadingDurationTime;

cpptext
{
	// AnimNotify interface.
	virtual void Notify( class UAnimNodeSequence* NodeSeq );
	virtual FString GetEditorComment() { return TEXT("HitMask"); }
}

/** Init Gore hit mask material **/
event SceneCapture2DHitMaskComponent CreateGoreMaskTexture( Actor Owner, SkeletalMeshComponent Mesh)
{
	local SceneCapture2DHitMaskComponent HitMaskComponent;
	local MaterialInstanceConstant MIC;
	local TextureRenderTarget2D GoreMaskTexture;

	MIC = Mesh.CreateAndSetMaterialInstanceConstant(MaterialIndex);
	if ( MIC != none )
	{
		GoreMaskTexture = class'TextureRenderTarget2D'.static.Create(TextureSize, TextureSize, PF_G8, MakeLinearColor(0, 0, 0, 1));

		if ( GoreMaskTexture!=none )
		{
			// Set new texture as GoreMask parameter
			MIC.SetTextureParameterValue('GoreMask', GoreMaskTexture);

			HitMaskComponent = new(Owner) class'SceneCapture2DHitMaskComponent';
			HitMaskComponent.MaterialIndex = MaterialIndex;
			HitMaskComponent.FadingStartTimeSinceHit = FadingStartTimeSinceHit;
			HitMaskComponent.FadingDurationTime = FadingDurationTime;
			HitMaskComponent.FadingIntervalTime = FadingDurationTime/10.f;
			// Update HitMaskComponent with this texture
			HitMaskComponent.SetCaptureTargetTexture( GoreMaskTexture );

			Owner.AttachComponent(HitMaskComponent);
		}
		else
		{
			`log(self@": Could not create gore mask texture (size "@TextureSize@"");    
		}
	}
	else
	{
		`log(self@": Material Index ("@MaterialIndex@") not found");
	}

	return HitMaskComponent;
}

defaultproperties
{
	bIgnoreIfActorHidden=TRUE
	HitRadius = 10
	MaterialIndex = 0
	TextureSize = 64

	FadingStartTimeSinceHit = 10
	FadingDurationTime = 50
}
