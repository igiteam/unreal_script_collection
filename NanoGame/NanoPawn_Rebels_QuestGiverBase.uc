/**
 * Rebels Quest Giver!
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoPawn_Rebels_QuestGiverBase extends NanoPawn_RebelsBase
	abstract
	implements( NanoInterface_Interact )
	native(Pawn)
	config(Pawn);

/** Is the Mission Giver currently actively giving a briefing to a pawn */
var transient bool  bIsBriefing;

/** The pawn that is currently getting briefed, if any */
var transient NanoPawn BriefingTargetPawn;

/** Link to the currently playing dialog line in kismet, used so we can cleanly cancel */
var transient SeqAct_PlayDialogLine CurrentDialogLine;

/** The pending view target to return the player to after they've been reset */
var transient Actor QueuedViewTarget;

/** Distance from the mission giver at which the pawn will be forced to put away their weapons and walk */
var()   float PawnDisarmRadius;

/** Distance the pawn can travel away from the mission giver before they get reset */
var()   float PawnResetDistance;
/** Distance in front of this pawn to reset the player too when they stray too far */
var()   float ResetPawnOffset;
/** Camera that the pawn should view from when reseting the pawn */
var()   CameraAnim PawnResetCameraAnim;

var SkeletalMeshComponent TheMesh;


/** Whether or not this way point is interactable during chaos. **/
var() bool bInteractableDuringChaos;

/** The pawn's light environment */
//var() transient DynamicLightEnvironmentComponent LightEnvironment;

/** Sprite above head for showing ready to be talked to */
var()   SpriteComponent QuestSpriteComponent;
var()   Texture2D       ExclamationSpriteTex;
var()   Texture2D       QuestionSpriteTex;


/** We cache this so we do not have to hide unhide the sprite component each frame **/
var private transient EHeadIconType PrevHeadIcon;

/** Current talk to event associated with this mission giver */
var private transient SeqEvt_SpokeWithNPC NPCTalkEvt;


simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	AimNodes.length = 0;
}

/** Can't target these guys */
simulated function bool IsTargetable( optional ETargetQueryType QT )
{
	return FALSE;
}

/** Can't dust */
simulated function bool CanBeDusted()
{
	return TRUE;
}

/** Can't dense */
simulated function bool CanBeDensed()
{
	return TRUE;
}

simulated function NotifyCancelBriefing()
{
	// Notify the current line that we've cancelled, and it should stop playing
	if( CurrentDialogLine != None )
	{
		CurrentDialogLine.OnCancelBriefing();
	}

	// Pull the pawn out of the briefing state, which will cause subsequent dialog lines to skip, unless they're forced
	if( BriefingTargetPawn != None )
	{
		BriefingTargetPawn.GotoState('NearMissionBriefing');
	}

	return;
}

simulated function OnTriggerBriefing(SeqAct_TriggerBriefing Action)
{
	// Only trigger the dialog based on the kismet briefing action IF we're not already briefing a pawn.  Otherwise, do nothing, and the track index will be changed by kismet
	if( BriefingTargetPawn == None )
	{
		// Trigger the briefing with the track number specified in the action
		TriggerBriefingEvent( Action.Instigator, Action.TrackIndex );
	}	
}

simulated function OnFinishBriefing(SeqAct_FinishBriefing Action)
{
	if( BriefingTargetPawn != None )
	{
		ClearTimer(nameof(ResetPlayerViewTarget));

		// Handle returning the player to their pawn, and resetting the input, if needed
		ResetPlayerViewTarget();

		bIsBriefing = FALSE;
		PawnLeftBriefing();
	}
}

/////// NanoInterface_Interact

/** Returns the UI component which we will then act upon. **/
simulated function InteractableComponent GetInteractableComponent()
{
	return None;
}

/** This is called when the interaction has completed successfully **/
simulated function InteractionSuccessfullyCompleted();

