/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

interface NanoInterface_Forgeable extends Interface
	dependson(NanoPlan);

/** Function to forge the implementing actor.  Actor is responsible for calling the callback when object is forged and ready to use. */
function ForgeActor(optional delegate<NanoPlan.OnForgeActorFinished> OnFinishCallback);

