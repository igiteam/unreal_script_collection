//=============================================================================
// ForcedDirVolume
// used to force TMVehicles [of a certain class if wanted] in a certain direction
//
// Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
//=============================================================================

class ForcedDirVolume extends PhysicsVolume
	placeable
	native;

var() bool bAllowBackwards; // allows negative forces, thus trapping vehicles on a line instead of in a direction
var() class<TMVehicle> TypeToForce;
var() bool bIgnoreHoverboards;
var() const ArrowComponent Arrow;
var() bool bDenyExit; // if the vehicle is being effected by a force volume, the player cannot exit the vehicle.
var() bool bBlockPawns;
var() bool bBlockSpectators;
var vector ArrowDirection;
var array<TMVehicle> TouchingVehicles;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	if ( !bBlockSpectators && (BrushComponent != None) )
	{
		BrushComponent.SetTraceBlocking(false,true);
	}
}

event ActorEnteredVolume(Actor Other)
{
	if ( PlayerController(Other) != None )
	{
		Other.FellOutOfWorld(None);
	}
}

simulated event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	local TMVehicle V;

	Super.Touch(Other, OtherComp, HitLocation, HitNormal);

	V = TMVehicle(Other);
	if ((V != None) && ClassIsChildOf(V.Class, TypeToForce) && V.OnTouchForcedDirVolume(self))
	{
		TouchingVehicles.AddItem(V);
		if (bDenyExit)
		{
			V.bAllowedExit = false;
		}
	}
}

simulated event UnTouch(Actor Other)
{
	local bool bInAnotherVolume;
	local ForcedDirVolume AnotherVolume;

	if (ClassIsChildOf(Other.class, TypeToForce))
	{
		TouchingVehicles.RemoveItem(TMVehicle(Other));
		if (bDenyExit)
		{
			foreach Other.TouchingActors(class'ForcedDirVolume', AnotherVolume)
			{
				if (AnotherVolume.bDenyExit)
				{
					bInAnotherVolume = true;
					break;
				}
			}
			if (!bInAnotherVolume)
			{
				TMVehicle(Other).bAllowedExit = TMVehicle(Other).default.bAllowedExit;
			}
		}
	}
}

simulated function bool StopsProjectile(Projectile P)
{
	return false;
}

