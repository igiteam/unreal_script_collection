/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class Trigger_Engage extends Trigger
	native
	implements(EditorLinkSelectionInterface)
	implements(Interface_AIMoveOverride);

// The actor this trigger is associated with.
var() Actor ENGAGE_Actor;


/** Which special move to play for this interaction. */
var ESpecialMove ENGAGE_StartSpecialMove;
/** Which special move to play when ending this interaction. */
var ESpecialMove ENGAGE_EndSpecialMove;

// Counter for how many times it takes to finish this trigger.
var() int ENGAGE_TurnsToComplete;

/** minimum amount of time between turns */
var() float ENGAGE_LoopDelay;

/** Offset to move the player away from the ENGAGE_Actor */
var() vector ENGAGE_OffsetFromActor;

/** Speed at which the pawn will face the valve. */
var() float ENGAGE_TurnTowardSpeed;

/** The anim set to use for the interactions this trigger deals with (base version, which is the default) */
var() AnimSet ENGAGE_AnimSet_Base;
/** The anim set to use for the interactions this trigger deals with (version used for women characters) */
var() AnimSet ENGAGE_AnimSet_Woman;

/** Name of the animation to START the engaging */
var() Name ENGAGE_AnimName_Start;
/** Name of the animation to END the engaging */
var() Name ENGAGE_AnimName_End;
/** Name of the animation to LOOP when engaging - If empty will assume no looping */
var() Name ENGAGE_AnimName_Loop;
/** Name of the idle animation when engaging - If empty will assume no looping */
var() Name ENGAGE_AnimName_Idle;
/** Name of the forced off animation when engaging - If empty ENGAGE_AnimName_End will be used */
var() Name ENGAGE_AnimName_ForceOff;

/** Root bone mode for the start animation */
var() ERootBoneAxis RootBoneMotion_Start;
/** Root bone mode for the end animation */
var() ERootBoneAxis RootBoneMotion_End;
/** Root bone mode for the loop animation */
var() ERootBoneAxis RootBoneMotion_Loop;
/** Root bone mode for the Idle animation */
var() ERootBoneAxis RootBoneMotion_Idle;
/** Root bone mode for the ForceOff animation */
var() ERootBoneAxis RootBoneMotion_ForceOff;

/** Should Pawn holster his weapon first? */
var() bool	ENGAGE_bShouldHolsterWeaponFirst;
/** Should Pawn holster his weapon first? */
var() bool	ENGAGE_bPlayAnimationForHeavyWeapons;
/** Should player auto drop his weapon when triggering this interaction? */
var() bool	ENGAGE_bShouldAutoDropHeavyWeapon;

/** Whether to disable look in the engage special move */
var() bool ENGAGE_bDisableLook;

/** Whether to require that use button be held */
var() bool ENGAGE_bRequireButtonHold;

/** Action info associated with engage */
var ActionInfo ENGAGE_ActionInfo;
var const array<ActionInfo> ENGAGE_ActionInfoList;

enum EEngageInputType
{
	eEngageInputType_None,
	eEngageInputType_A,
	eEngageInputType_B,
	eEngageInputType_LeftStickClockwise,
	eEngageInputType_LeftStickCounterCW,
	eEngageInputType_RightStickClockwise,
	eEngageInputType_RightStickCounterCW,
};
/** Key to be used for the interaction */
var() EEngageInputType ENGAGE_InteractInputType;

enum EStickDirection
{
	eStickDirection_None,
	eStickDirection_Up,
	eStickDirection_UpRight,
	eStickDirection_Right,
	eStickDirection_DownRight,
	eStickDirection_Down,
	eStickDirection_DownLeft,
	eStickDirection_Left,
	eStickDirection_UpLeft,
};

var transient EStickDirection LastStickRotDirection;
var transient EStickDirection EndStickRotDirection;

/** Whether the trigger is enabled or not - will also set the events used by this trigger */
var bool bEngageEnabled;

// Number of times the interaction occured
var transient int LoopCounter;

/** last time the engaging action happened */
var transient float LastTurnTime;

var() Trigger_Engage LinkedCoopTrigger;
var transient float LastAttemptTurnTime;

var transient GearPawn EngagedPawn;

/** Whether this trigger is able to be engaged or not */
var transient bool bIsEngagable;


