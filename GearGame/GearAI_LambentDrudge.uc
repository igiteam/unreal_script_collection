/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 */
class GearAI_LambentDrudge extends GearAI_LambentDrone;

/** Accuracy to use after a leg mutation. Should be more accurate than the default. */
var() config float AI_Base_AimError_LegMutation;
/** Accuracy to use after an arm mutation. Should be less accurate than the default. */
var() config float AI_Base_AimError_ArmMutation;
/** Accuracy to use after an head mutation. Should be less accurate than the default. */
var() config float AI_Base_AimError_HeadMutation;

// Flags for mutations
var transient bool bMutatedHead;
var transient bool bMutatedArms;
var transient bool bMutatedLegs;

// target variables - for now they're actors
// moving all target vars to pawn: for replication - client doesn't have AI
var transient GearPawn_LambentDroneMutatable DrudgePawn;

/** Range of time between tentacle projectiles */
var() config float MinTentacleFireDelay;
var() config float MaxTentacleFireDelay;
/** Delay between shots in a burst - arms mutation */
var() config float MinTentacleBurstDelay;
var() config float MaxTentacleBurstDelay;
/** Delay between shots in a burst - arms AND legs mutation */
var() config float MinTentacleBurstDelay_Stalk;
var() config float MaxTentacleBurstDelay_Stalk;

/** Number of projectiles to fire per burst */
var() config int MinTentacleBurstFireCount;
var() config int MaxTentacleBurstFireCount;
/** Number of projectiles to fire per burst - arms AND legs mutation */
var() config int MinTentacleBurstFireCount_Stalk;
var() config int MaxTentacleBurstFireCount_Stalk;

/** Number of projectiles left to fire this burst */
var transient int CurrentBurstCount;


/** Range of time between head flame projectiles */
var() config float MinHeadWormFireDelay;
var() config float MaxHeadWormFireDelay;
var() config float MinHeadWormFireDuration;
var() config float MaxHeadWormFireDuration;

/** Range of fire attack - this depends on FlameThrowerSpray, not just number */
var() float MaxFlameThrowerDistance;

var transient vector LastHeardLocation;
var transient float LastHeardTime;

event Possess(Pawn NewPawn, bool bVehicleTransition)
{
	Super.Possess(NewPawn, bVehicleTransition);

	DrudgePawn = GearPawn_LambentDroneMutatable(NewPawn);
}

// Override GeneratePathTo functions to bail when we have a leg mutation
event bool GeneratePathTo( Actor Goal, optional float WithinDistance, optional bool bAllowPartialPath )
{
	if( bMutatedLegs )
	{
		return false;
	}
	return Super.GeneratePathTo(Goal, WithinDistance, bAllowPartialPath);
}

function bool GeneratePathToValidatedLocation( out Vector out_Goal, optional float WithinDistance, optional bool bAllowPartialPath )
{
	if( bMutatedLegs )
	{
		return false;
	}
	return Super.GeneratePathToValidatedLocation(out_Goal, WithinDistance, bAllowPartialPath);

}

event bool GeneratePathToLocation( Vector Goal, optional float WithinDistance, optional bool bAllowPartialPath )
{
	if( bMutatedLegs )
	{
		return false;
	}
	return Super.GeneratePathToLocation(Goal, WithinDistance, bAllowPartialPath);
}

// Don't do normal banzai if we have a leg mutation
function BanzaiAttack()
{
	if( bMutatedLegs )
	{
		AutoAcquireEnemy();
	}
	else
	{
		Super.BanzaiAttack();
	}
}

// Override to return false when there has been a leg mutation
function bool ShouldMoveToSquad( optional bool bSkipLastPositionCheck, optional Vector TestLocation )
{
	if( bMutatedLegs )
	{
		return false;
	}
	return Super.ShouldMoveToSquad(bSkipLastPositionCheck, TestLocation );
}

