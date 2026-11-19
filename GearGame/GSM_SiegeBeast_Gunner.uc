/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_SiegeBeast_Gunner extends GearSpecialMove
	DependsOn(GearPawn);

var Vehicle_Siegebeast_Base     SiegeBeast;

/** Move started so clear the destination flag */
function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	SiegeBeast = Vehicle_Siegebeast_Base(PawnOwner.DrivenVehicle);

	Super.SpecialMoveStarted( bForced, PrevMove );

	// Stop the holstering animations
	PawnOwner.MyGearWeapon.HolsterWeaponTemporarily(TRUE);
	PawnOwner.MyGearWeapon.StopHolsterAnims();

	PawnOwner.AddLocalCustomAnimSets( SiegeBeast.WheelTurnAnimSetList );

	if( PawnOwner.IKCtrl_LeftHand != None )		
	{ 
		PawnOwner.IKCtrl_LeftHand.EffectorLocationSpace = BCS_BaseMeshSpace;
		PawnOwner.IKCtrl_LeftHand.EffectorSpaceBoneName = SiegeBeast.GunnerIKBoneName_Left;
		PawnOwner.IKCtrl_LeftHand.EffectorLocation      = SiegeBeast.GunnerIKEffectorLocation_Left;
		PawnOwner.IKCtrl_LeftHand.SetSkelControlActive(TRUE);
		PawnOwner.IKCtrl_LeftHand.SetSkelControlStrength(1.0, 0.0);
	}
	if( PawnOwner.IKCtrl_RightHand != None )		
	{ 
		PawnOwner.IKCtrl_RightHand.EffectorLocationSpace = BCS_BaseMeshSpace;
		PawnOwner.IKCtrl_RightHand.EffectorSpaceBoneName = SiegeBeast.GunnerIKBoneName_Right;
		PawnOwner.IKCtrl_RightHand.EffectorLocation      = SiegeBeast.GunnerIKEffectorLocation_Right;
		PawnOwner.IKCtrl_RightHand.SetSkelControlActive(TRUE);
		PawnOwner.IKCtrl_RightHand.SetSkelControlStrength(1.0, 0.0);
	}

	if( PawnOwner.IKRotCtrl_RightHand != None )
	{
		PawnOwner.IKRotCtrl_RightHand.bApplyRotation = TRUE;
		PawnOwner.IKRotCtrl_RightHand.BoneRotationSpace = BCS_BaseMeshSpace;
		PawnOwner.IKRotCtrl_RightHand.BoneRotation = SiegeBeast.GunnerIKRotation_Right;
		PawnOwner.IKRotCtrl_RightHand.SetSkelControlActive(TRUE);
		PawnOwner.IKRotCtrl_RightHand.SetSkelControlStrength(1.0, 0.0);
	}

	if( PawnOwner.IKRotCtrl_LeftHand != None )
	{
		PawnOwner.IKRotCtrl_LeftHand.bApplyRotation = TRUE;
		PawnOwner.IKRotCtrl_LeftHand.BoneRotationSpace = BCS_BaseMeshSpace;
		PawnOwner.IKRotCtrl_LeftHand.BoneRotation = SiegeBeast.GunnerIKRotation_Left;
		PawnOwner.IKRotCtrl_LeftHand.SetSkelControlActive(TRUE);
		PawnOwner.IKRotCtrl_LeftHand.SetSkelControlStrength(1.0, 0.0);
	}	

	PlayIdleAnimation();
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	ReleaseIK();

	PawnOwner.RemoveLocalCustomAnimSets( SiegeBeast.WheelTurnAnimSetList );

	PawnOwner.FullBodyNode.StopCustomAnim(0.2f);
	PawnOwner.MyGearWeapon.HolsterWeaponTemporarily(FALSE);

	// Call super class version.
	Super.SpecialMoveEnded(PrevMove, NextMove);
}

function PlayIdleAnimation()
{
	PawnOwner.BS_Play( SiegeBeast.GunnerIdleStance, SpeedModifier, 0.25f, -1.f, TRUE, TRUE );
}

function EndSpecialMove()
{
	PawnOwner.EndSpecialMove();
}

simulated function PlayReleaseGunnerAnimation()
{
	EndSpecialMove();

	ReleaseIK();
}

/** Returns IK to its' proper state */
simulated function ReleaseIK()
{
	if( PawnOwner.IKCtrl_RightHand != None )
	{
		PawnOwner.IKCtrl_RightHand.SetSkelControlStrength(0.0, 0.0);
		PawnOwner.IKCtrl_RightHand.SetSkelControlActive(FALSE);
	}
	if( PawnOwner.IKCtrl_LeftHand != None )
	{
		PawnOwner.IKCtrl_LeftHand.SetSkelControlStrength(0.0, 0.0);
		PawnOwner.IKCtrl_LeftHand.SetSkelControlActive(FALSE);
	}

	if( PawnOwner.IKRotCtrl_RightHand != None )
	{
		PawnOwner.IKRotCtrl_RightHand.SetSkelControlStrength(0.0, 0.0);
		PawnOwner.IKRotCtrl_RightHand.SetSkelControlActive(FALSE);
	}
	if( PawnOwner.IKRotCtrl_LeftHand != None )
	{
		PawnOwner.IKRotCtrl_LeftHand.SetSkelControlStrength(0.0, 0.0);
		PawnOwner.IKRotCtrl_LeftHand.SetSkelControlActive(FALSE);
	}
}

/*
simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	PawnOwner.IKCtrl_RightHand.EffectorLocation = SiegeBeast.GunnerIKEffectorLocation_Right;
	PawnOwner.IKCtrl_LeftHand.EffectorLocation = SiegeBeast.GunnerIKEffectorLocation_Left;
	PawnOwner.IKRotCtrl_RightHand.BoneRotation = SiegeBeast.GunnerIKRotation_Right;
	PawnOwner.IKRotCtrl_LeftHand.BoneRotation = SiegeBeast.GunnerIKRotation_Left;
}
*/

defaultproperties
{
	bShouldAbortWeaponReload=TRUE
	bCanFireWeapon=FALSE
	bLockPawnRotation=TRUE
	bDisableMovement=TRUE
	bDisableLook=FALSE

 	bUseUnsynchedServerMove=TRUE

	bDoMeshFloorConform=FALSE
	bDoIKFloorConform=FALSE
	bDoFootPlacement=FALSE
}
