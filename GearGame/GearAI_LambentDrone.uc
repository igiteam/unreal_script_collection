/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * Non Mutatable Lambent Drone
 *
 */
class GearAI_LambentDrone extends GearAI_Lambent
	native(AI);

/** True if charging */
var transient bool bCharging;
/** Set to true when Destabilize() has been called */
var transient bool bDestabilized;
/** True if drudge should have infinite health during the suicide charge */
var transient bool bUnlimitedHealthCharge;
/** Probability of charging when destabilized */
var() config float ChargeChance;
/** Preferred target to charge towards on death */
var transient Actor ChargeTarget;
/** Timer starts when the drudge starts its suicide charge. When it expires, the drudge will explode regardless if it reached its destination */
var transient float MaxChargingTime;

/** Custom burst fire range for Drudge */
var() config Vector2D BurstFireCount;

/** Spew time control */
var() config float ReSpewTime;
var transient float LastSpewTime;

/** Maximum distance to travel when roaming to player */
var config float MaxRoamDist;
/** Outer distance for roaming envelope */
var config float RoamEnvelopeOuter;
/** Inner distance for roaming envelope */
var config float RoamEnvelopeInner;

var config float RoamWaitMax;
var config float RoamWaitMin;

// effective range of spew attack
var config float SpewAttackRange;

// minimum time between screams
var config float MinTimeBetweenScreams;

// min distance between drudges
var config float MinDrudgeSeparationDist;

// if all enemeis are outside this distance, do closing behavior
var config float ClosingDistance;
// when closing, multiply groundspeed by this value
var config float ClosingSpeedModifier;

var transient float OldGroundSpeed;
cpptext
{
	// overidden to not rotate while charging
	void UpdatePawnRotation();
};

// Instead of DBNO, Lambent goes destabilized
function Destabilize( Actor Inst, AIReactChannel OriginatingChannel )
{
	local GearPawn InstigatorPawn;
	local GearPawn_LambentDroneBase Drudge;

	if( ChargeTarget != None || FRand() < ChargeChance )
	{
		// Cache the instigator PRI that caused this
		Drudge = GearPawn_LambentDroneBase(Pawn);
		InstigatorPawn = GearPawn(Inst);
		if( InstigatorPawn != None &&
			InstigatorPawn.PlayerReplicationInfo != None )
		{
			Drudge.Destabilizer = InstigatorPawn;
		}

		bDestabilized = true;
		ReactionManager.SuppressReactionsByType(class'AIReactCond_DmgThreshold',false);
		BeginChargeAttack();
	}
}

function BeginChargeAttack()
{
	local GearPawn_LambentDroneBase Drone;

	Drone = GearPawn_LambentDroneBase(Pawn);

	// switch roadie run to charge
	Drone.SpecialMoveClasses[SM_RoadieRun]=class'GSM_LambentDrone_Charge';
	Drone.SpecialMoveClasses[GSM_Drudge_PreCharge]=class'GSM_LambentDrone_PreCharge';
	Drone.SpecialMoveClasses[SM_StumbleFromMelee] = none;
	Drone.SpecialMoveClasses[SM_StumbleFromMelee2] = none;
	Drone.SpecialMoveClasses[SM_StumbleFromMantleKick] = none;

	// charge is on
	bCharging = TRUE;

	// send to charge command
	if ( FindCommandOfClass(class'AICmd_Attack_Drudge_Charge') == none )
	{
		AbortCombatCommands();
		BeginCombatCommand( class'AICmd_Attack_Drudge_Charge', "Charging!", TRUE );
	}
}

function SetupEnemyDistances(optional GearWeapon Wpn)
{
	Super.SetupEnemyDistances(Wpn);

	EnemyDistance_Melee=SpewAttackRange;
}

/** Overridden to abort AICmd_Base_LambentDrone_CloseIn, so we don't keep running towards previous target */
function OnAISetTarget(SeqAct_AISetTarget InAction)
{
	Super.OnAISetTarget(InAction);
	AbortCommand(None, class'AICmd_Base_LambentDrone_CloseIn');
}