cpptext
{
	virtual void LinkSelection(USelection* SelectedObjects);
}


simulated function ResetLoopCounter()
{
	LoopCounter = ENGAGE_TurnsToComplete;
	bIsEngagable = true;
}

simulated event PostBeginPlay()
{
	ResetLoopCounter();

	ENGAGE_ActionInfo = ENGAGE_ActionInfoList[ENGAGE_InteractInputType];

	// Little Hack for Gears 2 ship. Too risky to update maps, so we do this in code.
	if( ENGAGE_AnimName_Start == 'Floor_Lever_Pull_Start' ||
		ENGAGE_AnimName_Start == 'Wall_Lever_Pull_A_Start' ||
		ENGAGE_AnimName_Start == 'Wall_Lever_Pull_B_Start' )
	{
		ENGAGE_bShouldHolsterWeaponFirst = FALSE;
		ENGAGE_bShouldAutoDropHeavyWeapon = FALSE;
	}
}

// Override the untrigger so it's not triggered anymore.
function UnTrigger()
{
}

/** Whether being linked to another trigger forces this trigger not be able to execute or not */
simulated function bool CanExecuteEngageWithCoopTrigger()
{
	// If there isn't a linked trigger this check is done
	if(LinkedCoopTrigger == None ||
		// If there is another linked trigger make sure someone is engaged to the other trigger
	   (LinkedCoopTrigger.EngagedPawn != None &&
	    // Make sure this trigger's pawn doesn't go too far ahead of the other
		LinkedCoopTrigger.LoopCounter - LoopCounter <= 0 &&
		// Make sure we're in a state that makes sense for this trigger to interact
	    (LinkedCoopTrigger.EngagedPawn.IsDoingSpecialMove(SM_Engage_Loop) ||
		 LinkedCoopTrigger.EngagedPawn.IsDoingSpecialMove(SM_Engage_Idle))))
	{
		return true;
	}

	return false;
}

simulated function HandleEngageButtonInput(GearPC PC, Name ButtonName)
{
	local array<SequenceEvent>	EngageEvents;
	local GearAI AIBuddy;

	// Release from the engage actor and reset the state.
	if (ButtonName == 'X')
	{
		if ( PC.IsDoingSpecialMove(SM_Engage_Idle) )
		{
			// Make the actor of this trigger release
			PC.GotoState('PlayerWalking');
			PC.ClientGotoState('PlayerWalking');

			// Make the other actor release if that actor is AI
			if (LinkedCoopTrigger != None)
			{
				AIBuddy = GearAI(LinkedCoopTrigger.EngagedPawn.Controller);
				if (AIBuddy != None)
				{
					AIBuddy.MyGearPawn.DoSpecialMove(SM_Engage_End, true);
				}
			}
		}
	}
	else if(ENGAGE_InteractInputType == eEngageInputType_A && ButtonName == 'A' ||
			ENGAGE_InteractInputType == eEngageInputType_B && ButtonName == 'B')
	{
		if ( LoopCounter > 0 && 
			(WorldInfo.TimeSeconds - LastTurnTime >= ENGAGE_LoopDelay) && 
			 FindEventsOfClass(class'SeqEvt_Engage',EngageEvents) && 
			 EngageEvents[0].bEnabled && 
			 !PC.IsDoingSpecialMove(SM_Engage_Start) && 
			 !PC.IsDoingSpecialMove(SM_Engage_Loop) && 
			 !PC.IsDoingSpecialMove(SM_Engage_End) && 
			 !PC.IsDoingSpecialMove(SM_Engage_ForceOff))
		{
			// check for a linked trigger
			if(CanExecuteEngageWithCoopTrigger())
			{
				LastAttemptTurnTime = WorldInfo.TimeSeconds;
				PC.TriggerEngageLoop();
			}
		}
	}
}

