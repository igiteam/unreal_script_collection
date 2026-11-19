
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Kidnapper_GrenadeRelease extends GSM_InteractionPawnLeader_Base;

/** anims to play */
var BodyStance BS_Attacker, BS_Victim;

protected function bool InternalCanDoSpecialMove()
{
	local GearWeap_GrenadeBase GrenadeWeap;
	local vector FollowerLoc;

	if (PawnOwner.IsAKidnapper())
	{
		FollowerLoc = PawnOwner.InteractionPawn.Location;
		if (!PawnOwner.InteractionPawn.FindSpot(PawnOwner.InteractionPawn.GetCollisionExtent(), FollowerLoc) || Abs(FollowerLoc.Z - PawnOwner.InteractionPawn.Location.Z) > PawnOwner.InteractionPawn.MaxStepHeight)
		{
			return false;
		}
		else
		{
			GrenadeWeap = GearWeap_GrenadeBase(PawnOwner.FindInventoryType(class'GearWeap_GrenadeBase', true));
			return (GrenadeWeap != None && GrenadeWeap.HasAnyAmmo());
		}
	}
	else
	{
		return false;
	}
}

function bool CanOverrideSpecialMove(ESpecialMove InMove)
{
	return (InMove == SM_Kidnapper);
}

function DetachPawn(GearPawn APawn)
{
	local SkelControlBase HostageHeadLock;

	HostageHeadLock = APawn.Mesh.FindSkelControl('HostageHeadLock');
	if( HostageHeadLock != None )
	{
		HostageHeadLock.SetSkelControlActive(FALSE);
	}
	HostageHeadLock = APawn.Mesh.FindSkelControl('HostageHeadLockIK');
	if( HostageHeadLock != None )
	{
		HostageHeadLock.SetSkelControlActive(FALSE);
	}

	Super.DetachPawn(APawn);

	// Allow the game object to know if someone was released by a kidnapping
	if (PawnOwner.WorldInfo.Game != None)
	{
		GearGame(PawnOwner.WorldInfo.Game).KidnappingStopped(Follower, PawnOwner);
	}
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	bCanFireWeapon = default.bCanFireWeapon;

	Super.SpecialMoveStarted(bForced, PrevMove);

	if (PawnOwner.WorldInfo.Game != None)
	{
		GearGame(PawnOwner.WorldInfo.Game).TriggerGUDEvent(GUDEvent_BagTag, PawnOwner, Follower);
	}
}

function StartInteraction()
{
	DetachPawn(Follower);

	Follower.SetPhysics(Follower.WalkingPhysics);
	Follower.bRunPhysicsWithNoController = TRUE;
	Follower.BS_Play(BS_Victim, SpeedModifier, 0.35f/SpeedModifier, -1.f);
	Follower.BS_SetRootBoneAxisOptions(BS_Victim, RBA_Translate, RBA_Translate, RBA_Translate);
	Follower.Mesh.RootMotionMode = RMM_Accel;

	PawnOwner.BS_Play(BS_Attacker, SpeedModifier, 0.35f/SpeedModifier, 0.35f/SpeedModifier);
	PawnOwner.BS_SetRootBoneAxisOptions(BS_Attacker, RBA_Translate, RBA_Translate, RBA_Translate);
	PawnOwner.Mesh.RootMotionMode = RMM_Accel;
 	PawnOwner.BS_SetAnimEndNotify(BS_Attacker, TRUE);

	if (PawnOwner.Role == ROLE_Authority)
	{
		Follower.SoundGroup.PlayEffort(Follower, GearEffort_BagTagged,, TRUE);
	}
}

