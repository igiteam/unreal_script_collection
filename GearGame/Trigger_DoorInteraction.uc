/**
* A trigger that streamlines the door interaction process.
* Touching and Untouching this trigger will allow code to handle the input
* and animation work needed to open the door.
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class Trigger_DoorInteraction extends Trigger
	native
	implements(EditorLinkSelectionInterface)
	placeable;

/** The actor to align to when approaching the door */
var() Actor AlignToObj;

/** The anim set to use for the interactions this trigger deals with (base version, which is the default) */
var() AnimSet AnimSet_Base;

/** Name of the animation to play when pressing X */
var() Name AnimName;

/** Root bone mode for the animation */
var() ERootBoneAxis RootBoneMotion;

/** Should Pawn holster his weapon first? */
var() bool	bShouldHolsterWeaponFirst;
/** Should Pawn holster his weapon first? */
var() bool	bPlayAnimationForHeavyWeapons;
/** Should player auto drop his weapon when triggering this interaction? */
var() bool	bShouldAutoDropHeavyWeapon;

/** Amount of time into the animation that you want the door event to fire */
var() float TimeForDoorOpen;

/** Speed at which the pawn will face the AlignToObj. */
var() float TurnTowardSpeed;

/** Forces the alignment to of the pawn to the AlighToObj actor before doing the animation */
var() bool bForceAlignment;
/** TRUE to disable camera animation */
var() bool bDisableCameraAnim;

/** When ON a trace will be performed between the player and the trigger to ensure there is no collision in between them */
var() bool bDoTraceToPlayer;

var() bool bDisableCollision;

var() bool bAutoTriggerAI;

cpptext
{
	virtual void LinkSelection(USelection* SelectedObjects);
}


/**	Handling Toggle event from Kismet. */
simulated function OnToggle(SeqAct_Toggle Action)
{
	// Turn ON
	if (Action.InputLinks[0].bHasImpulse)
	{
		if(!bCollideActors)
		{
			SetCollision(true, bBlockActors);
		}
		CollisionComponent.SetBlockRigidBody( TRUE );
	}
	// Turn OFF
	else if (Action.InputLinks[1].bHasImpulse)
	{
		if(bCollideActors)
		{
			SetCollision(false, bBlockActors);
		}
		CollisionComponent.SetBlockRigidBody( FALSE );
	}
	// Toggle
	else if (Action.InputLinks[2].bHasImpulse)
	{
		SetCollision(!bCollideActors, bBlockActors);
		CollisionComponent.SetBlockRigidBody( !CollisionComponent.BlockRigidBody );
	}
	`log(self@GetFuncName()@bCollideActors);
}

defaultproperties
{
	Begin Object Name=CollisionCylinder
		CollisionRadius=128.f
		CollisionHeight=128.f
	End Object

	SupportedEvents.Add(class'SeqEvt_DoorOpen')
	SupportedEvents.Remove(class'SeqEvent_Used')

	bShouldHolsterWeaponFirst=false
	bShouldAutoDropHeavyWeapon=false
	bPlayAnimationForHeavyWeapons=false

	TimeForDoorOpen=0.95f
	TurnTowardSpeed=8.f
	bDisableCameraAnim=FALSE
	bDoTraceToPlayer=true
}
