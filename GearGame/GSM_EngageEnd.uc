
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_EngageEnd extends GSM_Engage;


function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local array<SequenceEvent>	EngageEvents;
	local SeqEvt_Engage	EngageEvent;
	local BodyStance EndStance;
	local GearAI AIBuddy;
	local float AnimPlayTime;

	Super.SpecialMoveStarted(bForced,PrevMove);

	if( PawnOwner.EngageTrigger != None )
	{
		if( PawnOwner.EngageTrigger.ENGAGE_AnimName_End != '' &&
			(PawnOwner.EngageTrigger.ENGAGE_bPlayAnimationForHeavyWeapons || PawnOwner.MyGearWeapon.WeaponType != WT_Heavy) )
		{
			// Create the STOP stance
			EndStance.Stance.Length = 1; // Array of struct needs to be pre-sized.
			EndStance.Stance[0].Slot = BS_FullBody;
			EndStance.Stance[0].AnimName = PawnOwner.EngageTrigger.ENGAGE_AnimName_End;

			// Play body stance animation.
			AnimPlayTime = PawnOwner.BS_Play(EndStance, SpeedModifier, 0.2f/SpeedModifier, 0.2f/SpeedModifier, FALSE, TRUE);

			// Set Root motion on animation node
			PawnOwner.BS_SetRootBoneAxisOptions(EndStance, PawnOwner.EngageTrigger.RootBoneMotion_End, PawnOwner.EngageTrigger.RootBoneMotion_End, PawnOwner.EngageTrigger.RootBoneMotion_End);

			// Enable end of animation notification. This is going to call SpecialMoveEnded()
			PawnOwner.BS_SetAnimEndNotify(EndStance, TRUE);

			// If the anim couldn't be played, bail
			if( AnimPlayTime <= 0.0f )
			{
				PawnOwner.SetTimer(0.1f, FALSE, 'EndInteraction', Self);
			}
		}
		else
		{
			PawnOwner.SetTimer(0.1f, FALSE, 'EndInteraction', Self);
		}

		PawnOwner.EngageTrigger.EngagedPawn = None;

		// fire proper kismet event
		if( PawnOwner.EngageTrigger.FindEventsOfClass(class'SeqEvt_Engage', EngageEvents) )
		{
			EngageEvent = SeqEvt_Engage(EngageEvents[0]);
			if( (EngageEvent != None) && EngageEvent.bEnabled )
			{
				// don't check fov since the camera could be anywhere
				EngageEvent.bCheckInteractFOV = false;
				// fire the event
				PawnOwner.EngageTrigger.TriggerEventClass( class'SeqEvt_Engage', PawnOwner, eENGAGEOUT_Stopped );
				// if the other trigger has an AI buddy on it, have that trigger disengage too
				if (PawnOwner.EngageTrigger.LinkedCoopTrigger != None &&
					PawnOwner.EngageTrigger.LinkedCoopTrigger.EngagedPawn != None)
				{
					AIBuddy = GearAI(PawnOwner.EngageTrigger.LinkedCoopTrigger.EngagedPawn.Controller);
					if (AIBuddy != None)
					{
						PawnOwner.EngageTrigger.LinkedCoopTrigger.TriggerEventClass(class'SeqEvt_Engage', PawnOwner.EngageTrigger.LinkedCoopTrigger.EngagedPawn, eENGAGEOUT_Stopped);
					}
				}
			}
		}
	}
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	local BodyStance EndStance;

	if( PawnOwner.EngageTrigger != None )
	{
		if( PawnOwner.EngageTrigger.ENGAGE_AnimName_End != '' &&
			(PawnOwner.EngageTrigger.ENGAGE_bPlayAnimationForHeavyWeapons || PawnOwner.MyGearWeapon.WeaponType != WT_Heavy) )
		{
			// Create the STOP stance
			EndStance.Stance.Length = 1; // Array of struct needs to be pre-sized.
			EndStance.Stance[0].Slot = BS_FullBody;
			EndStance.Stance[0].AnimName = PawnOwner.EngageTrigger.ENGAGE_AnimName_End;
			PawnOwner.BS_SetAnimEndNotify(EndStance, FALSE);

			// Turn off Root motion on animation node
			PawnOwner.BS_SetRootBoneAxisOptions(EndStance, RBA_Discard, RBA_Discard, RBA_Discard);
		}
	}

	if( PCOwner != None )
	{
		PCOwner.SetRumbleScale(1.f);
	}

	Super.SpecialMoveEnded(PrevMove, NextMove);
}
