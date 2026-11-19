
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_Gunker_MeleeFar extends GearSpecialMove;


/** Struct to keep track of the actors we hit with the move and when it happened */
struct GunkerStabActorData
{
	/** The actor who was stabbed */
	var transient GearPawn StabbedActor;
	/** Last time the actor was stabbed */
	var transient float LastStabTime;
};
/** List of stabbed actors */
var transient array<GunkerStabActorData> StabbedActors;

/** Time between stabbing checks for an actor */
var const float TimeBetweenStabChecks;

/** List of names of the bones in the tentacle arm */
var const array<Name> ArmBoneNames;

/** Keeps track of the aim offset values so we can lock them during the anim */
var transient float AimOffsetPitch;
var transient float AimOffsetYaw;
/** Whether we have locked the aim offset or not */
var transient bool bLockAimOffset;

/** Whether we are currently IKing the arm to the enemy or not */
var transient bool bIKTentacleToEnemy;

/** If we started blending the additive anim for the tentacle arm yet */
var transient bool bBlendTentacleArm;
/** Last blend value for the additive blend of making the tentacle the correct length */
var transient float LastTentacleBlendValue;

/** Whether we are currently dealing damage to enemies traced by the attack */
var transient bool bDealingDamage;

/** Name of the stab anim */
var const Name StabAnimName;


function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local GearPawn_LocustGunkerBase GunkerPawn;

	Super.SpecialMoveStarted(bForced,PrevMove);

	GunkerPawn = GearPawn_LocustGunkerBase(PawnOwner);
	if (GunkerPawn != None)
	{
		// Play body stance animation
		// Now Additive/Main is synced - make sure they both play 
		GunkerPawn.AnimSeq_Chop.PlayAnim();
		GunkerPawn.AnimSeq_Chop_Add.PlayAnim();
		// Play the telegraph sound
		GunkerPawn.PlaySound(GunkerPawn.TentacleStabTelegraph, TRUE,,, GunkerPawn.Location);
	}

	bLockAimOffset = FALSE;
	bIKTentacleToEnemy = FALSE;
	bBlendTentacleArm = FALSE;
	bDealingDamage = FALSE;
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	local GearPawn_LocustGunkerBase GunkerPawn;

	// Turn the IK control off
	GunkerPawn = GearPawn_LocustGunkerBase(PawnOwner);
	if (GunkerPawn != None)
	{
		GunkerPawn.TentacleIKControl.SetSkelControlActive(FALSE);
	}

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

/** Overrode to set the aim offset for the melee attack */
event bool DisableAimOffset()
{
	// No Aimoffset if not blending
	if (!bBlendTentacleArm)
	{
		return TRUE;
	}

	return FALSE;
}

/** Starts the tentacle arm IK toward the enemy */
function StartTentacleIK()
{
	local GearPawn_LocustGunkerBase GunkerPawn;

	GunkerPawn = GearPawn_LocustGunkerBase(PawnOwner);
	if (GunkerPawn != None)
	{
		// Turn the IK control on
		GunkerPawn.TentacleIKControl.SetSkelControlActive(TRUE);
	}
	bIKTentacleToEnemy = TRUE;
}

/** Stops the tentacle arm IK */
function StopTentacleIK()
{
	local GearPawn_LocustGunkerBase GunkerPawn;

	bIKTentacleToEnemy = FALSE;
	// Stopping when notification comes in. 
	GunkerPawn = GearPawn_LocustGunkerBase(PawnOwner);
	if (GunkerPawn != None)
	{
		// Turn the IK control on
		GunkerPawn.TentacleIKControl.SetSkelControlActive(FALSE);
	}
}

/** Starts the tentacle arm IK toward the enemy */
function StartTentacleBlend()
{
	bBlendTentacleArm = TRUE;
	LastTentacleBlendValue = 0.0f;
}

