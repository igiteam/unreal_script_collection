/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class Trigger_ChainsawInteraction extends Trigger
	native;

var() Actor ActorToFace, ActorToMoveTo;

var() bool bWithBlood;

var() int NumberOfMeleeHitsNeeded;

var() ParticleSystem ChainsawFX;

var() repnotify		bool	bDisplayIcon;
var()				float	IconAnimSpeed;

var() SoundCue ChainsawRipSound;

/** If TRUE, don't look for or try to fire any kismet events - just call TriggerChainsawed. */
var bool bNoKismet;

var bool bActivatedByMelee;

var Pawn CurrentActivator;

/** Array of delegates that will be triggered when this trigger is chainsawed */
var array<delegate<OnChainsawEvent> > ChainsawEventDelegates;

replication 
{
	if( Role == ROLE_Authority )
		bDisplayIcon, CurrentActivator;
}

simulated event ReplicatedEvent( name VarName )
{
	local GearPC PC;

	switch( VarName )
	{
		case 'bDisplayIcon':
			foreach LocalPlayerControllers( class'GearPC', PC )
			{
				UpdateDisplayIcon( GearPawn(PC.Pawn) );
			}
			break;
	}

	Super.ReplicatedEvent( VarName );
}

/** Delegate fired when someone chainsaws in this trigger */
delegate OnChainsawEvent();

/**
 * Adds the delegate to the list to be notified when the player chainsaws in this trigger
 *	@param EventDelegate - the delegate to add to the event
 */
final function AddEventDelegate(delegate<OnChainsawEvent> EventDelegate)
{
	// Only add to the list once
	if (ChainsawEventDelegates.Find(EventDelegate) == INDEX_NONE )
	{
		ChainsawEventDelegates.AddItem(EventDelegate);
	}
}

/**
 * Removes the delegate from the list to be notified when the player chainsaws this trigger
 *	@param EventDelegate - the delegate to add to the event
 */
final function ClearEventDelegate(delegate<OnChainsawEvent> EventDelegate )
{
	ChainsawEventDelegates.RemoveItem(EventDelegate);
}

/** Calls all of the delegates associated with this event */
final function TriggerEventDelegates()
{
	local int DelegateIdx;
	local delegate<OnChainsawEvent> OnEventDelegate;

	for (DelegateIdx = 0; DelegateIdx < ChainsawEventDelegates.length; DelegateIdx++)
	{
		OnEventDelegate = ChainsawEventDelegates[DelegateIdx];
		OnEventDelegate();
	}
}

/** Clears all delegates associated with this trigger */
final function ClearAllEventDelegates()
{
	ChainsawEventDelegates.Length = 0;
}

/** Called from GSM_ChainsawAttack_Object.SpecialMoveStarted - allows trigger to do script reaction to being chansawed. */
simulated function TriggerBeginChainsaw(GearPawn Pawn)
{
	if( bNoKismet )
	{
		bDisplayIcon = FALSE;
	}

	// Trigger any delegates that wanted notified and clear the delegates
	TriggerEventDelegates();
	ClearAllEventDelegates();
}

/** Called from GSM_ChainsawAttack_Object.SpecialMoveEnded - allows trigger to do script reaction to being chansawed. */
simulated function TriggerEndChainsaw(GearPawn Pawn)
{
	local GearPC PC;
	PC = GearPC(Pawn.Controller);
	if (PC != None)
	{
		PC.ClientToggleKismetIcon( FALSE, eGEARBUTTON_ChainsawMash, IconAnimSpeed );
	}
}

/** Called when you try and grenade tag one of these trigger. */
simulated function bool GrenadeTagged(GearWeap_GrenadeBase GrenadeWeap, vector HitLocation, vector HitNorm, TraceHitInfo HitInfo)
{
	return FALSE;
}

simulated function HitByMelee(GearPawn Pawn)
{
	if( bNoKismet )
	{
		bDisplayIcon = FALSE;
	}
	UpdateDisplayIcon( Pawn );
}

simulated function Destroyed()
{
	local GearPawn GP;

	Super.Destroyed();

	foreach TouchingActors( class'GearPawn', GP )
	{
		UnTouch( GP );
	}
	bDisplayIcon = FALSE;
}

simulated function bool ShouldDisplayIcon( Actor Other )
{
	local GearPawn GP;
	if( bDisplayIcon )
	{
		if( bNoKismet || TriggerEventClass( class'SeqEvt_ChainsawInteraction', Other, 0, TRUE ) )
		{
			GP = GearPawn(Other);
			if (NumberOfMeleeHitsNeeded > 0 || GP == None || GearWeap_AssaultRifle(GP.Weapon) != None)
			{
				return TRUE;
			}
		}
	}

	return FALSE;	
}

simulated function UpdateDisplayIcon( Actor Other )
{
	local GearPawn	GP;
	local GearPC	PC;

	GP = GearPawn(Other);
	if( GP != None )
	{
		PC = GearPC(GP.Controller);
		if( PC != None )
		{
			PC.ClientToggleKismetIcon( ShouldDisplayIcon(Other), eGEARBUTTON_ChainsawMash, IconAnimSpeed );
		}
	}
}

simulated event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	local GearPawn	GP;
	local GearPC	PC;

	GP = GearPawn(Other);
	if( GP != None )
	{
		PC = GearPC(GP.Controller);
		if( PC != None && PC.IsLocalPlayerController() )
		{
			UpdateDisplayIcon( Other );
		}
    }
}

simulated event UnTouch( Actor Other )
{
	local GearPawn	GP;
	local GearPC	PC;

	GP = GearPawn(Other);
	if( GP != None )
	{
		PC = GearPC(GP.Controller);
		if( PC != None && PC.IsLocalPlayerController() )
		{
			PC.ClientToggleKismetIcon( FALSE, eGEARBUTTON_ChainsawMash, IconAnimSpeed );
		}
	}
}

/** Enables and disabled all chainsaw interaction events associated with this trigger */
simulated function SetTriggerEnable(bool Value)
{
	local array<SequenceEvent> Evts;
	local SeqEvt_ChainsawInteraction Evt;
	local int Idx;

	FindEventsOfClass(class'SeqEvt_ChainsawInteraction',Evts, true);
	for (Idx = 0; Idx < Evts.Length; Idx++)
	{
		Evt = SeqEvt_ChainsawInteraction(Evts[Idx]);
		if (Evt != None && Evt.TriggerCount < Evt.MaxTriggerCount)
		{
			Evt.bEnabled = Value;
			bDisplayIcon = Value;
		}
	}
}

defaultproperties
{
	Begin Object Name=CollisionCylinder
		CollisionRadius=128.f
		CollisionHeight=128.f
	End Object
	
	SupportedEvents.Add(class'SeqEvt_ChainsawInteraction')
	SupportedEvents.Remove(class'SeqEvent_Used')

	NumberOfMeleeHitsNeeded=3

	bDisplayIcon=TRUE
	IconAnimSpeed=0.f
}
