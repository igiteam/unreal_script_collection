/**
 * Play a tempest sneak animations
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Tempest_Sneak extends GearSpecialMove;

/** Animations for the sneak sequence */
var GearPawn.BodyStance BS_Start;
var GearPawn.BodyStance BS_Loop;
var GearPawn.BodyStance BS_End;

/** The animation currently playing */
var GearPawn.BodyStance BS_Current;

/** Reference to the tempest */
var GearPawn_LocustTempestBase Tempest;
var GearAI_LocustTempest TempestAI;

/** Length of time to do the beam attack */
var float BeamAttackTime;

/** Object to shoot the beam at */
var Actor BeamTarget;

/** Overwrite so we can open the mouth **/
function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Tempest = GearPawn_LocustTempestBase(PawnOwner);
	TempestAI = GearAI_LocustTempest(PawnOwner.Controller);

	Super.SpecialMoveStarted(bForced, PrevMove);

	BS_Current = BS_Start;
	PawnOwner.BS_Play(BS_Current, 1.0f, 0.2f, 0.2f);
	PawnOwner.BS_SetRootBoneAxisOptions(BS_Current, RBA_Translate, RBA_Translate, RBA_Translate);
	PawnOwner.BS_SetAnimEndNotify(BS_Current, TRUE);
	PawnOwner.Mesh.RootMotionMode = RMM_Translate;

	PawnOwner.SetTimer(0.1f, false, nameof(StartBeamAttack), self);
}

/** Start firing the weapon */
function StartBeamAttack()
{
	if (TempestAI != None)
	{
		TempestAI.FireTarget = BeamTarget;
		TempestAI.BeamAttackTarget = BeamTarget;
		TempestAI.StartFiring();
	}
}

/** Called when the animations finish */
function BS_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	if (BS_Current == BS_Start)
	{
		Tempest.ActivateGroundMode(true);
		Tempest.ResetIdle();
		BS_Current = BS_Loop;
		PawnOwner.BS_Play(BS_Current, 1.0f, 0.2f, 0.2f, true);
		PawnOwner.BS_SetRootBoneAxisOptions(BS_Current, RBA_Translate, RBA_Translate, RBA_Translate);
		PawnOwner.SetTimer(BeamAttackTime, false, nameof(FinishSneakAttack), self);
	}
	else if (BS_Current == BS_End)
	{
		PawnOwner.EndSpecialMove();
	}
}

/** Kicks off the exit animation and will eventually end the move */
simulated function FinishSneakAttack()
{
	BS_Current = BS_End;
	PawnOwner.BS_Play(BS_Current, 1.0f, 0.2f, 0.2f);
	PawnOwner.BS_SetRootBoneAxisOptions(BS_Current, RBA_Translate, RBA_Translate, RBA_Translate);
	PawnOwner.BS_SetAnimEndNotify(BS_Current, TRUE);
	TempestAI.StopFiring();
}

/** Overwrite so we can close the mouth **/
function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	// unset root motion
	PawnOwner.BS_SetRootBoneAxisOptions(BS_Current, RBA_Discard, RBA_Discard, RBA_Discard);
	PawnOwner.Mesh.RootMotionMode = PawnOwner.default.Mesh.RootMotionMode;

	Tempest.ActivateGroundMode(false);
	Tempest.ResetIdle();

	Super.SpecialMoveEnded(PrevMove, NextMove);

	Tempest.TriggerEventClass(class'SeqEvt_TempestAnimFinished', Tempest, 1);
}

defaultproperties
{
	BS_Start=(Stance=((Slot=BS_FullBody,AnimName="Land_Sneak")))
	BS_Loop=(Stance=((Slot=BS_FullBody,AnimName="Attack_Sneak")))
	BS_End=(Stance=((Slot=BS_FullBody,AnimName="Takeoff_Sneak")))

	bDisableAI=TRUE
	bLockPawnRotation=TRUE
	BeamAttackTime=2.0f
}
