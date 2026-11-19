/** 
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAbsorbOrb_Body extends NanoAbsorbOrb;


defaultproperties
{
	Begin Object Name=ParticleSystemComponent0
		Template=ParticleSystem'Nano_Power_FX.Effects.P_FX_NanoPower_Body_Suck_Single'
	End Object
	Components.Add(ParticleSystemComponent0)
	//ColorForOrb=(X=1.0f,Y=0,Z=0)

	Begin Object Name=InteractableComponent0
	    bAutoAcquireOnTouch=TRUE
	End Object

	bShouldMoveToPlayer=TRUE

}

