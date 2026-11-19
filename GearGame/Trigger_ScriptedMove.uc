/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class Trigger_ScriptedMove extends Trigger
	native
	implements(EditorLinkSelectionInterface);


// The actor this trigger is associated with.
var() Actor ScriptedActor;

// Number of times this trigger will allow scripted moves (0 - infinite)
var() int TotalTriggerCount;

// Number of times this trigger has actually triggered a scripted move
var int TriggerCounter;

// Counter for how many times it takes to finish the move.
var() int TurnsToComplete;

/** Speed at which the pawn will face the ScriptedActor. */
var() float TurnTowardSpeed;

/** The anim set to use for the interactions this trigger deals with (base version, which is the default) */
var() AnimSet AnimSet_Base;
/** The anim set to use for the interactions this trigger deals with (version used for women characters) */
var() AnimSet AnimSet_Woman;

/** Name of the animation to START the scripted sequence */
var() Name AnimName_Start;
/** Name of the animation to END the scripted sequence - If empty will assume no end anim */
var() Name AnimName_End;
/** Name of the animation to LOOP during the scripted sequence - If empty will assume no looping */
var() Name AnimName_Loop;

/** Root bone mode for the start animation */
var() ERootBoneAxis RootBoneMotion_Start;
/** Root bone mode for the end animation */
var() ERootBoneAxis RootBoneMotion_End;
/** Root bone mode for the loop animation */
var() ERootBoneAxis RootBoneMotion_Loop;

/** Should Pawn holster his weapon first? */
var() bool	bShouldHolsterWeaponFirst;
/** Should Pawn holster his weapon first? */
var() bool	bPlayAnimationForHeavyWeapons;
/** Should player auto drop his weapon when triggering this interaction? */
var() bool	bShouldAutoDropHeavyWeapon;

/** Number of times the interaction occurred */
var transient int LoopCounter;

/** Array of linked script triggers that work together (for example, walking back and forth in a doorway) */
var() array<Trigger_ScriptedMove> LinkedTriggers;

/** A volume which is used to make the trigger not usable if another character is within it */
var() TriggerVolume SingleUserVolume;

/** Whether this trigger should be disabled if more than one user is present */
var() bool bOneUserOnly;

/** Whether the player needs to face in the direction of the scripted actor or not */
var() bool bDoDirectionCheck;

/** Whether to mirror the animation (eg. stepping through doorway on opposite side) */
var() bool bMirrorAnimation;


cpptext
{
	virtual void LinkSelection(USelection* SelectedObjects);
}


/** Returns whether the the events attached to a scripted move trigger can fire */
function bool TriggerCanFireEvents(Trigger_ScriptedMove ScriptTrig, GearPawn UserGP)
{
	local int EvtIdx;
	local SequenceEvent ScriptEvent;

	// See if there are any events attached to this trigger, and if there is, make sure we can trigger it
	for (EvtIdx = 0; EvtIdx < ScriptTrig.GeneratedEvents.Length; EvtIdx++)
	{
		ScriptEvent = ScriptTrig.GeneratedEvents[EvtIdx];
		if (ScriptEvent != None &&
			!ScriptEvent.CheckActivate(ScriptTrig, UserGP, true))
		{
			return false;
		}
	}

	return true;
}

/** Returns whether this trigger or any linked triggers can fire events */
function bool AllTriggersAreReadyForEvents(GearPawn UserGP)
{
	local int Idx;

	// First test this trigger
	if (!TriggerCanFireEvents(self, UserGP))
	{
		return false;
	}

	// Then loop through all linked triggers and test them
	for (Idx = 0; Idx < LinkedTriggers.Length; Idx++)
	{
		if (LinkedTriggers[Idx] != None &&
			!TriggerCanFireEvents(LinkedTriggers[Idx], UserGP))
		{
			return false;
		}
	}

	return true;
}

/** The trigger has been used so handle any counters needing updated */
simulated function TriggerUsedNotify()
{
	if (TotalTriggerCount > 0)
	{
		TriggerCounter++;
	}
}

