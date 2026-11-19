/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoPickup_SuperTick extends NanoPickup_Tick;

defaultproperties
{
	Amount=500
	PickUpName="SuperOrb Pickup"

	Begin Object Name=PowerEffectComp
		Template=ParticleSystem'MET_TechTick.Effects.P_MET_TechTick_PowerEffect_Blue'
	End Object

	Begin Object Name=PlumeMeshComp
		StaticMesh=StaticMesh'Nano_Proto_CTF.Meshes.S_GatherOrbPlume_Blue'
	End Object
}

