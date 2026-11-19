/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
interface NanoInterface_Absorb extends Interface;

/** See if this object can be interacted with by this Pawn */
simulated function bool CanAbsorb( NanoPawn NP, ENanoInteractType Type );

/** Perform the interaction */
simulated function DoAbsorb( NanoPawn NP, ENanoInteractType Type );