/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
/**
 * This is a content only archetype object to allow artists to update weapon tracers
 * content without programmer intervention
 */
class GearTracerEffect extends Object
	editinlinenew
	hidecategories(Object);

/** projectile initial speed */
var() const float Speed;
/** projectile maximum speed */
var() const float MaxSpeed;
/** projectile rate of acceleration */
var() const float AccelRate;
/** visual mesh */
var() const StaticMesh Mesh;
/** base DrawScale3D applied to the mesh component */
var() const vector BaseDrawScale3D;
/** DrawScale3D applied instead of BaseDrawScale3D if the tracer is owned by the local player (ignored if zero) */
var() const vector LocallyOwnedDrawScale3D;
/** The particle system to attach to the projectile */
var() const ParticleSystem ParticleSystemTemplate;
/** The particle system to attach to the projectile if the tracer is owned by the local player */
var() const ParticleSystem LocallyOwnedParticleSystemTemplate;
/** The name of the vector parameter to set with the end point value */
var() const name EndPointVectorParamName;
/** Whether the particle system should be attached to the projectile or not */
var() const bool bShouldAttachToProjectile;
/** The amount of time the particle system should stay alive */
var() const float ParticleKeepAliveTime;
/** The percentage of the time that a smoke trail is spawned. 1.0 is 100%, 0.0 is 0% */
var() const float SmokeTrailFrequency;

defaultproperties
{
	BaseDrawScale3D=(X=1.0,Y=1.0,Z=1.0)
	ParticleKeepAliveTime=2.5
	SmokeTrailFrequency=0.5f
}
