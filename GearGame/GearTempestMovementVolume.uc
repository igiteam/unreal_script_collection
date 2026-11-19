/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearTempestMovementVolume extends Volume
	native
	placeable;

cpptext
{
	UBOOL IgnoreBlockingBy( const AActor *Other ) const;
}

native function bool LineCheckAgainstVolume(vector End, vector Start, out vector Intersection, out vector Normal);

defaultproperties
{
	Begin Object Name=BrushComponent0
		CollideActors=false
		BlockActors=false
		BlockZeroExtent=false
		BlockNonZeroExtent=false
		BlockRigidBody=false
		bDisableAllRigidBody=false
		RBChannel=RBCC_Nothing
	End Object

	bWorldGeometry=false
	bCollideActors=false
	bBlockActors=false
}