/** See if we have a speak event */
simulated function bool CanInteract(NanoPawn NP, ENanoInteractType Type)
{
	local SeqEvt_SpokeWithNPC SpeakEvt;

	// if there is chaos and we are not allowed to interact
	if( ( NanoGRI(WorldInfo.GRI).GetCurrentChaosLevel() > 0 ) 
		&& ( bInteractableDuringChaos == FALSE )
		)
	{
		return FALSE;
	}

	// if we are already briefing someone then no one else can interact
	if( BriefingTargetPawn != None )
	{
		return FALSE;
	}


	SpeakEvt = FindTalkToEvent();

	if( NP.IsInState('MissionBriefing') == TRUE )
	{
		//`log( "In MissionBriefing ");
		return FALSE;
	}
	//`log( `showvar(NP.GetStateName()) @ `showvar(SpeakEvt)  @ `showvar(SpeakEvt.bEnabled) @ `showvar(bIsBriefing) @ `showvar(BriefingTargetPawn) );


	// if the speak event is not allowed
	if( ( SpeakEvt != None) && ( SpeakEvt.bEnabled == FALSE ) )
	{
		return FALSE;
	}

	if( (Type == ENIT_Default) && (SpeakEvt != None) && (VSize(Location - NP.Location) < SpeakEvt.InteractDistance) )
	{
		return TRUE;
	}
	
	return FALSE;
}

/** Get tooltip for interacting */
simulated function string GetInteractToolTip( NanoPawn NP, out Texture2D out_TextureButtonToPrefix )
{
	out_TextureButtonToPrefix = Texture2D'UI_Common.button_B';
	return "to Talk";
}

/** Perform the interaction */
simulated function DoInteract(NanoPawn NP, ENanoInteractType Type)
{
	if(Type == ENIT_Default)
	{
		// Trigger the briefing on the default track
		TriggerBriefingEvent(NP, 0);
	}
}
/////// End NanoInterface_Interact

simulated function TriggerBriefingEvent(NanoPawn NP, int Track)
{
	local SequenceEvent Evt;
	local array<int> ActivateIndices;

	// Store a reference to the pawn that we're briefing
	BriefingTargetPawn = NP;

	// Activate the primary output
	ActivateIndices[0] = 0;
	
	foreach GeneratedEvents(Evt)
	{
		NPCTalkEvt = SeqEvt_SpokeWithNPC(Evt);
		if( (NPCTalkEvt != None) && ( NPCTalkEvt.bEnabled == TRUE ) && (NPCTalkEvt.MaxTriggerCount == 0 || NPCTalkEvt.TriggerCount < NPCTalkEvt.MaxTriggerCount) )
		{
			// Notify all found events that a briefing has been triggered
			NPCTalkEvt.Instigator = NP;
			NPCTalkEvt.Originator = self;
			NPCTalkEvt.Track = Track;

			NPCTalkEvt.CheckActivate(self, NP,, ActivateIndices);

			bIsBriefing = TRUE;
			NP.GotoState('MissionBriefing');
		}
	}
}


/** Looks through the events associated with this actor to find a 'talk to' one that is ready to go */
simulated function SeqEvt_SpokeWithNPC FindTalkToEvent()
{
	local SequenceEvent Evt;
	foreach GeneratedEvents(Evt)
	{
		// See if this is a 'talk to' event, and is still good to trigger
		NPCTalkEvt = SeqEvt_SpokeWithNPC(Evt);
		if((NPCTalkEvt != none) && ( NPCTalkEvt.bEnabled == TRUE ) && (NPCTalkEvt.MaxTriggerCount == 0 || NPCTalkEvt.TriggerCount < NPCTalkEvt.MaxTriggerCount))
		{
			return NPCTalkEvt;
		}
	}

	return None;
}

