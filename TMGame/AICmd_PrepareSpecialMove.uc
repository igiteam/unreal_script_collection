class AICmd_PrepareSpecialMove extends AICommand
	within TGAI;

var bool bOldIgnoreStepAside;

/** GoW global macros */

function Pushed()
{
	Super.Pushed();
	bOldIgnoreStepAside = bIgnoreStepAside;
	bIgnoreStepAside=true;
	ReactionManager.SuppressAllChannels();
	GotoState('Prepare');
}

function Popped()
{
	Super.Pushed();
	ReactionManager.UnSuppressAllChannels();
	//bIgnoreStepAside=false;
    bIgnoreStepAside = bOldIgnoreStepAside;
}

function bool ShouldIgnoreTimeTransitions()
{
	return TRUE;
}


state Prepare
{
Begin:
	;
	InvalidateCover();
	StopFiring();
	if (SpecialMoveAlignActor != None)
	{
		SetFocalPoint( SpecialMoveAlignActor.Location + vector(SpecialMoveAlignActor.Rotation) * 1024.f, TRUE );
		if (VSize(SpecialMoveAlignActor.Location - Pawn.Location) > 512.f)
		{
			bPreciseDestination = TRUE;
			SetMoveGoal(SpecialMoveAlignActor,,,32.f);
			;
		}
		else
		{
			Pawn.SetLocation(SpecialMoveAlignActor.Location);
			;
		}
		Focus = None;
		SetFocalPoint( SpecialMoveAlignActor.Location + vector(SpecialMoveAlignActor.Rotation) * 1024.f, TRUE );
		// set desiredrotation since that's what finish rotation requires
		SetDesiredRotation(rotator(GetFocalPoint() - Pawn.Location));
		FinishRotation();
		;
	}
	if (QueuedSpecialMove == SM_Engage_Start)
	{
		MyTGPawn.EngageTrigger = Trigger_Engage(SpecialMoveAlignActor);

		// special hacky handling for wheel turns!
		;
		MyTGPawn.DoSpecialMove(SM_Engage_Start,TRUE);
		GSM_EngageStart(MyTGPawn.SpecialMoves[SM_Engage_Start]).StartGrabAnim();
		do
		{
			Sleep(0.1f);
		}
		until (MyTGPawn.SpecialMove == SM_Engage_Idle||MyTGPawn.SpecialMove == SM_None);
		do
		{
			MyTGPawn.EngageTrigger.LastAttemptTurnTime = WorldInfo.TimeSeconds;
			// check to see if this is an unlinked trigger, or if the linked trigger is ready to be turned
			if (MyTGPawn.EngageTrigger.LinkedCoopTrigger == None || (MyTGPawn.EngageTrigger.LinkedCoopTrigger.EngagedPawn != None && Abs(MyTGPawn.EngageTrigger.LastAttemptTurnTime - MyTGPawn.EngageTrigger.LinkedCoopTrigger.LastAttemptTurnTime) < 1.f))
			{
				;
				//`AILog("Doing SM_Engage_Loop");
				MyTGPawn.DoSpecialMove(SM_Engage_Loop,TRUE);
				do
				{
					Sleep(0.1f);
				}
				until (MyTGPawn.SpecialMove == SM_Engage_Idle||MyTGPawn.SpecialMove == SM_None);
			}
			else
			{
				Sleep(0.25f);
			}
		}
		until (MyTGPawn.SpecialMove == SM_None);

		MyTGPawn.DoSpecialMove(SM_Engage_End,TRUE);
	}
	else
	{
		MyTGPawn.DoSpecialMove(QueuedSpecialMove,TRUE);
		// wait for the sm to finish
		do
		{
			Sleep(0.1f);
		} until (MyTGPawn.SpecialMove == SM_None);
	}
	GotoState('DelaySuccess');
}

