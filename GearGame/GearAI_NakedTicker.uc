/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearAI_NakedTicker extends GearAI_Ticker
	config(AI);

/** If true, this ticker can eat a pickup from a GearWeaponPickupFactory, not just dropped pickups */
var() const bool bCanEatPickupFactory; 

/** Radius within which to look for pickups */
var config float PickupCheckRadius;

/** Ranges for grenade leap */
var config float PickupLeapRangeMax;
var config float PickupLeapRangeMid;
var config float PickupLeapRangeMin;

/** Time of our last melee attack */
var transient float LastMeleeTime;

/** If true, this ticker is moving towards a pickup to eat */
var transient bool bSeekingPickup;

function PlayExplodeAnim();
function DoExplosion();

function DoMeleeAttack(optional Pawn NewEnemy, optional Actor InTarget)
{
	if( CachedAICommandList == None || CachedAICommandList.IsAllowedToFireWeapon() )
	{
		LastMeleeTime = WorldInfo.TimeSeconds;
		if (NewEnemy != None)
		{
			SetEnemy(NewEnemy);
			class'AICmd_Attack_Ticker_Melee'.static.Melee(self, NewEnemy);
		}
		else
		{
			class'AICmd_Attack_Ticker_Melee'.static.Melee(self, InTarget);
		}
	}
}

function BeginMeleeCommandWrapper( Actor Inst, AIReactChannel OriginatingChannel )
{
	DoMeleeAttack(Pawn(Inst));
}

function bool CanEngageMelee()
{
	return Super(GearAI).CanEngageMelee();
}

function bool ShouldDelayExplode()
{
	return true;
}

function ConsiderHiding(Actor EventInstigator, AIReactChannel OrigChannel)
{
	// If a naked ticker has been given a banzai command, continue attacking until dead
	if( !bHasBanzaiReTriggers )
	{ 
		Super.ConsiderHiding(EventInstigator, OrigChannel);
	}
}

/**
* Called when a DroppedPickup is spawned
*/
function NotifyDroppedPickup( GearDroppedPickup Pickup )
{
	if( CanEatPickup(Pickup) && !bSeekingPickup )
	{
		class'AICmd_Ticker_PickupWeapon'.static.PickupWeaponFromPickup(self, Pickup);
	}
}

function bool CanEatPickup( GearDroppedPickup Pickup )
{
	local GearPawn_LocustNakedTickerBase TickerPawn;
	local GearWeapon DroppedWeapon;

	TickerPawn = GearPawn_LocustNakedTickerBase(MyGearPawn);
	DroppedWeapon = GearWeapon(Pickup.Inventory);

	// Make sure the pickup is a non-heavy weapon
	return ( TickerPawn != None && !TickerPawn.bEatenPickup && 
			 DroppedWeapon != None && GearWeap_HeavyBase(DroppedWeapon) == None );
}

function bool CanEatGrenade(GearProj_Grenade Grenade)
{
	return ( Grenade.GetMartyrVictim() == None || Grenade.GetMartyrVictim() == Pawn ) && 
		   ( !Grenade.bBounce || Grenade.GetBounceCount() > 0 );
}

