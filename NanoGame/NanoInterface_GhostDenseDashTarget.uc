/**
 * Interface for actors that can be DenseDashed hit
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
interface NanoInterface_GhostDenseDashTarget extends Interface;


/** When a pawn has been GhostDashed through this will determine what occurs.  (e.g.  a good place to have AI react or set the pawn into some state) **/
simulated function GhostDashedThrough( Controller InstigatedBy );


/** When a pawn has been DenseDashed through this will determine what occurs.  (e.g.  a good place to have AI react or set the pawn into some state) **/
simulated function DenseDashedThrough( Controller InstigatedBy );

// currently DenseDash uses his function so we need to make certain all of our objects implementing this interface have it
function Knockback( vector Dir, bool InbKnockDownOnLanding, optional name StunDesc );


/** Differnet objects are valid for different reasons.  Usually it is health which determines if we can Dash them **/
simulated function bool IsValidGhostDenseDashTarget();