/** Whether this trigger can currently be used or not */
simulated function bool TriggerIsUsable(GearPawn UserGP)
{
	local Vector PawnDir;
	local Vector AlignDir;
	local Vector VelocityDir;

	// See if we've already used all trigger counts
	if (TotalTriggerCount > 0 && TriggerCounter >= TotalTriggerCount)
	{
		return false;
	}

	// If we are only allowing one person in the trigger we need to
	// see if any gearpawns other than this user is in this trigger or any linked triggers
	if (bOneUserOnly &&
		IsVolumeTouchingGearPawns(UserGP) ||
		(UserGP.ScriptTrigger != None && UserGP.ScriptTrigger != self))
	{
		return false;
	}

	if (bDoDirectionCheck)
	{
		if (ScriptedActor != None)
		{
			PawnDir = Normal(Vector(UserGP.Rotation));
			AlignDir = Normal(Vector(ScriptedActor.Rotation));
			VelocityDir = Normal(UserGP.Velocity);
			if (PawnDir dot AlignDir > 0.7f &&
				VelocityDir dot AlignDir > 0.7f)
			{
				return true;
			}
		}
		return false;
	}

	return true;
}


/**
 * Determines whether a gearpawn other than the one passed in is currently touching the triggervolume
 * (if param is "none" it will determine if ANY gearpawn is in the trigger)
 */
simulated function bool IsVolumeTouchingGearPawns(GearPawn ExclusionPawn)
{
	local GearPawn TestGP;

	if (SingleUserVolume != None)
	{
		// Loop through all gearpawns
		foreach SingleUserVolume.TouchingActors(class'GearPawn', TestGP)
		{
			// If ExclusionPawn is null then we can early out since we are looking for any gearpawn
			if (ExclusionPawn == None)
			{
				return true;
			}
			else if (ExclusionPawn != TestGP)
			{
				return true;
			}
		}
	}

	return false;
}

/**
 * Determines whether a gearpawn other than the one passed in is currently touching this trigger or any linked triggers
 * (if param is "none" it will determine if ANY gearpawn is in the trigger)
 */
simulated function bool AreLinksTouchingGearPawns(GearPawn ExclusionPawn)
{
	local int Idx;

	for (Idx = 0; Idx < LinkedTriggers.Length; Idx++)
	{
		if (LinkedTriggers[Idx].IsTouchingGearPawns(ExclusionPawn))
		{
			return true;
		}
	}

	return false;
}

/**
 * Determines whether a gearpawn other than the one passed in is currently touching the trigger
 * (if param is "none" it will determine if ANY gearpawn is in the trigger)
 */
simulated function bool IsTouchingGearPawns(GearPawn ExclusionPawn)
{
	local GearPawn TestGP;

	// Loop through all gearpawns
	foreach TouchingActors(class'GearPawn', TestGP)
	{
		// If ExclusionPawn is null then we can early out since we are looking for any gearpawn
		if (ExclusionPawn == None)
		{
			return true;
		}
		else if (ExclusionPawn != TestGP)
		{
			return true;
		}
	}

	return false;
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
}

simulated function ResetLoopCounter()
{
	LoopCounter = TurnsToComplete;
}

simulated event PostBeginPlay()
{
	ResetLoopCounter();

	// Force the "one user" logic if there are any linked triggers
	if (LinkedTriggers.Length > 0)
	{
		bOneUserOnly = true;
	}
}

// Override the untrigger so it's not triggered anymore.
function UnTrigger()
{
}


defaultproperties
{
	Begin Object Name=CollisionCylinder
		CollisionRadius=128.f
		CollisionHeight=128.f
	End Object

	bStatic=false

	SupportedEvents.Add(class'SeqEvt_ScriptedMove')
	SupportedEvents.Remove(class'SeqEvent_Used')

	TurnTowardSpeed=8.f
	bShouldHolsterWeaponFirst=false
	bShouldAutoDropHeavyWeapon=true
	bPlayAnimationForHeavyWeapons=true

	AnimName_Start=""
	AnimName_End=""
	AnimName_Loop=""

	RootBoneMotion_Start=RBA_Discard
	RootBoneMotion_End=RBA_Discard
	RootBoneMotion_Loop=RBA_Discard
}
