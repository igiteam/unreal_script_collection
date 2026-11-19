/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoWireBase extends Actor
	implements(NanoInterface_Grapple)
	native
	abstract
	placeable;

/** The static mesh to deform for this actor */
var() StaticMesh            DeformMesh;

/** The mesh and spline representing the wire in the world */
var SplineMeshComponent     SplineMeshComponent;
var SplineComponent         SplineComponent;

/** The start and end tangents for the wire */
var() float                 WireSagFactor;
var() float                 WireTensionFactor;


/** Maximum speed of a pawn doing NSM_WireSlide on this wire */
var() float                 MaxWireSpeed;
/** Acceleration of a pawn doing NSM_WireSlide on this wire */
var() float                 WireAcceleration;
/** How fast to decelerate pawn when they're densed */
var()   float               WireDenseDeceleration;

/** If the pawn jumps on this wire, this is the vertical velocity added to their jump (in addition to their sliding velocity) */
var() float                 WireJumpVelocity;
/** If the pawn has densed and charged the wire, this is the vertical velocity that will be added to their sliding velocity */
var() float                 WireDensedJumpVelocity;

/** Distance from the endpoints within which if a pawn jumps, they will do an active handspring */
var() float                 ActiveDismountDistance;
/** Velocity multiplier to give the pawn when they perform an active dismount */
var() float                 ActiveDismountVelocityBonus;

/** Actor that marks the end of the spline */
var() Actor                 EndPointActor;

/** Endpoint of the wire, calculated by considering drawscale, mesh size, and origin location */
var const transient vector  EndPoint;

cpptext
{
	void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);
	void PostEditMove(UBOOL bFinished);
};

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	if( NanoGRI(WorldInfo.GRI) != None )
	{
		NanoGRI(WorldInfo.GRI).RegisterGrappleActor(self);
	}

	CalculateEndpoint();
}

/** Native function to update the endpoint of the wire.  Has to be native to get access to WireMesh.StaticMesh's default bounds (in local space) */
native function CalculateEndpoint();

/** Returns the world space coordinate on the spline closest to the test location, and the corresponding offset along the spline in Offset */
native function vector GetClosestPointOnWireTo( vector TestLocation, out float Offset );

native function RecalculateSplines();

/**********************************************************************
* NanoInterface_Grapple
**********************************************************************/
/** Is this actor currently able to be grappled? */
simulated function bool	IsGrapplable()
{
	return TRUE;
}

/** Return the closest point on the wire to the pawn */
simulated function vector GetGrappleLocation( NanoPawn Grappler )
{
	// Check for a location slightly in front of the player, to always suck them forward during the grapple.  Also adjust for the mesh translation (TEMP, animation hack)
	return GetGrappleLocation_Helper( Grappler.Location + 64.f*vector(Grappler.Rotation) );
}

/** If this returns TRUE, then NewRotation will be the target's desired rotation for the pawn */
simulated function bool ShouldOverrideDesiredRotation( NanoPawn Grappler, out rotator NewRotation, float DistanceToTarget )
{
	local vector WireTangent;

	// Face the pawn in the direction along the wire their rotation most closely matches
	WireTangent = (Endpoint - Location);
	if( vector(Grappler.Rotation) dot WireTangent > 0 )
	{
		NewRotation = rotator(WireTangent);
	}
	else
	{
		NewRotation = rotator(-WireTangent);
	}

	return TRUE;
}

/** Whether or not this location can be grapple to from above */
simulated function bool CanGrappleFromAbove()
{
	return FALSE;
}

simulated function GetGrappleAnims(bool bAboveTargetPoint, out name StartAnim, out name LoopAnim, out name EndAnim)
{
 	if( bAboveTargetPoint )
 	{
 		StartAnim = 'Zipline_Entry_Above_Start';
 		LoopAnim =  'Zipline_Entry_Above_Loop';
 		EndAnim =   'Zipline_Entry_Above_End';
 	}
 	else
 	{
 		StartAnim = 'Zipline_Entry_Below_Start';
 		LoopAnim =  'Zipline_Entry_Below_Loop';
 		EndAnim =   'Zipline_Entry_Below_End';
 	}
}

/** Helper function to efficiently compute grapple position on the wire */
native function vector GetGrappleLocation_Helper( vector TestLocation );

/** Called when someone begins grappling this actor */
simulated function NotifyBeginGrappled( NanoPawn Grappler );

/** Called when someone finishes grappling this actor */
simulated function NotifyEndGrappled( NanoPawn Grappler )
{
	// Do something to the pawn
	if( Grappler.IsLocallyControlled() )
	{
		Grappler.DoSpecialMove('NSM_WireSlide', FALSE, None, self);
	}
}

simulated function bool SupportsActiveGrapple()
{
	return FALSE;
}

simulated function vector GetActiveGrappleVelocity()
{
	return vect(0,0,0);
}

simulated function float GetMinimumGrappleDistance()
{
	return 0.f;
}

defaultproperties
{
	bEdShouldSnap=true

	Begin Object Class=SpriteComponent Name=Sprite
		Sprite=Texture2D'EditorResources.Spline.T_Loft_Spline'
		Scale=0.5
		HiddenGame=True
		AlwaysLoadOnClient=False
		AlwaysLoadOnServer=False
	End Object
	Components.Add(Sprite)

	Begin Object Class=SplineMeshComponent Name=SplineMeshComponent_0
		BlockNonZeroExtent=TRUE
		BlockZeroExtent=TRUE
		BlockActors=TRUE
		CollideActors=TRUE
	End Object
	Components.Add(SplineMeshComponent_0)
	SplineMeshComponent=SplineMeshComponent_0

	Begin Object Class=SplineComponent Name=SplineComponent_0
	End Object
	Components.Add(SplineComponent_0)
	SplineComponent=SplineComponent_0

	MaxWireSpeed=2000.f
	WireAcceleration=0.75f
	WireDenseDeceleration=2.f
	WireJumpVelocity=1024.f
	WireDensedJumpVelocity=2500.f

	ActiveDismountDistance=512.f
	ActiveDismountVelocityBonus=1.3f;
}