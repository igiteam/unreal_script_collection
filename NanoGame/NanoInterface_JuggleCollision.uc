/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
interface NanoInterface_JuggleCollision extends Interface;

/** 
 *  Called when juggled into by a pawn
 *  @param NPCollider the Pawn which did the colliding
 **/
simulated function JuggleCollisionWithJuggledActor(NanoPawnBase NPCollider);