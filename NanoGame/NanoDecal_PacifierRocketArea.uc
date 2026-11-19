/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoDecal_PacifierRocketArea extends DecalActorMovable;

/** Location this actor started */
var Vector Origin;
/** Potential spread from target */
var Vector2d Spread;
/** Random offset from target location */
var Vector OffsetFromTarg;
/** Original distance from target */
var float DistFromTarget;
/** Target this decal is tracking toward */
var Actor Target;
/** Speed at which rate to accel toward target */
var float Speed;
/** Time it takes for decal to get to destination */
var float TimeToDest;

simulated function Init()
{
	Origin = Location;
	DistFromTarget = VSize(Target.Location-Location);
	OffsetFromTarg = VRand();
	OffsetFromTarg.Z = 0;
	OffsetFromTarg = Normal(OffsetFromTarg) * RandRange( Spread.X, Spread.Y );
	Speed = VSize(GetTrackingLocation()-Origin) * TimeToDest;
}

simulated function Vector GetTrackingLocation()
{
	local Vector TargLoc;
	local float Time, CollisionHeight, CollisionRadius;

	if( Target != none )
	{
		Target.GetBoundingCylinder(CollisionRadius, CollisionHeight);
		TargLoc = Target.Location + OffsetFromTarg;
		TargLoc.Z += 256.f;

		Time = DistFromTarget / class'NanoProj_Pacifier_Rocket'.default.Speed;
		TargLoc += (Target.Velocity*Time*0.5f);
	}

	return TargLoc;
}


simulated function Tick( float DeltaTime )
{
	local Vector TrackLoc;

	Super.Tick( DeltaTime );

	if( Physics != PHYS_None )
	{
		TrackLoc = GetTrackingLocation();
		if( VSize(TrackLoc-Location) < 32.f )
		{
			SetPhysics( PHYS_None );
//			SetBase( Target );
		}
		else
		{
			Velocity = Normal(TrackLoc-Location) * Speed;
		}
	}
}

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

	bIgnoreBaseRotation=TRUE
	Physics=PHYS_Projectile
	Spread=(X=256,Y=768)

}