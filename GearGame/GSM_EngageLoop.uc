
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_EngageLoop extends GSM_Engage;

/** Force feedback waveform for the engage loop */
var ForceFeedbackWaveform EngageLoopFF;
/** Maximum scaling amount to apply to force feedback waveform based on engage speed */
var float MaxFFScale;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced,PrevMove);
	LoopEngage();
}

simulated function float CalcFFScale()
{
	if( PawnOwner.EngageTrigger.LastTurnTime == 0 )
	{
		return MaxFFScale * 0.5f;
	}
	else
	{
		// Try to get a nice range between 0.25*MaxFFScale and MaxFFScale
		return MaxFFScale - FClamp(((PawnOwner.WorldInfo.TimeSeconds - PawnOwner.EngageTrigger.LastTurnTime) - 1.5f) / 0.5f, 0.f, MaxFFScale * 0.75f);
	}

}

simulated function LoopEngage()
{
	local array<SequenceEvent> EngageEvents;
	local SeqEvt_Engage EngageEvent;
	local BodyStance LoopStance;
	local float FFScale;

	if( PawnOwner.EngageTrigger != None )
	{
		FFScale = CalcFFScale();

		if( PawnOwner.EngageTrigger.FindEventsOfClass(class'SeqEvt_Engage', EngageEvents) )
		{
			EngageEvent = SeqEvt_Engage(EngageEvents[0]);
			if( EngageEvent != None && EngageEvent.bEnabled )
			{
				// don't check fov since the camera could be anywhere
				EngageEvent.bCheckInteractFOV = FALSE;
				// fire an event
				PawnOwner.EngageTrigger.TriggerEventClass( class'SeqEvt_Engage', PawnOwner, eENGAGEOUT_InteractBegin );
				// reset the fov check
				EngageEvent.bCheckInteractFOV = TRUE;
				// Set the last timer timer
				PawnOwner.EngageTrigger.LastTurnTime = PawnOwner.WorldInfo.TimeSeconds;
				// Decrement the loop counter
				PawnOwner.EngageTrigger.LoopCounter--;
				//`log("Decremented"@PawnOwner.EngageTrigger@"to"@PawnOwner.EngageTrigger.LoopCounter);
			}
		}

		if( PawnOwner.EngageTrigger.ENGAGE_AnimName_Loop != '' &&
			(PawnOwner.EngageTrigger.ENGAGE_bPlayAnimationForHeavyWeapons || PawnOwner.MyGearWeapon.WeaponType != WT_Heavy) )
		{
			// Create the loop stance
			LoopStance.Stance.Length = 1; // Array of struct needs to be pre-sized.
			LoopStance.Stance[0].Slot = BS_FullBody;
			LoopStance.Stance[0].AnimName = PawnOwner.EngageTrigger.ENGAGE_AnimName_Loop;

			// Play body stance animation.
			PawnOwner.BS_Play(LoopStance, SpeedModifier, 0.1f/SpeedModifier, -1.f, FALSE, TRUE);

			// Set Root motion on animation node
			PawnOwner.BS_SetRootBoneAxisOptions(LoopStance, PawnOwner.EngageTrigger.RootBoneMotion_Loop, PawnOwner.EngageTrigger.RootBoneMotion_Loop, PawnOwner.EngageTrigger.RootBoneMotion_Loop);

			// Enable end of animation notification. This is going to call SpecialMoveEnded()
			PawnOwner.BS_SetAnimEndNotify(LoopStance, TRUE);

			if( PCOwner != None )
			{
				PCOwner.SetRumbleScale(FFScale);
				PCOwner.ClientPlayForceFeedbackWaveform(EngageLoopFF);
			}
		}
		else
		{
			PawnOwner.SetTimer(0.1f, FALSE, 'EndInteraction', Self);
		}
	}
}

/**
 * Notification called when body stance animation finished playing.
 * @param	SeqNode		- Node that finished playing. You can get to the SkeletalMeshComponent by looking at SeqNode->SkelComponent
 * @param	PlayedTime	- Time played on this animation. (play rate independant).
 * @param	ExcessTime	- how much time overlapped beyond end of animation. (play rate independant).
 */
function BS_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	// See if we're finished
	if( CheckForFinishEngage(true) && PawnOwner.Role == ROLE_Authority )
	{
		PawnOwner.ServerEndSpecialMove();
	}
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	local BodyStance LoopStance;
	local array<SequenceEvent> EngageEvents;
	local SeqEvt_Engage EngageEvent;

	if( PawnOwner.EngageTrigger != None )
	{
		if( PawnOwner.EngageTrigger.ENGAGE_AnimName_Loop != '' &&
			(PawnOwner.EngageTrigger.ENGAGE_bPlayAnimationForHeavyWeapons || PawnOwner.MyGearWeapon.WeaponType != WT_Heavy) )
		{
			LoopStance.Stance.Length = 1; // Array of struct needs to be pre-sized.
			LoopStance.Stance[0].Slot = BS_FullBody;
			LoopStance.Stance[0].AnimName = PawnOwner.EngageTrigger.ENGAGE_AnimName_Loop;

			// Stop animation
			PawnOwner.BS_SetAnimEndNotify(LoopStance, FALSE);
			PawnOwner.BS_Stop(LoopStance, 0.2f);

			// Turn off Root motion on animation node
			PawnOwner.BS_SetRootBoneAxisOptions(LoopStance, RBA_Discard, RBA_Discard, RBA_Discard);

			if( PawnOwner.EngageTrigger.FindEventsOfClass(class'SeqEvt_Engage', EngageEvents) )
			{
				EngageEvent = SeqEvt_Engage(EngageEvents[0]);
				if( EngageEvent != None && EngageEvent.bEnabled )
				{
					// don't check fov since the camera could be anywhere
					EngageEvent.bCheckInteractFOV = FALSE;
					// fire the "Interact ended" event
					PawnOwner.EngageTrigger.TriggerEventClass( class'SeqEvt_Engage', PawnOwner, eENGAGEOUT_InteractEnd );
					// reset the fov check
					EngageEvent.bCheckInteractFOV = TRUE;
				}
			}
		}
	}

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

defaultproperties
{
	MaxFFScale=1.f;
	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformGrab1
		Samples(0)=(LeftAmplitude=30,RightAmplitude=30,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=0.800)
	End Object
	EngageLoopFF=ForceFeedbackWaveformGrab1
}
