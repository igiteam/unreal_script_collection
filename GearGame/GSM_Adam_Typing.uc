
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * This is special move for Adam to play - triggered by LDs
 */

class GSM_Adam_Typing extends GearSpecialMove;

var	GearPawn.BodyStance	BS_TypingMain;
var	GearPawn.BodyStance	BS_TypingAndPointing;
var	GearPawn.BodyStance	BS_TransitionToTyping;

/** how long do you want main loop to play **/
var() config int    MinMainAnimLoop;
var() config int    MaxMainAnimLoop;

var transient int   CurrentMainAnimLoop;

/** Should we wait for the weapon to be holstered before starting the execution. */
var bool	bWaitForWeaponHolstered;

function WeaponTemporarilyHolstered()
{
	bWaitForWeaponHolstered = FALSE;

	PlayAnimation(BS_TransitionToTyping);
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	bWaitForWeaponHolstered = FALSE;
	CurrentMainAnimLoop = 0;

	if (PawnOwner.MyGearWeapon != None)
	{
		// See if Killer should Holster his weapon.
		bWaitForWeaponHolstered = PawnOwner.HolsterWeapon();
	}

	// if failed, just let it play transition
	if ( bWaitForWeaponHolstered == FALSE )
	{
		PlayAnimation(BS_TransitionToTyping);
	}

	Super.SpecialMoveStarted(bForced,PrevMove);
}

// play animation
function PlayAnimation( GearPawn.BodyStance BS_Animation )
{
	// Try transition first
	PawnOwner.BS_Play(BS_Animation, SpeedModifier, 0.15f/SpeedModifier, 0.15f/SpeedModifier, FALSE);
	PawnOwner.BS_SetAnimEndNotify(BS_Animation, TRUE);
}

// note that this isn't synced for co-op, if you'd like to sync this, 
// check punch face sync. That should be the way to go
function PlayMainLoop()
{
	// play if it's still less than mini loop or random chance of 50%
	if (CurrentMainAnimLoop < MinMainAnimLoop || 
		(CurrentMainAnimLoop < MaxMainAnimLoop && FRand() > 0.7f) )
	{
		PlayAnimation(BS_TypingMain);		
		CurrentMainAnimLoop++;
	}
	else
	{
		CurrentMainAnimLoop = 0;
		PlayAnimation(BS_TypingAndPointing);
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
	// transition to typing is done, just transition to type
	if ( PawnOwner.BS_SeqNodeBelongsTo(SeqNode, BS_TransitionToTyping) )
	{
		PlayMainLoop();
	}
	else if ( PawnOwner.BS_SeqNodeBelongsTo(SeqNode, BS_TypingMain) )
	{
		PlayMainLoop();
	}
	else if ( PawnOwner.BS_SeqNodeBelongsTo(SeqNode, BS_TypingAndPointing) )
	{
		PlayMainLoop();
	}
}

//NOTE: Is ended by an outside call to end the move, does not end itself!
function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	// Unholster weapon after execution finishes.
	if( PawnOwner.IsWeaponHolstered() )
	{
		PawnOwner.UnHolsterWeapon();
	}

	PawnOwner.BS_Stop(BS_TransitionToTyping, 0.25f);
	PawnOwner.BS_Stop(BS_TypingMain, 0.25f);
	PawnOwner.BS_Stop(BS_TypingAndPointing, 0.25f);

	PawnOwner.BS_SetAnimEndNotify(BS_TransitionToTyping, FALSE);
	PawnOwner.BS_SetAnimEndNotify(BS_TypingMain, FALSE);
	PawnOwner.BS_SetAnimEndNotify(BS_TypingAndPointing, FALSE);

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

defaultproperties
{
	BS_TypingMain=(Stance=((Slot=BS_FullBody,AnimName="Adam_Typing_Main")))
	BS_TypingAndPointing=(Stance=((Slot=BS_FullBody,AnimName="Adam_Typing_Point")))
	BS_TransitionToTyping=(Stance=((Slot=BS_FullBody,AnimName="Adam_Unarmed_Trans")))

	bDisableLook=TRUE
	bDoMeshFloorConform=FALSE
	bDoIKFloorConform=FALSE
	bDoFootPlacement=FALSE

	bBreakFromCover=TRUE
	bDisableMovement=TRUE
	bDisableTurnInPlace=TRUE
	bShouldAbortWeaponReload=TRUE
	bCanFireWeapon=FALSE
	bLockPawnRotation=TRUE
}
