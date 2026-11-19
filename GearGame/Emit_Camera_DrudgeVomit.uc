/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class Emit_Camera_DrudgeVomit extends Emit_Camera_Immulsion
	config(Weapon);


defaultproperties
{
	// JF: not using this emitter at the moment, save the mem
//	PS_CameraEffect=ParticleSystem'LOC_Drudge.Effects.P_Camera_FX_Drudge_Puke'
	FadeRampInTime=0.2
	StartFadeDelay=1.5
	EmittersToTreatAsSame.Add(class'Emit_Camera_Immulsion')
}



