/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_PrepareSpecialMove extends AICommand
	within GearAI;

/** GoW global macros */

var GearPawn InteractionPawn;
var int SpecialMoveFlags;
var vector AlignOffset;

static function bool PrepareSpecialMove( GearAI AI, optional GearPawn InInteractionPawn, optional int InSpecialMoveFlags, optional vector InAlignOffset )
{
	local AICmd_PrepareSpecialMove Cmd;

	if( AI != None )
	{
		Cmd = new(AI) default.class;
		if( Cmd != None )
		{
			Cmd.InteractionPawn = InInteractionPawn;
			Cmd.SpecialMoveFlags = InSpecialMoveFlags;
			Cmd.AlignOffset = InAlignOffset;
			AI.PushCommand( Cmd );
			return TRUE;
		}
	}

	return FALSE;
}

function Pushed()
{
	Super.Pushed();
	bIgnoreStepAside=true;
	ReactionManager.SuppressAllChannels();
	ClearMoveAction();
	GotoState('Prepare');
}

function Popped()
{
	Super.Pushed();
	ReactionManager.UnSuppressAllChannels();
	bIgnoreStepAside=false;
}

function bool ShouldIgnoreTimeTransitions()
{
	return TRUE;
}


state Prepare 
{
Begin:
	`AILog(self@GetStatename()@"preparing special move for "@SpecialMoveAlignActor);
	//InvalidateCover(); // Removed because this causes issues for cover-based special moves
	StopFiring();
	if (SpecialMoveAlignActor != None)
	{
		SetFocalPoint( SpecialMoveAlignActor.Location + AlignOffset >> SpecialMoveAlignActor.Rotation, TRUE );

		bPreciseDestination = TRUE;

		do 
		{
			SetMoveGoal(SpecialMoveAlignActor,InteractionPawn,,VSize(AlignOffset));
		} until( ChildStatus == 'Success');
		`AILog("Reached align destination");

		Focus = None;
		SetFocalPoint( SpecialMoveAlignActor.Location + AlignOffset >> SpecialMoveAlignActor.Rotation, TRUE );

		// set desiredrotation since that's what finish rotation requires
		SetDesiredRotation(rotator(GetFocalPoint() - Pawn.Location));
		FinishRotation();
		`AILog("Finished rotating to align destination");
	}
	if (QueuedSpecialMove == SM_Engage_Start)
	{
		MyGearPawn.EngageTrigger = Trigger_Engage(SpecialMoveAlignActor);
		
		// special hacky handling for wheel turns!
		`AILog("Doing SM_Engage_Start"@MyGearPawn.EngageTrigger);
		MyGearPawn.DoSpecialMove(SM_Engage_Start,TRUE);
		//MT-> this is called from GSM_EngageSTart::TickSpecialMove, calling twice causes anim to play twice 
		// GSM_EngageStart(MyGearPawn.SpecialMoves[SM_Engage_Start]).StartGrabAnim();
		do
		{
			Sleep(0.1f);
		}
		until (MyGearPawn.SpecialMove == SM_Engage_Idle||MyGearPawn.SpecialMove == SM_None);
		if (MyGearPawn.EngageTrigger.ENGAGE_AnimName_Loop != '')
		{
			do
			{
				// check to see if this is an unlinked trigger, or if the linked trigger is ready to be turned
				if (MyGearPawn.EngageTrigger.LoopCounter > 0 &&
					(MyGearPawn.EngageTrigger.LinkedCoopTrigger == None ||
					 (WorldInfo.TimeSeconds - MyGearPawn.EngageTrigger.LinkedCoopTrigger.LastAttemptTurnTime > MyGearPawn.EngageTrigger.LinkedCoopTrigger.ENGAGE_LoopDelay &&
					  MyGearPawn.EngageTrigger.LinkedCoopTrigger.EngagedPawn != None &&
					  (MyGearPawn.EngageTrigger.LinkedCoopTrigger.EngagedPawn.IsDoingSpecialMove(SM_Engage_Loop) ||
					   MyGearPawn.EngageTrigger.LinkedCoopTrigger.EngagedPawn.IsDoingSpecialMove(SM_Engage_Idle)))))
				{
					// Make sure the AI is only turning it to keep up with the player (don't want him non-stop turning)
					if (MyGearPawn.EngageTrigger.LinkedCoopTrigger != None &&
						MyGearPawn.EngageTrigger.LinkedCoopTrigger.LoopCounter < MyGearPawn.EngageTrigger.LoopCounter)
					{
						`AILog("Doing SM_Engage_Loop"@MyGearPawn.EngageTrigger.LoopCounter);
						MyGearPawn.EngageTrigger.LastAttemptTurnTime = WorldInfo.TimeSeconds;
						MyGearPawn.DoSpecialMove(SM_Engage_Loop,TRUE);
						do
						{
							Sleep(0.1f);
						}
						until (MyGearPawn.SpecialMove == SM_Engage_Idle || MyGearPawn.SpecialMove == SM_None);
					}
					else
					{
						Sleep(0.25f);
					}
				}
				else
				{
					Sleep(0.25f);
				}
			}
			until (MyGearPawn.SpecialMove == SM_None);
		}
		else
		{
			`AILog("Skipping automatic engage looping."@MyGearPawn.EngageTrigger);
			MyGearPawn.DoSpecialMove(SM_Engage_End,TRUE);
		}
	}
	else
	{
		MyGearPawn.DoSpecialMove(QueuedSpecialMove, TRUE, InteractionPawn, SpecialMoveFlags);
		// wait for the sm to finish
		do
		{
			Sleep(0.1f);
		} until (MyGearPawn.SpecialMove == SM_None);
	}
	GotoState('DelaySuccess');
}

DefaultProperties
{
	bIgnoreNotifies=true
}