// Override Melee attack to Spew
function DoMeleeAttack(optional Pawn NewEnemy, optional Actor InTarget)
{
	local GearPawn_LambentDroneBase Drone;

	Drone = GearPawn_LambentDroneBase(Pawn);

	`AIlog(GetFuncName());
	if (NewEnemy != None)
	{
		SetEnemy(NewEnemy);
	}

	if( FindCommandOfClass(class'AICmd_Attack_LambentDrudgeSpew') == None &&
		Drone.CanMeleeTarget(Enemy) )
	{
		class'AICmd_Attack_LambentDrudgeSpew'.static.Spew(self, InTarget);
	}
}

// Overwrite Melee attack
function BeginMeleeCommandWrapper( Actor Inst, AIReactChannel OriginatingChannel )
{
	DoMeleeAttack(Pawn(Inst));
}

// do explosion death
function DoSuicideExplosion()
{
	if( Pawn != None )
	{
		Pawn.GroundSpeed = 0.0;
		Pawn.ZeroMovementVariables();
		// suicide!
		Pawn.Died(self, class'GDT_Suicide',Pawn.Location);
	}
}

// CanEngage Melee
function bool CanEngageMelee()
{
	// do not allow melee if charging
	if (bCharging)
	{
		return FALSE;
	}

	// if spew time hasn't elapsed since last spew time
	if ( WorldInfo.TimeSeconds - LastSpewTime < ReSpewTime )
	{
		return FALSE;
	}

	return Super.CanEngageMelee();
}

function bool ShouldAutoReload()
{
	return false;
}

// During charge mode, it shoudl roadie run
function bool ShouldRoadieRun()
{
	if (bCharging)
	{
		return TRUE;
	}

	return Super.ShouldRoadieRun();
}

// Don't allow Banzai ATtack during charge
function BanzaiAttack()
{
	if (!bCharging)
	{
		Super.BanzaiAttack();
	}
}

/** Overridden for chaotic firing during scream special move */
event vector GetAimLocation(vector StartLoc, optional bool bActuallyFiring, optional Actor AimTarget )
{
	local GearWeapon GW;
	local vector MuzzleLoc;
	local rotator MuzzleRot;
	local AICmd_Attack_LambentDroneScream ScreamCmd;

	ScreamCmd = AICmd_Attack_LambentDroneScream(GetActiveCommand());
	if (Pawn != None && (bCharging || (bActuallyFiring && ScreamCmd != None)))
	{
		GW = GearWeapon(Pawn.Weapon);
		if (GW != None)
		{
			GW.GetMuzzleLocAndRot(MuzzleLoc,MuzzleRot);
			return (MuzzleLoc + 256.0 * vector(MuzzleRot));
		}
	}

	return Super.GetAimLocation(StartLoc, bActuallyFiring, AimTarget);
}

function NotifyStumbleAction( ESpecialMove Action )
{
	// NO! - we don't want to stumble, we are gods among drones
}

// fire the whole time we're moving
function int GetNumBurstsToFireWhileMoving()
{
	return -1;
}

/**
 *	Called from movetogoal to notify us that the AI is starting a move
 */
function StartingMovement()
{
	local float Max;
	OldGroundSpeed=Pawn.GroundSpeed;
	if(MoveAction != none && MoveAction.MovementStyle == EMS_Fast)
	{
		Max = class'GSM_LambentDrone_Charge'.default.MaxSpeed;
		Pawn.GroundSpeed = Max;
	}
}

function ClearMoveAction()
{
	if(MoveAction != none && OldGroundSpeed > 0)
	{
		Pawn.GroundSpeed = OldGroundSpeed;
	}
	Super.ClearMoveAction();
}

function OnAIMove(SeqAct_AIMove Action)
{
	Super.OnAIMove(Action);

	AutoAcquireEnemy();
	SelectTarget();
}


function CheckProximityToOtherDrudges()
{
	local GearPawn_LambentDroneBase OtherDrudge;
	local float CurDistSq;
	local float ThreshDistSq;

	ThreshDistSq = MinDrudgeSeparationDist*MinDrudgeSeparationDist;

	foreach WorldInfo.AllPawns(class'GearPawn_LambentDroneBase', OtherDrudge)
	{
		if(OtherDrudge == Pawn)
		{
			continue;
		}

		CurDistSq = VSizeSq(OtherDrudge.Location - Pawn.Location);
		if( CurDistSq < ThreshDistSq )
		{
			`AILog("too close to other drudge! stepping aside");
			StepAsideFor(OtherDrudge);
			return;
		}
	}
}

function OnNewEnemy(Actor InInstigator, AIReactChannel OrigChannel)
{
	GearPawn_LambentDroneBase(MyGearPawn).PlayEnemyAcquiredSound();
}

// Set focus otherwise aim won't work correctly
function FireFromOpen(optional int InBursts = 1, optional bool bAllowFireWhileMoving=true)
{
	// need to set focus, otherwise, aiming code won't work
	Focus = FireTarget;
	Super.FireFromOpen(InBursts, bAllowFireWhileMoving);
}

defaultproperties
{
	DefaultCommand=class'AICmd_Base_LambentDrone'

	bCanRevive=FALSE
	bIgnoreSquadPosition=TRUE
	CombatMood=AICM_Aggressive

	// melee reaction
	Begin Object Name=EnemyInMeleeRangeReaction0
		ChanceToMeleeMin=0.25f
		ChanceToMeleeMax=1.0f
	End Object

	// plays a sound whenever we have a new enemy
	Begin Object class=AIReactCond_GenericCallDelegate Name=SoundCaller0
		AutoSubscribeChannels(0)=NoticedEnemy
		OutputFunction=OnNewEnemy
	End Object
	DefaultReactConditions.Add(SoundCaller0)

	Begin Object Class=AIReactCond_DmgThreshold Name=DamageReaction0
		DamageThreshold=1120
		OutputFunction=Destabilize
		bOneTimeOnly=true
	End Object
	DefaultReactConditions.Add(DamageReaction0)

	DefaultReactConditionClasses.Remove(class'AIReactCond_Stumble')
	MaxStepAsideDist=256.0
}
