/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoDecal_DropPodLandingZone extends DecalActorMovable;

defaultproperties
{
	Begin Object Name=NewDecalComponent
		DecalMaterial=MaterialInstance'Nano_WeaponFX.Missile.Materials.M_Missile_IncomingReticle_INST'
		FarPlane=1024.f
		Width=512.f
		Height=512.f
	End Object

	bCollideActors=FALSE
	bNoDelete=FALSE
}