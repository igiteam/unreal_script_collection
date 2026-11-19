
/**
 * Meat Shield: Execution
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Kidnapper_Execution extends GSM_Kidnapper;

var BodyStance BS_KidnapperAnim, BS_HostageAnim;

/** The effect to play from head socket location on the executee **/
var ParticleSystem PS_BloodSprayFromMouth;


protected function bool InternalCanDoSpecialMove()
{
	return (PawnOwner.SpecialMove == SM_Kidnapper);
}

function bool CanOverrideSpecialMove(ESpecialMove InMove)
{
	return (InMove == SM_Kidnapper);
}

/**
 * Begins the interaction.
 */
function StartInteraction()
{
	local vector Loc;
	local rotator Rot;
	local GearPRI FollowerPRI;

	// if we're in the special case for executing a losing leader at the end of the round,
	// award extra points for it
	if (PawnOwner.Role == ROLE_Authority)
	{
		FollowerPRI = GearPRI(Follower.PlayerReplicationInfo);
		if ( FollowerPRI != None && FollowerPRI.bIsLeader && GearGRI_MP(PawnOwner.WorldInfo.GRI) != None &&
			!GearGRI_MP(PawnOwner.WorldInfo.GRI).bLeadersAreKillable )
		{
			GearPRI(PawnOwner.PlayerReplicationInfo).Score += FollowerPRI.PointsFor_Executions;
		}
	}

	// Play animation on both characters.
	PawnOwner.BS_Play(BS_KidnapperAnim, 1.f, 0.33f, 0.33f);
	PawnOwner.BS_SetAnimEndNotify(BS_KidnapperAnim, TRUE);

	Follower.BS_Play(BS_HostageAnim, 1.f, 0.33f, -1.f);

	PawnOwner.SoundGroup.PlayEffort(PawnOwner, GearEffort_MeatbagExecutionEffort, true);

	if( PawnOwner.WorldInfo.GRI.ShouldShowGore() )
	{
		if( PawnOwner.EffectIsRelevant(PawnOwner.Location, false, 1000) )
		{
			// play a blood spewing from the mouth of the executee
			if (Follower.Mesh.GetSocketWorldLocationAndRotation('Head', Loc, Rot))
			{
				Follower.WorldInfo.MyEmitterPool.SpawnEmitter(PS_BloodSprayFromMouth, Loc, Rot);
			}
		}
	}

	// Make sure only the kidnapper kills the victim now.
	Follower.SpecialMoves[Follower.SpecialMove].bOnlyInteractionPawnCanDamageMe = TRUE;

	// Remove IK when doing this animation
	LockIKStatus(FALSE);
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);

	// Restore IK when animation is done blending out.
	PawnOwner.SetTimer(0.33f, FALSE, 'RestoreIKStatus', Self);
}


function BS_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	PawnOwner.EndSpecialMove();
}

defaultproperties
{
	KidnapperDamageType=class'GDT_NeckBreak'
	BS_KidnapperAnim=(Stance=((Slot=BS_FullBody,AnimName="Kidnapper_Execute")))
	BS_HostageAnim=(Stance=((Slot=BS_FullBody,AnimName="Hostage_Execute")))

	bShouldAbortWeaponReload=TRUE
	bCanFireWeapon=FALSE
	bDisableLook=TRUE

	PS_BloodSprayFromMouth=ParticleSystem'Effects_Gameplay.Blood.P_Blood_Head_Necksnap_Bloodspray'

	bShowHUDActions=TRUE
}