/** Notification forwarded by GearAnimNotify_SpecialMove */
function AnimNotify(AnimNodeSequence SeqNode, GearAnimNotify_SpecialMove NotifyObject)
{
	local WorldInfo WorldInfo;
	local GearWeap_GrenadeBase GrenadeWeap;
	local GearProj_Grenade Grenade;
	local float ExplosionTime, ArmGrenadeTime;

	ExplosionTime = 2.55f - PawnOwner.BS_GetPosition(BS_Attacker);
	ArmGrenadeTime = 1.5f;

	if (PawnOwner.Role == ROLE_Authority)
	{
		GrenadeWeap = GearWeap_GrenadeBase(PawnOwner.FindInventoryType(class'GearWeap_GrenadeBase', true));
		Grenade = GrenadeWeap.AttachToObject(Follower, Follower.GetHeadshotLocation(), -vector(PawnOwner.Rotation));
		Grenade.bIgnoreInstigator = TRUE;
		Grenade.BeginExplosionSequence(ArmGrenadeTime, ExplosionTime - ArmGrenadeTime);
		// simulate a reload so the grenade's ammo properties get updated correctly
		if (!GrenadeWeap.HasAmmo(0) && GrenadeWeap.HasAnyAmmo())
		{
			GrenadeWeap.PerformReload();
		}
		// adjust the follower's location slightly to account for any clipping due to e.g. stairs
		Follower.SetLocation(Follower.Location + vect(0,0,0.5));
		// @STATS - Bag and Tag, FollowerPawn no longer has controller
		WorldInfo = PawnOwner.WorldInfo;
		`RecordPlayerPlayerEvent(BAGTAG, PawnOwner.Controller, Controller(Follower.PlayerReplicationInfo.Owner));
	}

	PawnOwner.SetTimer(ExplosionTime, false, nameof(EndMove), self);
}

function BS_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	UnlockMovement();
}

/** allows PawnOwner to start moving/firing after some delay for animations */
final function UnlockMovement()
{
	PawnOwner.BS_SetRootBoneAxisOptions(BS_Attacker, RBA_Discard, RBA_Discard, RBA_Discard);
	PawnOwner.Mesh.RootMotionMode = PawnOwner.default.Mesh.RootMotionMode;
 	PawnOwner.BS_SetAnimEndNotify(BS_Attacker, FALSE);

	SetMovementLock(false);
	SetLockPawnRotation(false);
	bCanFireWeapon = TRUE;
}

/** ends the special move after the grenade explodes */
final function EndMove()
{
	if (PawnOwner.SpecialMoves[PawnOwner.SpecialMove] == self)
	{
		PawnOwner.EndSpecialMove();
	}
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	// Cancel Kidnapper animation in case we're being aborted early.
	if( PawnOwner.BS_IsPlaying(BS_Attacker) )
	{
		UnlockMovement();
		PawnOwner.BS_SetAnimEndNotify(BS_Attacker, FALSE);
	}

	if( Follower != None )
	{
		Follower.Mesh.RootMotionMode = Follower.default.Mesh.RootMotionMode;
		Follower.BS_SetRootBoneAxisOptions(BS_Victim, RBA_Discard, RBA_Discard, RBA_Discard);
		Follower.BS_Stop(BS_Victim, 0.35f);
		Follower.bRunPhysicsWithNoController = Follower.default.bRunPhysicsWithNoController;

	}

	if (PawnOwner.Role == ROLE_Authority && Follower != None && !Follower.bTearOff)
	{
		// if the former hostage should be killed but the grenade didn't do it, finish them off now
		if (Follower.CanBeSpecialMeleeAttacked(PawnOwner))
		{
			Follower.TearOffMomentum = Normal(Follower.Location - PawnOwner.Location);
			Follower.Died(PawnOwner.Controller, class'GSM_Kidnapper'.default.KidnapperDamageType, Follower.Location);
		}
		else
		{
			// otherwise start the recovery process
			Follower.ServerEndSpecialMove();
			Follower.FreeHostage(PawnOwner);
		}
	}

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

defaultproperties
{
	FollowerSpecialMove=SM_Hostage_GrenadeRelease
	BS_Attacker=(Stance=((Slot=BS_FullBody,AnimName="Kidnapper_bagNTag")))
	BS_Victim=(Stance=((Slot=BS_FullBody,AnimName="Hostage_bagNTag")))
	bDisableLook=false
}
