
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_CoverHead extends GearSpecialMove
	config(Pawn);

/** Mantle over animation */
var GearPawn.BodyStance BS_Start;
var GearPawn.BodyStance BS_Loop;
var GearPawn.BodyStance BS_End;

/** This is how long a pawn will spend covering their head when doing this SpecialMove **/
var protected config float TimeSpentCoveringHead;
/** length of ending anim */
var config float EndDuration;

protected function bool InternalCanDoSpecialMove()
{
`if(`notdefined(FINAL_RELEASE))
	// debugging headshots, don't move
	if (PawnOwner.bWeaponDebug_HeadShotLocation)
	{
		return false;
	}
`endif

	// don't cover head if in cover
	return (PawnOwner.DrivenVehicle == None && Super.InternalCanDoSpecialMove());
}

function bool CanOverrideSpecialMove(ESpecialMove InMove)
{
	return (InMove == PawnOwner.SpecialMove && PawnOwner.CanCoverHead());
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local float StartDuration, LoopDuration, CustomDuration;

	Super.SpecialMoveStarted(bForced,PrevMove);

	// Passed in custom duration
	CustomDuration = float(PawnOwner.SpecialMoveFlags) / 10.0;

	// Play intro animation
	StartDuration = PawnOwner.BS_Play(BS_Start, SpeedModifier, 0.2 / SpeedModifier, -1.0, false, true);

	TimeSpentCoveringHead = (CustomDuration > 0) ? FMax(0.01, CustomDuration - StartDuration - (EndDuration * SpeedModifier)) : default.TimeSpentCoveringHead;

	// Go to loop animation in x seconds and loop for a total of x seconds
	LoopDuration = StartDuration + TimeSpentCoveringHead;

	PawnOwner.SetTimer(StartDuration, false, nameof(StartAnimDone), self);
	PawnOwner.SetTimer(LoopDuration, false, nameof(LoopAnimDone), self);
}

function StartAnimDone()
{
	PawnOwner.ClearTimer('StartAnimDone', self);
	PawnOwner.BS_Stop(BS_Start, 0.2 / SpeedModifier);

	PawnOwner.BS_Play(BS_Loop, SpeedModifier, 0.2 / SpeedModifier, 0.0, true, true);
}

function LoopAnimDone()
{
	local float AnimTime;

	// Clear Timers.
	PawnOwner.ClearTimer(nameof(StartAnimDone), self);
	PawnOwner.ClearTimer(nameof(LoopAnimDone), self);

	// Stop cringe anims, play the end cringe animation.
	PawnOwner.BS_Stop(BS_Start, 0.2 / SpeedModifier);
	PawnOwner.BS_Stop(BS_Loop, 0.2 / SpeedModifier);

	AnimTime = EndDuration * SpeedModifier;
	PawnOwner.BS_PlayByDuration(BS_End, AnimTime, 0.2 / SpeedModifier, 0.3 / SpeedModifier, false, true);
	PawnOwner.SetTimer(AnimTime, false, nameof(EndSpecialMove), self);
}

function EndSpecialMove()
{
	PawnOwner.EndSpecialMove();
}

/** This will stop the special move while still playing the transition-out anim. */
function StopCoveringHead()
{
	if (PawnOwner.IsTimerActive(nameof(StartAnimDone), self))
	{
		// haven't made it to the loop yet
		StartAnimDone();
		LoopAnimDone();

		PawnOwner.ClearTimer(nameof(StartAnimDone), self);
		PawnOwner.ClearTimer(nameof(LoopAnimDone), self);
	}
	else if (PawnOwner.IsTimerActive(nameof(LoopAnimDone), self))
	{
		LoopAnimDone();
		PawnOwner.ClearTimer(nameof(LoopAnimDone), self);
	}
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	// Stop cringe anims, play the end cringe animation.
	PawnOwner.BS_Stop(BS_Start, 0.2 / SpeedModifier);
	PawnOwner.BS_Stop(BS_Loop, 0.2 / SpeedModifier);
	PawnOwner.BS_Stop(BS_End, 0.2 / SpeedModifier);

	PawnOwner.ClearTimer(nameof(StartAnimDone), self);
	PawnOwner.ClearTimer(nameof(LoopAnimDone), self);
	PawnOwner.ClearTimer(nameof(EndSpecialMove), self );

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

defaultproperties
{
	BS_Start=(Stance=((Slot=BS_FullBody,AnimName="ar_injured_headcover1_start")))
	BS_Loop=(Stance=((Slot=BS_FullBody,AnimName="ar_injured_headcover1_idle")))
	BS_End=(Stance=((Slot=BS_FullBody,AnimName="ar_injured_headcover1_end")))

	bShouldAbortWeaponReload=true
	bCanFireWeapon=false

	bBreakFromCover=true
	bDisableMovement=true
	bLockPawnRotation=true
	DefaultAICommand=class'AICmd_Base_PushedBySpecialMove'
}