simulated function HandleEngageJoystickInput(GearPC PC, byte JoystickActiveMask)
{
	local EStickDirection CurrentStickDir;
	local EStickDirection ExpectedStickDir;
	local array<SequenceEvent> EngageEvents;

	if( ( ENGAGE_InteractInputType == eEngageInputType_LeftStickClockwise || ENGAGE_InteractInputType == eEngageInputType_RightStickClockwise ||
		  ENGAGE_InteractInputType == eEngageInputType_LeftStickCounterCW || ENGAGE_InteractInputType == eEngageInputType_RightStickCounterCW )		&&
		  LoopCounter > 0 && 
		  ( LinkedCoopTrigger == None || LinkedCoopTrigger.EngagedPawn != None ) &&
		  FindEventsOfClass(class'SeqEvt_Engage', EngageEvents) && 
		  EngageEvents[0].bEnabled && 
		  !PC.IsDoingSpecialMove(SM_Engage_Start) && 
		  !PC.IsDoingSpecialMove(SM_Engage_Loop) && 
		  !PC.IsDoingSpecialMove(SM_Engage_End) && 
		  !PC.IsDoingSpecialMove(SM_Engage_ForceOff))
	{
		CurrentStickDir = JoystickMaskToStickDir(JoystickActiveMask);

		// If we haven't initialized LastStickRotDirection, do so now
		if( LastStickRotDirection == eStickDirection_None )
		{
			LastStickRotDirection = CurrentStickDir;
			EndStickRotDirection = CurrentStickDir;
			return;
		}

		// Determine what stick direction is next in the circular motion
		if( ENGAGE_InteractInputType == eEngageInputType_LeftStickClockwise || ENGAGE_InteractInputType == eEngageInputType_RightStickClockwise )
		{
			ExpectedStickDir = EStickDirection(LastStickRotDirection + 1);
			if( ExpectedStickDir > eStickDirection_UpLeft )
			{
				ExpectedStickDir = eStickDirection_Up;
			}
		}
		else
		{
			ExpectedStickDir = EStickDirection(LastStickRotDirection - 1);
			if( ExpectedStickDir <= eStickDirection_None )
			{
				ExpectedStickDir = eStickDirection_UpLeft;
			}
		}

		// Check if we are correctly continuing the circle
		if( CurrentStickDir == ExpectedStickDir )
		{
			// Check for full circle complete and make sure timing is proper
			if( CurrentStickDir == EndStickRotDirection )
			{
				LastAttemptTurnTime = WorldInfo.TimeSeconds;
				if (WorldInfo.TimeSeconds - LastTurnTime >= ENGAGE_LoopDelay)
				{
					// check for a linked trigger
					if(CanExecuteEngageWithCoopTrigger())
					{
						PC.TriggerEngageLoop();
					}
				}
			}
		}
		// Check if we messed up the stick rotation
		else if( CurrentStickDir != LastStickRotDirection )
		{
			ExpectedStickDir = CurrentStickDir;
		}

		LastStickRotDirection = CurrentStickDir;
	}
}

/** Returns the stick direction corresponding to JoystickActiveMask, based on ENGAGE_InteractInputType */
simulated function EStickDirection JoystickMaskToStickDir(byte JoystickActiveMask)
{
	if( ENGAGE_InteractInputType == eEngageInputType_LeftStickClockwise || ENGAGE_InteractInputType == eEngageInputType_LeftStickCounterCW )
	{
		// Use left stick
		switch( JoystickActiveMask )
		{
		case 1:	 // 00000001
			return eStickDirection_Up;
		case 2:  // 00000010
			return eStickDirection_Down;
		case 4:  // 00000100
			return eStickDirection_Left;
		case 5:  // 00000101
			return eStickDirection_UpLeft;
		case 6:  // 00000110
			return eStickDirection_DownLeft;
		case 8:  // 00001000
			return eStickDirection_Right;
		case 9:  // 00001001
			return eStickDirection_UpRight;
		case 10: // 00001010
			return eStickDirection_DownRight;
		default:
			return eStickDirection_None;
		}	
	}
	else
	{
		// Use right stick
		switch( JoystickActiveMask )
		{
		case 16:  // 00010000
			return eStickDirection_Down;
		case 32:  // 00100000
			return eStickDirection_Up;
		case 64:  // 01000000
			return eStickDirection_Left;
		case 80:  // 01010000
			return eStickDirection_DownLeft;
		case 96:  // 01100000
			return eStickDirection_UpLeft;
		case 128: // 10000000
			return eStickDirection_Right;
		case 144: // 10010000
			return eStickDirection_DownRight;
		case 160: // 10100000
			return eStickDirection_UpRight;
		default:
			return eStickDirection_None;
		}	
	}
}

