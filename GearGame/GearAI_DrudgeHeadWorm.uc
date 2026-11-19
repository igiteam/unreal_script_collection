//=============================================================================
// Controller for Drudge Head Worm
//
// Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
//=============================================================================

class GearAI_DrudgeHeadWorm extends GearAI
	native(AI);

// roam params
var config float MaxRoamDist;
var config float MinRoamDist;

/** Fire breath durations */
var() config float MinHeadWormFireDuration;
var() config float MaxHeadWormFireDuration;

var class<AICommand> ChargeEnemyCommandClass;

var GearPawn_DrudgeHeadWormBase HeadWorm;


cpptext
{
	virtual void	UpdatePawnRotation();
	virtual FRotator SetRotationRate(FLOAT deltaTime);
};

function Possess(Pawn NewPawn, bool bVehicleTransition)
{
	Super.Possess(NewPawn,bVehicleTransition);
	HeadWorm = GearPawn_DrudgeHeadWormBase(NewPawn);
}

function bool ShouldMoveToSquad( optional bool bSkipLastPositionCheck, optional Vector TestLocation )
{
	return FALSE;
}

singular function bool StepAsideFor( Pawn ChkPawn );

event bool HandlePathObstruction( Actor BlockedBy )
{
	return TRUE;
}

function bool ShouldAllowWalk()
{
	return false;
}

event vector GetAimLocation(vector StartLoc, optional bool bActuallyFiring, optional Actor AimTarget )
{
	if( !IsZero(GetFocalPoint()) )
	{
		return GetFocalPoint();
	}

	return Super.GetAimLocation(StartLoc,bActuallyFiring,AimTarget);
}

// Overwrite Melee attack
function StartFireWrapper( Actor Inst, AIReactChannel OriginatingChannel )
{
	StartFireSpray();
}

// wrapper to call headworm target startspray
function StartFireSpray()
{
	// Don't use firebreath immediately after spawning
	if( `TimeSince(HeadWorm.CreationTime) > 4.f )
	{
		// if I have clear line of sight to, do not interrupt if already firing
		if (!IsFireSprayOn() && CanFireSprayOn())
		{
			// stop moving if firing - at least initially
			ClearMovementInfo();
			HeadWorm.StartFireSpray();
			SetTimer(RandRange(MinHeadWormFireDuration, MaxHeadWormFireDuration), FALSE, 'StopFireSpray');
		}
	}
}

// wrapper to stop spray
function StopFireSpray()
{
	ClearTimer('StopFireSpray');
	ClearTimer('EmergencyStopFireSpray');
	HeadWorm.StopFireSpray();
}

// emergency stop fire - don't use stopfirespray. That timer is already active,
function EmergencyStopFireSpray()
{
	StopFireSpray();
}

// Is fire on?
function bool IsFireSprayOn()
{
	return (HeadWorm!=none && HeadWorm.bFireSprayOn);
}

// Can he fire?
function bool CanFireSprayOn()
{
	local vector ToEnemy;
	// rotation does not match with head rotation
	local matrix HeadBoneMatrix;
	local rotator HeadBoneRot;
	//FlushPersistentDebugLines();

	// first check line of sight
	if (FastTrace(Enemy.Location, HeadWorm.Location))
	{
		HeadBoneMatrix = HeadWorm.Mesh.GetBoneMatrix(HeadWorm.Mesh.MatchRefBone('Head_Creature_Head'));
		HeadBoneRot = MatrixGetRotator(HeadBoneMatrix);
		HeadBoneRot.Pitch = 0;

//		DrawDebugLine(MatrixGetOrigin(HeadBoneMatrix), MatrixGetOrigin(HeadBoneMatrix)+vector(HeadBoneRot)*100, 255, 255, 0, TRUE);
		// now check if head bone is aligned with enemy
		ToEnemy = Enemy.Location - MatrixGetOrigin(HeadBoneMatrix);
		// Remove Z - get rid of pitch diff
		ToEnemy.Z = 0;
		ToEnemy = Normal(ToEnemy);
		// check cone - right allow within 40 degree
//		if ( vector(HeadBoneRot) dot ToEnemy >= 0.76f )
		// since now it's grenade, forward allow it
		if ( vector(HeadBoneRot) dot ToEnemy >= 0.f )
		{
//			DrawDebugLine(MatrixGetOrigin(HeadBoneMatrix), Enemy.Location, 0, 255, 0, TRUE);
			return TRUE;
		}
	}

//	DrawDebugLine(MatrixGetOrigin(HeadBoneMatrix), Enemy.Location, 255, 0, 0, TRUE);
	return FALSE;
}

/** Tick to move head to enemy if firing**/
simulated function Tick(float DeltaTime)
{
	// if spray is on, and can't fire, turn it off
	if (IsFireSprayOn() && CanFireSprayOn()==FALSE && IsTimerActive('EmergencyStopFireSpray') == FALSE)
	{
		// set timer, so that it doesn't start/stop like crazy
		SetTimer(0.2f, FALSE, 'EmergencyStopFireSpray');
	}
	
	Super.Tick(DeltaTime);
}

defaultproperties
{
	DefaultCommand=class'AICmd_Base_DrudgeHeadWorm'

	DefaultReactConditions.Empty
	DefaultReactConditionClasses.Empty

	Begin Object Class=AIReactCond_EnemyCloseAndVisible Name=EnemyInFireRangeReaction0
		AutoSubscribeChannels(1)=Hearing
		AutoSubscribeChannels(2)=Force
		DistanceThreshold=1000.f
		MinTimeBetweenActivations=5.f
		OutputFunction=StartFireWrapper
	End Object
	DefaultReactConditions.Add(EnemyInFireRangeReaction0)

	bCanRevive=false
	bForceHasValidTarget=true
	bCanMelee=false
}
