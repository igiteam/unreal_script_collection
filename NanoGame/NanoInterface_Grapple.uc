/**
 * To use the actor must implement this interface and then in PostBeginPlay call
 * NanoGRI(WorldInfo.GRI).RegisterGrappleActor(self);
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

interface NanoInterface_Grapple extends Interface;

/** Is this actor currently able to be grappled? */
simulated function bool	IsGrapplable();

/** Location to grapple to, in world space */
simulated function vector GetGrappleLocation( NanoPawn Grappler );

/** If this returns TRUE, then NewRotation will be the target's desired rotation for the pawn */
simulated function bool ShouldOverrideDesiredRotation( NanoPawn Grappler, out rotator NewRotation, float DistanceToTarget );

/** Whether or not this location can be grapple to from above */
simulated function bool CanGrappleFromAbove();

/** Returns the start, sustain, and ending animations for this grapple interface (if empty, assumes the defaults) */
simulated function GetGrappleAnims(bool bAboveTargetPoint, out name StartAnim, out name LoopAnim, out name EndAnim);

/** Called when someone begins grappling this actor */
simulated function NotifyBeginGrappled( NanoPawn Grappler );

/** Called when someone finishes grappling this actor */
simulated function NotifyEndGrappled( NanoPawn Grappler );

/** Does this grapple target support active mantling at the top? */
simulated function bool SupportsActiveGrapple();

/** If SupportsActiveGrapple() returns TRUE, this function should return the velocity we should launch the player up at */
simulated function vector GetActiveGrappleVelocity();

/** If non-zero, the pawn will be stuck at this distance from the grapple object */
simulated function float GetMinimumGrappleDistance();