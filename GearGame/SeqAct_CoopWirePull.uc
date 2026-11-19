/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_CoopWirePull extends SeqAct_Latent
	native(Sequence);

enum ECoopWirePullInputType
{
	eCOOPWIREPULLIN_GrabTriggerActive,
	eCOOPWIREPULLIN_GrabTriggerInactive,
	eCOOPWIREPULLIN_ChainsawTriggerActive,
};

enum EActCoopWirePullOutputType
{
	eCOOPWIREPULLOUT_Started,
	eCOOPWIREPULLOUT_Aborted,
	eCOOPWIREPULLOUT_Finished,
};

/** References to the triggers involved */
var() Trigger_Engage WireGrabTrigger;
var() Trigger_ChainsawInteraction ChainsawTrigger;

/** If true, teleports AI to trigger instead of pathing */
var() bool bTeleportAIToTrigger;

/** Stores the number of human players in the game */
var transient int PlayerCount;

/** Indicate if the triggers are active */
var transient bool bWireGrabTriggerActive;
var transient bool bChainsawTriggerActive;

cpptext
{
	virtual void OnReceivedImpulse( USequenceOp* ActivatorOp, INT InputLinkIndex );
	virtual UBOOL UpdateOp(FLOAT deltaTime);
	virtual void DeActivated();

	void InitAIMovement();
}

/** Positions the AI for the engage special move. */
event StartAIMovement(GearAI GearAIToMove, Actor GoalActor)
{
	local vector GoalLocation;
	local rotator GoalRotation;

	if( WireGrabTrigger == GoalActor )
	{
		GoalRotation.Yaw = WireGrabTrigger.ENGAGE_Actor.Rotation.Yaw;
		GoalLocation = WireGrabTrigger.ENGAGE_Actor.Location + (WireGrabTrigger.ENGAGE_OffsetFromActor >> GoalRotation);

		// Check if we should teleport AI to InactiveTrigger location
		if( bTeleportAIToTrigger )
		{
			GearAIToMove.TeleportToLocation(GoalLocation, GoalRotation);
		}
		
		StartAISpecialMove(GearAIToMove, WireGrabTrigger.ENGAGE_StartSpecialMove, GoalActor, WireGrabTrigger.ENGAGE_OffsetFromActor);
	}
	else if( ChainsawTrigger == GoalActor )
	{
		GoalRotation.Yaw = Rotator(ChainsawTrigger.ActorToFace.Location - ChainsawTrigger.ActorToMoveTo.Location).Yaw;
		GoalLocation = ChainsawTrigger.ActorToMoveTo.Location;

		// Check if we should teleport AI to InactiveTrigger location
		if( bTeleportAIToTrigger )
		{
			GearAIToMove.TeleportToLocation(GoalLocation, GoalRotation);
		}

		StartAISpecialMove(GearAIToMove, SM_ChainSawHold, ChainsawTrigger);
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


defaultproperties
{
	ObjName="Co-op Wire Pull"
	ObjCategory="Gear"

	bTeleportAIToTrigger=false

	InputLinks.Empty
	InputLinks(eCOOPWIREPULLIN_GrabTriggerActive)=(LinkDesc="Grab Trigger Active")
	InputLinks(eCOOPWIREPULLIN_GrabTriggerInactive)=(LinkDesc="Grab Trigger Inactive")
	InputLinks(eCOOPWIREPULLIN_ChainsawTriggerActive)=(LinkDesc="Chainsaw Trigger Active")
	
	OutputLinks(eCOOPWIREPULLOUT_Started)=(LinkDesc="Started")
	OutputLinks(eCOOPWIREPULLOUT_Aborted)=(LinkDesc="Aborted")
	OutputLinks(eCOOPWIREPULLOUT_Finished)=(LinkDesc="Success")

	VariableLinks.Empty
	VariableLinks(0)=(ExpectedType=class'SeqVar_Object', LinkDesc="Instigator")
	//VariableLinks(1)=(ExpectedType=class'SeqVar_Object', LinkDesc="Cam Target", PropertyName=CameraTarget)
}	
