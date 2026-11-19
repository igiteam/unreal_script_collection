/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_CoopEngage extends SeqAct_Latent
	native(Sequence);

enum ECoopEngageInputType
{
	eCOOPENGAGEIN_Trigger1Interact,
	eCOOPENGAGEIN_Trigger1InteractEnd,
	eCOOPENGAGEIN_Trigger1Active,
	eCOOPENGAGEIN_Trigger1Inactive,
	eCOOPENGAGEIN_Trigger2Interact,
	eCOOPENGAGEIN_Trigger2InteractEnd,
	eCOOPENGAGEIN_Trigger2Active,
	eCOOPENGAGEIN_Trigger2Inactive,
};

enum EActCoopEngageOutputType
{
	eCOOPENGAGEOUT_Started,
	eCOOPENGAGEOUT_Opening,
	eCOOPENGAGEOUT_Closing,
	eCOOPENGAGEOUT_Finished,
};

/** Parameters that define how the camera will transition */
var() const Camera.ViewTargetTransitionParams CameraTransitionIn;
var() const Camera.ViewTargetTransitionParams CameraTransitionOut;

/** Structure to group all things associated with the triggers together */
struct native EngageTriggerData
{
	/** Reference to the trigger involved */
	var Trigger_Engage EngageTrigger;
	/** Indicate if the trigger is active */
	var transient bool bTriggerActive;
	/** Last time trigger was interacted with */
	var transient float LastInteractTime;
};
/** The data associated with each trigger this action has to deal with */
var array<EngageTriggerData> TriggerData;

/** Holds a ref to the new desired camera target. */
var() Actor CameraTarget;

/** If true, teleports AI to trigger instead of pathing */
var() bool bTeleportAIToTrigger;

/** Current counter of successful actions needed to complete the co-op engagement */
var int RemainingActionsToComplete;

/** Stores the number of human players in the game */
var transient int PlayerCount;

/** Amount of engagement inactivity before the gate begins to close (-1 = no failure delay) */
var() float InactivityFailDelay;
/** Last time we activated eCOOPENGAGEOUT_Closing */
var transient float LastInactivityFailTime;

/** Cancels the current animation when we have successfully finished the engagement - used when LD takes over with a matinee */
var() bool bCancelAnimOnSuccess;

/** The GUD to play when requesting help from another player to complete the coop action */
var() EGUDEventID NeedHelpGUDEvent;

cpptext
{
	virtual void PostLoad();

	virtual void OnReceivedImpulse( USequenceOp* ActivatorOp, INT InputLinkIndex );
	virtual UBOOL UpdateOp(FLOAT deltaTime);
	virtual void DeActivated();

	void TriggerInteract(INT InTriggerIdx);
	void TriggerInteractEnd(INT InTriggerIdx);

	void ToggleCamera(UBOOL bTurnOn);
	void InitAIMovement();
	INT GetTotalLoopCountFromTriggers();
}

/** Positions the AI for the engage special move. */
event StartAIMovement(GearAI GearAIToMove, Actor GoalActor)
{
	local Trigger_Engage EngageTrigger;
	local vector GoalLocation;
	local rotator GoalRotation;

	EngageTrigger = Trigger_Engage(GoalActor);
	if( EngageTrigger != None )
	{
		GoalRotation.Yaw = EngageTrigger.ENGAGE_Actor.Rotation.Yaw;
		GoalLocation = EngageTrigger.ENGAGE_Actor.Location + (EngageTrigger.ENGAGE_OffsetFromActor >> GoalRotation);

		// Check if we should teleport AI to InactiveTrigger location
		if( bTeleportAIToTrigger )
		{
			GearAIToMove.TeleportToLocation(GoalLocation, GoalRotation);
		}

		StartAISpecialMove(GearAIToMove, EngageTrigger.ENGAGE_StartSpecialMove, GoalActor, EngageTrigger.ENGAGE_OffsetFromActor);
	}
}

