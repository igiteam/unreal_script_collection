/**
 * To use the actor must implement this interface and then in PostBeginPlay call
 * NanoGRI(WorldInfo.GRI).RegisterTargetableActor(self);
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

interface NanoInterface_Targetable extends Interface
    native;

/** Is this object currently targetable */
simulated function bool IsTargetable( optional ETargetQueryType QT );

/** Returns the Targetable Octree component */
simulated function TargetableOctreeComponent GetTargetableOctreeComponent();
//{
//	local TargetableOctreeComponent TargetableComp;
//
//	foreach AllOwnedComponents( class'TargetableOctreeComponent', TargetableComp )
//	{
//		return TargetableComp;
//	}
//
//	return None;
//}

/** Should we rate this target? (if not just skip in rating loop) */
simulated function bool ShouldRateTarget();

/** Should this targetable actor ignore distance checks in rating calculations (caution...use with care!) */
simulated function bool ShouldIgnoreDistance();

/** Returns base priority for targeting this object. */
simulated function float GetBasePriority(NanoPC Askee, optional NanoPawn AskeePawn);

/** Get location that target should be considered */
simulated event vector GetTargetedLocation();

/** Rotation of the target.  Useful to see if they are facing some dir **/
simulated event rotator GetRotation();

/** How fast the target is currently moving **/
simulated event vector GetVelocity();

/** Pass in a struct and then have the interface fill in a ton of different firing targetable data **/
simulated function GetFiringTargetableDatum( out FiringTargetableDatum Out_FiringTargetableDatum );


/** Called when target is struck by thrown sword */
simulated function NotifyImpaledBySword( NanoProj_ThrownSword Sword );

/** Called when target struck by ricochet moon hook */
simulated function bool NotifyStruckByHook( NanoProj_RicochetMoonHook Hook );

/** Indicates this object can be dash-attacked with sword */
simulated function bool IsValidSwordDashTarget( NanoPawn Attacker );


// might want to add getting the CollisionRadius / CollisionCylinder here also
// c.f. "pawncasts" in NanoWeap_Melee

// to remove
/** We were using this for the FOctreeSemantics GetBoundingBox() but we can used GetcomponentsBoundingBox instead. **/
//simulated event BoxSphereBounds GetTargetableBounds();


// need to add shootable / meleeable / etc.  


