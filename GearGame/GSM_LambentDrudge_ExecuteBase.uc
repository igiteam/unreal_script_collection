
/**
 * Base class for Drudge executions
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

// FIXME: todo - change from GSM_CQC_Killer_Base to GSM_InteractionPawnLeader_Base
class GSM_LambentDrudge_ExecuteBase extends GSM_CQC_Killer_Base;

/** Attach bone SkelControl for Bayonet Attack alignment **/
var transient SkelControlSingleBone   AttachBoneControl;

/** Attach bone information - mostly for interpolation**/
var   Name              AttachBone;
var   float             AttachBlendInTime;
var   vector            AttachMarkerOffset;
var   rotator           AttachMarkerRotator;

// transient variable
var   transient bool      AttachTargetSet;
var   transient bool      AttachToBone;
var   transient float     CurrentAttachBlendInTime;
var   transient vector    AttachBoneOffset;
var   transient rotator   AttachBoneRotator;
var   transient float     AttachInterpVecSpeed, AttachInterpRotSpeed;

// you don't want any alignment for this case - do not do this;
function PlaceOnMarkers();

/** Special Move can be done if we can find a nearby victim. */
protected function bool InternalCanDoSpecialMove()
{
	Follower = PawnOwner.InteractionPawn;
	return (Follower != None && !Follower.IsBeingExecuted());
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	CurrentAttachBlendInTime = 0.f;
	AttachTargetSet = FALSE;
	AttachToBone = FALSE;
	// Cache attach bone - we can put this in GearPawn
	AttachBoneControl = SkelControlSingleBone(PawnOwner.Mesh.FindSkelControl('AttachBone'));

	Super.SpecialMoveStarted( bForced, PrevMove );
}

function StartInteraction()
{
	Super.StartInteraction();

	Follower.SetCollision(PawnOwner.bCollideActors, FALSE);
	Follower.bCollideWorld = FALSE;
	AttachBoneControl.SetSkelControlStrength(0.f, 0.25f);
}

/** Play victim animation - separated out to customize in children class**/
// This is kind of hack code, so I'm not going to save as variable
// it's very sampling each point to make it work for E3
function PlayVictimAnimation()
{
	local BodyStance HeadCoverAnim;
	
	Follower.bDisableDeathScreams = TRUE;
	Follower.SoundGroup.PlayEffortEx(Follower, GearEffort_RippedInHalfByDrudge, 0, TRUE);

	HeadCoverAnim.Stance.Length = 1;
	HeadCoverAnim.Stance[0].Slot = BS_FullBody;
	HeadCoverAnim.Stance[0].AnimName = 'ar_injured_headcover1_start';

	// play from beginning, till 0.3f second
	// we don't have time to play all anims, so just play up to that..
	Follower.BS_Play(HeadCoverAnim, SpeedModifier, 0.01f, 0.01f, FALSE, TRUE);
	PawnOwner.SetTimer(0.3f, FALSE, 'PlayHeadCoverAnimEnd', self);
}

function PlayHeadCoverAnimEnd()
{
	local BodyStance HeadCoverAnim;
	HeadCoverAnim.Stance.Length = 1;
	HeadCoverAnim.Stance[0].Slot = BS_FullBody;
	HeadCoverAnim.Stance[0].AnimName = 'ar_injured_headcover1_end';

	// play 0.3 from ending (1.43 - 0.3f = 1.13 f)
	// we're temporarily playing this to fill up the stillness of beginning animation
	Follower.BS_Play(HeadCoverAnim, SpeedModifier, 0.01f, 0.25f, FALSE, TRUE, , 0.15f);
	PawnOwner.SetTimer(0.3f, FALSE, 'PlayVictimExecution', self);
}

function PlayVictimExecution()
{
	local float StartTime;

	// find where attacker is, and sync
	StartTime = PawnOwner.BS_GetPosition(BS_KillerAnim);

	// If we have an animation defined for the victim, play it.
	if( BS_VictimAnim.Stance.Length > 0 )
	{
		Follower.BS_Play(BS_VictimAnim, SpeedModifier, 0.25f, -1.f, FALSE, TRUE, , StartTime );
	}
}