/** Stops the tentacle arm IK */
function StopTentacleBlend()
{
	bBlendTentacleArm = FALSE;
}

/** Start dealing damage to anything traced */
function StartDamage()
{
	bDealingDamage = TRUE;
}

/** Stop dealing damage to anything traced */
function StopDamage()
{
	bDealingDamage = FALSE;
}

/** Update the tentacle IKing to the enemy during the attack */
function UpdateTentacle()
{
	local GearAI_Gunker GunkerAI;
	local GearPawn_LocustGunkerBase GunkerPawn;
	local float DistFromEnemy;
	local vector GunkerPos;
	local float MaxArmDist;
	local float MinArmDist;
	local vector EnemyLoc;
	local GearPawn EnemyGP;

	GunkerPawn = GearPawn_LocustGunkerBase(PawnOwner);

	if (GunkerPawn != None)
	{
		GunkerPos = GunkerPawn.GetBodyCenterLocation();
		GunkerAI = GearAI_Gunker(PawnOwner.Controller);
		if (GunkerAI != None &&
			GunkerAI.Enemy != None)
		{
			// Get enemy location
			EnemyLoc = GunkerAI.GetEnemyLocationForFarMelee();
			EnemyGP = GearPawn(GunkerAI.Enemy);
			if (EnemyGP != None &&
				EnemyGP.IsInCover() &&
				EnemyGP.CoverType == CT_MidLevel)
			{
				EnemyLoc.Z = EnemyLoc.Z - GunkerAI.Enemy.GetCollisionHeight() + 50.0f;
			}
			else
			{
				EnemyLoc.Z = EnemyLoc.Z - GunkerAI.Enemy.GetCollisionHeight() + 100.0f;
				// Adjust for scaling
				EnemyLoc.Z -= (GunkerPawn.GunkerScale - 1.0f) * 100.0f;
			}
			// Get arm distances
			MaxArmDist = GunkerAI.EnemyDistance_Short + GunkerAI.ChopRangeDelta;
			MinArmDist = GunkerAI.EnemyDistance_Short - GunkerAI.ChopRangeDelta;

			if (bBlendTentacleArm)
			{
				// Determine the blend value for the additive anim that will correct the length of the tentacle arm
				DistFromEnemy = VSize(EnemyLoc - GunkerPos) - 50.0f;
				if (DistFromEnemy >= MaxArmDist)
				{
					LastTentacleBlendValue = 0.0f;
				}
				else if (DistFromEnemy <= MinArmDist)
				{
					LastTentacleBlendValue = 1.0f;
				}
				else
				{
					LastTentacleBlendValue = 1.0f - ((DistFromEnemy - MinArmDist) / (MaxArmDist - MinArmDist));
				}
				// Set the additive blend anim for the length of the tentacle
				// By Scott's request, increase blending time
				GunkerPawn.TentacleBlendNode.SetBlendTarget(LastTentacleBlendValue, 0.25f);
			}
			else if (LastTentacleBlendValue > 0.0f)
			{
				LastTentacleBlendValue = 0.0f;
				// Make sure to blend
				GunkerPawn.TentacleBlendNode.SetBlendTarget(0.0f, 0.1f);

			}

			// Only change the IK location if we are still actively updating where the enemy is
			if (bIKTentacleToEnemy)
			{
				// Set the IK location
				GunkerPawn.TentacleIKControl.EffectorLocation = EnemyLoc;
			}
		}
	}
}

