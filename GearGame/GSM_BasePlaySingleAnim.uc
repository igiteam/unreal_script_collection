
/**
 * Base Special Move to play a single animation,
 * and end itself once it's done playing.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_BasePlaySingleAnim extends GearSpecialMove
	native(SpecialMoves)
	abstract;

/** Animation to play */
var()	GearPawn.BodyStance	BS_Animation;
var		FLOAT				BlendInTime;
var		FLOAT				BlendOutTime;

/** Name of camera animation to play when this special move starts. */
var protected array<CameraBoneAnimation> SpecialMoveCameraBoneAnims;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced, PrevMove);

	// Play animation
	PlayAnimation();
}

function float PlayMyAnim()
{
	return PawnOwner.BS_Play(BS_Animation, SpeedModifier, BlendInTime/SpeedModifier, BlendOutTime/SpeedModifier, FALSE);
}

function PlayAnimation()
{
	local float AnimLength;

	// Play Animation
	AnimLength = PlayMyAnim();

	// If AnimLength is 0, it means the animation could not be found. So it's not safe to put a notify on it.
	if( AnimLength > 0.f )
	{
		// Enable end of animation notification. This is going to call Pawn.EndSpecialMove().
		PawnOwner.BS_SetAnimEndNotify(BS_Animation, TRUE);
	}
	else
	{
		// Failed to play animation, fall back to just setting a timer to exit the special move.
		`warn("Failed to play animation on special move" @ Self @ "on Pawn" @ PawnOwner @ "defaulting to a timer to end special move");
		PawnOwner.SetTimer(0.25f, FALSE, nameof(Self.EndThisSpecialMove), Self);
	}

	if( PCOwner != None )
	{
		if( SpecialMoveCameraBoneAnims.Length > 0 )
		{
			PCOwner.PlayRandomCameraBoneAnim(SpecialMoveCameraBoneAnims, SpeedModifier, BlendInTime/SpeedModifier, BlendOutTime/SpeedModifier,,, TRUE, TRUE, TRUE);
		}
	}
}

function EndThisSpecialMove()
{
	PawnOwner.EndSpecialMove();
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	// Clear timer if it's been set.
	PawnOwner.ClearTimer(nameof(Self.EndThisSpecialMove), Self);
	// Disable end of animation notification, so it doesn't interfere with future special moves
	// using that same animation channel.
	PawnOwner.BS_SetAnimEndNotify(BS_Animation, FALSE);

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

defaultproperties
{
	BlendInTime=0.2
	BlendOutTime=0.2
	AITimeout=10.0
}
