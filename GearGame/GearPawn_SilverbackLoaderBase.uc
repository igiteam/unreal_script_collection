
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearPawn_SilverbackLoaderBase extends GearPawn_SilverbackBase
	config(Pawn)
	abstract;

struct CheckpointRecord
{
	var vector Location;
	var rotator Rotation;
};

/** Used to blend in/out of attack anims */
var transient AnimNodeBlend BoxAttachedBlendNode;
/** Used to blend in/out of attack anims */
var transient AnimNodeBlend DriverBoxAttachedBlendNode;
/** Bone Controller for crate lift attachment */
var transient SkelControlSingleBone SkelControl_BoxAttachment;
/** Reference to crate we are touching */
var KActor_SilverbackLoaderCrateBase TouchingCrate;
/** Reference to crate we have picked up */
var repnotify KActor_SilverbackLoaderCrateBase PickedUpCrate;
/** Set to true when crate is properly attached */
var transient bool bAttachedCrate;
/** Time for blending in crate SkelControl */
var float CrateSkelControlBlendTime;

replication
{
	// Variables the server should send ALL clients.
	if (bNetDirty && Role == Role_Authority)
		PickedUpCrate;
}

/** Check on various replicated data and act accordingly. */
simulated event ReplicatedEvent(Name VarName)
{
	if( VarName == 'PickedUpCrate' )
	{
		// Attach the crate if it hasn't been attached yet
		if( PickedUpCrate != None && !bAttachedCrate )
		{
			AttachCrate();
		}
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}

simulated function CacheAnimNodes()
{
	Super.CacheAnimNodes();
	BoxAttachedBlendNode = AnimNodeBlend(Mesh.FindAnimNode('BoxAttached'));
	SkelControl_BoxAttachment = SkelControlSingleBone(Mesh.FindSkelControl('SkelControl_BoxAttachment'));

	// Make sure node starts off
	BoxAttachedBlendNode.SetBlendTarget(0, 0.f);
}

simulated function ClearAnimNodes()
{
	Super.ClearAnimNodes();
	BoxAttachedBlendNode = None;
	DriverBoxAttachedBlendNode = None;
	SkelControl_BoxAttachment = None;
}

simulated function DoDriverAttachment(GearPawn InDriver)
{
	Super.DoDriverAttachment(InDriver);

	DriverBoxAttachedBlendNode = AnimNodeBlend(InDriver.Mesh.FindAnimNode('BoxAttached'));

	// Make sure node starts off
	DriverBoxAttachedBlendNode.SetBlendTarget(0, 0.f);
}

simulated function bool CanLiftCrate()
{
	if( TouchingCrate == None )
	{
		return FALSE;
	}

	// Must be facing the crate
	if( Normal(TouchingCrate.Location - Location) dot Vector(Rotation) < 0.7f )
	{
		return FALSE;
	}

	return TRUE;
}

/** Called from GearPlayerInput when Action button is pressed, to attempt a crate pickup */
reliable server function ServerAttemptCratePickup()
{
	if( CanLiftCrate() )
	{
		bForceNetUpdate = TRUE;
		PickedUpCrate = TouchingCrate;

		// Do special move
		PickedUpCrate.TriggerEventClass( class'SeqEvent_LoaderCratePickedUp', self );
		ServerDoSpecialMove(GSM_SilverbackLoaderCratePickup, TRUE);

		GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_Silverback_PickedUpCrate, Driver);
	}
}

/** Attaches PickedUpCrate to the silverback loader */ 
simulated function AttachCrate()
{
	local Vector X, Y, Z;

	// Set the flag indicating that the crate was attached
	bAttachedCrate = true;

	// Ramp on the BoxAttachedBlendNode
	BoxAttachedBlendNode.SetBlendTarget(1, 0.2f);
	DriverBoxAttachedBlendNode.SetBlendTarget(1, 0.2f);

	// Place attach bone at crate location
	SkelControl_BoxAttachment.SetSkelControlStrength(1.f, 0.f);
	SkelControl_BoxAttachment.BoneTranslation = PickedUpCrate.Location;
	SkelControl_BoxAttachment.BoneRotation = PickedUpCrate.Rotation;
	
	// Figure out shortest rotation. Rotate 180 if needed.
	GetAxes(PickedUpCrate.Rotation, X, Y, Z);
	if( ((Location - PickedUpCrate.Location) dot Y) > 0.f )
	{
		SkelControl_BoxAttachment.BoneRotation += Rot(0,32768,0);
	}

	// Turn off physics
	PickedUpCrate.SetPhysics(PHYS_None);
	// Attach crate to bone
	PickedUpCrate.SetBase(self,, Mesh, 'Payload');
	// Smooth interp from current crate location, to animated bone position.
	SkelControl_BoxAttachment.SetSkelControlStrength(0.f, CrateSkelControlBlendTime);

	// Clear block actors as it causes us to not be able to step down properly
	PickedUpCrate.SetCollision(PickedUpCrate.bCollideActors, FALSE);

	SetCollisionSize(GetCollisionRadius()*1.5f, GetCollisionHeight());
}