function Tick(float DeltaTime)
{
	local matrix TM;

	// adjust relative location/rotation
	if ( Follower!=none && PawnOwner.BS_IsPlaying(BS_KillerAnim) )
	{
		if ( AttachToBone == FALSE )
		{
			AttachFollowerToLeader(AttachBone, -Follower.default.Mesh.Translation, MakeRotator(0, 0, 0));

			TM = Follower.Mesh.GetBoneMatrix(0);
			AttachBoneControl.BoneTranslation = MatrixGetOrigin(TM);
			AttachBoneControl.BoneRotation = MatrixGetRotator(TM);
			AttachBoneControl.SetSkelControlStrength(1.f, 0.f);

			AttachToBone = TRUE;

			//PawnOwner.DebugFreezeGame();

		}
		// meaning, this has full weight, we can trust the information
		else if ( AttachTargetSet==FALSE && CurrentAttachBlendInTime > BlendInTime )
		{
			TM = MakeRotationTranslationMatrix(AttachMarkerOffset, AttachMarkerRotator)*MakeRotationTranslationMatrix(MatrixGetOrigin(PawnOwner.Mesh.GetBoneMatrix(0)), PawnOwner.Rotation);
//			TM = MakeRotationTranslationMatrix(AttachMarkerOffset, AttachMarkerRotator)*PawnOwner.Mesh.GetBoneMatrix(0);
			AttachBoneOffset = MatrixGetOrigin(TM);
			AttachBoneRotator = MatrixGetRotator(TM);;

			AttachInterpVecSpeed = 1.f/AttachBlendInTime;
			AttachTargetSet = TRUE;
		}


		if ( AttachTargetSet )
		{
  			if ( CurrentAttachBlendInTime <= AttachBlendInTime )
			{
				TM = Follower.Mesh.GetBoneMatrix(0);

				//`log("PRE LOC: "@AttachBoneControl.BoneTranslation @", PRE ROT: "@AttachBoneControl.BoneRotation @", DELTATIME:"@DeltaTime);
				// if during blending, continue update bone location
				AttachBoneControl.BoneTranslation = VInterpTo(MatrixGetOrigin(TM), AttachBoneOffset, DeltaTime, AttachInterpVecSpeed);
				// don't interpolate rotation, looks weird
				AttachBoneControl.BoneRotation = AttachBoneRotator; //RInterpTo(MatrixGetRotator(TM), AttachBoneRotator, DeltaTime, AttachInterpRotSpeed, TRUE);
				//`log("POST LOC: "@AttachBoneControl.BoneTranslation @", POST ROT: "@AttachBoneControl.BoneRotation @", DELTATIME:"@DeltaTime);

			//	PawnOwner.DebugFreezeGame();
			}
			else
  			{
  				// if blending is done, just turn it off
  				//AttachBoneControl.SetSkelControlStrength(0.f, 0.25f);
				AttachBoneControl.BoneTranslation = AttachBoneOffset;
				AttachBoneControl.BoneRotation = AttachBoneRotator;
  			}
		}

// 		PawnOwner.FlushPersistentDebugLines();
// 		PawnOwner.DrawDebugCoordinateSystem(AttachBoneControl.BoneTranslation, AttachBoneControl.BoneRotation, 200, TRUE);
// 		PawnOwner.DrawDebugCoordinateSystem(AttachBoneOffset, AttachBoneRotator, 100, TRUE);

		CurrentAttachBlendInTime += DeltaTime;
	}

	Super.Tick(DeltaTime);
}


/** Kill Victim */
function KillVictim()
{
	local GearPawn_LambentDroneMutatable Drudge;
	local vector HitLocation;

	Follower.SetCollision(PawnOwner.bCollideActors, TRUE);
	Follower.bCollideWorld = TRUE;

	bKilledVictim = TRUE;

	Drudge = GearPawn_LambentDroneMutatable(PawnOwner);
	
	if( PawnOwner != None && PawnOwner.WorldInfo.NetMode != NM_Client &&
		Follower != None && Follower.IsGameplayRelevant() )
	{
		HitLocation = Follower.Mesh.GetBoneLocation('b_MF_Spine_01');
		// Have the momentum be in the direction the killer is looking
		Follower.TearOffMomentum = Vect( 0,0, -1);
		// don't play deathanimaion here
		Follower.bPlayDeathAnimations = FALSE;
		Follower.Died(PawnOwner.Controller, ExecutionDamageType, HitLocation);
		Follower.Mesh.AddRadialImpulse(HitLocation, 100, 200, RIF_Linear);
	}


	PawnOwner.PlaySound(Drudge.TentacleImpactSound);

	AttachBoneControl.SetSkelControlStrength(0.f, 0.25f);
}


defaultproperties
{
	BS_KillerAnim=(Stance=((Slot=BS_FullBody,AnimName="Tear_attack")))
	BS_VictimAnim=(Stance=((Slot=BS_FullBody,AnimName="Drudge_tear_attack_react")))
	VictimDeathTime=3.23f
	ExecutionDamageType=class'GDT_DrudgeExecute'

	bAlignPawns = FALSE;
	AttachBone="b_MF_Attach"
	AttachBlendInTime=0.5f
	// no blending - because it attached to blended animation
	BlendInTime= 0.f;

	bForcePrecisePosition=FALSE

	// attach marker location
	// this is apart from what's happening COG_Killer
	AttachMarkerOffset = (X=145.967, Y=0.00, Z=0.00)
	AttachMarkerRotator = (Pitch=0, Yaw=-32768, Roll=0)

	bUseUnsynchedServerMove = TRUE
}
