/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class MomCorpser_Encroacher extends Actor
	native;

cpptext
{
	UBOOL ShouldTrace(UPrimitiveComponent* Primitive,AActor *SourceActor, DWORD TraceFlags)
	{
		return (SourceActor != NULL && SourceActor->GetAPawn());
	}

	virtual UBOOL IgnoreBlockingBy(const AActor *Other) const;
}

/** Index of the leg this encroacher is attached to */
// Used to apply timer to leg for duration that it is stuck in the ground
var int LegIdx;

defaultproperties
{
	Begin Object Class=CylinderComponent Name=CollisionCylinder
		CollisionRadius=120.000000
		CollisionHeight=120.000000
		BlockNonZeroExtent=TRUE
		BlockZeroExtent=FALSE
		BlockActors=TRUE
		CollideActors=TRUE
		Translation=(X=0,Y=0,Z=80)
	End Object
	CollisionComponent=CollisionCylinder
	Components.Add(CollisionCylinder)

	bCollideActors=TRUE
	bBlockActors=TRUE
	bCollideWorld=FALSE

	Physics=PHYS_None
}
