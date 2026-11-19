/**
 * Interface for actors are patrol targets 
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
interface NanoInterface_PatrolDestination extends Interface;

simulated function bool GetPatrolDestination( out Vector out_PatrolDest );