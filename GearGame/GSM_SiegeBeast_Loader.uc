/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_SiegeBeast_Loader extends GearSpecialMove
	DependsOn(GearPawn);

var Vehicle_Siegebeast_Base     SiegeBeast;
var GearWeaponPawn              Wheel;

var bool bAllowedToReload;

/** Whether everything is ready for the special move to begin (replication isn't guaranteed so we need this for getting reference to the siege beast) */
var transient bool bReadyForMove;

/** Move started so clear the destination flag */
function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	bReadyForMove = false;
	Wheel = None;
	SiegeBeast = None;
	bAllowedToReload = FALSE;

	Super.SpecialMoveStarted( bForced, PrevMove );
}

/** Initializes the special move and attempts to start the animation */
function InitializeMove()
{
	if (Wheel == None || SiegeBeast == None)
	{
		Wheel = GearWeaponPawn(PawnOwner.DrivenVehicle);
		SiegeBeast = Vehicle_Siegebeast_Base(Wheel.Base);

		if (Wheel != None && SiegeBeast != None)
		{
			PawnOwner.AddLocalCustomAnimSets(SiegeBeast.WheelTurnAnimSetList);

			if( PawnOwner.SpecialMoveFlags == 2 )
			{
				if( PawnOwner.IKCtrl_LeftHand != None )		
				{ 
					PawnOwner.IKCtrl_LeftHand.EffectorLocationSpace = BCS_BaseMeshSpace;
					PawnOwner.IKCtrl_LeftHand.EffectorSpaceBoneName = SiegeBeast.CrankIKBoneName_Right;
					PawnOwner.IKCtrl_LeftHand.EffectorLocation      = SiegeBeast.CrankIKEffectorLocation_Right;
					PawnOwner.IKCtrl_LeftHand.SetSkelControlActive(TRUE);
					PawnOwner.IKCtrl_LeftHand.SetSkelControlStrength(1.0, 0.0);
				}

				if( PawnOwner.IKRotCtrl_LeftHand != None )
				{
					PawnOwner.IKRotCtrl_LeftHand.bApplyRotation = TRUE;
					PawnOwner.IKRotCtrl_LeftHand.BoneRotationSpace = BCS_BaseMeshSpace;
					PawnOwner.IKRotCtrl_LeftHand.RotationSpaceBoneName = SiegeBeast.CrankIKBoneName_Right;
					PawnOwner.IKRotCtrl_LeftHand.BoneRotation = SiegeBeast.GunnerIKRotation_Left;
					PawnOwner.IKRotCtrl_LeftHand.SetSkelControlActive(TRUE);
					PawnOwner.IKRotCtrl_LeftHand.SetSkelControlStrength(1.0, 0.0);
				}	
			}
			else
			{
				if( PawnOwner.IKCtrl_RightHand != None )		
				{ 
					PawnOwner.IKCtrl_RightHand.EffectorLocationSpace = BCS_BaseMeshSpace;
					PawnOwner.IKCtrl_RightHand.EffectorSpaceBoneName = SiegeBeast.CrankIKBoneName_Left;
					PawnOwner.IKCtrl_RightHand.EffectorLocation      = SiegeBeast.CrankIKEffectorLocation_Left;
					PawnOwner.IKCtrl_RightHand.SetSkelControlActive(TRUE);
					PawnOwner.IKCtrl_RightHand.SetSkelControlStrength(1.0, 0.0);
				}

				if( PawnOwner.IKRotCtrl_RightHand != None )
				{
					PawnOwner.IKRotCtrl_RightHand.bApplyRotation = TRUE;
					PawnOwner.IKRotCtrl_RightHand.BoneRotationSpace = BCS_BaseMeshSpace;
					PawnOwner.IKRotCtrl_RightHand.RotationSpaceBoneName = SiegeBeast.CrankIKBoneName_Left;
					PawnOwner.IKRotCtrl_RightHand.BoneRotation = SiegeBeast.GunnerIKRotation_Right;
					PawnOwner.IKRotCtrl_RightHand.SetSkelControlActive(TRUE);
					PawnOwner.IKRotCtrl_RightHand.SetSkelControlStrength(1.0, 0.0);
				}
			}

			PlayMountAnimation();
		}
	}
}

/** Script Tick function. */
function Tick(float DeltaTime)
{
	if (!bReadyForMove)
	{
		InitializeMove();
	}

	Super.Tick(DeltaTime);
}


