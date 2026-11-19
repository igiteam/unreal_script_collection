/**
 * 
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoCollectableActorBase extends Actor
	abstract
	placeable
	hidecategories(Advanced,Attachment,Collision,Debug,Display,Mobile,Movement,Object,Physics);

/** 
 * We place an actor in the world (this class) and then we spawn a specific actor that the player interacts with.
 * This is our ref to the spawned object
 **/
var transient NanoInteractableActor Interact;



defaultproperties
{

}