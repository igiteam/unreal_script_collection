
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_UnMountHeavySniper extends GSM_BasePlaySingleAnim;

var() const protected	GearPawn.BodyStance	BS_UnMount, BS_UnMountCover, BS_UnMountStdCover, BS_UnMountMidCoverLean;

var() const protected	SoundCue			SniperUnmountSound;

function bool CanChainMove(ESpecialMove NextMove)
{
	if( NextMove == SM_TargetHeavySniper )
	{
		return TRUE;
	}

	return FALSE;
}

protected function bool InternalCanDoSpecialMove()
{
	// Need to carry a heavy weapon for the animations to exist.
	return PawnOwner.MyGearWeapon != None && PawnOwner.MyGearWeapon.WeaponType == WT_Heavy;
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local GearWeap_HeavyBase	HeavyWeapon;

	// Heavy Weapon being carried.
	HeavyWeapon = GearWeap_HeavyBase(PawnOwner.Weapon);

	// Pick correct animation.
	if( PawnOwner.HeavyMountedCoverType == CT_MidLevel && PawnOwner.HeavyMountedCoverAction == CA_PopUp )
	{
		BS_Animation = BS_UnMountCover;

		// Play weapon unmounting animation in cover.
		if( HeavyWeapon != None )
		{
			HeavyWeapon.PlayWeaponAnim('HW_Gatling_Cov_Mid_Deployed_Exit', SpeedModifier, 0.f, 0.f, FALSE, TRUE);
		}
	}
	else
	{
		if( PawnOwner.HeavyMountedCoverType == CT_MidLevel )
		{
			BS_Animation = BS_UnMountMidCoverLean;
		}
		else if( PawnOwner.HeavyMountedCoverType == CT_Standing )
		{
			BS_Animation = BS_UnMountStdCover;
		}
		else
		{
			BS_Animation = BS_UnMount;
		}

		// Play weapon unmounting animation outside of cover.
		if( HeavyWeapon != None )
		{
			HeavyWeapon.PlayWeaponAnim('HW_Gatling_Deployed_Exit', SpeedModifier, 0.f, 0.f, FALSE, TRUE);
		}
	}

	// heavy lifting effort
	PawnOwner.SoundGroup.PlayEffort(PawnOwner, GearEffort_LiftHeavyWeaponEffort, true);

	PawnOwner.PlaySound(SniperUnmountSound);

	Super.SpecialMoveStarted(bForced, PrevMove);
}

/** need group to sync**/
function float PlayMyAnim()
{
	return PawnOwner.BS_Play(BS_Animation, SpeedModifier, BlendInTime/SpeedModifier, BlendOutTime/SpeedModifier, FALSE,,'UnMounting');
}

function Tick(float DeltaTime)
{
	local GearWeap_HeavyBase HeavyWeap;

	Super.Tick(DeltaTime);

	if( PawnOwner.IsLocallyControlled() )
	{
		// If we ever lose our weapon, then exit this special move.
		HeavyWeap = GearWeap_HeavyBase(PawnOwner.Weapon);
		if( HeavyWeap == None )
		{
			PawnOwner.LocalEndSpecialMove();
		}
	}
}


function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	local GearWeap_HeavyBase HeavyWeap;
	
	Super.SpecialMoveEnded(PrevMove, NextMove);

	// check to see if we delayed an auto-switch
	HeavyWeap = GearWeap_HeavyBase(PawnOwner.Weapon);
	if (HeavyWeap != None)
	{
		HeavyWeap.MaybeAutoSwitchWeapon();
	}

	// If we're unmounting the gun, check if we should mount it back again.
	if( NextMove == SM_None && PawnOwner != None && PawnOwner.IsLocallyControlled() )
	{
		PawnOwner.CheckHeavyWeaponMounting(TRUE);
	}
}

function PreProcessInput(GearPlayerInput Input)
{
	// manually disable movement
	Input.RawJoyRight = 0.f;
	Input.RawJoyUp = 0.f;
}


defaultproperties
{
	BlendOutTime=0.25f

	BS_UnMount=(Stance=((Slot=BS_Std_Idle_Lower,AnimName="HW_Gatling_Deployed_Exit"), (Slot=BS_Std_Up,AnimName="HW_Gatling_Deployed_Exit")))
	BS_UnMountCover=(Stance=((Slot=BS_CovMidIdle,AnimName="HW_Gatling_Cov_Mid_Deployed_Exit"), (Slot=BS_CovMidLean_Up,AnimName="HW_Gatling_Cov_Mid_Deployed_Exit")))
	BS_UnMountStdCover=(Stance=((Slot=BS_CovStdIdle,AnimName="HW_Gatling_Cov_Std2Deployed_Lean_Exit"), (Slot=BS_CovStdLean_Up,AnimName="HW_Gatling_Cov_Std2Deployed_Lean_Exit")))
	BS_UnMountMidCoverLean=(Stance=((Slot=BS_CovMidIdle,AnimName="HW_Gatling_Cov_Mid2Deployed_Lean_Exit"), (Slot=BS_CovMidLean_Up,AnimName="HW_Gatling_Cov_Mid2Deployed_Lean_Exit")))

	SniperUnmountSound=SoundCue'Foley_BodyMoves.BodyMoves.CogBodyTurn180_Cue'
	
	bBreakFromCover=FALSE
	bCanFireWeapon=FALSE
	bLockPawnRotation=TRUE
	//bDisablePhysics=TRUE
	bCameraFocusOnPawn=FALSE
	bDisableLook=FALSE
	bDisableMovement=TRUE
}
