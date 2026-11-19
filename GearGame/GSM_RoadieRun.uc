
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_RoadieRun extends GearSpecialMove
	DependsOn(GearPawn)
	native(SpecialMoves);

/** timer before aborting the special move, basically tracks time when velocity is less than 30% of groundspeed */
var transient float RunAbortTimer;

/** refs to currently playing looping sounds */
var array<AudioComponent> LoopingSounds;

// Double click move flags
var bool bWasForward;
var bool bWasBack;
var bool bWasLeft;
var bool bWasRight;
var bool bEdgeForward;
var bool bEdgeBack;
var bool bEdgeLeft;
var bool bEdgeRight;

var() protected const vector2d	RRCameraTurnTime;

/** True if turning/steering is temporarily disabled. */
var protected transient bool bDisableSteering;

/** True if transitions to the rear should be disabled. Will either clamp to the side or go forwards */
var() protected const bool bDisallowReverseTransitions;

/** Whether or not to immediately check to see if the move should be aborted once it starts */
var bool bCheckForCancelAtStart;

/** The percentage of DefaultGroundSpeed the player must be moving at to not be considered for stopping */
var float MinSpeedPercent;
/** The maximum amount of time the player can be moving below minspeedpercent before the run ends */
var float MaxSlowTime;
/** percentage of input to apply to steering (i.e. how fast players can turn) */
var float SteeringPct;

//Whether or not to stop the looping sounds at the end of the move
var bool bStopLoopingSoundsAtEndOfMove;

/** If set the camera turn transitions are entirely disabled */
var bool bIgnoreCameraTurn;

cpptext
{
	virtual void TickSpecialMove(FLOAT DeltaTime);
};

/** Takes into account boost and shield. */
native function float GetSpeedModifier();

/**
* On server only, possibly save chained move
* @Return TRUE if move could be chained to this one
*/
function bool CanChainMove(ESpecialMove NextMove)
{
	return (NextMove == SM_Run2MidCov || NextMove == SM_Run2StdCov || NextMove == SM_MantleDown || NextMove == SM_LadderClimbUp || NextMove == SM_LadderClimbDown);
}

/** Notification called when body stance animation finished playing */
simulated function BS_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	if ( !PawnOwner.IsLocallyControlled() )
	{
		//`log("Don't animend roadierun on non-owning animend!");
		return;
	}
	super.BS_AnimEndNotify(SeqNode, PlayedTime, ExcessTime);
}

