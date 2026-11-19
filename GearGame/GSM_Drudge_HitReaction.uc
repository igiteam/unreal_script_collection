
/**
 * Play a full body hit reaction, takes over control for a little bit.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Drudge_HitReaction extends GSM_BasePlaySingleAnim;

enum EDrudgeHitReactionFlags
{
	EDHR_Left,
	EDHR_Right,
	EDHR_Back, 
	EDHR_Front,

	EDHR_Left_TrunkLeft,
	EDHR_Right_TrunkLeft,
	EDHR_Back_TrunkLeft, 
	EDHR_Front_TrunkLeft,

	EDHR_Left_TrunkRight,
	EDHR_Right_TrunkRight,
	EDHR_Back_TrunkRight, 
	EDHR_Front_TrunkRight,

	EDHR_Rage,
};

var array<BodyStance> HitReactionBSList;

// have I played rage trunk, this only happens once in their lifetime
var transient  bool PlayedRageTrunk;

protected function bool InternalCanDoSpecialMove()
{
	local GearPawn_LambentDroneMutatable Drudge;

	Drudge = GearPawn_LambentDroneMutatable(PawnOwner);

	// make sure it's drudge and leg is mutated
	if( Drudge==none || Drudge.Transforms[ETS_LEGS].Mutated==FALSE )
	{
		return FALSE;
	}

	// don't do it if any specialmove going on
	if ( Drudge.SpecialMove!=SM_None )
	{
		return FALSE;
	}

	// death is coming, don't play, confusing
	if ( Drudge.Health < 1000 )
	{
		return FALSE;
	}

	return TRUE;
}

static function INT PickHitReactionAnim(GearPawn Victim, class<GearDamageType> DamageType, TraceHitInfo HitInfo, vector Momentum, vector HitLocation)
{
	local GearPawn_LambentDroneMutatable	Drudge;
//	local GSM_Drudge_HitReaction            HitReactionGSM;

// 	local Vector			ShotDir, HitNormal, LookDir, RightDir;
// 	local FLOAT				DotFront, DotRight;
	local INT               AnimIndex;

	Drudge = GearPawn_LambentDroneMutatable(Victim);
//	HitReactionGSM = GSM_Drudge_HitReaction( Drudge.SpecialMoves[SM_FullBodyHitReaction] );

 	// some severe damage, try to have him play angry
	// FIXME: we don't use this until new animation
//  	if ( Drudge.Health < 2000 && HitReactionGSM.PlayedRageTrunk == FALSE )
//  	{
//  		return EDHR_Rage;
//  	}

	// Try to figure out shot direction.
// 	ShotDir		= IsZero(Momentum) ? Normal(Victim.Location - HitLocation) : Normal(Momentum);
// 	HitNormal	= -1.f * ShotDir;
// 	HitNormal.Z = 0.f;
// 	HitNormal	= Normal(HitNormal);

	// FIXME: this maybe have to change to where aim is, instead of rotation, 
	// in trunk, the rotation is based on trunk, not the upper body
//	LookDir		= vector(Victim.Rotation);
//	RightDir	= vect(0,0,1) cross LookDir;
// 	DotFront	= HitNormal dot LookDir;
// 	DotRight	= HitNormal dot RightDir;

	AnimIndex = 0;
	// Check based on bone names
	if( HitInfo.BoneName != '' )
	{
		if( Drudge != None )
		{
			// it hit below of trunk, have it play additive
			if (HitInfo.BoneName == 'Stalk_Spine_1' || Drudge.Mesh.BoneIsChildOf(HitInfo.BoneName, 'Stalk_Spine_1'))
			{
				// shot from right
// 				if ( DotRight > 0.f)
// 				{
// 					AnimIndex = EDHR_Left_TrunkRight;
// 				}
// 				else
// 				{
// 					AnimIndex = EDHR_Left_TrunkLeft;
// 				}

				// make random for now. It's better than seeing same thing over and over again. 
				AnimIndex = Rand(2);
			}
		}
	}

	// so far below direction check works very boring, 
	// so I'm just going to pick random stuff - that will look better for trunk

 	// Check based on hit location
//  	if( Abs(DotFront) > Abs(DotRight) )
//  	{
// 		// playing same thing all the time didn't make it cool, so I'm randomizing this
//  		//if( DotFront > 0.f )
// 		if (FRand() > 0.5f)
//  		{
//  			return (AnimIndex + EDHR_Front);
//  		}
//  		else
//  		{
//  			return (AnimIndex + EDHR_Back);
//  		}
//  	}
// 	else
// 	{
// 		if (FRand() > 0.5f)
//  		{
// 			return (AnimIndex + EDHR_Right);
//  		}
// 		else
// 		{
// 			return (AnimIndex + EDHR_Left);
// 		}
// 	}

//	return EDHR_Front;
	return AnimIndex + Rand(4);
}

function float PlayMyAnim()
{
	return PawnOwner.BS_Play(BS_Animation, SpeedModifier, BlendInTime/SpeedModifier, BlendOutTime/SpeedModifier, FALSE,,'HitReaction');
}

function PlayAnimation()
{
	if ( PawnOwner.SpecialMoveFlags == EDHR_Rage )
	{
		PlayedRageTrunk = TRUE;
		BlendOutTime = 0.3f;
	}

	// Assign proper animation.
	BS_Animation = HitReactionBSList[PawnOwner.SpecialMoveFlags];

	Super.PlayAnimation();

	PawnOwner.BS_SetEarlyAnimEndNotify(BS_Animation, FALSE);
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
//	SpeedModifier = default.SpeedModifier;
	BlendOutTime = default.BlendOutTime;

	// Make sure animation is stopped if aborted
	if( PawnOwner.BS_IsPlaying(BS_Animation) )
	{
		PawnOwner.BS_Stop(BS_Animation, BlendOutTime);
	}

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

defaultproperties
{
	HitReactionBSList(0)=(Stance=((Slot=BS_FullBody,AnimName="React_back_trunk")))
	HitReactionBSList(1)=(Stance=((Slot=BS_FullBody,AnimName="React_fwd_trunk")))
	HitReactionBSList(2)=(Stance=((Slot=BS_FullBody,AnimName="React_left_trunk")))
	HitReactionBSList(3)=(Stance=((Slot=BS_FullBody,AnimName="React_right_trunk")))

	HitReactionBSList(4)=(Stance=((Slot=BS_FullBody,AnimName="React_back_trunk"), (Slot=BS_Additive,AnimName="ADD_React_trunk_only_left")))
	HitReactionBSList(5)=(Stance=((Slot=BS_FullBody,AnimName="React_fwd_trunk"), (Slot=BS_Additive,AnimName="ADD_React_trunk_only_left")))
	HitReactionBSList(6)=(Stance=((Slot=BS_FullBody,AnimName="React_left_trunk"), (Slot=BS_Additive,AnimName="ADD_React_trunk_only_left")))
	HitReactionBSList(7)=(Stance=((Slot=BS_FullBody,AnimName="React_right_trunk"), (Slot=BS_Additive,AnimName="ADD_React_trunk_only_left")))

	HitReactionBSList(8)=(Stance=((Slot=BS_FullBody,AnimName="React_back_trunk"), (Slot=BS_Additive,AnimName="ADD_React_trunk_only_right")))
	HitReactionBSList(9)=(Stance=((Slot=BS_FullBody,AnimName="React_fwd_trunk"), (Slot=BS_Additive,AnimName="ADD_React_trunk_only_right")))
	HitReactionBSList(10)=(Stance=((Slot=BS_FullBody,AnimName="React_left_trunk"), (Slot=BS_Additive,AnimName="ADD_React_trunk_only_right")))
	HitReactionBSList(11)=(Stance=((Slot=BS_FullBody,AnimName="React_right_trunk"), (Slot=BS_Additive,AnimName="ADD_React_trunk_only_right")))

	//HitReactionBSList(12)=(Stance=((Slot=BS_FullBody,AnimName="Rage_Trunk")))

	BlendInTime=0.05f
	BlendOutTime=0.15f

	DefaultAICommand=class'AICmd_Base_PushedBySpecialMove'
	bBreakFromCover=TRUE
	bDisableTurnInPlace=TRUE
	bShouldAbortWeaponReload=TRUE
	bCanFireWeapon=FALSE
	bDisableMovement=TRUE
	bLockPawnRotation=TRUE
	bDisableAI=TRUE
	bRestoreMovementAfterMove=TRUE
}
