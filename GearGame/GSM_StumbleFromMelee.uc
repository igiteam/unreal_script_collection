
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_StumbleFromMelee extends GearSpecialMove;

/** Stumble Animation */
var const	GearPawn.BodyStance	BS_Animation, BS_HitFromBackAnim;
var BodyStance PlayedStance;

protected function bool InternalCanDoSpecialMove()
{
	// Disable if carrying a heavy weapon, as we don't have animations for those yet.
	if( PawnOwner.MyGearWeapon != None && PawnOwner.MyGearWeapon.WeaponType == WT_Heavy )
	{
		return FALSE;
	}

	// Can't stumble if doing another special move, except idles, chainsaw, and roadie run
	return ( ( PawnOwner.SpecialMove == SM_None || PawnOwner.SpecialMove == SM_ChainsawHold ||
		PawnOwner.SpecialMove == SM_RoadieRun || PawnOwner.IsDoingMove2IdleTransition() )
	&& InterpActor_GearBasePlatform(PawnOwner.Base) == None && GearPawnRidable_Base(PawnOwner.Base) == None );
}

/**
 * Can this special move override InMove if it is currently playing?
 */
function bool CanOverrideSpecialMove(ESpecialMove InMove)
{
	return (InMove == SM_ChainsawHold || InMove == SM_RoadieRun);
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced,PrevMove);

	PawnOwner.StopFiring();

	// Play body stance animation.
	if( PawnOwner.SpecialMoveFlags > 0 )
	{
		PlayedStance = BS_HitFromBackAnim;
	}
	else 
	{   
		PlayedStance = BS_Animation;
		
	}
	PawnOwner.BS_Play(PlayedStance, SpeedModifier, 0.2f/SpeedModifier, 0.3f/SpeedModifier, FALSE, TRUE);

	// Turn on root motion on animation node
	PawnOwner.BS_SetRootBoneAxisOptions(PlayedStance, RBA_Translate, RBA_Translate, RBA_Translate);

	// Enable end of animation notification. This is going to call SpecialMoveEnded()
	PawnOwner.BS_SetAnimEndNotify(PlayedStance, TRUE);

	// Turn on Root motion on mesh.
	PawnOwner.Mesh.RootMotionMode = RMM_Accel;
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);

	// Turn off Root motion on animation node
	PawnOwner.BS_SetRootBoneAxisOptions(PlayedStance, RBA_Discard, RBA_Discard, RBA_Discard);

	PawnOwner.BS_SetAnimEndNotify(PlayedStance, FALSE);

	// Turn off Root motion on mesh.
	PawnOwner.Mesh.RootMotionMode = PawnOwner.default.Mesh.RootMotionMode;
}


defaultproperties
{
	BS_Animation=(Stance=((Slot=BS_FullBody,AnimName="AR_Injured_React1")))
	BS_HitFromBackAnim=(Stance=((Slot=BS_FullBody,AnimName="HitReact_Back")))

	bShouldAbortWeaponReload=FALSE
	bCanFireWeapon=FALSE
	bCameraFocusOnPawn=TRUE
	bLockPawnRotation=TRUE
	bBreakFromCover=TRUE
	bDisableMovement=TRUE
	bRestoreMovementAfterMove=TRUE

	DefaultAICommand=class'AICmd_Base_PushedBySpecialMove'
	bDisableAI=TRUE
}