protected function bool InternalCanDoSpecialMove()
{
	// don't allow if temporary disabled (covering head)
	if( PawnOwner.bCannotRoadieRun || ( PawnOwner.MyGearWeapon != None && !PawnOwner.MyGearWeapon.bAllowsRoadieRunning ) )
	{
		return FALSE;
	}

	// don't allow if in cover and not about to break from it
	if ( PawnOwner.CoverType != CT_None && (PawnOwner.SpecialMove == SM_None || !PawnOwner.SpecialMoves[PawnOwner.SpecialMove].bBreakFromCoverOnEnd) &&
		 PawnOwner.SpecialMove != SM_CoverSlip &&
		(PawnOwner.SpecialMove != SM_None || PCOwner == None || !PCOwner.bBreakFromCover) )
	{
		return FALSE;
	}

	// don't allow if stuck in a walk volume
	if ( WalkVolume(PawnOwner.PhysicsVolume) != None &&
		 WalkVolume(PawnOwner.PhysicsVolume).bActive )
	{
		return FALSE;
	}

	if (PawnOwner.bIsConversing || PawnOwner.bWantToConverse)
	{
		return FALSE;
	}

	if ( (PawnOwner.Health <= 0) && !PawnOwner.IsDBNO() )
	{
		// could be waiting to go dbno (bDelayedDBNO on server)
		return FALSE;
	}

	return TRUE;
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local rotator	NewPlayerRot;
	local float		YawDiff, Pct, CamTurnTime;
	local			GearGameplayCamera Cam;
	local Vector	Direction, X, Y, Z;
	local array<SequenceEvent> TouchEvents;
	local actor		A;
	local int		i;

   	Super.SpecialMoveStarted(bForced,PrevMove);

	RunAbortTimer = 0.f;
	bDisableSteering = false;

	// for players, turn to face direction he's trying to move
	if (PCOwner != None)
	{
		if (bCheckForCancelAtStart)
		{
			// double-check the player is still holding the A button, in cases where the move was chained but the player later released the button
			if (PCOwner.IsLocalPlayerController() && !PCOwner.IsHoldingRoadieRunButton() && !PCOwner.bForcedRoadieRun)
			{
				// make sure to call it on the playercontroller so that it's replicated to the server
				PCOwner.EndSpecialMove();
				return;
			}
		}

		GetAxes(PCOwner.Rotation, X, Y, Z);

		// Local player may have dirtied remapped joy variables if in cover
		if (PCOwner.PlayerInput != None)
		{
			PCOwner.RemappedJoyUp = PCOwner.PlayerInput.RawJoyUp;
			PCOwner.RemappedJoyRight = PCOwner.PlayerInput.RawJoyRight;
		}

		// go in direction stick is pointing
		Direction = Normal((PCOwner.RemappedJoyUp * X) + (PCOwner.RemappedJoyRight * Y));

		// @fixme jf, using vel here is suboptimal, cuz it doesn't directly map to
		// player desires (like the stick does).  But using raw stick values doesn't
		// do well in multi, so coming up with something here would be good.
		// That is, if this iteration of roadie run survives. :)
		if( !bIgnoreCameraTurn )
		{
			if (!IsZero(Direction))
			{
				NewPlayerRot = Rotator(Direction);

				// figure how far we turned so we can turn the camera smoothly into the new orientation
				YawDiff = NormalizeRotAxis(PCOwner.Rotation.Yaw - NewPlayerRot.Yaw);

				// If we're near from 90-105 degrees off, clamp it to 90. Otherwise ignore the desired rotation and go straight
				if (bDisallowReverseTransitions)
				{
					if (YawDiff < -19000 || YawDiff > 19000)
					{
						YawDiff = 0;
					}
					else
					{
						YawDiff = Clamp(YawDiff, -16384, 16384);
					}
					NewPlayerRot.Yaw = PCOwner.Rotation.Yaw - YawDiff;
				}

				// turn the player
				PCOwner.SetRotation( NewPlayerRot );

				// start executing a code-driven camera turn
				Cam = GearPlayerCamera(PCOwner.PlayerCamera).GameplayCam;
				if (Cam != None)
				{
					// some minor gymnastics here to find a function that feels good.
					// we want a snappier turn at 180, but we can tolerate a slower rate
					// closer to 0.  0.9 is the time to rotate at 180, and 0.6 is the
					// time to rotate at 0.
					Pct = Abs(YawDiff) / 32768.f;

					Pct = Sqrt(Pct);		// good feeling function
					CamTurnTime = GetRangeValueByPct(RRCameraTurnTime, Pct);

					Cam.BeginTurn(YawDiff, 0, CamTurnTime, 0.f);
					bDisableSteering = TRUE;
					PawnOwner.SetTimer(CamTurnTime, FALSE, nameof(EndRoadieRunSteeringDelay), self);
				}
			}
		}
	}

	StartLoopingSounds();

	PawnOwner.StartRoadieRunPSC();

	// Trigger the roadie run delegates in the PC
	if ( PCOwner != None )
	{
		PCOwner.TriggerGearEventDelegates( eGED_RoadieRun );
	}

	foreach PawnOwner.TouchingActors(class'Actor', A)
	{
		if (A.FindEventsOfClass(class'SeqEvt_GearTouch', TouchEvents))
		{
			for (i = 0; i < TouchEvents.length; i++)
			{
				SeqEvt_GearTouch(TouchEvents[i]).CheckRoadieRunTouchActivate(A,PawnOwner,true);
			}
			// clear array for next iteration
			TouchEvents.length = 0;
		}
	}
}

function StartLoopingSounds()
{
	if( PCOwner != None &&
		PCOwner.IsLocalPlayerController() == TRUE &&
		(PawnOwner.Health / PawnOwner.DefaultHealth) < 0.40f )
	{
		LoopingSounds[LoopingSounds.Length] = PawnOwner.SoundGroup.PlayFoleySoundEx(PawnOwner, GearFoley_FastHeartbeat, 2.f);
	}
	// if we are not already breathing from being close to death
	if( PawnOwner.NearDeathBreathSound == none )
	{
		LoopingSounds[LoopingSounds.Length] = PawnOwner.SoundGroup.PlayEffortEx(PawnOwner, GearEffort_RoadieRunBreathe, 2.f);
	}
}