function float AdjustEnemyRatingForTentacle(Pawn P, bool bLeft)
{
	local Vector	EnemyLocation, X, Y, Z;
	local Vector	VectToEnemy;
	local float		EnemyDotY;
	local float     DistToEnemy;
	local float		RatingMult;

	RatingMult = 1.f;
	EnemyLocation = GetEnemyLocation(P);

	// Penalize enemies that would require this gun to shoot across the body
	GetAxes( MyGearPawn.Rotation, X, Y, Z );
	VectToEnemy = EnemyLocation - MyGearPawn.Location;

	DistToEnemy = VSize(VectToEnemy);

	// Penalize enemies that are very far away
	if( DistToEnemy == 0.0f || DistToEnemy > 2.0f * EnemyDistance_Long )
	{
		return 0.f;
	}
	else if( DistToEnemy > EnemyDistance_Long )
	{
		RatingMult *= 0.5f;
	}

	EnemyDotY = (VectToEnemy / DistToEnemy) DOT Y;
	if( ( bLeft && EnemyDotY > 0.f) ||
		(!bLeft && EnemyDotY < 0.f) )
	{
		RatingMult *= 0.5f;
	}

	// Prefer to shoot at a different enemy then the other gun
	if( ( bLeft && DrudgePawn.RightTentacleTarget == P ) ||
		( !bLeft && DrudgePawn.LeftTentacleTarget == P ) )
	{
		RatingMult *= 0.5f;
	}

	return RatingMult;
}

// do not interrupt if mutated
// AI command keeps sending them to cover or so
// Do not send anywhere!!!
function bool CheckInterruptCombatTransitions()
{
	if ( bMutatedLegs || bMutatedArms || bMutatedHead )
	{
		return FALSE;
	}

	return Super.CheckInterruptCombatTransitions();
}

// If leg is mutated, it can shoot 360 degrees
function int GetCanFireFacingThreshold()
{
	// default is 45 degrees
	if ( bMutatedLegs )
	{
		// all directions
		return 65536;
	}

	return Super.GetCanFireFacingThreshold();
}

function bool SelectEnemy()
{
	local Pawn BestLeftTarget, BestRightTarget;
	local float Rating, BestLeftRating, BestRightRating;
	local int EnemyIdx;
	local bool bSuperRetval;

	bSuperRetval = Super.SelectEnemy();
	if( bMutatedArms )
	{
		if( Enemy == None )
		{
			DrudgePawn.LeftTentacleTarget = None;
			DrudgePawn.RightTentacleTarget = None;
			return false;
		}

		BestLeftRating = -1.f;
		BestRightRating = -1.f;
		for( EnemyIdx = 0; EnemyIdx < LocalEnemyList.length; ++EnemyIdx )
		{
			if( LocalEnemyList[EnemyIdx].Rating > 0.f )
			{
				Rating = LocalEnemyList[EnemyIdx].Rating * AdjustEnemyRatingForTentacle(LocalEnemyList[EnemyIdx].Pawn, true);
				if( Rating > 0.f &&
					( BestLeftRating <= 0.f || Rating > BestLeftRating ) )
				{
					BestLeftTarget = LocalEnemyList[EnemyIdx].Pawn;
					BestLeftRating = Rating;
				}

				Rating = LocalEnemyList[EnemyIdx].Rating * AdjustEnemyRatingForTentacle(LocalEnemyList[EnemyIdx].Pawn, false);
				if( Rating > 0.f &&
					( BestRightRating <= 0.f || Rating > BestRightRating ) )
				{
					BestRightTarget = LocalEnemyList[EnemyIdx].Pawn;
					BestRightRating = Rating;
				}
			}
		}
		DrudgePawn.LeftTentacleTarget = BestLeftTarget;
		DrudgePawn.RightTentacleTarget = BestRightTarget;
	}

	if ( bMutatedHead )
	{
		// temporary target selection code - the firing distance
		if ( Enemy != none )
		{
			if ( VSizeSq(Enemy.Location-Pawn.Location) <= MaxFlameThrowerDistance*MaxFlameThrowerDistance )
			{
				DrudgePawn.HeadWormTarget = Enemy;
			}
			else
			{
				DrudgePawn.HeadWormTarget = none;
			}
		}
		else
		{
			DrudgePawn.HeadWormTarget = none;
		}
	}

	DrudgePawn.FireTarget = Enemy;

	return bSuperRetval;
}

