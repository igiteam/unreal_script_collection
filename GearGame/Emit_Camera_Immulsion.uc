/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class Emit_Camera_Immulsion extends Emit_CameraScorch
	config(Weapon);

defaultproperties
{
	PS_CameraEffect=ParticleSystem'LOC_Drudge.Effects.head.P_Drudge_Burn_Camera_FX'
	PS_CameraEffectNonExtremeContent=ParticleSystem'LOC_Drudge.Effects.head.P_Drudge_Burn_Camera_FX'
	FadeMaterial=Material'LOC_Drudge.Effects.Materials.M_Screen_Effect_new_burn_Lambent';
	FadeRampInTime=0.5
	StartFadeDelay=0.1
	CurFadeRate=1.7

	EmittersToTreatAsSame.Add(class'Emit_Camera_DrudgeVomit')
}