/** Reset the trigger back to a usable state */
simulated function EngageReset()
{
	local array<SequenceEvent> SeqEvents;
	local SeqEvt_Engage EngageEvent;
	local int EventIdx;

	ResetLoopCounter();
	FindEventsOfClass( class'SeqEvt_Engage', SeqEvents, TRUE );
	for ( EventIdx = 0; EventIdx < SeqEvents.length; EventIdx++ )
	{
		EngageEvent = SeqEvt_Engage(SeqEvents[EventIdx]);
		EngageEvent.bEnabled = true;
	}
}

// Reset the trigger
simulated function OnManageEngage( SeqAct_ManageEngage inAction )
{
	local array<SequenceEvent> SeqEvents;
	local SeqEvt_Engage EngageEvent;
	local int EventIdx;

	// Reset and exit
	if( inAction.InputLinks[eMANAGEENGAGEIN_Reset].bHasImpulse )
	{
		EngageReset();
		return;
	}

	// Enable
	if( inAction.InputLinks[eMANAGEENGAGEIN_Enable].bHasImpulse )
	{
		bEngageEnabled = TRUE;
	}
	// Disable
	else if( inAction.InputLinks[eMANAGEENGAGEIN_Disable].bHasImpulse )
	{
		bEngageEnabled = FALSE;
	}
	// Toggle
	else if( inAction.InputLinks[eMANAGEENGAGEIN_Toggle].bHasImpulse )
	{
		bEngageEnabled = !bEngageEnabled;
	}

	FindEventsOfClass( class'SeqEvt_Engage', SeqEvents, TRUE );

	// Loop through all of the events and see if we need to enable or disable them
	for ( EventIdx = 0; EventIdx < SeqEvents.length; EventIdx++ )
	{
		EngageEvent = SeqEvt_Engage(SeqEvents[EventIdx]);
		EngageEvent.bEnabled = bEngageEnabled;
	}

	// See if we need to kick any players off the engage
	if ( !bEngageEnabled )
	{
		BootEngagedPlayers();
	}
}

/**	Handling Toggle event from Kismet. */
simulated function OnToggle(SeqAct_Toggle Action)
{
	// Turn ON
	if (Action.InputLinks[0].bHasImpulse)
	{
		bEngageEnabled = TRUE;
		if(!bCollideActors)
		{
			SetCollision(true, bBlockActors);
		}
	}
	// Turn OFF
	else if (Action.InputLinks[1].bHasImpulse)
	{
		bEngageEnabled = FALSE;
		if(bCollideActors)
		{
			SetCollision(false, bBlockActors);
		}
	}
	// Toggle
	else if (Action.InputLinks[2].bHasImpulse)
	{
		bEngageEnabled = !bEngageEnabled;
		SetCollision(!bCollideActors, bBlockActors);
	}
}

/** Boot any players engaged off of the engage object */
final event BootEngagedPlayers()
{
	local GearPawn GearPawnTouching;
	local GearPC MyGearPC;
	local BodyStance IdleStance;
	local GearAI MyGearAI;

	IdleStance.Stance.Length = 1; // Array of struct needs to be pre-sized.
	IdleStance.Stance[0].Slot = BS_FullBody;
	IdleStance.Stance[0].AnimName = ENGAGE_AnimName_Idle;

	foreach TouchingActors( class'GearPawn', GearPawnTouching )
	{
		if ( !GearPawnTouching.IsDoingSpecialMove( SM_Engage_ForceOff ) &&
			 !GearPawnTouching.IsDoingSpecialMove( SM_Engage_End ) &&
			 ClassIsChildOf( GearPawnTouching.SpecialMoves[GearPawnTouching.SpecialMove].Class, class'GSM_Engage' ) )
		{
			MyGearPC = GearPC(GearPawnTouching.Controller);
			if ( MyGearPC != None )
			{
				GearPawnTouching.BS_Stop( IdleStance, 0.2f );
				GearPawnTouching.DoSpecialMove( SM_Engage_ForceOff, true );
				MyGearPC.ClientGotoState( 'PlayerWalking' );
				MyGearPC.GotoState( 'PlayerWalking' );
			}
			else
			{
				MyGearAI = GearAI(GearPawnTouching.Controller);
				if (MyGearAI != None)
				{
					MyGearAI.MyGearPawn.DoSpecialMove(SM_Engage_ForceOff, true);
				}
			}
		}
	}
}