function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	ReleaseIK();

	PawnOwner.ClearTimer( nameof(AllowReloadCrank), self );

	PawnOwner.BS_SetAnimEndNotify( SiegeBeast.WheelTurnEndStance, FALSE );
	PawnOwner.RemoveLocalCustomAnimSets( SiegeBeast.WheelTurnAnimSetList );

	PawnOwner.FullBodyNode.StopCustomAnim(0.2f);

	PawnOwner.MyGearWeapon.HolsterWeaponTemporarily(FALSE);

	// Call super class version.
	Super.SpecialMoveEnded(PrevMove, NextMove);
}

function PlayMountAnimation()
{
	local float AnimTime;
	local float BlendInTime, BlendOutTime;

	PawnOwner.MyGearWeapon.HolsterWeaponTemporarily(TRUE);

	// Stop the holstering animations
	PawnOwner.MyGearWeapon.StopHolsterAnims();

	BlendInTime  = 0.2f;
	BlendOutTime = -1.f;
	AnimTime = PawnOwner.BS_Play( SiegeBeast.WheelTurnStartStance, SpeedModifier, BlendInTime/SpeedModifier, BlendOutTime/SpeedModifier, FALSE, TRUE );
	PawnOwner.FullBodyNode.Children[PawnOwner.FullBodyNode.CustomChildIndex].bMirrorSkeleton = (PawnOwner.SpecialMoveFlags == 2);

	PawnOwner.SetTimer( AnimTime, FALSE, nameof(AllowReloadCrank), self );
}

function PlayIdleAnimation()
{
	PawnOwner.BS_Play( SiegeBeast.WheelTurnIdleStance, SpeedModifier, 0.25f, -1.f, TRUE, TRUE );
	PawnOwner.FullBodyNode.Children[PawnOwner.FullBodyNode.CustomChildIndex].bMirrorSkeleton = (PawnOwner.SpecialMoveFlags == 2);
}

function AllowReloadCrank()
{
	bAllowedToReload = TRUE;
	PlayIdleAnimation();
}

function EndSpecialMove()
{
	PawnOwner.EndSpecialMove();
}

simulated function PlayLoaderCrankAnimation( float StartTime )
{
	PawnOwner.FullBodyNode.StopCustomAnim( 0.f );
	PawnOwner.ClearTimer( nameof(AllowReloadCrank), self );

	PawnOwner.BS_Play( SiegeBeast.WheelTurnStance, SpeedModifier, 0.f, -1.f, FALSE, TRUE,, StartTime );
	PawnOwner.FullBodyNode.Children[PawnOwner.FullBodyNode.CustomChildIndex].bMirrorSkeleton = (PawnOwner.SpecialMoveFlags == 2);
}

simulated function StopLoaderCrankAnimation()
{
	local AnimNodeSequence Seq;

	Seq = PawnOwner.FullBodyNode.GetCustomAnimNodeSeq();
	Seq.StopAnim();
	PlayIdleAnimation();
}

simulated function PlayReleaseLoaderAnimation()
{
	PawnOwner.ClearTimer( nameof(AllowReloadCrank), self );

	PawnOwner.BS_Play( SiegeBeast.WheelTurnEndStance, SpeedModifier, 0.f, -1.f, FALSE, TRUE );
	PawnOwner.FullBodyNode.Children[PawnOwner.FullBodyNode.CustomChildIndex].bMirrorSkeleton = (PawnOwner.SpecialMoveFlags == 2);
	PawnOwner.BS_SetAnimEndNotify( SiegeBeast.WheelTurnEndStance, TRUE );

	ReleaseIK();
}

/** Returns the IK back to its' normal state */
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

simulated function BS_AnimEndNotify( AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime )
{
	if( PawnOwner.BS_IsPlaying(SiegeBeast.WheelTurnEndStance) )
	{
		EndSpecialMove();
	}
}

/*
simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	PawnOwner.IKCtrl_RightHand.EffectorLocation = SiegeBeast.CrankIKEffectorLocation_Left;
	PawnOwner.IKCtrl_LeftHand.EffectorLocation = SiegeBeast.CrankIKEffectorLocation_Right;
	PawnOwner.IKRotCtrl_RightHand.BoneRotation = SiegeBeast.CrankIKRotation_Left;
	PawnOwner.IKRotCtrl_LeftHand.BoneRotation = SiegeBeast.CrankIKRotation_Right;
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