function bool SeekNearbyPickup()
{
	local GearProj_Grenade Grenade;
	local GearWeaponPickupFactory Factory, BestFactory;
	local GearDroppedPickup Pickup, BestPickup;
	local GearWeapon CurWeapon;
	local float BestPickupSqDist;

	//MyGearPawn.FlushPersistentDebugLines();
	//MyGearPawn.DrawDebugSphere(MyGearPawn.Location, Outer.PickupLeapRangeMax, 16, 0, 0, 255, TRUE);

	foreach MyGearPawn.CollidingActors(class'GearProj_Grenade', Grenade, PickupLeapRangeMax)
	{
		if (Grenade.bIsSimulating)
		{
			continue;
		}

		if( CanEatGrenade(Grenade) )
		{
			class'AICmd_Ticker_PickupWeapon'.static.PickupLiveGrenade(self, Grenade);
			return true;
		}
	}

	foreach MyGearPawn.CollidingActors(class'GearDroppedPickup', Pickup, PickupCheckRadius)
	{
		CurWeapon = GearWeapon(Pickup.Inventory);

		// Make sure the pickup is a non-heavy weapon
		if( CurWeapon != None && CanEatPickup(Pickup) )
		{
			if( BestPickup == None )
			{
				BestPickup = Pickup;
			}
			else if( CurWeapon.IsA('GearWeap_GrenadeBase') && !GearWeapon(BestPickup.Inventory).IsA('GearWeap_GrenadeBase') )
			{
				BestPickup = Pickup;
			}
			else if( CurWeapon.GetAIRating() > GearWeapon(BestPickup.Inventory).GetAIRating() )
			{
				BestPickup = Pickup;
			}
		}
	}

	if( BestPickup != None )
	{
		class'AICmd_Ticker_PickupWeapon'.static.PickupWeaponFromPickup(self, BestPickup);
		return true;
	}

	if( bCanEatPickupFactory )
	{
		// Find the best nearby pickup factory
		foreach MyGearPawn.CollidingActors(class'GearWeaponPickupFactory', Factory, PickupCheckRadius)
		{
			// Make sure the pickup is a non-heavy weapon
			if( Factory != None && Factory.CanBePickedUpBy(MyGearPawn) && Factory.ReadyToPickup(0.0) )
			{
				if( BestFactory == None || BestPickupSqDist <= 0.0f )
				{
					BestFactory = Factory;
					BestPickupSqDist = VSizeSq(MyGearPawn.Location - BestFactory.Location);
				}
				else if( ClassIsChildOf(Factory.WeaponPickupClass, class'GearWeap_GrenadeBase') && !ClassIsChildOf(BestFactory.WeaponPickupClass, class'GearWeap_GrenadeBase') )
				{
					BestFactory = Factory;
					BestPickupSqDist = VSizeSq(MyGearPawn.Location - BestFactory.Location);
				}
				else if( VSizeSq(MyGearPawn.Location - Factory.Location) < BestPickupSqDist )
				{
					BestFactory = Factory;
					BestPickupSqDist = VSizeSq(MyGearPawn.Location - BestFactory.Location);
				}
			}
		}
		if( BestFactory != None )
		{
			class'AICmd_Ticker_PickupWeapon'.static.PickupWeaponFromFactory(self, BestFactory);
			return true;
		}
	}

	return false;
}

function bool CheckInterruptCombatTransitions()
{
	local GearMeleeTarget MeleeObjective;
	local AICommand_Base_Combat	CurCommand;

	// If not in combat then don't bother
	CurCommand = AICommand_Base_Combat(CommandList);
	if( CurCommand == None )
	{
		return false;
	}

	if( CheckReviveOrExecute(GetReviveOrExecuteInterruptDist()) )
	{
		//`log("--- Ticker Found pawn to execute");
		return true;
	}

	if( GearGameMP_Base(WorldInfo.Game) != None )
	{
		// see if should melee objective
		MeleeObjective = GearMeleeTarget(GearGameMP_Base(WorldInfo.Game).GetObjectivePointForAI(self));
		if ( MeleeObjective != None && VSize(MeleeObjective.Location - Pawn.Location) < 512.0 &&
			FindCommandOfClass(class'AICmd_Melee_Forced') == None )
		{
			//`log("----- Ticker found fortification to attack:"@MeleeObjective);
			class'AICmd_Melee_Forced'.static.ForceMelee(self, MeleeObjective);
			return true;
		}
	}

	if( !GearPawn_LocustNakedTickerBase(MyGearPawn).bEatenPickup && !bSeekingPickup )
	{
		return SeekNearbyPickup();
	}

	return false;
}

/** Naked tickers are teamkilling jerks, so they execute their teammates instead of reviving */
function GoReviveTeammate( GearPawn GP )
{
	GoExecuteEnemy(GP);
}

