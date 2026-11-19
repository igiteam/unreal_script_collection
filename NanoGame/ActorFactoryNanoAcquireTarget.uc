/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class ActorFactoryNanoAcquireTarget extends ActorFactoryDynamicSM;

/** How close you must be to object to interact with it */
var()   float   InteractDistance;
/** Whether you can quickly grab object (destroys it) */
var()   bool    bCanGrab;
/** Whether you can slowly absorb object by holding button */
var()   bool    bCanAbsorb;
/** How long it takes to absorb */
var()   float   AbsorbTime;

/** Allows script to modify new actor */
simulated event PostCreateActor(Actor NewActor)
{
	local NanoAcquireTarget NewTarget;
	
	NewTarget = NanoAcquireTarget(NewActor);

	NewTarget.InteractableComp.InteractDistance = InteractDistance;
	NewTarget.InteractableComp.bCanGrab = bCanGrab;
	NewTarget.InteractableComp.bCanAbsorb = bCanAbsorb;
	NewTarget.InteractableComp.AbsorbTime = AbsorbTime;
}

defaultproperties
{
	MenuName="Add NanoAcquireTarget"
	NewActorClass=class'NanoGame.NanoAcquireTarget'
	
	//StaticMesh=StaticMesh'GP_Pickups.SM.Mesh.S_GP_Pickups_Card01'
	
	CollisionType=COLLIDE_BlockAll
	
	
	InteractDistance=128.0
	bCanGrab=TRUE
	bCanAbsorb=FALSE
	AbsorbTime=2.0	
}
