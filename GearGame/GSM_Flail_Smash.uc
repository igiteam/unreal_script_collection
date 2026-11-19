
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Flail_Smash extends GearSpecialMove;

/** Full swing animation */
var()	GearPawn.BodyStance	BS_SlowSwingAnim;
/** Above head (aimed) animation */
var()	GearPawn.BodyStance BS_AimedAnim;

/** Type of flail smash performed */
enum EFlailSmashType
{
	FST_Invalid,  // dummy value to fill up 0
	FST_Targeted,
	FST_Normal,
	FST_Max
};

static function INT PackSpecialMoveFlags(EFlailSmashType FlailSmashType)
{
	local int Flags;
	Flags = int(FlailSmashType);
	return Flags;
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local GearWeap_HeavyFlailBase FlailWeap;
	local bool bIsTargetedSmash;
    local float TotalPlayTime; 

	Super.SpecialMoveStarted(bForced,PrevMove);

	bIsTargetedSmash = bool(PawnOwner.SpecialMoveFlags & 1);
	if (bIsTargetedSmash)
	{
		// Play body stance animation.
		TotalPlayTime = PawnOwner.BS_Play(BS_AimedAnim, SpeedModifier, 0.2f/SpeedModifier, 0.2f/SpeedModifier, FALSE, TRUE);
		// Enable end of animation notification. This is going to call SpecialMoveEnded()
		PawnOwner.BS_SetAnimEndNotify(BS_AimedAnim, TRUE);

		PawnOwner.SoundGroup.PlayEffort( PawnOwner, GearEffort_MeleeAttackSmallEffort, TRUE );
	}
	else
	{
		// Play body stance animation.
		TotalPlayTime = PawnOwner.BS_Play(BS_SlowSwingAnim, SpeedModifier, 0.2f/SpeedModifier, 0.2f/SpeedModifier, FALSE, TRUE);
		// Enable end of animation notification. This is going to call SpecialMoveEnded()
		PawnOwner.BS_SetAnimEndNotify(BS_SlowSwingAnim, TRUE);

		PawnOwner.SoundGroup.PlayEffort( PawnOwner, GearEffort_MeleeAttackMediumEffort, TRUE );
	}

	FlailWeap = GearWeap_HeavyFlailBase(PawnOwner.MyGearWeapon);
	if (FlailWeap != None && FlailWeap.ChainEndBodyInstance != None)
	{
		FlailWeap.SetChainEndBoneSpringTarget( 10.0f, 0.05f * TotalPlayTime);
		PawnOwner.SetTimer( 0.4f * TotalPlayTime, FALSE, 'TurnOffChainEndBoneSpring', FlailWeap );
	}
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	local bool bIsTargetedSmash;

	Super.SpecialMoveEnded(PrevMove, NextMove);

	// Disable end of animation notification. 
	bIsTargetedSmash = bool(PawnOwner.SpecialMoveFlags & 1);
	if (bIsTargetedSmash)
	{
		PawnOwner.BS_SetAnimEndNotify(BS_AimedAnim, FALSE);
	}
	else
	{
		PawnOwner.BS_SetAnimEndNotify(BS_SlowSwingAnim, FALSE);
	}
}

defaultproperties
{											  
	BS_SlowSwingAnim=(Stance=((Slot=BS_FullBody,AnimName="Flail_Swing_Slow")))
	BS_AimedAnim=(Stance=((Slot=BS_FullBody,AnimName="Flail_Swing_Aim")))

	bLockPawnRotation=TRUE
	bDisableMovement=TRUE
	bDisablePhysics=TRUE
	bCanFireWeapon=FALSE
}