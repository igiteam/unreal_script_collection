/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoCollectable_NanoSmallAmount extends NanoCollectableBase
	notplaceable;





defaultproperties
{
	Begin Object Name=InteractableComponent0
		AbsorbTime=0.5f
	End Object

	Begin Object Name=ParticleSystemComponent0
	    Template=ParticleSystem'Nano_Power_FX.Effects.P_FX_NanoPower_NanoCollectible_01'
	End Object

	//ColorForOrb=(X=0.784,Y=0.909,Z=0.666)
	// divided in half ColorForOrb=(X=0.372,Y=0.454,Z=0.333)
}