/** checks if we should revive or execute any nearby DBNO pawns and if so pushes the appropriate command */
function bool CheckReviveOrExecute(float CheckDist)
{
	local GearPawn P;
	local GearTeamInfo Team;
	local int TeammateIdx;

	if( bCanExecute && FindCommandOfClass( class'AICmd_Execute' ) == None )
	{
		// check for enemies to execute
		if( Squad != None )
		{
			foreach Squad.AllEnemies(class'GearPawn', P)
			{
				if ( P.IsDBNO() && VSize(GetEnemyLocation(P) - Pawn.Location) < CheckDist &&
					!Squad.IsTryingToExecute(P) )
				{
					`AILog("Execute enemy:" @ P);
					GoExecuteEnemy(P);
					return true;
				}
			}
		}

		Team = GearTeamInfo(PlayerReplicationInfo.Team);
		if( Team != None )
		{
			for( TeammateIdx = 0; TeammateIdx < Team.TeamMembers.length; ++TeammateIdx )
			{
				P = GearPawn(Team.TeamMembers[TeammateIdx].Pawn);
				if ( P != none && P.IsDBNO() && VSize(P.Location - Pawn.Location) < CheckDist &&
					!Squad.IsTryingToExecute(P) )
				{
					`AILog("Execute enemy:" @ P);
					GoExecuteEnemy(P);
					return true;
				}
			}
		}
	}

	return false;
}

function bool CanExecutePawn( GearPawn GP )
{
	if( bCanExecute && MyGearPawn != None &&
		GP.IsDBNO(true) &&
		WorldInfo.TimeSeconds - GP.TimeStampEnteredRevivingState >= ExecuteDelay &&
		GP != Pawn &&
		!MyGearPawn.IsDBNO() &&
		!GP.IsInPainVolume() &&
		!IsDead() &&
		!GP.IsAHostage() &&
		( WorldInfo.GRI.IsMultiplayerGame() || GP.GetTeamNum() != TEAM_COG || !GP.bCanRechargeHealth ||
			(GP.IsHumanControlled() &&
			 GearPRI(GP.PlayerReplicationInfo).Difficulty.default.bHumanCOGCanBeExecuted &&
			 GP.GetMinDistToAnyHumanSquadMate() > GearPRI(GP.PlayerReplicationInfo).Difficulty.default.DistFromHumanSquadMatesBeforeEligibleForExecution) 
		)
	   )
	{
		return TRUE;
	}
	return FALSE;
}

function HandleExecuteReactionAndPushExecuteCommand(Actor Inst, AIReactChannel OrigChan)
{
	class'AICmd_Ticker_Execute'.static.Execute( self, GearPawn(Inst) );
}

defaultproperties
{
	DefaultCommand=class'AICmd_Base_NakedTicker'

	bCanExecute=true

	DefaultReactConditions.Empty

	// execute enemy
	Begin Object Class=AIReactCond_GenericCallDelegate Name=ExecutEnemyReaction0
		AutoSubscribeChannels(0)=HaveEnemyToExecute
		OutputFunction=HandleExecuteReactionAndPushExecuteCommand
	End Object
	DefaultReactConditions.Add(ExecutEnemyReaction0)

	// melee reaction
	Begin Object Class=AIReactCond_EnemyCanBeMeleed Name=EnemyInMeleeRangeReaction0
		AutoSubscribeChannels(0)=EnemyWithinMeleeDistance
		OutputFunction=BeginMeleeCommandWrapper
	End Object
	DefaultReactConditions.Add(EnemyInMeleeRangeReaction0)

	DefaultReactConditions.Add(ChargeCloseAndVis0)
	DefaultReactConditions.Add(HideFromNewEnemy0)
	DefaultReactConditions.Add(NewEnemy0)

	DefaultReactConditionClasses.Empty
	DefaultReactConditionClasses.Add(class'AIReactCond_Ticker_Grenade')
	DefaultReactConditionClasses.Add(class'AIReactCond_SurpriseEnemyLoc')

	bPreciseDestination=true
}
