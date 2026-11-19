/**
 * Interface for things that can be flung around in the maglev tracks
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
interface NanoInterface_MagLev extends Interface
	native;

/** Called when the maglev spline want to try and attract an actor **/
simulated event bool ShouldMagLevitate();

/** Called once when the maglev spline would like to attract and actor towards its spline path, and subsequently when passed to a new spline **/
simulated event BeginMagLevAttraction( NanoVehicleSpline_MagLev LevitatingSpline );

/** Called once when the actor can no longer be levitated (as governed by ShouldMagLevitate()) **/
simulated event EndMagLevAttraction();