/** Called when the coop engage is finished */
event AllActionCompleted()
{
	local int TriggerIdx;

	// Detach players from engage actors
	for ( TriggerIdx = 0; TriggerIdx < TriggerData.length; ++TriggerIdx )
	{
		if (TriggerData[TriggerIdx].EngageTrigger != None)
		{
			TriggerData[TriggerIdx].EngageTrigger.LoopCounter = 0;
			TriggerData[TriggerIdx].EngageTrigger.bIsEngagable = false;

			if (TriggerData[TriggerIdx].EngageTrigger.EngagedPawn != None &&
				TriggerData[TriggerIdx].EngageTrigger.EngagedPawn.Controller != None)
			{
				if (bCancelAnimOnSuccess)
				{
					if (!TriggerData[TriggerIdx].EngageTrigger.EngagedPawn.IsDoingSpecialMove(SM_Engage_End))
					{
						TriggerData[TriggerIdx].EngageTrigger.EngagedPawn.ServerDoSpecialMove(SM_Engage_End, true,,,SM_Engage_End);
					}
				}
				else
				{
					StartAISpecialMove(TriggerData[TriggerIdx].EngageTrigger.EngagedPawn.Controller, TriggerData[TriggerIdx].EngageTrigger.ENGAGE_EndSpecialMove);
				}
			}
		}
	}
}

/** Starts / ends the engage special move for an AI */
event StartAISpecialMove(Controller InController, ESpecialMove SpecialMove, optional Actor AlignActor, optional vector AlignOffset)
{
	if( GearAI(InController) != None )
	{
		GearAI(InController).HandleScriptedSpecialMove(SpecialMove, AlignActor,,,AlignOffset);
	}
}

/**
 * Return the version number for this class.  Child classes should increment this method by calling Super then adding
 * a individual class version to the result.  When a class is first created, the number should be 0; each time one of the
 * link arrays is modified (VariableLinks, OutputLinks, InputLinks, etc.), the number that is added to the result of
 * Super.GetObjClassVersion() should be incremented by 1.
 *
 * @return	the version number for this specific class.
 */
static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 3;
}


defaultproperties
{
	ObjName="Co-op Engage"
	ObjCategory="Gear"

	InactivityFailDelay=-1.f
	bTeleportAIToTrigger=false

	InputLinks.Empty
	InputLinks(eCOOPENGAGEIN_Trigger1Interact)=(LinkDesc="Trigger 1 Interact")
	InputLinks(eCOOPENGAGEIN_Trigger1InteractEnd)=(LinkDesc="Trigger 1 Interact Done")
	InputLinks(eCOOPENGAGEIN_Trigger1Active)=(LinkDesc="Trigger 1 Active")
	InputLinks(eCOOPENGAGEIN_Trigger1Inactive)=(LinkDesc="Trigger 1 Inactive")
	InputLinks(eCOOPENGAGEIN_Trigger2Interact)=(LinkDesc="Trigger 2 Interact")
	InputLinks(eCOOPENGAGEIN_Trigger2InteractEnd)=(LinkDesc="Trigger 2 Interact Done")
	InputLinks(eCOOPENGAGEIN_Trigger2Active)=(LinkDesc="Trigger 2 Active")
	InputLinks(eCOOPENGAGEIN_Trigger2Inactive)=(LinkDesc="Trigger 2 Inactive")


	OutputLinks(eCOOPENGAGEOUT_Started)=(LinkDesc="Started")
	OutputLinks(eCOOPENGAGEOUT_Opening)=(LinkDesc="Opening")
	OutputLinks(eCOOPENGAGEOUT_Closing)=(LinkDesc="Closing")
	OutputLinks(eCOOPENGAGEOUT_Finished)=(LinkDesc="Success")

	VariableLinks.Empty
	VariableLinks(0)=(ExpectedType=class'SeqVar_Object', LinkDesc="Instigator")
	VariableLinks(1)=(ExpectedType=class'SeqVar_Object', LinkDesc="Cam Target", PropertyName=CameraTarget)
	VariableLinks(2)=(ExpectedType=class'SeqVar_Object',LinkDesc="Trigger 1")
	VariableLinks(3)=(ExpectedType=class'SeqVar_Object',LinkDesc="Trigger 2")

	bCancelAnimOnSuccess=true

	NeedHelpGUDEvent=GUDEvent_CoopDoorHelpRequest
}
