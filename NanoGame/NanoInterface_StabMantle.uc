/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

interface NanoInterface_StabMantle extends Interface;

simulated function vector GetStabAttachOffset();

/** Returns a distance scaling factor to modify the range at which this actor is a valid stabbing target. */
simulated function float GetTargetDistanceScaling();

simulated function NotifySomeoneAttached( NanoPawn Rider );
/** Called to attach yourself to the car _firmly_ (heh).  If bViaLanding is set, the pawn landed on top of the actor, and did not actually stab mantle it (See NanoPawn::Landed()) */
simulated function NotifyFinishedStabMantle( NanoPawn Rider, optional bool bViaLanding );

/** Useful for checking to see if the StabMantle target is alive / not destroyed / in some state which makes mantling not valid. bIsLandingCheck is true if this is a check for landing on an actor, as opposed to stabbing it **/
simulated function bool IsValidStabMantleTarget(optional bool bIsLandingCheck);

/** Returns the name of the anim to play when flying towards this actor */
simulated function name GetStabMantleApproachAnim();

/** Returns the name of the anim to play for stab mantling on this actor */
simulated function name GetStabMantleAnim( bool bRightSide );

/** Returns the playrate for the stab mantle anim */
simulated function float GetStabMantleAnimRate();




