/**
 * Play a tempest tower animations
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Tempest_Tower extends GearSpecialMove;

/** Animations for the tower sequence */
var GearPawn.BodyStance BS_Land;
var Array<BodyStance> BS_AttackList;
var GearPawn.BodyStance BS_Takeoff;
var GearPawn.BodyStance BS_HurtLeft;
var GearPawn.BodyStance BS_HurtRight;

/** The animation currently playing */
var GearPawn.BodyStance BS_Current;
/** The last attack animation played */
var GearPawn.BodyStance BS_LastAttack;

/** Reference to the tempest */
var GearPawn_LocustTempestBase Tempest;

/** Structure to handle the pattern the tempest should animate when getting hurt */
struct TempestHurtConfig
{
	/** Array of the order of anims to use */
	var array<Name> AnimList;
};

/** List of anim configs for when the tempest gets hurt */
var array<TempestHurtConfig> HurtConfigList;

/** Current and previous indexes in the hurt list for which config to use */
var transient int CurrHurtListIdx;
var transient int PrevHurtListIdx;
/** Current index in the config list we are on right now */
var transient int CurrAnimIdx;


/** Overwrite so we can open the mouth **/
function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Tempest = GearPawn_LocustTempestBase(PawnOwner);
	Tempest.StartBackEffects();

	Super.SpecialMoveStarted(bForced, PrevMove);

	BS_Current = BS_Land;
	PawnOwner.BS_Play(BS_Current, 1.0f, 0.2f, 0.2f);
	PawnOwner.BS_SetAnimEndNotify(BS_Current, TRUE);
	PawnOwner.BS_SetRootBoneAxisOptions(BS_Current, RBA_Translate, RBA_Translate, RBA_Translate);
	PawnOwner.BS_SetRootRotationOption(BS_Current, RRO_Extract);
	PawnOwner.Mesh.RootMotionMode = RMM_Translate;
	PawnOwner.Mesh.RootMotionRotationMode = RMRM_RotateActor;

	SetHurtListIndex();
	CurrAnimIdx = 0;
}

/** Called when the animations finish */
function BS_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	if (BS_Current == BS_Land)
	{
		Tempest.bOnTower = true;
		Tempest.ActivateGroundMode(true);
		Tempest.ResetIdle();
	}

	if (BS_Current != BS_Takeoff)
	{
		BS_Current = GetAttackAnimation();
		PawnOwner.BS_Play(BS_Current, 1.0f, 0.2f, 0.2f);
		PawnOwner.BS_SetAnimEndNotify(BS_Current, TRUE);
		PawnOwner.BS_SetRootBoneAxisOptions(BS_Current, RBA_Translate, RBA_Translate, RBA_Translate);
		PawnOwner.BS_SetRootRotationOption(BS_Current, RRO_Extract);
	}
	else
	{
		PawnOwner.EndSpecialMove();
	}
}

/** Whether the tempest is in an animation that we will allow it to take damage */
function bool CanTakeDamage()
{
	local int Idx;

	for (Idx = 0; Idx < BS_AttackList.Length; Idx++)
	{
		if (BS_AttackList[Idx] == BS_Current)
		{
			return true;
		}
	}

	return false;
}

/** called when DoSpecialMove() is called again with this special move, but the special move flags have changed */
function SpecialMoveFlagsUpdated()
{
	local Name AnimName;

	if (PawnOwner.SpecialMoveFlags >= 5)
	{
		DoTakeOff();
	}
	else if (PawnOwner.SpecialMoveFlags > 0)
	{
		CurrAnimIdx = PawnOwner.SpecialMoveFlags - 1;
		AnimName = HurtConfigList[CurrHurtListIdx].AnimList[CurrAnimIdx];
		if (AnimName == 'Left')
		{
			BS_Current = BS_HurtLeft;
		}
		else
		{
			BS_Current = BS_HurtRight;
		}
		PawnOwner.BS_Play(BS_Current, 1.0f, 0.2f, 0.2f);
		PawnOwner.BS_SetAnimEndNotify(BS_Current, TRUE);
		PawnOwner.BS_SetRootBoneAxisOptions(BS_Current, RBA_Translate, RBA_Translate, RBA_Translate);
		PawnOwner.BS_SetRootRotationOption(BS_Current, RRO_Extract);
	}
}

/** Kicks off the takeoff animation and will eventually end the move */
simulated function DoTakeOff()
{
	if (BS_Current != BS_Takeoff)
	{
		BS_Current = BS_Takeoff;
		PawnOwner.BS_Play(BS_Current, 1.0f, 0.2f, 0.2f);
		PawnOwner.BS_SetAnimEndNotify(BS_Current, TRUE);
		PawnOwner.BS_SetRootBoneAxisOptions(BS_Current, RBA_Translate, RBA_Translate, RBA_Translate);
		PawnOwner.BS_SetRootRotationOption(BS_Current, RRO_Extract);
	}
}

/** Overwrite so we can close the mouth **/
function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	// unset root motion
	PawnOwner.BS_SetRootBoneAxisOptions(BS_Current, RBA_Discard, RBA_Discard, RBA_Discard);
	PawnOwner.BS_SetRootRotationOption(BS_Current, RRO_Discard);
	PawnOwner.Mesh.RootMotionMode = PawnOwner.default.Mesh.RootMotionMode;
	PawnOwner.Mesh.RootMotionRotationMode = PawnOwner.default.Mesh.RootMotionRotationMode;

	Tempest.ActivateGroundMode(false);
	Tempest.ResetIdle();

	Tempest.bOnTower = false;
	Tempest.StopBackEffects();

	Super.SpecialMoveEnded(PrevMove, NextMove);

	Tempest.TriggerEventClass(class'SeqEvt_TempestAnimFinished', Tempest, 2);
}

function GearPawn.BodyStance GetAttackAnimation()
{
	local int RandomNumber;

	RandomNumber = Rand(BS_AttackList.Length);
	if (BS_AttackList[RandomNumber] == BS_LastAttack)
	{
		RandomNumber = (RandomNumber + 1) % BS_AttackList.Length;
	}

	BS_LastAttack = BS_AttackList[RandomNumber];
	return BS_LastAttack;
}

function SetHurtListIndex()
{
	CurrHurtListIdx = Rand(HurtConfigList.Length);
	if (CurrHurtListIdx == PrevHurtListIdx)
	{
		CurrHurtListIdx = (CurrHurtListIdx + 1) % HurtConfigList.Length;
	}

	PrevHurtListIdx = CurrHurtListIdx;
}


defaultproperties
{
	BS_Land=(Stance=((Slot=BS_FullBody,AnimName="Land_Tower")))
	BS_Takeoff=(Stance=((Slot=BS_FullBody,AnimName="Takeoff_Tower")))
	BS_AttackList(0)=(Stance=((Slot=BS_FullBody,AnimName="Idle_Tower_1")))

	BS_HurtLeft=(Stance=((Slot=BS_FullBody,AnimName="HitReaction_Tower_Left")))
	BS_HurtRight=(Stance=((Slot=BS_FullBody,AnimName="HitReaction_Tower_Right")))

	HurtConfigList(0)=(AnimList=("Left","Right","Right","Left"))
	HurtConfigList(1)=(AnimList=("Right","Left","Left","Right"))
	HurtConfigList(2)=(AnimList=("Right","Right","Left","Left"))
	HurtConfigList(3)=(AnimList=("Left","Right","Left","Right"))
	HurtConfigList(4)=(AnimList=("Right","Left","Right","Left"))

	bDisableAI=TRUE
	bLockPawnRotation=TRUE

	PrevHurtListIdx=INDEX_NONE
}