// overwrite melee for mutated state
function BeginMeleeCommandWrapper( Actor Inst, AIReactChannel OriginatingChannel )
{
	if ( !bMutatedHead )
	{
		// if head isn't mutated, just use parent melee - spew
		Super.BeginMeleeCommandWrapper( Inst, OriginatingChannel );
	}
	else
	{
		// or what else do I do?
		`log(self@" nothing else to do in melee ");
	}
}

// CanEngage Melee
function bool CanEngageMelee()
{
	// do not allow melee if charging
	if( Super.CanEngageMelee() && 
		!bMutatedHead &&
		FindCommandOfClass(class'AICmd_Drudge_Mutate') == None )
	{

		// if head isn't mutated, still allow
		return ( !bMutatedHead );
	}

	return FALSE;
}

function BeginExecutionCommandWrapper( Actor Inst, AIReactChannel OriginatingChannel )
{
	// go to Melee for now
	DoMeleeAttack(Pawn(Inst));
}

function DoMeleeAttack(optional Pawn NewEnemy, optional Actor InTarget)
{
	local GearPawn GP;

	GP = GearPawn(NewEnemy);
	
	// if any of these attacks are in progress, don't do it
	if (FindCommandOfClass(class'AICmd_Attack_LambentDrudgeSpew') != None 
		|| FindCommandOfClass(class'AICmd_Drudge_Execute') != None )
	{
		return;
	}

	`AIlog(GetFuncName());
	if (NewEnemy != None)
	{
		SetEnemy(NewEnemy);
	}

	// FIXME: only allow arm execution for now
	// when it's not stalked - because the animation won't work
	if( GP != None && CanExecutePawn(GP) )
	{
		class'AICmd_Drudge_Execute'.static.Execute(self, GP);
	}
	// if head isn't mutated
	else if (!bMutatedHead)
	{
		Super.DoMeleeAttack(NewEnemy, InTarget);
	}
}

/** Overridden to only allow executions after a head or arm mutation, and to allow execution of non-DBNO pawns */
function bool CanExecutePawn( GearPawn GP )
{
	if ( bCanExecute &&
		 MyGearPawn != None &&
		 GP != None &&
		 !GP.InGodMode() &&
		 !GP.bUnlimitedHealth && 
		 // for now we don't allow if leg is muated
		 ( !bMutatedLegs ) && 
		 // if arm is mutated, make sure no arm is destroyed yet
		 ( bMutatedArms && !DrudgePawn.bRightTentacleArmDestroyed && !DrudgePawn.bLeftTentacleArmDestroyed ) &&
		 GP != Pawn &&
		 !Pawn.IsSameTeam( GP ) &&
		 !MyGearPawn.IsDBNO() &&
		 !GP.IsInPainVolume() &&
		 !IsDead() &&
		 !GP.IsAHostage() &&
		 GP.CanBeSpecialMeleeAttacked(MyGearPawn) &&
		 !MyGearPawn.IsAKidnapper()
		)
	{
		return TRUE;
	}

	return FALSE;
}

function Destabilize( Actor Inst, AIReactChannel OriginatingChannel )
{
	bDestabilized = true;
	ReactionManager.SuppressReactionsByType(class'AIReactCond_DmgThreshold',false);

	if ( !bMutatedHead && !bMutatedArms && !bMutatedLegs &&
		FindCommandOfClass(class'AICmd_Drudge_Mutate') == None )
	{
		// clear all commands and add mutate command
		AbortCombatCommands();
		// have it choose which to transform
		class'AICmd_Drudge_Mutate'.static.Mutate( self );
		DefaultCommand=class'AICmd_Base_LambentDrudge';
	}
	// if leg isn't mutated, destabilize as well
	else if ( !bMutatedLegs && (bMutatedArms || bMutatedHead))
	{
		// if leg isn't mutated
		Super.Destabilize( Inst, OriginatingChannel );
	}
}

// PauseHeadFire
function PauseHeadFire()
{
	TurnOffHeadWormFire();
	ClearTimer(nameof(TryTurnOnHeadWormFire));
	ClearTimer(nameof(TurnOffHeadWormFire));
}

function  ResumeHeadFire()
{
	TryTurnOnHeadWormFire();
}

// pause it
function PauseAttack()
{
	// if he's firing, stop
	if (MyGearPawn.MyGearWeapon.IsFiring())
	{
		MyGearPawn.MyGearWeapon.StopFire(0);
	}

	if ( bMutatedHead )
	{
		PauseHeadFire();
	}

	if ( bMutatedArms )
	{
		PauseTentacleFire();
	}
}

// resume attack
function ResumeAttack()
{
	if (MyGearPawn == none)
	{
		ClearTimer(nameof(ResumeAttack));
		return;
	}

	if (MyGearPawn.SpecialMove != SM_None || Enemy==none)
	{
		SetTimer(0.5f, FALSE, nameof(ResumeAttack));
		return;
	}

	if (bMutatedHead)
	{
		ResumeHeadFire();
	}

	if (bMutatedArms)
	{
		ResumeTentacleFire();
	}
}

function float GetTentacleBurstDelay()
{
	if( DrudgePawn != None )
	{
		if( DrudgePawn.Transforms[ETS_LEGS].Mutated &&
			DrudgePawn.Transforms[ETS_ARMS].Mutated )
		{
			return RandRange(MinTentacleBurstDelay_Stalk, MaxTentacleBurstDelay_Stalk);
		}
	}

	return RandRange(MinTentacleBurstDelay, MaxTentacleBurstDelay);
}

function float GetTentacleFireDelay()
{
	return RandRange(MinTentacleFireDelay, MaxTentacleFireDelay);
}

function int GetBurstCount()
{
	if( DrudgePawn != None )
	{
		if( DrudgePawn.Transforms[ETS_LEGS].Mutated &&
			DrudgePawn.Transforms[ETS_ARMS].Mutated )
		{
			return Rand(MaxTentacleBurstFireCount_Stalk - MinTentacleBurstFireCount_Stalk + 1) + MinTentacleBurstFireCount_Stalk;
		}
	}
	return Rand(MaxTentacleBurstFireCount - MinTentacleBurstFireCount + 1) + MinTentacleBurstFireCount;
}

function PauseTentacleFire()
{
	ClearTimer(nameof(RightTentacleFire));
	ClearTimer(nameof(LeftTentacleFire));
}

function ResumeTentacleFire()
{
	SetTimer(GetTentacleFireDelay(), false, nameof(LeftTentacleFire));
}

function LeftTentacleFire()
{
	if( DrudgePawn != None )
	{
		if ( DrudgePawn.LeftTentacleHealth > 0 )
		{
			if( Enemy == None || DrudgePawn.LeftTentacleTarget == None )
			{
				SelectEnemy();
			}

			// FIXME: LH - I need to make sure if I'm facing at least that way
			if ( DrudgePawn.LeftTentacleTarget!=None )
			{
				DrudgePawn.PlayTentaclePreFireAnimation(false);
			}
		}
		--CurrentBurstCount;

		if( CurrentBurstCount > 0 )
		{
			DrudgePawn.bTentacleHeatRampUp = TRUE;
			DrudgePawn.TentacleHeatRamp();

			SetTimer(GetTentacleBurstDelay(), false, nameof(RightTentacleFire) );
		}
		else
		{
			DrudgePawn.bTentacleHeatRampUp = FALSE;
			DrudgePawn.TentacleHeatRamp();

			CurrentBurstCount = GetBurstCount();
			// Alternate firing if both tentacles are alive
			if( DrudgePawn.RightTentacleHealth > 0 )
			{
				SetTimer(GetTentacleFireDelay(), false, nameof(RightTentacleFire));
			}
			else if( DrudgePawn.LeftTentacleHealth > 0 )
			{
				SetTimer(GetTentacleFireDelay() * 2.f, false, nameof(LeftTentacleFire));
			}
		}
	}
}

function RightTentacleFire()
{
	if( DrudgePawn != None )
	{
		if ( DrudgePawn.RightTentacleHealth >  0 )
		{
			if( Enemy == None || DrudgePawn.RightTentacleTarget == None )
			{
				SelectEnemy();
			}

			// FIXME: LH - I need to make sure if I'm facing at least that way
			if ( DrudgePawn.RightTentacleTarget != None )
			{
				DrudgePawn.PlayTentaclePreFireAnimation(true);
			}
		}

		--CurrentBurstCount;

		if( CurrentBurstCount > 0 )
		{
			DrudgePawn.bTentacleHeatRampUp = TRUE;
			DrudgePawn.TentacleHeatRamp();

			SetTimer(GetTentacleBurstDelay(), false, nameof(LeftTentacleFire));
		}
		else
		{
			DrudgePawn.bTentacleHeatRampUp = FALSE;
			DrudgePawn.TentacleHeatRamp();

			CurrentBurstCount = GetBurstCount();
			// Alternate firing if both tentacles are alive
			if( DrudgePawn.LeftTentacleHealth > 0 )
			{
				SetTimer(GetTentacleFireDelay(), false, nameof(LeftTentacleFire));
			}
			else if( DrudgePawn.RightTentacleHealth > 0 )
			{
				SetTimer(GetTentacleFireDelay() * 2.f, false, nameof(RightTentacleFire));
			}
		}
	}
}

// turn on headworm fire - make sure this doesn't get called while animation is playing
function TryTurnOnHeadWormFire()
{
	SelectEnemy();

	if( DrudgePawn.HeadWormTarget != None )
	{
		TurnOnHeadWormFire();
	}
	else
	{
		SetTimer(2.f, FALSE, nameof(TryTurnOnHeadWormFire));
	}
}

// check to see if I should turn off fire
function CheckHeadWormFire()
{
	if ( Enemy != none && DrudgePawn.HeadWormTarget != none )
	{
		if ( DrudgePawn!=none && DrudgePawn.bPlayHeadWormAnim )
		{
			if ( VSizeSq(Enemy.Location-Pawn.Location) > MaxFlameThrowerDistance*MaxFlameThrowerDistance )
			{
				// if it calls from here, I need to clear timer for TurnOffHeadWormFire
				ClearTimer(nameof(TurnOffHeadWormFire));
				TurnOffHeadWormFire();
			}
		}
	}
}

// turn on headworm fire - make sure this doesn't get called while animation is playing
function TurnOnHeadWormFire()
{
	if( DrudgePawn != None )
	{
		if ( DrudgePawn.HeadWormTarget!=none )
		{
			// during head fire, stop tentacle fire
			PauseTentacleFire();

			DrudgePawn.PlayHeadFireAnimation();
		}

		SetTimer(RandRange(MinHeadWormFireDuration, MaxHeadWormFireDuration), FALSE, nameof(TurnOffHeadWormFire));
		SetTimer(1.f, TRUE, nameof(CheckHeadWormFire));
	}
}

// Turn off - make sure this doesn't get called while animation is playing
function TurnOffHeadWormFire()
{
	if( DrudgePawn != None )
	{
		DrudgePawn.StopHeadFireAnimation();

		// Restart tentacle fire after headworm is done
		ResumeTentacleFire();
	}

	SetTimer(RandRange(MinHeadWormFireDelay, MaxHeadWormFireDelay), FALSE, nameof(TryTurnOnHeadWormFire));
	ClearTimer(nameof(CheckHeadWormFire));
}

/** Called to notify the AI of the mutation */
function Mutated(INT TransformFlags)
{
	if( DrudgePawn != None )
	{
		if( DrudgePawn.IsHeadMutation(TransformFlags) && !bMutatedHead )
		{
			bMutatedHead = true;
			bCanExecute = true;
			ReactionManager.UnSuppressReactionsByType(class'AIReactCond_EnemyCloseAndVisible',false);
			// will be overwritten if other parts are mutated
			BaseAimError = AI_Base_AimError_HeadMutation;
		}
		if( DrudgePawn.IsArmMutation(TransformFlags) && !bMutatedArms )
		{
			bMutatedArms = true;
			bCanExecute = true;
			ReactionManager.UnSuppressReactionsByType(class'AIReactCond_EnemyCloseAndVisible',false);

			// Modify accuracy upon leg mutation
			BaseAimError = AI_Base_AimError_ArmMutation;
		}
		if( DrudgePawn.IsLegMutation(TransformFlags) && !bMutatedLegs )
		{
			//ReactionManager.UnSuppressReactionsByType(class'AIReactCond_DmgThreshold',false);

			// this is kind of hack, but we don't want any hit reaction except leg mutation
			MinFullBodyHitReactionInterval=5.f;
			bMutatedLegs = true;

			// Prevent the AI from trying to move when it has a leg mutation
			ClearTether();
			bIgnoreStepAside = true;

			// Modify accuracy if we have a leg mutation and no arm mutation
			if( !bMutatedArms )
			{
				BaseAimError = AI_Base_AimError_LegMutation;
			}
		}

		ResumeAttack();
	}
}

event NotifyEnemyHeard( Pawn HeardEnemy, Name NoiseType )
{
	// only when head is mutated but not arms
	if ( bMutatedHead && !bMutatedArms )
	{
		// at least wait for a bit
		if ( WorldInfo.TimeSeconds - LastHeardTime > 1.f )
		{
			LastHeardLocation = HeardEnemy.Location;
			LastHeardTime = WorldInfo.TimeSeconds;
		}
	}

	Super.NotifyEnemyHeard(HeardEnemy, NoiseType);
}

function bool AllowScriptedMove()
{
	if ( bMutatedLegs )
	{
		return FALSE;
	}

	return TRUE;
}
function OnAIMove(SeqAct_AIMove Action)
{
	// make sure trunk doesn't move even with kismet
	if (AllowScriptedMove())
	{
		Super.OnAIMove(Action);
	}
	else
	{
		// abort any previous latent moves
		ClearMoveAction();
	}
}

function OnAIMoveToActor( SeqAct_AIMoveToActor Action )
{
	// make sure trunk doesn't move even with kismet
	if (AllowScriptedMove())
	{
		Super.OnAIMoveToActor(Action);
	}
	else
	{
		// abort any previous latent moves
		ClearLatentAction( class'SeqAct_AIMoveToActor', TRUE );
		ClearMoveAction();
	}
}
/** Overridden to account for leg mutation, where AimRot.Yaw should not be set to Pawn.Rotation.Yaw */
function rotator DefaultGetAdjustedAimFor(Weapon W, vector StartFireLoc)
{
	local rotator AimRot;

	AimRot = Super.DefaultGetAdjustedAimFor(W, StartFireLoc);

	// Use AimOffsetPct when we have a leg mutation
	if( MyGearPawn != None && bMutatedLegs )
	{
		AimRot.Yaw = Pawn.Rotation.Yaw + 16384 * MyGearPawn.AimOffsetPct.X;
	}

	return AimRot;
}


function DoEvade( ESpecialMove EvadeDir, optional bool bClearActionDamage )
{
	// if leg is mutated, don't go default evade, but trigger specialmoves
	if( bMutatedLegs )
	{
		if (!MyGearPawn.IsDoingASpecialMove())
		{
			MyGearPawn.DoSpecialMove(EvadeDir);
		}

		return;
	}

	super.DoEvade(EvadeDir,bClearActionDamage);
}

/** When special move is started */
function NotifyStartOfSpecialMove( GearPawn.ESpecialMove NewMove )
{
	if (NewMove != SM_None)
	{
		PauseAttack();
	}

	Super.NotifyStartOfSpecialMove(NewMove);
}

/** When special move is complete allow movement to continue */
function NotifyEndOfSpecialMove( GearPawn.ESpecialMove LastMove )
{
	Super.NotifyEndOfSpecialMove(LastMove);
	ResumeAttack();
}

function NotifyEvadeByDamage( Actor Inst, AIReactChannel OriginatingChannel )
{
	local ESpecialMove EvadeDir;
	local vector ToEnemy, Facing;
	local float CosAngle;

	if ( bMutatedLegs )
	{
		ToEnemy = Normal(Inst.Location-MyGearPawn.Location);
		Facing = vector(MyGearPawn.Rotation);
		CosAngle = Abs(ToEnemy Dot Facing);
		// if it's either front or back 45 degree
		if (CosAngle > 0.707f)
		{
			if (FRand() < 0.05f && MyGearPawn.SpecialMove == SM_None)
			{
				// then do right or left
				if( FRand() < 0.5f )
				{
					EvadeDir = SM_EvadeLt;
				}
				else
				{
					EvadeDir = SM_EvadeRt;
				}
			}
		}
		else
		{
			// then do right or left
			if( FRand() < 0.5f )
			{
				EvadeDir = SM_EvadeBwd;
			}
			else
			{
				EvadeDir = SM_EvadeFwd;
			}
		}
	}
	else
	{
		if( FRand() < 0.5f )
		{
			EvadeDir = SM_EvadeLt;
		}
		else
		{
			EvadeDir = SM_EvadeRt;
		}
	}

	DoEvade( EvadeDir, TRUE );
}

defaultproperties
{
	bCanRevive=FALSE
	bCanExecute = FALSE

	MaxFlameThrowerDistance = 1400.f

	Begin Object Name=DamageReaction0
		DamageThreshold=800
	End Object

	Begin Object Class=AIReactCond_DmgThreshold Name=DamageReaction1
		DamageThreshold=200
		OutputFunction=NotifyEvadeByDamage
	End Object
	DefaultReactConditions.Add(DamageReaction1)

	// Execution reaction
	Begin Object Class=AIReactCond_EnemyCloseAndVisible Name=EnemyInMeleeRangeReaction1
		AutoSubscribeChannels(1)=Hearing
		AutoSubscribeChannels(2)=Force
		AutoSubscribeChannels(3)=Damage
		DistanceThreshold=400
		bSuppressed=true
		OutputFunction=BeginExecutionCommandWrapper
	End Object
	DefaultReactConditions.Add(EnemyInMeleeRangeReaction1)
}
