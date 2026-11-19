/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearAnimNotify_PlayParticleEffect extends AnimNotify_PlayParticleEffect
	native(Anim);

/** 
 *	The Particle system to play for Lambent pawns. 
 *	All others will play the PSTemplate value.
 */
var() ParticleSystem PSTemplate_Lambent;

/** Set this to true to preview the lambent effect in the animset viewer */
var() editoronly bool bPreviewLambent;

cpptext
{
	// AnimNotify interface.
	virtual void Notify( class UAnimNodeSequence* NodeSeq );
}

defaultproperties
{
}

