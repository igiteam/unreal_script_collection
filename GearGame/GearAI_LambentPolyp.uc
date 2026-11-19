/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearAI_LambentPolyp extends GearAI
	config(AI);

/** Maximum distance to travel when roaming to player */
var config float MaxRoamDist;
/** Outer distance for roaming envelope */
var config float RoamEnvelopeOuter;
/** Inner distance for roaming envelope */
var config float RoamEnvelopeInner;
/** Range for how long to pause while roaming */
var config float RoamWaitMax;
var config float RoamWaitMin;
/** Range for how long to roam before trying to melee charge */
var config float OverallRoamDurationMin;
var config float OverallRoamDurationMax;
/** Earliest time we should stop roaming */
var transient float RoamEndTime;

/** Earliest time we should try spitting */
var transient float NextSpitTime;
/** Delay between spit attacks */
var config float SpitDelayRangeMin;
var config float SpitDelayRangeMax;

/** Range at which to use pounce melee anim vs stationary */
var() config float MeleePounceRange;

/** True if this polyp is the squad leader */
var transient bool bSquadLeader;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	NextSpitTime = WorldInfo.TimeSeconds + RandRange(SpitDelayRangeMin, SpitDelayRangeMax);
}

/** Always force polyps onto the same squad */
event SetSquadName( Name NewSquadName, optional bool bLeader )
{
	Super.SetSquadName('PolypsAreFun', bLeader);

	// Set this polyp as the leader if the squad does not have one
	if( Squad != None && Squad.Leader == None )
	{
		Squad.RegisterSquadMember(self, true);
	}
}

function bool ShouldMoveToSquad( optional bool bSkipLastPositionCheck, optional Vector TestLocation )
{
	return false;
}

/** Check if we have been assigned or unassigned as our squad's leader */
function NotifySquadLeaderChanged()
{
	if( Squad != None )
	{
		if( Squad.Leader == self )
		{
			bSquadLeader = true;
		}
		else if( Squad.Leader != self )
		{
			bSquadLeader = false;
		}
	}
	Super.NotifySquadLeaderChanged();
}

singular function bool StepAsideFor( Pawn ChkPawn );

function AddBasePathConstraints(bool bIsCoverSearch)
{
	Super.AddBasePathConstraints(bIsCoverSearch);
	class'NavMeshPath_PreferWalls'.static.PreferWalls(NavigationHandle, 1000);
}

/** If banzai attack is set up as melee, do a kamikaze explosion at the target */
function OnAIForceBanzaiCharge(SeqAct_AIForceBanzaiCharge Action)
{
	local Actor Target;

	NotifyDidSomethingInteresting();
	if( Action.bMelee && Action.MeleeTarget != None )
	{
		Target = Action.MeleeTarget;
		if( Pawn(Action.MeleeTarget) != None )
		{
			SetEnemy(Pawn(Target));
		}
		else if( Controller(Action.MeleeTarget) != None )
		{
			Target = Controller(Action.MeleeTarget).Pawn;
			SetEnemy(Pawn(Target));
		}
		class'AICmd_Attack_LambentPolypBanzaiExplode'.static.BanzaiExplode(self, Target);
	}
	else
	{
		BanzaiAttack();
	}
}

/** For normal banzai, alert the polyp to enemies, and they'll seek them out normally */
function BanzaiAttack()
{
	MaxRoamDist = 100000;
	AutoAcquireEnemy();
}

function DoMeleeAttack(optional Pawn NewEnemy, optional Actor InTarget)
{
	`AIlog(GetFuncName());
	if (NewEnemy != None)
	{
		SetEnemy(NewEnemy);
	}
	
	class'AICmd_Attack_LambentPolypMelee'.static.Melee(self, InTarget);
}

function DoSpitAttack(optional Pawn NewEnemy)
{
	`AIlog(GetFuncName());
	if( CachedAICommandList == None || CachedAICommandList.IsAllowedToFireWeapon() )
	{
		if (NewEnemy != None)
		{
			SetEnemy(NewEnemy);
		}


		if( FindCommandOfClass(class'AICmd_Attack_LambentPolypSpit') == None )
		{
			class'AICmd_Attack_LambentPolypSpit'.static.InitCommand(self);
		}
	}
}

function BeginMeleeCommandWrapper( Actor Inst, AIReactChannel OriginatingChannel )
{
	`AILog(GetFuncName());
	DoMeleeAttack(Pawn(Inst));
}
function bool NotifyBump( Actor Other, vector HitNormal );


/** Override to prevent firing outside of spit special move */
event StartFiring(optional int InBurstsToFire=-1)
{
	if( MyGearPawn.IsDoingSpecialMove(GSM_LambentPolyp_Spit) )
	{
		Super.StartFiring(InBurstsToFire);
	}
}

function bool ShouldSpit()
{
	return ( NextSpitTime < WorldInfo.TimeSeconds && ClaimFireTicket() );
}

function bool ShouldMelee()
{
	local float MeleeChance;

	if( RoamEndTime < WorldInfo.TimeSeconds )
	{
		// Lower chance of melee attack when on ceilings or walls
		MeleeChance = Pawn.Floor dot vect(0,0,1) * 0.5f + 0.8f;
		return ( FRand() < MeleeChance && ClaimFireTicket() );
	}
	return false;
}

function OnNewEnemy(Actor InInstigator, AIReactChannel OrigChannel)
{
	GearPawn_LambentPolypBase(MyGearPawn).PlayEnemyAcquiredSound();
}

event bool CanUseJumpLink(JumpLink Link)
{
	return Link.bAllowPolyps;
}

defaultproperties
{
	DefaultCommand=class'AICmd_Base_LambentPolyp'
	DefaultReactConditions.Empty
	DefaultReactConditionClasses.Empty

	CombatMood=AICM_Aggressive

	// melee reaction
	/*
	Begin Object Name=EnemyInMeleeRangeReaction0
		AutoSubscribeChannels(0)=EnemyWithinMeleeDistance
		OutputFunction=BeginMeleeCommandWrapper
	End Object
	DefaultReactConditions.Add(EnemyInMeleeRangeReaction0)
	*/

	// plays a sound whenever we have a new enemy
	Begin Object class=AIReactCond_GenericCallDelegate Name=SoundCaller0
		AutoSubscribeChannels(0)=NoticedEnemy
		OutputFunction=OnNewEnemy
	End Object
	DefaultReactConditions.Add(SoundCaller0)

	bCanRevive=false
	bCanExecute=false

	bUseFireTickets=false
	bIgnoreSquadPosition=true
	bUseFlockingMovement=true

	MaxPathLaneValue=4.f
}
