/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
interface NanoInterface_Attraction extends Interface
	native;

simulated function bool ShouldAttractActor(Actor TestActor);

simulated function Actor GetAttractionActor();

simulated event vector GetAttractionLocationOffset();

/** Called each frame that a Pawn is being attracted to this object */
simulated function bool AttractingPawn(NanoPawn NP);