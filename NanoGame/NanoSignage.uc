/**
 * Base class for all placeable city signs
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoSignage extends Actor
	abstract;

defaultproperties
{
	bEdShouldSnap=TRUE
	RemoteRole=ROLE_None
	bNoDelete=TRUE
	bMovable=FALSE
	bPushedByEncroachers=FALSE
	bHardAttach=TRUE
	bCollideActors=FALSE
}