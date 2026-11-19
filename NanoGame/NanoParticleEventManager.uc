/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoParticleEventManager extends ParticleEventManager
	native(Particle);

event HandleParticleModuleEventSendToGame( ParticleModuleEventSendToGame InEvent, const out vector InCollideDirection, const out vector InHitLocation, const out vector InHitNormal, const out name InBoneName )
{
	//`log( `showvar(InEvent) @ `showvar(InCollideDirection) @ `showvar(InHitLocation) @ `showvar(InHitNormal) @ `showvar(InBoneName) );
	InEvent.DoEvent( InCollideDirection, InHitLocation, InHitNormal, InBoneName );
}

defaultproperties
{
}