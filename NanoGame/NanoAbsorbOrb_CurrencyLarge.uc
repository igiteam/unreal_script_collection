/** 
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAbsorbOrb_CurrencyLarge extends NanoAbsorbOrb;


defaultproperties
{
	Begin Object Name=ParticleSystemComponent0
		Template=ParticleSystem'Nano_Power_FX.Effects.P_FX_NanoPower_MoneyOrb'
	End Object
	Components.Add(ParticleSystemComponent0)

	Begin Object Name=InteractableComponent0
	    bAutoAcquireOnTouch=TRUE
	End Object

	bShouldMoveToPlayer=TRUE
}