simulated event Tick(float DeltaTime)
{
	local vector ToPawn;
	local float ToPawnDist;
	local Texture2D HeadIconTex;
	local NanoPawn NP;

	super.Tick(DeltaTime);

	// See if we are ready to be talked to
	NPCTalkEvt = FindTalkToEvent();
	if((NPCTalkEvt == none) || (NPCTalkEvt.HeadIcon == EHIT_Nothing))
	{
		QuestSpriteComponent.SetHidden(TRUE);
	}
	else
	{
		if( PrevHeadIcon != NPCTalkEvt.HeadIcon )
		{
			// If so, assign correct icon and show
			HeadIconTex = (NPCTalkEvt.HeadIcon == EHIT_Exclamation) ? ExclamationSpriteTex : QuestionSpriteTex;
			QuestSpriteComponent.SetSprite(HeadIconTex);

			QuestSpriteComponent.SetHidden(FALSE);

			PrevHeadIcon = NPCTalkEvt.HeadIcon;
		}
	}

	// If we're briefing, check to make sure the pawn doesn't go out of range
	if( bIsBriefing && BriefingTargetPawn != None )
	{
		ToPawn = BriefingTargetPawn.Location - Location;
		ToPawnDist = VSize(ToPawn);
		// Reset the pawn if they're farther than PawnResetDistance, or outside of 130 degree window
 		if( (ToPawnDist > PawnResetDistance) || ((ToPawn/ToPawnDist) dot vector(Rotation) < 0.42f) )
 		{
 			ReturnPawnToBriefing();
 		}
	}
	// If we're not briefing and have no target pawn, look for one
	else if( BriefingTargetPawn == None )
	{
		foreach CollidingActors(class'NanoPawn', NP, PawnDisarmRadius, Location, FALSE)
		{
			if( !NP.IsInState('NearMissionBriefing') && NP.IsHumanControlled() && (NPCTalkEvt != None) )
			{
				BriefingTargetPawn = NP;
				NP.CurrentMissionBriefer = self;
				NP.GotoState('NearMissionBriefing');
			}
		}
	}
}

simulated function ReturnPawnToBriefing()
{
	local NanoPC NPC;
	local SequenceEvent Evt;
	local SeqEvt_BriefingTrackChanged TrackEvent;
	local SeqEvt_BriefingPawnReset ResetEvent;
	local array<int> ActivateIndices;

	NPC = NanoPC(BriefingTargetPawn.Controller);

	// Reset the pawn to the default location in front of the speaker
	BriefingTargetPawn.SetLocation( Location + ResetPawnOffset * vector(Rotation) );
	BriefingTargetPawn.Velocity = vect(0.f, 0.f, 0.f);
	BriefingTargetPawn.Controller.SetRotation( rotator(Location - BriefingTargetPawn.Location) );
	BriefingTargetPawn.SetPhysics(PHYS_Falling);

	// Lock the player's controls to make sure they don't get residual motion
	NPC.DisableInput(TRUE, TRUE, TRUE, FALSE);
	
	// If specified, set the pawn's view target to the mission giver, and play an animation on the camera to mask the teleport
	if( (NPC != None) && (PawnResetCameraAnim != None) )
	{
		// Set the mission giver as the new view target, so we can teleport unnoticed
		NPC.SetViewTarget(self);
		NPC.PlayerCamera.PlayCameraAnim(PawnResetCameraAnim, 1.f, 1.f, 0.f, 0.f, FALSE, FALSE);

		// Set a timer to return the player to their own body after the camera animation has played
		SetTimer(PawnResetCameraAnim.AnimLength, FALSE, nameof(ResetPlayerViewTarget));
	}

	// Fire off the track changed event, for any special handling necessary in kismet
	ActivateIndices[0] = 0;
	foreach GeneratedEvents(Evt)
	{
		TrackEvent = SeqEvt_BriefingTrackChanged(Evt);
		if( TrackEvent != None )
		{
			// 0 is the default track
			TrackEvent.NewTrack = 0;
			TrackEvent.CheckActivate(self, BriefingTargetPawn,,ActivateIndices);
		}
		else
		{
			ResetEvent = SeqEvt_BriefingPawnReset(Evt);
			if( ResetEvent != None )
			{
				ResetEvent.CheckActivate(self, BriefingTargetPawn,,ActivateIndices);
			}
		}
	}
}