function StopLoopingSounds()
{
	local int i;
	// stop all of the looped sounds
	for( i = 0; i < LoopingSounds.Length; ++i )
	{
		if (LoopingSounds[i] != None)
		{
			LoopingSounds[i].FadeOut(1.f, 0.f);
		}
	}
	LoopingSounds.Length = 0;
}


function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	local int i;
	local array<SequenceEvent> TouchEvents;
	local actor		A;

	Super.SpecialMoveEnded(PrevMove, NextMove);

	if (bStopLoopingSoundsAtEndOfMove)
	{
		StopLoopingSounds();
	}

	if( PawnOwner.PSC_RoadieRun != none )
	{
		PawnOwner.PSC_RoadieRun.DeActivateSystem();
		PawnOwner.SetTimer( 1.0f, FALSE, nameof(PawnOwner.HideRoadieRunPSC) );
	}

	PawnOwner.RoadieRunBoostTime = -9999.f;

	foreach PawnOwner.TouchingActors(class'Actor', A)
	{
		if (A.FindEventsOfClass(class'SeqEvt_GearTouch', TouchEvents))
		{
			for (i = 0; i < TouchEvents.length; i++)
			{
				SeqEvt_GearTouch(TouchEvents[i]).CheckRoadieRunTouchActivate(A,PawnOwner,false);
			}
			// clear array for next iteration
			TouchEvents.length = 0;
		}
	}

	if( PCOwner != None && GearPlayerInput(PCOwner.PlayerInput) != None )
	{
		GearPlayerInput(PCOwner.PlayerInput).ForcePitchCentering(TRUE, TRUE, 0);
	}

	PawnOwner.LastRoadieRunTime = PawnOwner.WorldInfo.TimeSeconds;

	// check for chaining into a ladder climb
	if (NextMove == SM_None && PCOwner != None && PawnOwner.IsLocallyControlled())
	{
		if (PawnOwner.CanDoSpecialMove(SM_LadderClimbUp))
		{
			PCOwner.DoSpecialMove(SM_LadderClimbUp);
		}
		else if (PawnOwner.CanDoSpecialMove(SM_LadderClimbDown))
		{
			PCOwner.DoSpecialMove(SM_LadderClimbDown);
		}
	}
}

simulated function EndRoadieRunSteeringDelay()
{
	bDisableSteering = FALSE;
}

simulated function PreProcessInput(GearPlayerInput Input)
{
	// Check for Double click movement.
	// Store before wiping out inputs so that we can detect double clicks for evade during RR
	bEdgeForward	= (bWasForward	^^ (Input.aBaseY  > 0));
	bEdgeBack		= (bWasBack		^^ (Input.aBaseY  < 0));
	bEdgeLeft		= (bWasLeft		^^ (Input.aStrafe < 0));
	bEdgeRight		= (bWasRight	^^ (Input.aStrafe > 0));
	bWasForward		= (Input.aBaseY	 > 0);
	bWasBack		= (Input.aBaseY	 < 0);
	bWasLeft		= (Input.aStrafe < 0);
	bWasRight		= (Input.aStrafe > 0);

	// force running forwards
	Input.aBaseY	= 1.f;

	// strafe becomes turning
	Input.aTurn		= bDisableSteering ? 0.f : (Input.aStrafe * SteeringPct);
	Input.aStrafe	= 0.f;
}

simulated function PreDoubleClickCheck( GearPlayerInput_Base Input )
{
	// Restore DClick info for player input to detect
	Input.bWasForward	= bWasForward;
	Input.bWasBack		= bWasBack;
	Input.bWasLeft		= bWasLeft;
	Input.bWasRight		= bWasRight;
	Input.bEdgeForward	= bEdgeForward;
	Input.bEdgeBack		= bEdgeBack;
	Input.bEdgeLeft		= bEdgeLeft;
	Input.bEdgeRight	= bEdgeRight;
}

defaultproperties
{
	bNoStoppingPower=FALSE
	bCanFireWeapon=FALSE

	bDoMeshFloorConform=FALSE
	bDoIKFloorConform=FALSE
	bDoFootPlacement=FALSE

	RRCameraTurnTime=(X=0.15f,Y=0.9f)
	bDisallowReverseTransitions=false

	bCheckForCancelAtStart=true

	MinSpeedPercent=0.3
	MaxSlowTime=0.5
	SteeringPct=0.33

	bStopLoopingSoundsAtEndOfMove=TRUE

	bDeferWeaponSwitch=TRUE

	bShowHUDActions=TRUE
}
