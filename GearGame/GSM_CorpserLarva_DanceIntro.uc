
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_CorpserLarva_DanceIntro extends GearSpecialMove;

/** Animation to play */
var()	GearPawn.BodyStance	BS_Intro, BS_Loop;
var		FLOAT				BlendInTime;

/**
 * Can a new special move override this one before it is finished?
 * This is only if CanDoSpecialMove() == TRUE && !bForce when starting it.
 */
function bool CanOverrideMoveWith(ESpecialMove NewMove)
{
	return NewMove == GSM_CorpserLarva_DanceOutro || NewMove == SM_ChainsawVictim;
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced, PrevMove);

	// Play animation
	PlayIntro();
}

function PlayIntro()
{
	local float AnimLength;

	// Play Animation
	AnimLength = PawnOwner.BS_Play(BS_Intro, SpeedModifier, BlendInTime/SpeedModifier, 0.f, FALSE);

	// If AnimLength is 0, it means the animation could not be found. So it's not safe to put a notify on it.
	if( AnimLength > 0.f )
	{
		// Enable end of animation notification. This is going to call Pawn.EndSpecialMove().
		PawnOwner.BS_SetAnimEndNotify(BS_Intro, TRUE);
	}
	else
	{
		// Failed to play animation, fall back to just setting a timer to exit the special move.
		`warn("Failed to play animation on special move" @ Self @ "on Pawn" @ PawnOwner);
		PawnOwner.SetTimer(0.25f, FALSE, nameof(Self.FailedToPlayIntro), Self);
	}
}

function FailedToPlayIntro()
{
	// Skip to playing looping part.
	BS_AnimEndNotify(None, 0.f, 0.f);
}

function BS_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	// Play looping animation forever, until special move is aborted.
	PawnOwner.BS_Play(BS_Loop, SpeedModifier, 0.f, 0.f, TRUE);
	PawnOwner.BS_SetPosition(BS_Loop, ExcessTime * PawnOwner.BS_GetPlayRate(BS_Loop));

	PawnOwner.SetTimer(1.f, TRUE, nameof(Self.TryPlayTaunt), Self);
}

function TryPlayTaunt()
{
	local BodyStance	BS_Anim;

	// If we're playing an animation on this node, don't override it.
	if( PawnOwner.BodyStanceNodes[BS_Additive].bIsPlayingCustomAnim )
	{
		return;
	}

	BS_Anim.Stance.Length = 1; // Array of struct needs to be pre-sized.
	BS_Anim.Stance[0].Slot = BS_Additive;
	BS_Anim.Stance[0].AnimName = 'ADD_taunt';

	PawnOwner.BS_Play(BS_Anim, 1.f, 0.2f, 0.33f);
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	// Clear timer if it's been set.
	PawnOwner.ClearTimer(nameof(Self.FailedToPlayIntro), Self);
	PawnOwner.ClearTimer(nameof(Self.TryPlayTaunt), Self);
	// Disable end of animation notification, so it doesn't interfere with future special moves
	// using that same animation channel.
	PawnOwner.BS_SetAnimEndNotify(BS_Intro, FALSE);

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

defaultproperties
{
	BS_Intro=(Stance=((Slot=BS_FullBody,AnimName="hit_react_intro")))
	BS_Loop=(Stance=((Slot=BS_FullBody,AnimName="hit_react_loop")))
	BlendInTime=0.2f

	bLockPawnRotation=TRUE
	bDisableMovement=TRUE
	
	DefaultAICommand=class'AICmd_Base_PushedBySpecialMove'
	bDisableAI=TRUE
}