simulated function PawnLeftBriefing()
{
	// Safety catch:  if the pawn is briefing, make sure that they are reset, and not dropped out of the briefing area (can happen if pawn reset distance is outside the disarm distance)
	if( !bIsBriefing )
	{
		// Unregister this mission giver from the pawn
		BriefingTargetPawn.CurrentMissionBriefer = None;
		BriefingTargetPawn.GotoState('');

		// Unregister the pawn from ourself
		BriefingTargetPawn = None;
	}
}

/** Called after the camera animation has played to reset the player */
simulated function ResetPlayerViewTarget()
{
	local NanoPC NPC;
	local SequenceEvent Evt;
	local SeqEvt_BriefingPawnReset ResetEvent;
	local array<int> ActivateIndices;

	if( BriefingTargetPawn != None )
	{
		// Reset the idle timer
		BriefingTargetPawn.BriefingPawnIdleTime = 0.f;

		// Reset the player's view to their pawn
		NPC = NanoPC(BriefingTargetPawn.Controller);
		if( NPC != None )
		{
			NPC.SetViewTarget(QueuedViewTarget != None ? QueuedViewTarget : BriefingTargetPawn);
			NPC.EnableInput(TRUE, TRUE, TRUE);

		}
	}

	// Notify kismet the pawn has been reset
	ActivateIndices[0] = 1;
	foreach GeneratedEvents(Evt)
	{
		ResetEvent = SeqEvt_BriefingPawnReset(Evt);
		if( ResetEvent != None )
		{
			ResetEvent.CheckActivate(self, BriefingTargetPawn,,ActivateIndices);
		}
	}
}

event bool IsResettingPlayer()
{
	return IsTimerActive(nameof(ResetPlayerViewTarget));
}

simulated function String GetHumanReadableName()
{
	return "Capt. Oblivious";
}

defaultproperties
{
	bPawnInvulnerable=TRUE

	Begin Object Class=SpriteComponent Name=QuestSprite
		Translation=(Z=110.0)
		Scale=0.3
	End Object
	QuestSpriteComponent=QuestSprite
	Components.Add(QuestSprite)

	ExclamationSpriteTex=Texture2D'Nano_ProtoHUD_Ingame.T_UI_HUD_Ingame_Exclamation'
	QuestionSpriteTex=Texture2D'Nano_ProtoHUD_Ingame.T_UI_HUD_Ingame_Question'


	Begin Object Name=NanoPawnMesh
		AnimSets.Empty()
        bHasPhysicsAssetInstance=TRUE	// Needed by PhysicsBodyImpact
	End Object

	bKillDuringLevelTransition=FALSE

	bStatic=FALSE
	bHidden=FALSE

	PrevHeadIcon=EHIT_Nothing

	TickFrequencyDecreaseDistanceStart=1000
	TickFrequencyDecreaseDistanceEnd=2000
	TickFrequencyAtEndDistance=0.250

	PawnDisarmRadius=768.f
	PawnResetDistance=768.f
	ResetPawnOffset=64.f

	Begin Object Name=UIIconComponent0
	    MiniMap=(bShown=TRUE,bShownEvenIfClamped=TRUE,DistancesToDrawIcon=(X=0,Y=20000),Icon=Texture2D'UI_HUD.Minimap.Mission',IconScale=0.125f,IconColor=(R=255,G=255,B=255,A=255),bAlternateAboveBelowIcon=TRUE,AboveBelowIconScale=0.100f,TextName="",TextDescription="",TextVerticalOffset=0.0f)
	End Object

}