/** Validate collision from Pawn to Door Trigger */
simulated function bool ValidateDoorTriggerCollision(Trigger_DoorInteraction DoorTrig)
{
	local bool bResult, bOldCollideActor, bOldBlockActor, bOldIgnoreEncroachers;

	if( PickedUpCrate != None )
	{
		bOldCollideActor = PickedUpCrate.bCollideActors;
		bOldBlockActor = PickedUpCrate.bBlockActors;
		bOldIgnoreEncroachers = PickedUpCrate.bIgnoreEncroachers;
		PickedUpCrate.SetCollision(FALSE, FALSE, TRUE);
	}

	bResult = Super.ValidateDoorTriggerCollision(DoorTrig);

	if( PickedUpCrate != None )
	{
		PickedUpCrate.SetCollision(bOldCollideActor, bOldBlockActor, bOldIgnoreEncroachers);
	}

	return bResult;
}

function bool ShouldSaveForCheckpoint()
{
	return (Driver == None);
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
	Record.Location = Location;
	Record.Rotation = Rotation;
}

function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
	SetLocation(Record.Location);
	SetRotation(Record.Rotation);
}

/** Clear the box collision to avoid blocking any melee traces */
simulated function DoMeleeImpact()
{
	local bool bOldCollideActor, bOldBlockActor, bOldIgnoreEncroachers;

	if (PickedUpCrate != None)
	{
		bOldCollideActor = PickedUpCrate.bCollideActors;
		bOldBlockActor = PickedUpCrate.bBlockActors;
		bOldIgnoreEncroachers = PickedUpCrate.bIgnoreEncroachers;
		PickedUpCrate.SetCollision(FALSE, FALSE, FALSE);
		
		Super.DoMeleeImpact();

		PickedUpCrate.SetCollision(bOldCollideActor, bOldBlockActor, bOldIgnoreEncroachers);
	}
	else
	{
		MyGearWeapon.MeleeAttackImpact();
	}
}

/**
 * Don't collide the exiting driver with the crate
 * 
 * @param ExitingDriver - the exiting pawn
 * 
 * @return TRUE if the driver could be placed
 */
function bool PlaceExitingDriver(optional Pawn ExitingDriver)
{
	local bool bOldCollideActor, bOldBlockActor, bOldIgnoreEncroachers;
	local bool bResult;
		
	if (PickedUpCrate != None)
	{
		bOldCollideActor = PickedUpCrate.bCollideActors;
		bOldBlockActor = PickedUpCrate.bBlockActors;
		bOldIgnoreEncroachers = PickedUpCrate.bIgnoreEncroachers;
		PickedUpCrate.SetCollision(FALSE, FALSE, FALSE);
	}

	bResult = Super.PlaceExitingDriver(ExitingDriver);

	if (PickedUpCrate != None)
	{
		PickedUpCrate.SetCollision(bOldCollideActor, bOldBlockActor, bOldIgnoreEncroachers);
	}

	return bResult;
}

defaultproperties
{
	CrateSkelControlBlendTime=0.33f

	SpecialMoveClasses.Empty
	SpecialMoveClasses(GSM_SilverbackLoaderCratePickup)=class'GSM_SilverbackLoaderCratePickup'
	SpecialMoveClasses(GSM_SilverbackLoaderDropCrate)=class'GSM_SilverbackLoaderDropCrate'
	SpecialMoveClasses(GSM_Silverback_SuperCurbStomp)=class'GSM_SilverbackLoader_SuperCurbstomp'
	SpecialMoveClasses(SM_RoadieRun)=class'GSM_Silverback_RoadieRun'
	SpecialMoveClasses(GSM_Silverback_GetIn)=Class'GSM_Silverback_GetIn'
	SpecialMoveClasses(GSM_Silverback_GetOut)=Class'GSM_Silverback_GetOut'
	SpecialMoveClasses(SM_DoorKick)=class'GSM_DoorKick'

	ActionSpecialMoves.Add(GSM_SilverbackLoaderCratePickup)
	
	DefaultInventory.Empty()
	DefaultInventory(0)=class'GearGame.GearWeap_SilverbackLoaderMelee'
}
