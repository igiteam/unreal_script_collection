/** 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoInterpActor extends InterpActor
	native
	implements(NanoInterface_BoulderedInto, NanoInterface_Targetable);

/** Mesh to swap to if you boulder into this InterpActor hard enough */
var()   StaticMesh      BoulderIntoSwapMesh;

/** If BoulderIntoSwapMesh is not None, speed you must be moving to swap mesh */
var()	EDashPip	    BoulderSwapDashPip;

/** Sound to play when mesh is swapped */
var()   SoundCue        BoulderSwapSound;

/** If TRUE, this actor can be targeted */
var()   bool            bTargetable;

/** If TRUE, then this actor will be targetable at any distance */
var()   bool            bTargetableAtAnyDistance;

/** The base priority for targeting on this actor */
var() float Priority;

/** If TRUE, then the center of the mesh component will be used for the location of the actor, instead of the pivot point */
var() bool              bUseMeshCenterForTarget;

cpptext
{
	virtual FVector GetTargetLocation(AActor* RequestedBy, UBOOL bRequestAlternateLoc) const;
};

function OnToggle(SeqAct_Toggle inAction)
{
	if (inAction.InputLinks[0].bHasImpulse)
	{
		bTargetable = TRUE;
	}
	else if (inAction.InputLinks[1].bHasImpulse)
	{
		bTargetable = FALSE;
	}
	else
	{
		bTargetable = !bTargetable;
	}
}

////// NanoInterface_Targetable
simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	NanoGRI(WorldInfo.GRI).RegisterTargetableActor(self);
}

simulated function float GetBasePriority(NanoPC Askee, optional NanoPawn AskeePawn)
{
	return Priority;
}

simulated function bool IsTargetable( optional ETargetQueryType QT )
{
	return bTargetable;
}


/** Returns the Targetable Octree component */
simulated function TargetableOctreeComponent GetTargetableOctreeComponent()
{
	local TargetableOctreeComponent TargetableComp;

	foreach AllOwnedComponents( class'TargetableOctreeComponent', TargetableComp )
	{
		return TargetableComp;
	}

	return None;
}



simulated function bool ShouldRateTarget()
{
	 // if we have not seen this actor for 2 second then don't allow targeting of it
	return ((WorldInfo.TimeSeconds - LastRenderTime) < 2.0f);
}

simulated function bool ShouldIgnoreDistance()
{
	return bTargetableAtAnyDistance;
}

simulated event vector GetTargetedLocation()
{
	// use middle of mesh bounds
	return StaticMeshComponent.Bounds.Origin;
}

/** Rotation of the target.  Useful to see if they are facing some dir **/
simulated event rotator GetRotation()
{
	return Rotation;
}

/** How fast the target is currently moving **/
simulated event vector GetVelocity()
{
	return Velocity;
}

/** Pass in a struct and then have the interface fill in a ton of different firing targetable data **/
simulated function GetFiringTargetableDatum( out FiringTargetableDatum Out_FiringTargetableDatum );

simulated event BoxSphereBounds GetTargetableBounds()
{
	return StaticMeshComponent.Bounds;
}


simulated function NotifyImpaledBySword( NanoProj_ThrownSword Sword );
simulated function bool NotifyStruckByHook( NanoProj_RicochetMoonHook Hook );

simulated function bool IsValidSwordDashTarget( NanoPawn Attacker )
{
	return FALSE;
}

//////

/** Called when hit by dense, running pawn */
simulated function BoulderedIntoBy(NanoPawn NP)
{
	// Swap mesh when hit
	if((BoulderIntoSwapMesh != None) && (StaticMeshComponent.StaticMesh != BoulderIntoSwapMesh) && NP.IsInAtLeastDashPip(BoulderSwapDashPip))
	{
		// Change mesh
		StaticMeshComponent.SetStaticMesh(BoulderIntoSwapMesh);
		// Play sound
		PlaySound(BoulderSwapSound);
	}
}

defaultproperties
{
	BoulderSwapDashPip=EDP_Dash2

	Priority=5.f
	bUseMeshCenterForTarget=TRUE

	SupportedEvents.Add(class'SeqEvt_BoulderedInto')


	Begin Object Class=TargetableOctreeComponent Name=TargetableOctreeComp0
	End Object
	Components.Add(TargetableOctreeComp0)

}