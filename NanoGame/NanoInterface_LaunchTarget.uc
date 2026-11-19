/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * 
 * Convenience interface for objects that are used as launch targets.  Allows them to override the location they are targeted at (i.e. launch poles want pawns to land at the tip)
 */
interface NanoInterface_LaunchTarget extends Interface
	native;

/** Should return a vector (in world space) where the pawn should land for big jumps */
simulated event vector GetLandingLocation();