/**
 * Allows other objects to override the behavior of the MoveToGoal of a GearAI
 *
 * @return - true if we are going to handle the move
 */
function bool DoMoveOverride(GearAI AIToMove, SeqAct_AIMove MoveAction)
{
	// If there isn't an engaged pawn and we are allowing AI to initiate the interaction
	if (EngagedPawn == None &&
		MoveAction != None &&
		MoveAction.bInteractWithEngageTrigger)
	{
		// Have the AI initiate the interaction
		AIToMove.HandleScriptedSpecialMove(ENGAGE_StartSpecialMove, self,,, ENGAGE_OffsetFromActor);
		return true;
	}
	return false;
}


defaultproperties
{
	Begin Object Name=CollisionCylinder
		CollisionRadius=128.f
		CollisionHeight=128.f
	End Object

	bStatic=false

	SupportedEvents.Add(class'SeqEvt_Engage')
	SupportedEvents.Remove(class'SeqEvent_Used')

	ENGAGE_StartSpecialMove=SM_Engage_Start
	ENGAGE_EndSpecialMove=SM_Engage_End

	ENGAGE_LoopDelay=1.2
	ENGAGE_TurnTowardSpeed=8.f
	bEngageEnabled=true
	ENGAGE_bShouldHolsterWeaponFirst=TRUE
	ENGAGE_bShouldAutoDropHeavyWeapon=TRUE
	ENGAGE_bDisableLook=TRUE

	ENGAGE_InteractInputType=eEngageInputType_None

	ENGAGE_AnimName_Start="Interact_Start"
	ENGAGE_AnimName_End="Interact_End"
	ENGAGE_AnimName_Loop="Interact_Action"
	ENGAGE_AnimName_Idle="Interact_Idle"

	RootBoneMotion_Start=RBA_Discard
	RootBoneMotion_End=RBA_Discard
	RootBoneMotion_Loop=RBA_Discard
	RootBoneMotion_Idle=RBA_Discard
	RootBoneMotion_ForceOff=RBA_Discard

	ENGAGE_ActionInfoList(eEngageInputType_A)={(
		ActionName=AButton,
		IconAnimationSpeed=0.5,
		ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=212,V=314,UL=35,VL=43),
										  (Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=248,V=314,UL=35,VL=43))),
							(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=109,V=429,UL=68,VL=71)))	),
		)}
	ENGAGE_ActionInfoList(eEngageInputType_B)={(
		ActionName=BButton,
		IconAnimationSpeed=0.5,
		ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.HUD.HUD_ActionIcons2',U=83,V=0,UL=45,VL=32),
										  (Texture=Texture2D'Warfare_HUD.HUD.HUD_ActionIcons2',U=83,V=33,UL=45,VL=32))),
							(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=109,V=429,UL=68,VL=71)))	),
		)}
	ENGAGE_ActionInfoList(eEngageInputType_LeftStickClockwise)={(
		ActionName=LeftStickCW,
		IconAnimationSpeed=0.5,
		ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.HUD.Gears_WeaponIcons',U=134,V=327,UL=93,VL=90))),
							(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=109,V=429,UL=68,VL=71)))	),
		)}
	ENGAGE_ActionInfoList(eEngageInputType_LeftStickCounterCW)={(
		ActionName=LeftStickCCW,
		IconAnimationSpeed=0.5,
		ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.HUD.Gears_WeaponIcons',U=134,V=327,UL=93,VL=90))),
							(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=109,V=429,UL=68,VL=71)))	),
		)}
	ENGAGE_ActionInfoList(eEngageInputType_RightStickClockwise)={(
		ActionName=RightStickCW,
		IconAnimationSpeed=0.5,
		ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.HUD.Gears_WeaponIcons',U=134,V=327,UL=93,VL=90))),
							(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=109,V=429,UL=68,VL=71)))	),
		)}
	ENGAGE_ActionInfoList(eEngageInputType_RightStickCounterCW)={(
		ActionName=RightStickCCW,
		IconAnimationSpeed=0.5,
		ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.HUD.Gears_WeaponIcons',U=134,V=327,UL=93,VL=90))),
							(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=109,V=429,UL=68,VL=71)))	),
		)}
}
