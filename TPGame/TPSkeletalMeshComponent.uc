/**
 * Copyright ? 2004-2005 Epic Games, Inc. All Rights Reserved.
 */
class TPSkeletalMeshComponent extends SkeletalMeshComponent
	native;


/** This changes the FOV used for rendering the skeletal mesh component. A value of 0 means to use the default. */
var private	float			FOV;


// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


native function AttachComponentToSocketFOV(ActorComponent Component, name SocketName);
native function SetFOV(float newFOV);


