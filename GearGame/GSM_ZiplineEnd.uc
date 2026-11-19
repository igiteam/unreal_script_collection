/**
 * Player exiting the zipline
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_ZiplineEnd extends GearSpecialMove;

/** The drop animation */
var BodyStance BS_Drop;

/** The mid-drop animation */
var BodyStance BS_MidDrop;

/** The roll animation */
var BodyStance BS_Roll;

var() InterpActor_ZiplineHookBase ZiplineBase;

/**
 * Start the body animation, switch to the pistol, and force targeting
 *
 * @param bForced - was the special move forced
 *
 * @param PrevMove - the previous special move to run
 */
function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced, PrevMove);

	ZiplineBase = InterpActor_ZiplineHookBase(PawnOwner.Base);
	PawnOwner.BS_Play(BS_Drop, 1.0f, 0.0f, -1.f);
	PawnOwner.BS_SetAnimEndNotify(BS_Drop, TRUE);
}

/** 
 * Transition to the next state based on the animation that just completed
 * 
 * @param SeqNode - the animation node sequence that just completed
 * 
 * @param PlayedTime - the length of the animation
 * 
 * @param ExcessTime - the overage time of the animation
 */
function BS_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	if (PawnOwner.BS_SeqNodeBelongsTo(SeqNode, BS_Drop))
	{
		PawnOwner.BS_SetAnimEndNotify(BS_Drop, FALSE);

		PawnOwner.BS_Play(BS_MidDrop, 1.0f, 0.0f, -1.f);
		PawnOwner.BS_SetAnimEndNotify(BS_MidDrop, TRUE);
	}
	else if (PawnOwner.BS_SeqNodeBelongsTo(SeqNode, BS_MidDrop))
	{
		PawnOwner.BS_SetAnimEndNotify(BS_MidDrop, FALSE);

		PawnOwner.BS_Play(BS_Roll, 1.0f, 0.0f, 0.2f);
		PawnOwner.BS_SetAnimEndNotify(BS_Roll, TRUE);
			
		PawnOwner.BS_SetRootBoneAxisOptions(BS_Roll, RBA_Translate, RBA_Translate, RBA_Translate);
		PawnOwner.Mesh.RootMotionMode = RMM_Accel;
		PawnOwner.Mesh.RootMotionAccelScale = Vect(1,1,1);
	}
	else
	{
		PawnOwner.EndSpecialMove();
	}
}

/**
 * Revert to the original anim tree
 *
 * @param PrevMove - the previous special move to run
 *
 * @param NextMove - the next special move to run
 */
function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);
	
	PawnOwner.BS_SetAnimEndNotify(BS_Roll, FALSE);
	PawnOwner.Mesh.RootMotionMode = PawnOwner.default.Mesh.RootMotionMode;

	PawnOwner.Mesh.SetAnimTreeTemplate(PawnOwner.default.Mesh.AnimTreeTemplate);
	PawnOwner.RemoveLocalCustomAnimSets(ZiplineBase.ZiplineAnimSets);

//	PawnOwner.bUnlimitedHealth = PawnOwner.default.bUnlimitedHealth;
	if( PawnOwner.Controller != None )
	{
		PawnOwner.Controller.bGodMode = FALSE;
	}
	PawnOwner.Health = PawnOwner.DefaultHealth;
}

defaultproperties
{
	bCanSwitchWeapons=FALSE
	bDisableMovement=TRUE
	bDisableTurnInPlace=TRUE
	bCanFireWeapon=FALSE	
	bLockPawnRotation=TRUE

	bDoMeshFloorConform=FALSE
	bDoIKFloorConform=FALSE
	bDoFootPlacement=FALSE

	BS_Drop=(Stance=((Slot=BS_FullBody,AnimName="Zipline_Jump_Down_Start")))
	BS_MidDrop=(Stance=((Slot=BS_FullBody,AnimName="Zipline_Jump_Down_Middle")))
	BS_Roll=(Stance=((Slot=BS_FullBody,AnimName="Zipline_Jump_Down_End")))
}