/** Perform the check to see if any new actors were stabbed recently */
function UpdateStabbedActors()
{
	local GearPawn_LocustGunkerBase GunkerPawn;
	local GearPawn StabbedGP;
	local int StabListIdx;
	local bool bApplyDamage;
	local vector HitLoc;
	local vector HitNorm;
	local vector TraceStartLoc;
	local vector TraceEndLoc;
	local Rotator TraceStartRot;
	local Rotator TraceEndRot;
	local TraceHitInfo HitInfo;
	local Actor StabbedActor;
	local vector Extent;

	// Only check for damage if we are still IKing (since this corresponds to the time when he is aiming the stab)
	GunkerPawn = GearPawn_LocustGunkerBase(PawnOwner);
	if (GunkerPawn != None)
	{
		// Make sure we have a valid mesh
		if (GunkerPawn.Mesh != None)
		{
			// Set the trace vectors
			GunkerPawn.Mesh.GetSocketWorldLocationAndRotation('Blade1', TraceStartLoc, TraceStartRot);
			GunkerPawn.Mesh.GetSocketWorldLocationAndRotation('Blade2', TraceEndLoc, TraceEndRot);
			// Build the extent
			Extent.X = 16;
			Extent.Y = VSize(TraceEndLoc - TraceStartLoc);
			Extent.Z = 32;

			// Loop through all actors who have met the trace conditions
			foreach GunkerPawn.TraceActors(class'Actor', StabbedActor, HitLoc, HitNorm, TraceStartLoc, TraceEndLoc, Extent, HitInfo)
			{
				StabbedGP = GearPawn(StabbedActor);
				if (StabbedGP != None &&
					StabbedGP != GunkerPawn)
				{
					bApplyDamage = FALSE;
					// See if this actor is already in the list
					StabListIdx = StabbedActors.Find('StabbedActor', StabbedGP);
					// Not in the list
					if (StabListIdx == INDEX_NONE)
					{
						// Add this actor to the list and mark them for damage
						StabListIdx = StabbedActors.length;
						StabbedActors.length = StabListIdx + 1;
						StabbedActors[StabListIdx].StabbedActor = StabbedGP;
						StabbedActors[StabListIdx].LastStabTime = PawnOwner.WorldInfo.TimeSeconds;
						bApplyDamage = TRUE;
					}
					// In the list so see if we need to reset the time and do damage
					else
					{
						if (StabbedActors[StabListIdx].LastStabTime + TimeBetweenStabChecks < PawnOwner.WorldInfo.TimeSeconds)
						{
							StabbedActors[StabListIdx].LastStabTime = PawnOwner.WorldInfo.TimeSeconds;
							bApplyDamage = TRUE;
						}
					}

					// Perform damage if needed
					if (bApplyDamage)
					{
						GunkerPawn.PlaySound(GunkerPawn.HitImpactFromStab,,,,GunkerPawn.Location);
						StabbedGP.TakeDamage(1000, PawnOwner.Controller, StabbedGP.Location, Normal(StabbedGP.Location-PawnOwner.Location), class'GDT_GunkerStab', HitInfo);
					}
				}
			}
		}
	}
}

/** Overloaded to test for giving damage */
function Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);

	// Update the IK and tentacle blend
	UpdateTentacle();

	if (bDealingDamage &&
		PawnOwner.Role == ROLE_Authority)
	{
		// See if we need to give damage to anything
		UpdateStabbedActors();
	}
}

defaultproperties
{
	TimeBetweenStabChecks = 2.0f

	ArmBoneNames(0)="b_MF_Tentacle_1"
	ArmBoneNames(1)="b_MF_Tentacle_2"
	ArmBoneNames(2)="b_MF_Tentacle_3"
	ArmBoneNames(3)="b_MF_Tentacle_4"
	ArmBoneNames(4)="b_MF_Tentacle_5"
	ArmBoneNames(5)="b_MF_Tentacle_6"
	ArmBoneNames(6)="b_MF_Tentacle_7"
	ArmBoneNames(7)="b_MF_Tentacle_8"
	ArmBoneNames(8)="b_MF_Tentacle_9"
	ArmBoneNames(9)="b_MF_Tentacle_10"

	StabAnimName="Gunker_Attack_RtArm_StabFwd"
	
	// Going back to locking position/movement
	bPawnRotationLocked = TRUE
	bDisableMovement = TRUE
}
