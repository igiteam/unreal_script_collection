
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Ticker_LeapForward extends GSM_BasePlaySingleAnim;

var BodyStance BS_JumpLong, BS_JumpShort;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	if( PawnOwner.SpecialMoveFlags == 1 )
	{
		BS_Animation = BS_JumpShort;
	}
	else
	{
		BS_Animation = BS_JumpLong;
	}

	Super.SpecialMoveStarted(bForced,PrevMove);

	// Turn on root motion on animation node
	PawnOwner.BS_SetRootBoneAxisOptions(BS_Animation, RBA_Translate, RBA_Translate, RBA_Translate);

	// Turn on Root motion on mesh.
	PawnOwner.Mesh.RootMotionMode = RMM_Accel;
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);

	// Turn off Root motion on animation node
	PawnOwner.BS_SetRootBoneAxisOptions(BS_Animation, RBA_Discard, RBA_Discard, RBA_Discard);

	// Turn off Root motion on mesh.
	PawnOwner.Mesh.RootMotionMode = PawnOwner.default.Mesh.RootMotionMode;

	PawnOwner.ZeroMovementVariables();
}

defaultproperties
{
	BS_JumpLong=(Stance=((Slot=BS_FullBody,AnimName="jump_on_grenade")))
	BS_JumpShort=(Stance=((Slot=BS_FullBody,AnimName="jump_on_grenade_short")))

	BlendInTime=0.25f
	BlendOutTime=0.25f
	bLockPawnRotation=TRUE
	bBreakFromCover=TRUE
	bDisableMovement=TRUE
	DefaultAICommand=class'AICmd_Base_PushedBySpecialMove'
}
