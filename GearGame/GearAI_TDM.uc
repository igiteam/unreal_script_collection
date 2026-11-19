/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearAI_TDM extends GearAI_Cover
	native(AI);

cpptext
{
	virtual UBOOL IsPlayerOwner()
	{
		return TRUE;
	}
}

/** chance to select the hammerburst as our starting weapon instead of the lancer */
var config float HammerburstChance;

var Actor RoamGoal;
/** indicates RouteCache is valid path to RoamGoal */
var bool bRoamGoalCacheValid;
/** force weapon rush when idle (instead of considering game objective)
 * used for secondary squads to spread out the AI, take more map control, and get them attacking from different angles
 */
var bool bForceWeaponRush;
/** when we can't find any enemies in a non-objective game (e.g. TDM), after powering up on weapon pickups we go
 * looking around for the enemy, starting with their spawn location. This flag indicates whether we've reached that step.
 */
var bool bCheckedEnemySpawnPoint;
/** whether we have engaged in any combat during our current life */
var bool bHadCombatThisLife;

/** last time we tried to plant a grenade */
var float LastGrenadePlantTime;
/** last time we conveniently had to reload just before downing or killing a human player (casual bots only) */
var float LastMercyReloadTime;

/** reaction used for interrupting certain actions when we take damage */
var instanced AIReactCondition_Base DamageInterruptReaction;
/** similiar damage interrupt check only used for the team leader in leader-based gametypes (Guardian) */
var instanced AIReactCondition_Base LeaderDamageInterruptReaction;
/** cover evaluator used to keep the AI very close to important game objectives */
var instanced NavMeshGoal_AtCover AtCover_VeryNear;
/** version of AtCover_Toward used when mood is aggressive and targeting enemy */
var instanced NavMeshGoal_AtCover AtCover_TowardEnemyAggressive;
/** if set, last time we tried to use AtCover_TorwardEnemyAggressive it failed to find any cover at all, so don't do that again */
var bool bLastAggressiveCoverFailed;

/** projectile we set a timer to evade */
var Projectile PendingEvadeProjectile;

auto state WaitingForPawn
{
Begin:
	Stop;
}

event PreBeginPlay()
{
	// we can't do this in defaults because it will get instanced separately (so DamageInterruptReaction wouldn't be pointing to the array entry)
	DefaultReactConditions.AddItem(DamageInterruptReaction);
	DefaultReactConditions.AddItem(LeaderDamageInterruptReaction);

	Super.PreBeginPlay();
}

function InitPlayerReplicationInfo()
{
	local array<GearGameWeaponSummary> PrimaryWeaponList, SecondaryWeaponList;

	Super.InitPlayerReplicationInfo();

	// look up weapon we want to use and set its index in the PRI
	class'GearGameWeaponSummary'.static.GetSortedDefaultWeapons(PrimaryWeaponList, SecondaryWeaponList);

	if (PrimaryWeaponList.length > 0)
	{
		GearPRI(PlayerReplicationInfo).InitialPrimaryWeaponType = PrimaryWeaponList[Rand(PrimaryWeaponList.length)].WeaponID;
	}
	if (SecondaryWeaponList.length > 0)
	{
		GearPRI(PlayerReplicationInfo).InitialSecondaryWeaponType = SecondaryWeaponList[Rand(SecondaryWeaponList.length)].WeaponID;
	}
}

function NotifyReachedCover()
{
	Super.NotifyReachedCover();

	SetTimer(4.0, true, nameof(DecayCover));
}

/** adds a decay cost to the cover the AI is currently using */
final function DecayCover()
{
	local CoverInfo MyCovInfo;

	if (Squad != None && MyGearPawn != None && MyGearPawn.IsInCover() && !GearPRI(PlayerReplicationInfo).bIsLeader)
	{
		MyCovInfo.Link = MyGearPawn.CurrentLink;
		MyCovInfo.SlotIdx = MyGearPawn.CurrentSlotIdx;
		// decay cover faster when aggressive to keep the AI closing in
		Squad.AddCoverDecay(MyCovInfo, (CombatMood == AICM_Aggressive) ? 600 : 400);
	}
	else
	{
		ClearTimer('DecayCover');
	}
}

/** if the AI is on an AI team or the human leader is dead, considers changing combat mood based on game state */
final function CheckCombatMood()
{
	if (Pawn != None && Squad != None && (Squad.Leader == None || AIController(Squad.Leader) != None || Squad.Leader.IsDead()))
	{
		GearGameMP_Base(WorldInfo.Game).SetAICombatMoodFor(self);
	}
}

function SetIsInCombat()
{
	local bool bNowInCombat;

	// in MP we always say not in combat (@see GearPC::IsInCombat())
	if (MyGearPawn != None)
	{
		bNowInCombat = GearGameMP_Base(WorldInfo.Game).bUseOldCombatMovementSpeed;
		// avoid setting bNetDirty to true unnecessarily
		if (MyGearPawn.bIsInCombat != bNowInCombat)
		{
			MyGearPawn.bIsInCombat = bNowInCombat;
		}
	}
	ClearTimer('SetIsInCombat');
}

function bool StepAsideFor(Pawn ChkPawn)
{
	// if we are the leader, we step aside for nobody!
	// this mainly avoids AI confusion at the beginning of the match when everyone is leaving the spawn point
	return (GetSquadLeader() != self && Super.StepAsideFor(ChkPawn));
}

function bool WantsInfiniteAmmoFor(GearWeapon Wpn)
{
	// only give MP bots infinite ammo for assault rifles
	return (Wpn.IsA('GearWeap_AssaultRifle') || Wpn.IsA('GearWeap_LocustAssaultRifle') || Wpn.IsA('GearWeap_RetroLancer'));
}

/** @return whether the given point is the move goal for another AI on this team */
final function bool IsMoveGoalForTeamMember(NavigationPoint N)
{
	local GearTeamInfo Team;
	local int i;
	local GearAI AI;

	Team = GearTeamInfo(PlayerReplicationInfo.Team);
	if (Team != None)
	{
		for (i = 0; i < Team.TeamMembers.length; i++)
		{
			AI = GearAI(Team.TeamMembers[i]);
			if (AI != None && AI != self && (AI.MoveGoal == N || AI.RouteGoal == N))
			{
				return true;
			}
		}
	}

	return false;
}

/**
 * Picks someplace to go when not in combat and we have no squad leader or are the leader
 */
final function protected PickRoamGoal()
{
	local GearWeaponPickupFactory Pickup;
	local Controller C;
	local Actor ObjectiveActor;
	local Interface_AIMoveFailed MFInt;
	local array<BiasedGoalActor> Actors;
	local int Index;

	ObjectiveActor = GearGameMP_Base(WorldInfo.Game).GetObjectivePointForAI(self);
	MFInt = Interface_AIMoveFailed(ObjectiveActor);
	if ( (!bForceWeaponRush || bHadCombatThisLife) && (MFInt == none || !MFInt.HasPathFailedRecently(self) ) )
	{
		// first ask gametype if there's somewhere important to go
		RoamGoal = ObjectiveActor;
	}
	if (RoamGoal == None)
	{
		// next look at weapon pickups, except if we're in sudden death so need to hurry up and resolve things
		if (!GearGameMP_Base(WorldInfo.Game).bIsInSuddenDeath)
		{
			foreach WorldInfo.AllNavigationPoints(class'GearWeaponPickupFactory', Pickup)
			{
				if ( Pickup != ObjectiveActor &&
					Pickup.WeaponPickupClass != None && Pickup.ReadyToPickup(0) &&
					VSize(Pickup.Location - Pawn.Location) > 512.f &&
					!Pickup.HasPathFailedRecently(self) &&
					(Pickup.FindInteractionWith(Pawn, false) != '' || Pickup.FindInteractionWith(Pawn, true) == 'SwapWithCurrent') &&
					!IsMoveGoalForTeamMember(Pickup) )
				{
					Index = Actors.Add(1);
					Actors[Index].Goal = Pickup;
					Actors[Index].ExtraCost = Rand(6000);
				}
			}
		}

		if (Actors.length > 0)
		{
			AddBasePathConstraints(false);

			// NOTE: heuristic points back to bot here because we are pathing backwards from our goals
			class'NavMeshPath_Toward'.static.TowardPoint(NavigationHandle, Pawn.Location);
			class'NavMeshGoal_ClosestActorInList'.static.ClosestActorInList(NavigationHandle, Actors);
			NavigationHandle.FindPath(RoamGoal);
		}

		if (RoamGoal != None)
		{
			`AILog("ClosestActorInList search found "@`showvar(RoamGoal));
			bRoamGoalCacheValid = true;
		}
		// try enemy start location if we haven't already
		else if (!bForceWeaponRush && !bCheckedEnemySpawnPoint)
		{
			foreach WorldInfo.AllControllers(class'Controller', C)
			{
				if ( C.GetTeamNum() != GetTeamNum() && !C.IsDead() && C.Pawn != None && C.Pawn.Health > 0 &&
					C.IsPlayerOwned() )
				{
					RoamGoal = WorldInfo.Game.FindPlayerStart(None, C.GetTeamNum());
					break;
				}
			}
			if (RoamGoal == None)
			{
				`AILog("Failed to find an enemy PlayerStart to check for stragglers!");
				RoamGoal = None;
			}
			bCheckedEnemySpawnPoint = true;
		}
		// try some random location so the AI looks around for enemies
		else if (!bForceWeaponRush && FindRandomDest() != None)
		{
			`AILog("FindRandomDest found "@`showvar(RoamGoal));
			RoamGoal = RouteGoal;
			bRoamGoalCacheValid = true;
		}
		else
		{
			// fall back to just staying where we are
			RoamGoal = None;
			bForceWeaponRush = false;
		}
		Pawn.PathSearchType = Pawn.default.PathSearchType;
	}
}

/** checks if the AI is standing on a weapon pickup and whether it wants that weapon
 * if so, pushes AICmd_PickupWeapon
 * @return if the AI is picking up a weapon now
 */
final function bool CheckPickupWeapon()
{
	local GearWeaponPickupFactory Factory;
	local GearDroppedPickup Pickup;
	local class<GearWeapon> WeaponClass;

	// can't pick stuff up while holding a meat shield or heavy weapon
	if (MyGearPawn != None && (MyGearPawn.IsAKidnapper() || MyGearPawn.IsCarryingAHeavyWeapon()))
	{
		return false;
	}

	foreach Pawn.TouchingActors(class'GearWeaponPickupFactory', Factory)
	{
		//@note: we currently assume that the LD-placed pickups are always better than what we have
		if ( Factory.WeaponPickupClass != None && Factory.ReadyToPickup(0.0) && Factory.ValidTouch(Pawn) &&
			(Factory.FindInteractionWith(Pawn, false) != '' || Factory.FindInteractionWith(Pawn, true) == 'SwapWithCurrent') )
		{
			class'AICmd_PickupWeapon'.static.PickupWeaponFromFactory(self, Factory);
			return true;
		}
	}

	foreach Pawn.TouchingActors(class'GearDroppedPickup', Pickup)
	{
		WeaponClass = class<GearWeapon>(Pickup.InventoryClass);
		if ( WeaponClass != None && WeaponClass.default.AIRating >= 1.0 && AllowDetourToPickUp(WeaponClass) && Pickup.ValidTouch(Pawn) &&
			(Pickup.FindInteractionWith(Pawn, false) != '' || Pickup.FindInteractionWith(Pawn, true) == 'SwapWithCurrent') )
		{
			class'AICmd_PickupWeapon'.static.PickupWeaponFromPickup(self, Pickup);
			return true;
		}
	}

	// if we are adjacent to one then consider moving to it if doing so won't get us killed
	if (!IsUnderHeavyFire())
	{
		foreach WorldInfo.RadiusNavigationPoints(class'GearWeaponPickupFactory', Factory, Pawn.Location, 1024.0)
		{
			if ( Factory != None && Factory.WeaponPickupClass != None && Factory.ReadyToPickup(0.0) && Factory.CanBePickedUpBy(Pawn) &&
					(Factory.FindInteractionWith(Pawn, false) != '' || Factory.FindInteractionWith(Pawn, true) == 'SwapWithCurrent') &&
					!Factory.HasPathFailedRecently(self) &&
					NavigationHandle.ActorReachable(Factory) )
			{
				SetMoveGoal(Factory,, true);
				return true;
			}
		}
	}

	return false;
}

final function bool AllowDetourToPickUp(class<Inventory> InvClass)
{
	// if we're not in any known danger and we're not about to kill/DBNO an enemy
	// then query the inventory and ask it if it is good enough
	return ( MyGearPawn != None && !MyGearPawn.IsAKidnapper() &&
		(Enemy == None || float(Enemy.Health) / float(Enemy.HealthMax) > 0.35) &&
		InvClass.static.DetourWeight(Pawn, 1) > 0.0 &&
		FindCommandOfClass(class'AICmd_Revive') == None && FindCommandOfClass(class'AICmd_Execute') == None );
}

/** @return whether the bot has a game objective to consider and is currently close enough to it */
final function bool IsNearGameObjective(float CheckDist)
{
	local Actor ObjectiveActor;

	ObjectiveActor = GearGameMP_Base(WorldInfo.Game).GetObjectivePointForAI(self);
	return (ObjectiveActor != None && VSize(ObjectiveActor.Location - Pawn.Location) <= CheckDist);
}

function bool ShouldMoveToSquad( optional bool bSkipLastPositionCheck, optional Vector TestLocation )
{
	// don't run around looking for the leader when there are enemies around unless playing wingman
	return ( ( GearGameWingman_Base(WorldInfo.Game) != None || (HasSquadLeader() && GearPRI(GetSquadLeader().PlayerReplicationInfo).bIsLeader) ||
			(!IsUnderHeavyFire() && GetNearEnemyDistance(Pawn.Location) > EnemyDistance_Long) ) &&
			!IsNearGameObjective(256.0) &&
		Super.ShouldMoveToSquad(bSkipLastPositionCheck, TestLocation) );
}

function CheckCombatTransition()
{
	local bool bAbort;
	local Pawn P;
	local AICmd_MoveToSquadLeader MoveToLeaderCmd;

	CheckCombatMood();

	// don't abort roaming for long range enemy unless we're actually getting hit
	if ((CommandList != None || !HasSquadLeader()) && AICommand_Base_Combat(CommandList) == None)
	{
		if (GetHealthPercentage() >= 0.9)
		{
			bAbort = true;
			foreach Squad.AllEnemies(class'Pawn', P)
			{
				if (IsMediumRange(GetEnemyLocation(P)))
				{
					bAbort = false;
					break;
				}
			}
		}
	}

	if (bAbort)
	{
		// check again after some time
		// this handles the case where we don't receive any more enemy notifications, but
		// our roam goal happens to put the enemy in range anyway
		SetTimer(1.5, false, nameof(CheckCombatTransition));
	}
	else
	{
		// check if we should abort any move to leader commands because we saw enemies in the way
		MoveToLeaderCmd = FindCommandOfClass(class'AICmd_MoveToSquadLeader');
		if (MoveToLeaderCmd != None && !ShouldMoveToSquad())
		{
			AbortCommand(MoveToLeaderCmd);
		}

		Super.CheckCombatTransition();
	}
}

function bool ShouldReturnToIdle()
{
	local int i;

	if (Super.ShouldReturnToIdle())
	{
		return true;
	}
	else
	{
		// return to idle if we haven't seen any enemy in over 30 seconds
		for (i = 0; i < Squad.EnemyList.length; i++)
		{
			if ( Squad.EnemyList[i].Pawn != None && Squad.EnemyList[i].Pawn.IsValidEnemyTargetFor(PlayerReplicationInfo, true) &&
				WorldInfo.TimeSeconds - Squad.EnemyList[i].LastUpdateTime < 30.0 )
			{
				return false;
			}
		}

		return true;
	}
}

function bool CheckInterruptCombatTransitions()
{
	local bool bResult;
	local GearMeleeTarget MeleeObjective;

	// if casual (dumb) AI gets caught moving around, sometimes get lost and stand there shooting at them
	if ( GetDifficultyLevel() == DL_Casual && IsFiringWeapon() && IsUnderHeavyFire() && Enemy != None &&
		GetHealthPercentage() < 0.9 && FRand() < 0.5 && AICmd_MoveToGoal_Mesh(GetActiveCommand()) != None &&
		CanFireAt(FireTarget, Pawn.GetWeaponStartTraceLocation()) )
	{
		FireFromOpen();
		return true;
	}
	else
	{
		bResult = Super.CheckInterruptCombatTransitions();
		if (!bResult)
		{
			// see if should melee objective
			MeleeObjective = GearMeleeTarget(GearGameMP_Base(WorldInfo.Game).GetObjectivePointForAI(self));
			if ( MeleeObjective != None && VSize(MeleeObjective.Location - Pawn.Location) < 512.0 &&
				FindCommandOfClass(class'AICmd_Melee_Forced') == None )
			{
				// can't melee objectives with chainsaw
				if (GearWeap_AssaultRifle(Pawn.Weapon) != None)
				{
					SelectWeapon(true);
				}
				if (GearWeap_AssaultRifle(Pawn.Weapon) == None || Pawn.InvManager.PendingWeapon != None)
				{
					class'AICmd_Melee_Forced'.static.ForceMelee(self, MeleeObjective);
					bResult = true;
				}
			}
		}
		return bResult;
	}
}

function BeginCombatCommand(class<AICommand> CmdClass, optional coerce string Reason, optional bool bForced)
{
	if (CmdClass != None)
	{
		bHadCombatThisLife = true;
	}
	// drop heavy minigun if we exit combat since it may be tethered
	else if (MyGearPawn != None && GearWeap_HeavyCoopMGBase(MyGearPawn.MyGearWeapon) != None)
	{
		MyGearPawn.ThrowActiveWeapon();
	}
	Super.BeginCombatCommand(CmdClass, Reason, bForced);
}

function bool IsValidMeleeTarget(GearPawn WP, optional bool bSkipZCheck)
{
	local GearGameMP_Base Game;
	local Actor ObjectiveActor;

	// if we need to be standing on an objective point, don't leave it to melee somebody
	Game = GearGameMP_Base(WorldInfo.Game);
	if (Game.MustStandOnObjective(self))
	{
		ObjectiveActor = Game.GetObjectivePointForAI(self);
		if ( ObjectiveActor != None && VSize(ObjectiveActor.Location - Pawn.Location) <= 256.0 &&
			VSize(WP.Location - ObjectiveActor.Location) > 256.0 )
		{
			return false;
		}
	}

	return Super.IsValidMeleeTarget(WP, bSkipZCheck);
}

function bool CheckReviveOrExecute(float CheckDist)
{
	local Pawn P;
	local bool bEnemiesRemain;

	// increase range if we need to execute enemies to kill them
	if (GearGameMP_Base(WorldInfo.Game).bExecutionRules)
	{
		CheckDist *= 1.5;
	}

	// if we have no important objective and all enemies are dead or DBNO,
	// then allow execution or revival at any range
	if (GearGameMP_Base(WorldInfo.Game).GetObjectivePointForAI(self) == None)
	{
		foreach Squad.AllEnemies(class'Pawn', P, self)
		{
			if (!P.IsA('GearPawn') || !GearPawn(P).IsDBNO())
			{
				bEnemiesRemain = true;
				break;
			}
		}

		if (!bEnemiesRemain)
		{
			if (HasAnyEnemies())
			{
				bShouldRoadieRun = true;
			}
			CheckDist = 1000000.0;
		}
	}

	return Super.CheckReviveOrExecute(CheckDist);
}

function bool CanExecutePawn(GearPawn GP)
{
	local GearGameMP_Base Game;
	local Actor ObjectiveActor;
	local float EnemyDist;

	if (Pawn != None)
	{
		// if we need to stand on a game objective, don't execute anyone unless they are on the way
		Game = GearGameMP_Base(WorldInfo.Game);
		if (Game.MustStandOnObjective(self))
		{
			ObjectiveActor = Game.GetObjectivePointForAI(self);
			if (ObjectiveActor != None && ObjectiveActor != GP)
			{
				EnemyDist = VSize(GP.Location - ObjectiveActor.Location);
				if (EnemyDist > 256.0 && VSize(ObjectiveActor.Location - Pawn.Location) < EnemyDist)
				{
					return false;
				}
			}
		}
	}

	return Super.CanExecutePawn(GP);
}

function GoExecuteEnemy(GearPawn GP)
{
	// see if we should kidnap this Pawn instead
	if ( MyGearPawn != None && !MyGearPawn.IsDBNO() && !MyGearPawn.IsAKidnapper() &&
		GP == GearGameMP_Base(WorldInfo.Game).GetObjectivePointForAI(self) )
	{
		class'AICmd_Kidnap'.static.Kidnap(self, GP);
	}
	else
	{
		Super.GoExecuteEnemy(GP);
	}
}

function bool EvaluateCover
(
	ECoverSearchType Type,
	Actor GoalActor,
	out CoverInfo out_Cover,
	optional CoverInfo InBestCover,
	optional int InBestCoverRatingTheshold,
	optional NavMeshGoal_AtCover GoalEvaluator,
	optional float MaxDistFromGoal,
	optional vector OverrideGoalLoc
)
{
	local bool bResult;

	// if we want to charge, use the special goal evaluator with more weight towards enemy
	if ( CombatMood == AICM_Aggressive && GoalEvaluator == None && GoalActor == Enemy &&
		Type == SearchType_Towards && !bLastAggressiveCoverFailed &&
		(MyGearPawn == None || MyGearPawn.MyGearWeapon == None || !MyGearPawn.MyGearWeapon.bSniping) )
	{
		bResult = Super.EvaluateCover(Type, GoalActor, out_Cover, InBestCover, InBestCoverRatingTheshold, AtCover_TowardEnemyAggressive, MaxDistFromGoal, OverrideGoalLoc);
		if (!bResult)
		{
			bLastAggressiveCoverFailed = true;
		}
	}
	else
	{
		bLastAggressiveCoverFailed = false;
		bResult = Super.EvaluateCover(Type, GoalActor, out_Cover, InBestCover, InBestCoverRatingTheshold, GoalEvaluator, MaxDistFromGoal, OverrideGoalLoc);
	}
	return bResult;
}

function bool CanFireWeapon(Weapon Wpn, byte FireModeNum)
{
	local bool bResult;
	local AICmd_Execute ExecuteCmd;

	// if our target is highly exposed and we're close, then stop and take aim for better accuracy
	bResult = Super.CanFireWeapon(Wpn, FireModeNum);
	if ( bResult && FireModeNum == 0 && MyGearPawn != None && !MyGearPawn.IsInCover() && !MyGearPawn.IsAKidnapper() &&
		!bMovingToCover && GetHealthPercentage() > 0.75 && HasValidTarget() &&
		(GearPawn(FireTarget) == None || !GearPawn(FireTarget).IsAKidnapper() || (MyGearPawn.MyGearWeapon != None && MyGearPawn.MyGearWeapon.bCanNegateMeatShield)) &&
		(IsMediumRange(FireTarget.Location) || (MyGearPawn.MyGearWeapon != None && MyGearPawn.MyGearWeapon.bSniping)) &&
		AICmd_MoveToGoal_Mesh(GetActiveCommand()) != None && FindCommandOfClass(class'AICmd_Attack_FireFromOpen') == None &&
		FastTrace(FireTarget.Location, Pawn.GetWeaponStartTraceLocation(Wpn)) )
	{
		// if we're on the way to execute an enemy that requires it to die, don't get distracted
		ExecuteCmd = FindCommandOfClass(class'AICmd_Execute');
  		if (ExecuteCmd != None && !GearGame(WorldInfo.Game).CanBeShotFromAfarAndKilledWhileDownButNotOut(ExecuteCmd.ExecuteTarget, Pawn, None))
  		{
  			return true;
  		}
  		else
  		{
			// don't if we're about to reach important objective
			if (IsNearGameObjective(512.0) && GearGameMP_Base(WorldInfo.Game).MustStandOnObjective(self))
			{
				return true;
			}
			else
			{
				// see if we want a better weapon first - if so, start the switch and keep moving
				SelectWeapon();
				if (!IsSwitchingWeapons())
				{
					FireFromOpen();
				}
				return false;
			}
		}
	}
	// if a lowest difficulty bot is attacking a human and is about to down/kill him... oh wait! The bot needs to reload! How fortunate!
	else if ( bResult && GetDifficultyLevel() == DL_Casual && FireTarget != None && FireTarget == Enemy && Enemy.IsHumanControlled() &&
			WorldInfo.TimeSeconds - LastMercyReloadTime > 30.0 &&
			float(Enemy.Health) / float(Enemy.HealthMax) < 0.25 && FireModeNum != class'GearWeapon'.const.RELOAD_FIREMODE &&
			MyGearPawn != None && MyGearPawn.MyGearWeapon != None && MyGearPawn.MyGearWeapon.CanReload() )
	{
		if (MyGearPawn.MyGearWeapon.IsFiring())
		{
			MyGearPawn.MyGearWeapon.StopFire(0);
		}
		MyGearPawn.MyGearWeapon.ForceReload();
		LastMercyReloadTime = WorldInfo.TimeSeconds;
		return false;
	}
	else
	{
		// see if we have a lull in combat and should try reloading
		if ( !bResult && FireModeNum != class'GearWeapon'.const.RELOAD_FIREMODE &&
			MyGearPawn != None && MyGearPawn.MyGearWeapon != None &&
			MyGearPawn.MyGearWeapon.CanReload() && !MyGearPawn.MyGearWeapon.IsReloading() &&
			!MyGearPawn.MyGearWeapon.IsFiring() && WorldInfo.TimeSeconds - LastShotAtTime > 3.0 &&
			GearPRI(PlayerReplicationInfo).Difficulty.default.DifficultyLevel > DL_Casual )
		{
			if (Enemy == None)
			{
				MyGearPawn.MyGearWeapon.ForceReload();
			}
			else if ( WorldInfo.TimeSeconds - Squad.GetEnemyLastSeenTime(Enemy) > 3.0 &&
				VSize(Enemy.Location - Pawn.Location) > EnemyDistance_Melee * 1.5 &&
				float(Enemy.Health) / Enemy.HealthMax > 0.4 )
			{
				MyGearPawn.MyGearWeapon.ForceReload();
			}
		}
		return bResult;
	}
}

function int GetNumBurstsToFireWhileMoving()
{
	return (GetDifficultyLevel() == DL_Casual) ? 1 : -1;
}

/** @return whether the AI should plant a grenade near its current location */
final function bool ShouldPlantGrenade()
{
	local Pawn CheckEnemy;
	local GearWeap_GrenadeBase Grenade;
	local Actor Objective;

	// if we have a grenade, we're near our objective, don't need to stay on it, and are not currently engaged with any enemies
	if ( WorldInfo.TimeSeconds - LastGrenadePlantTime > 20.0 &&
		WorldInfo.TimeSeconds - LastShotAtTime > 2.0 && FRand() < 0.25 * GetDifficultyLevel() )
	{
		Objective = GearGameMP_Base(WorldInfo.Game).GetObjectivePointForAI(self);
		if ( Objective != None && Pawn(Objective) == None && VSize(Objective.Location - Pawn.Location) < 512.0 &&
			!GearGameMP_Base(WorldInfo.Game).MustStandOnObjective(self) )
		{
			Grenade = GearWeap_GrenadeBase(Pawn.FindInventoryType(class'GearWeap_GrenadeBase', true));
			if (Grenade != None && Grenade.HasAnyAmmo())
			{
				foreach Squad.AllEnemies(class'Pawn', CheckEnemy, self)
				{
					if (VSize(CheckEnemy.Location - Pawn.Location) < 1500.0 && TimeSinceLastSeenEnemy(CheckEnemy, true) < 4.0)
					{
						return false;
					}
				}

				return true;
			}
		}
	}

	return false;
}

/** interrupts the first child of the base command (if any) */
function InterruptAction(Actor EventInstigator, AIReactChannel OrigChannel)
{
	if (CommandList != None && CommandList.ChildCommand != None)
	{
		`AILog("Aborting current action due to impulse from" @ OrigChannel.ChannelName);
		AbortCommand(CommandList.ChildCommand);

		if (FRand() < 0.25 * GearPRI(PlayerReplicationInfo).Difficulty.default.DifficultyLevel && CanEvade())
		{
			DoEvade(GetBestEvadeDir(MyGearPawn.Location, Pawn(EventInstigator)), true);
		}
	}
}

/** called when the leader takes damage to consider whether he should be interrupted so he can run away instead */
function CheckLeaderInterrupt(Actor EventInstigator, AIReactChannel OrigChannel)
{
	local float ExposedScale;

	// trigger if we take a bunch of damage in the open
	if ( GearPRI(PlayerReplicationInfo).bIsLeader && GetHealthPercentage() < 0.7 && MyGearPawn != None &&
		(!MyGearPawn.IsInCover() || (IsCoverExposedToAnEnemy(Cover,, ExposedScale) && ExposedScale > 0.7)) )
	{
		if (AICmd_Base_CoverAI(CommandList) == None)
		{
			BeginCombatCommand(GetDefaultCommand(), "Restart combat logic due to leader damage and exposure");
		}
		else
		{
			if (CommandList.ChildCommand != None)
			{
				AbortCommand(CommandList.ChildCommand);
			}
			CommandList.GotoState(, 'Begin');
		}
	}
}

/** @return whether bot should move to objective when idle instead of staying in formation around leader */
final function bool IdleFollowerShouldMoveToObjective()
{
	local Actor ObjectiveActor;

	// always if kidnapper
	//@todo: kindy hacky (mostly for meatflag), maybe generalize? (add a IsHoldingObjective() or something)
	//	another possibility is to temporarily make this guy the squad leader when he takes the meatflag
	if (MyGearPawn != None && MyGearPawn.IsAKidnapper())
	{
		return true;
	}
	else
	{
		// do so if we have an objective and it is reasonably close to us or our leader
		ObjectiveActor = GearGameMP_Base(WorldInfo.Game).GetObjectivePointForAI(self);
		return ( ObjectiveActor != None &&
			(VSize(ObjectiveActor.Location - GetSquadLeaderLocation()) < 1500.0 || VSize(ObjectiveActor.Location - Pawn.Location) < 512.0) );
	}
}

function bool PeekFromCover(optional bool bLookForEnemy = true, optional float PeekTime = 0.f)
{
	// hardcore/insane bots skip the peeking for faster response time
	return (GetDifficultyLevel() < DL_Hardcore && Super.PeekFromCover(bLookForEnemy, PeekTime));
}

function bool ShouldNoticeFriendKilled(Controller KilledC, Pawn KilledP)
{
	// bots read the death messages
	return true;
}

function TurretIdle(int IdleTime)
{
	Super.TurretIdle(IdleTime);

	// get bored fairly fast if we have nothing to do
	// even faster if we've got more important things to worry about
	if (IdleTime > ((GearGameMP_Base(WorldInfo.Game).GetObjectivePointForAI(self) != None) ? 5 : 10))
	{
		BeginCombatCommand(HasAnyEnemies() ? GetDefaultCommand() : None, "Idle too long on turret", true);
	}
}

// bots are never stale!
function SetEnableDeleteWhenStale(bool bAmIExpendable);
function ConditionalDeleteWhenStale();

state Action_Idle
{
Begin:
	//debug
	`AILog( "BEGIN TAG"@PrintTetherInfo(), 'State' );

	bRoamGoalCacheValid = false;
	RoamGoal = None;

	CheckCombatMood();

	// check if should pickup weapon
	if (CheckPickupWeapon())
	{
		// CheckPickupWeapon() should have pushed the pickup weapon command
		Sleep(0.5f);
	}
	// check for a tether
	else if( (Pawn != None) && !IsWithinTether( Pawn.Location ) )
	{
		`AILog("Not within tether, moving");

		// Move to tether
		SetTether( GetTetherLocation(), GetTetherActor(), DesiredTetherDistance, bDynamicTether, TetherPersistDuration );
		// clear it if we failed
		if (!IsWithinTether(Pawn.Location))
		{
			ClearMovementInfo();
		}
	}
	else
	{
		// If we have enemies
		if (HasAnyEnemies() && !ShouldReturnToIdle())
		{
			// Try to notice one which will put us into combat
			CheckNoticedEnemy();
		}
		CheckReviveOrExecute(768.f);
		if (ShouldPlantGrenade())
		{
			class'AICmd_Attack_PlantGrenade'.static.PlantGrenade(self, 750, 1250);
			LastGrenadePlantTime = WorldInfo.TimeSeconds;
		}
		if ((!bForceWeaponRush || bHadCombatThisLife) && HasSquadLeader())
		{
			if (IdleFollowerShouldMoveToObjective())
			{
				Goto('Roam');
			}
			// otherwise if we have no enemies but do have a squad
			else if ( ShouldMoveToSquad() )
			{
MoveToSquad:
				//debug
				`AILog("Moving to squad...");

				// then move to the squad
				MoveToSquadPosition();

				// If no tether actor to clear
				if( bFailedToMoveToEnemy )
				{
					// Sleep to prevent recursive craziness
					Sleep( 1.0f );
				}

				// If we shouldn't keep the tether
				if( !bKeepTether )
				{
					// Clear the tether so that we always update to a new one
					ClearTether();
				}
				bKeepTether = FALSE;

				// check to see if we should immediately move again
				if (!HasAnyEnemies() &&
					ShouldMoveToSquad())
				{
					//debug
					`AILog("Continuing move to squad");
					Sleep(0.1f);
					Goto('MoveToSquad');
				}
				else
				{
					`AILog("Not continuing move to squad?"@HasAnyEnemies()@ShouldMoveToSquad());
				}
				Sleep(0.25f);
			}
			else if (VSize(GetSquadLeaderLocation() - Pawn.Location) < 1024.0)
			{
MoveToCover:
				// check to see if we should get into cover because of our squad leader
				if (IsAlert() &&
					(!HasValidCover() || !IsAtCover()))
				{
					`AILog("Moving to cover because of alertness or squad leader being in cover");
					ClearMovementInfo();
					MoveToNearestCoverIdle();
					if (!bReachedMoveGoal)
					{
						`AILog("No nearby cover or failed to reach cover, sleeping");
						Sleep(0.5f);
					}
				}
				else if (IsAlert() && IsAtCover())
				{
					if (!PeekFromCover())
					{
						Sleep(0.5f);
					}
				}
				else
				{
					`AILog("Shouldn't move to squad or cover, sleeping"@PrintTetherInfo()@MoveAction);
					Sleep(0.5f);
				}
			}
			else
			{
				Goto('Roam');
			}
		}
		else
		{
Roam:
			PickRoamGoal();
			// if we're near our goal then chill in cover
			if ( (RoamGoal == None || VSize(RoamGoal.Location - Pawn.Location) < 256.f) &&
				(PickupFactory(RoamGoal) == None || !PickupFactory(RoamGoal).ReadyToPickup(0)) )
			{
				if (HasAnyEnemies())
				{
					// intentional override of custom "do other stuff until enemy is close" logic
					// because if we got here, there's nothing better to do but shoot at them
					Super.CheckCombatTransition();
					Sleep(0.5f);
				}
				else
				{
					Goto('MoveToCover');
				}
			}
			else
			{
				// no squad leader, so move to a random goal
				if (!GearPRI(PlayerReplicationInfo).bIsLeader && GetDifficultyLevel() > DL_Normal)
				{
					bShouldRoadieRun = true;
				}
				SetMoveGoal(RoamGoal,, TRUE,, /*bRoamGoalCacheValid*/,,,, TRUE );
				Sleep(0.5f);
			}
		}
	}
	Goto('Begin');
}

function CleanupPRI()
{
	`AILog(GetFuncName()@"booooo");
	PlayerReplicationInfo.Destroy();
	PlayerReplicationInfo = None;
}

/** called to send PC to the respawning state, if the gametype allows it */
final function WaitForRespawn()
{
	if (IsDead() || IsSpectating())
	{
		if (GearGame(WorldInfo.Game).ShouldRespawnPC(PlayerReplicationInfo.Team.TeamIndex, self))
		{
			GearGame(WorldInfo.Game).StartRespawning(self);
		}
		else
		{
			// ask the game again later
			SetTimer(1.0, false, nameof(WaitForRespawn));
		}
	}
}

function PawnDied(Pawn InPawn)
{
	local GearPawn WP;

	//debug
	`AILog(GetFuncName()@InPawn);

	if (InPawn == Pawn)
	{
		if (MyGearPawn != None)
		{
			// catch a special case when killed mid spawn
			MyGearPawn.bSpawning = false;
		}

		RouteCache_Empty();

		if (Squad != None)
		{
			foreach Squad.AllEnemies(class'GearPawn', WP)
			{
				WP.ReleaseFireTicket(self);
			}
		}

		while (CommandList != None)
		{
			AbortCommand(None, class'AICommand');
		}

		ClearTimer(nameof(DoProjectileEvade));

		UnClaimCover();

		GearPRI(PlayerReplicationInfo).PlayerStatus = WPS_Dead;
		SetTimer(3.0, false, nameof(WaitForRespawn));

		ClearTether();
	}

	// skip GearAI::PawnDied() so we don't lose Squad, etc
	Super(AIController).PawnDied(InPawn);

	MyGearPawn = None;
}

function Possess(Pawn NewPawn, bool bVehicleTransition)
{
	Super.Possess(NewPawn, bVehicleTransition);

	if (Pawn != None && !bVehicleTransition)
	{
		GearPRI(PlayerReplicationInfo).PlayerStatus = WPS_Alive;
		ClearTimer(nameof(WaitForRespawn));
		if (GearPRI(PlayerReplicationInfo).bIsLeader)
		{
			LeaderDamageInterruptReaction.UnSuppress();
		}
		// roadie run from start location like players do unless we're the leader (so the other guys can get ahead and protect)
		// or too dumb to know how
		else if (GetDifficultyLevel() > DL_Casual)
		{
			bShouldRoadieRun = true;
		}
		// clear out old transient AI info
		LastSquadLeaderPosition = vect(0,0,0);
		bCheckedEnemySpawnPoint = false;
		bLastAggressiveCoverFailed = false;
		bHadCombatThisLife = false;

		if (!GearGameMP_Base(WorldInfo.Game).AreBotsActive())
		{
			GotoState('Inactive');
		}
	}
}

function bool WantsToRoadieRunToLeader()
{
	return ( GetDifficultyLevel() > DL_Casual ||
		(HasSquadLeader() && GearPawn(GetSquadLeader().Pawn) != None && GearPawn(GetSquadLeader().Pawn).IsDoingSpecialMove(SM_RoadieRun)) );
}

function bool ShouldRoadieRun()
{
	local GearPawn GP;

	// if moving to objective, roadie run only if can't see enemy
	// also roadie run if objective is a kidnapper or hostage (e.g. Meatflag), since firing from afar against that is not useful
	if ( MoveGoal != None && GearGameMP_Base(WorldInfo.Game).GetObjectivePointForAI(self) == MoveGoal &&
		(!bShouldRoadieRun || AICommand_Base_Combat(CommandList) != None) )
	{
		bShouldRoadieRun = false;
		if (Enemy == None || VSize(Enemy.Location - Pawn.Location) > EnemyDistance_Long * 1.5)
		{
			bShouldRoadieRun = true;
		}
		else if ( !IsUnderHeavyFire() &&
			(MyGearPawn == None || MyGearPawn.MyGearWeapon == None || !MyGearPawn.MyGearWeapon.bCanNegateMeatShield) )
		{
			GP = GearPawn(MoveGoal);
			if ( GP != None && (GP.IsAHostage() || GP.IsAKidnapper()) &&
				(vector(GP.Rotation) dot Normal(GP.Location - Pawn.Location) > 0.0 ? !IsShortRange(GP.Location) : !IsMediumRange(GP.Location)) )
			{
				bShouldRoadieRun = true;
			}
		}
		if (!bShouldRoadieRun)
		{
			bShouldRoadieRun = GetNearEnemyDistance(Pawn.Location) > 512.0 && !LineOfSightTo(Enemy);
		}
	}
	// if the enemy is tagging us from cover and we can't easily return fire (i.e. no exposure), roadie run to get away faster
	else if ( !bShouldRoadieRun && GetDifficultyLevel() > DL_Normal && GetHealthPercentage() < 0.9 && IsUnderHeavyFire() &&
		(MyGearPawn == None || !MyGearPawn.IsInCover()) )
	{
		GP = GearPawn(Enemy);
		if ( GP != None && GP.IsInCover() &&
			vector(GP.CurrentLink.GetSlotRotation(GP.CurrentSlotIdx)) dot Normal(Pawn.Location - Enemy.Location) > 0.7 )
		{
			bShouldRoadieRun = true;
		}
	}
	return Super.ShouldRoadieRun();
}

function InvalidateCoverFromDamage(Actor Damager)
{
	local CoverInfo NewCover;
	local AICmd_Attack_FireFromCover FireCmd;

	if (GetDifficultyLevel() > DL_Casual && Enemy != none)
	{
		// pop back down
		StopFiring();
		// reduce desireability of this cover
		Squad.AddCoverDecay(Cover, 500);

		// don't disrupt an existing move for this
		if (FindCommandOfClass(class'AICmd_MoveToGoal_Mesh') == None)
		{
			class'NavMeshPath_SameCoverLink'.static.SameCoverLink(NavigationHandle, Cover.Link);
			AllowedCoverLinks.AddItem(Cover.Link);
			if (EvaluateCover(SearchType_Towards, Enemy, NewCover, Cover))
			{
				//debug
				`AILog("Switching cover slots to" @ NewCover.Link.GetDebugString(NewCover.SlotIdx) @ "due to damage");

				// abort any fire from cover command first
				FireCmd = AICmd_Attack_FireFromCover(GetActiveCommand());
				if (FireCmd != None)
				{
					AbortCommand(FireCmd);
				}

				// moving on up
				SetCoverGoal(NewCover, true);
			}
			AllowedCoverLinks.length = 0;
		}
	}
}

/** checks if the given enemy we just received an update on has snuck up close to us (near melee range) when we weren't paying attention */
final function CheckVeryCloseEnemyWarning(Pawn CheckEnemy)
{
	local float CheckEnemyDist;

	// if we're a stupid bot, never pay attention
	// if we're already paying attention to that enemy or we're in cover and not exposed to that enemy from here, ignore it
	if ( GetDifficultyLevel() > DL_Casual && Enemy != CheckEnemy && CheckEnemy.Health > 0 && CheckEnemy.Physics != PHYS_RigidBody &&
		(MyGearPawn == None || !MyGearPawn.IsInCover() || (MyGearPawn.CoverAction == CA_Default && IsCoverExposedToAnEnemy(Cover, CheckEnemy))) )
	{
		// check if it's close and that we don't have an even more dangerous target
		CheckEnemyDist = VSize(CheckEnemy.Location - Pawn.Location);
		if (CheckEnemyDist < 384.0 && (Enemy == None || CheckEnemyDist < VSize(Enemy.Location - Pawn.Location)))
		{
			`AILog("Detected untargeted enemy" @ CheckEnemy @ "within very short range!");
			// switch enemies
			SetEnemy(CheckEnemy);
			// abort fire/peek from cover actions
			AbortCommand(None, class'AICmd_Attack_FireFromCover');
			AbortCommand(None, class'AICmd_Attack_PeekFromCover');
			// maybe evade
			if (CanEvade() && FRand() < 0.25 * GearPRI(PlayerReplicationInfo).Difficulty.default.DifficultyLevel)
			{
				ResetCoverType();
				DoEvade(GetBestEvadeDir(CheckEnemy.Location, CheckEnemy));
			}
			// go melee them instead
			else if (IsValidMeleeTarget(GearPawn(CheckEnemy)) && !CommandList.IsA('AICmd_Base_Melee'))
			{
				ReactionManager.NudgeChannel(CheckEnemy, 'EnemyWithinMeleeDistance');
			}
			else
			{
				// at least shoot them
				StartFiring();
			}
		}
	}
}

event NotifyEnemyHeard(Pawn HeardEnemy, name NoiseType)
{
	Super.NotifyEnemyHeard(HeardEnemy, NoiseType);

	// if we're not in combat, make sure we evaluate that, since CheckCombatTransition() is generally only called when acquiring a new enemy
	if (AICommand_Base_Combat(CommandList) == None && !IsTimerActive(nameof(CheckCombatTransition)))
	{
		CheckCombatTransition();
	}

	CheckVeryCloseEnemyWarning(HeardEnemy);
}
event NotifyEnemySeen(Pawn SeenEnemy)
{
	Super.NotifyEnemySeen(SeenEnemy);

	// if we're not in combat, make sure we evaluate that, since CheckCombatTransition() is generally only called when acquiring a new enemy
	if (AICommand_Base_Combat(CommandList) == None && !IsTimerActive(nameof(CheckCombatTransition)))
	{
		CheckCombatTransition();
	}

	CheckVeryCloseEnemyWarning(SeenEnemy);
}

function CheckNearMiss(Pawn Shooter, GearWeapon GearWeap, const out ImpactInfo Impact, class<DamageType> InDamageType)
{
	local float OldNearMissDistance;

	OldNearMissDistance = AI_NearMissDistance;

	// if we're pretty sure they're shooting at us, increase check distance
	if (Shooter != None && Shooter.Controller != None && Shooter.Controller.ShotTarget == Pawn && GetDifficultyLevel() > DL_Casual)
	{
		AI_NearMissDistance *= 2.0;
	}

	Super.CheckNearMiss(Shooter, GearWeap, Impact, InDamageType);

	AI_NearMissDistance = OldNearMissDistance;
}

function ReceiveChargeTargetWarning(Pawn Shooter)
{
	// if we're looking in that direction and skilled enough, try to evade
	if ( (Enemy == Shooter || vector(Pawn.Rotation) dot Normal(Shooter.Location - Pawn.Location) > 0.7) &&
		FRand() < 0.25 * GearPRI(PlayerReplicationInfo).Difficulty.default.DifficultyLevel && CanEvade() )
	{
		DoEvade(GetBestEvadeDir(Shooter.Location, Shooter), true);
	}
}

/** triggers an evade from the PendingEvadeProjectile, if possible and it's still on target */
final function DoProjectileEvade()
{
	local float Dist;
	local vector Dir, LineDist, FuturePos;

	if (Pawn != None && PendingEvadeProjectile != None && !PendingEvadeProjectile.bDeleteMe && !IsZero(PendingEvadeProjectile.Velocity) && CanEvade())
	{
		Dir = Normal(PendingEvadeProjectile.Velocity);
		FuturePos = Pawn.Location + Pawn.Velocity * VSize(PendingEvadeProjectile.Location - Pawn.Location) / VSize(PendingEvadeProjectile.Velocity);
		LineDist = FuturePos - (PendingEvadeProjectile.Location + (Dir Dot (FuturePos - PendingEvadeProjectile.Location)) * Dir);
		Dist = VSize(LineDist);
		if (Dist < FMax(250.0, PendingEvadeProjectile.IsA('GearProj_ExplosiveBase') ? (GearProj_ExplosiveBase(PendingEvadeProjectile).ExploDamageRadius * 0.5) : (PendingEvadeProjectile.DamageRadius * 0.5)))
		{
			DoEvade(GetBestEvadeDir(PendingEvadeProjectile.Location, PendingEvadeProjectile.Instigator), true);
		}
	}
	PendingEvadeProjectile = None;
}

function ReceiveProjectileWarning(Projectile Proj)
{
	local float TimeToImpact;

	// if we're looking in that direction and skilled enough, try an evasive maneuver
	if ( !Proj.IsA('GearProj_Grenade') && Proj.Speed > 0.0 && !IsTimerActive(nameof(DoProjectileEvade)) &&
		(Enemy == Proj.Instigator || vector(Pawn.Rotation) dot Normal(Proj.Instigator.Location - Pawn.Location) > 0.7) &&
		FRand() < 0.25 * GearPRI(PlayerReplicationInfo).Difficulty.default.DifficultyLevel )
	{
		TimeToImpact = Proj.GetTimeToLocation(Pawn.Location);
		PendingEvadeProjectile = Proj;
		SetTimer(FMax(TimeToImpact - 0.6, 0.5 - 0.3 * GearPRI(PlayerReplicationInfo).Difficulty.default.DifficultyLevel), false, nameof(DoProjectileEvade));
	}
}

function AdjustEnemyRating(out float out_Rating, Pawn EnemyPawn)
{
	Super.AdjustEnemyRating(out_Rating, EnemyPawn);

	if (out_Rating > 0.0)
	{
		GearGameMP_Base(WorldInfo.Game).AdjustEnemyRating(self, out_Rating, EnemyPawn);
	}
}

event float GetEvadeChanceScale()
{
	return 1.0;
}

function bool CanEvade(optional bool bCheckChanceToEvade, optional float InChanceToEvade = -1.f, optional float ChanceToEvadeScale = 1.f)
{
	// on casual, whenever we might evade, additional 50% chance that we don't
	if (GetDifficultyLevel() == DL_Casual)
	{
		bCheckChanceToEvade = true;
		if (InChanceToEvade > 0.0)
		{
			InChanceToEvade *= 0.5;
		}
		else
		{
			InChanceToEvade = 0.5;
		}
	}
	return Super.CanEvade(bCheckChanceToEvade, InChanceToEvade, ChanceToEvadeScale);
}

event float GetAimError(vector TargetLocation)
{
	local float Result;

	Result = Super.GetAimError(TargetLocation);
	// reduce accuracy of casual bots against humans slightly
	if (GetDifficultyLevel() == DL_Casual && Enemy != None && Enemy == FireTarget && PlayerController(Enemy.Controller) != None)
	{
		Result = FMax(Abs(Result), BaseAimError * 0.15 * FRand()) * ((Result < 0.0) ? -1.0 : 1.0);
	}

	return Result;
}

function int GetCanFireFacingThreshold()
{
	// when using a suppressive weapon, allow spraying bullets as we rotate to track the target
	// when not, wait until we're reasonably close to our desired rotation (based on difficulty)
	return IsUsingSuppressiveWeapon() ? 65536 : (182 * (4 - int(GearPRI(PlayerReplicationInfo).Difficulty.default.DifficultyLevel)));
}

function NotifyChangedWeapon(Weapon PrevWeapon, Weapon NewWeapon)
{
	local EDifficultyLevel Difficulty;

	Super.NotifyChangedWeapon(PrevWeapon, NewWeapon);

	// slight additional delay on lower difficulties
	Difficulty = GetDifficultyLevel();
	if (Difficulty == DL_Casual)
	{
		WeaponAimDelay += 0.75;
	}
	else if (Difficulty == DL_Normal)
	{
		WeaponAimDelay += 0.25;
	}
}

function float AboutToFireFromOpen()
{
	local float Result;
	local EDifficultyLevel Difficulty;

	Result = Super.AboutToFireFromOpen();
	// slight additional delay on lower difficulties
	Difficulty = GetDifficultyLevel();
	if (Difficulty == DL_Casual)
	{
		// slight additional delay
		Result += 0.75;
	}
	else if (Difficulty == DL_Normal)
	{
		Result += 0.25;
	}
	return Result;
}

function float GetPreFireFromCoverDelay()
{
	switch (GetDifficultyLevel())
	{
		case DL_Casual:
			return 1.0 + 0.5 * FRand();
		case DL_Normal:
			return 0.5 + 0.5 * FRand();
		case DL_Hardcore:
			return 0.25 + 0.25 * FRand();
		case DL_Insane:
			return 0.0;
	}
}
function float GetPostFireFromCoverDelay()
{
	local float Result, Exposure;

	Result = GetPreFireFromCoverDelay();
	// less ending delay if actively taking hits from enemy that is flanking us
	if ( IsUnderHeavyFire() && GetDifficultyLevel() > DL_Casual && Pawn.LastHitBy != None &&
		(!MyGearPawn.IsInCover() || (IsCoverExposedToAnEnemy(Cover, Pawn.LastHitBy.Pawn, Exposure) && Exposure > 0.5)) )
	{
		Result *= 0.5;
	}
	return Result;
}

event bool ShouldBlindFire()
{
	local float Chance;
	local EDifficultyLevel Difficulty;

	// casual bots cannot blind fire
	Difficulty = GetDifficultyLevel();
	if (MyGearPawn == None || !MyGearPawn.bCanBlindFire || Difficulty == DL_Casual)
	{
		return false;
	}
	// don't blind fire at stuff far away
	else if (!IsMediumRange(GetFireTargetLocation()))
	{
		return false;
	}
	// only hardcore and insane bots blindfire grenades
	else if (MyGearPawn.Weapon.IsA('GearWeap_GrenadeBase'))
	{
		return (Difficulty >= DL_Hardcore);
	}
	// only blindfire with suppressive weapons as for others we don't want to waste ammo with inaccurate shots
	else if (!IsUsingSuppressiveWeapon())
	{
		return false;
	}
	else
	{
		Chance = MyGearPawn.BlindFirePct;
		// more likely to blindfire when damaged if we're smart
		if (Difficulty >= DL_Hardcore && (IsUnderHeavyFire() || GetHealthPercentage() < 0.9))
		{
			Chance *= 2.0;
		}
		return (FRand() < Chance);
	}
}

function TransitionToSpectateFromEndOfRound()
{
	if (Pawn != None)
	{
		PawnDied(Pawn);
	}
}

function float GetReviveOrExecuteInterruptDist()
{
	return 512.f;
}

state Dead
{
	function CheckCombatTransition();
}

/** used in training grounds when we just want the bots to stand around and do nothing, but still exist */
state Inactive
{
	ignores CheckInterruptCombatTransitions, CheckCombatTransition;

	event BeginState(name PreviousStateName)
	{
		bAllowCombatTransitions = false;
	}

	event EndState(name NextStateName)
	{
		bAllowCombatTransitions = true;
	}
}

defaultproperties
{
	DefaultCommand=class'AICmd_Base_CoverAI_TDM'
	MeleeCommand=class'AICmd_Base_Melee_TDM'
	bDestroyOnPawnDeath=false
	bUseFireTickets=false
	bAvoidIdleMantling=false
	bWeightEnemyExposure=true
	AI_NearMissDistance=100.0
	InUseNodeCostMultiplier=0.0 // doesn't seem useful given that we don't repath each node most of the time
	MaxFireFromCoverBursts=-1

	DefaultReactConditionClasses.Remove(class'AIReactCond_MeatShield')
	DefaultReactConditionClasses.Remove(class'AIReactCond_Targeted')
	// remove it from the class list so we can mess with it
	DefaultReactConditionClasses.Remove(class'AIReactCond_Stumble')
	DefaultReactConditionClasses.Remove(class'AIReactCond_DmgLeaveCover')

	Begin Object Class=AIReactCond_Stumble Name=DamageStumble0
		bIgnoreLegShotStumbles=true
	End Object
	DefaultReactConditions.Add(DamageStumble0)

	Begin Object Class=AIReactCond_DmgLeaveCover Name=DmgLeaveCover0
		bSkipIfBeatingEnemy=true
		DamageThreshPct=0.33
	End Object
	DefaultReactConditions.Add(DmgLeaveCover0)

	Begin Object Class=AIReactCond_GenericCallDelegate Name=DamageInterrupt0
		AutoSubscribeChannels[0]=Damage
		OutputFunction=InterruptAction
		bSuppressed=true
	End Object
	DamageInterruptReaction=DamageInterrupt0

	Begin Object Class=AIReactCond_GenericCallDelegate Name=DamageInterrupt1
		AutoSubscribeChannels[0]=Damage
		OutputFunction=CheckLeaderInterrupt
		bSuppressed=true
	End Object
	LeaderDamageInterruptReaction=DamageInterrupt1

	// override melee reaction
	Begin Object Class=AIReactCond_EnemyCanBeMeleed_MP Name=EnemyInMeleeRangeReaction1
		OutputFunction=BeginMeleeCommandWrapper
	End Object
	DefaultReactConditions.Remove(EnemyInMeleeRangeReaction0)
	DefaultReactConditions.Add(EnemyInMeleeRangeReaction1)

	Begin Object Class=AIReactCond_StoppingPowerThreshold Name=StoppingPowerTemplate2
		ChanceToStumble=0.0
	End Object
	StoppingPowerReactionTemplate=StoppingPowerTemplate2

	Begin Object Class=CovGoal_GoalProximity Name=CovGoal_Proximity3
		BestGoalDist=0.0f
		MinGoalDist=0.0f
		MaxGoalDist=256.0f
		bHardLimits=true
	End Object
	Begin Object Class=CovGoal_TeammateProximity name=CovGoal_TeammateProx0
		RatingBoost=1.f
	End Object
	Begin Object Class=NavMeshGoal_AtCover Name=AtCov_Near1
		CoverGoalConstraints.Add(CovGoal_Enemies0)
		CoverGoalConstraints.Add(CovGoal_EnemyProx0)
		CoverGoalConstraints.Add(CovGoal_Proximity3)
		CoverGoalConstraints.Add(CovGoal_MovDist0)
		CoverGoalConstraints.Add(CovGoal_SquadLeadProx0)
		CoverGoalConstraints.Add(CovGoal_TeammateProx0)
	End Object
	AtCover_VeryNear=AtCov_Near1

	Begin Object Class=CovGoal_GoalProximity Name=CovGoal_Proximity4
		BestGoalDist=512.0
		MinGoalDist=128.0
		MaxGoalDist=2048.0
	End Object
	Begin Object Class=CovGoal_MovementDistance Name=CovGoal_MovDist2
		BestCoverDist=768.0f
		MinCoverDist=256.0f
		MaxCoverDist=1500.0f
		bMoveTowardGoal=true
		MinDistTowardGoal=256.f
	End object
	Begin Object Class=NavMeshGoal_AtCover Name=AtCover_Toward2
		CoverGoalConstraints.Add(CovGoal_Enemies0)
		CoverGoalConstraints.Add(CovGoal_WeaponRange0)
		CoverGoalConstraints.Add(CovGoal_MovDist2)
		CoverGoalConstraints.Add(CovGoal_TeammateProx0)
		CoverGoalConstraints.Add(CovGoal_Proximity4)
	End Object
	AtCover_TowardEnemyAggressive=AtCover_Toward2

	Begin Object Name=CovGoal_MovDist1
		BestCoverDist=768.0f
		MinCoverDist=256.0f
		MaxCoverDist=1024.0f
		bMoveTowardGoal=true
		MinDistTowardGoal=256.f
	End object
	Begin Object Name=AtCover_AlongPath0
		CoverGoalConstraints.Empty()
		CoverGoalConstraints.Add(CovGoal_Enemies0)
		CoverGoalConstraints.Add(CovGoal_MovDist1)
	End Object

	Begin Object Name=CovGoal_Proximity1
		BestGoalDist=2048.0
		MinGoalDist=1024.0
		MaxGoalDist=4096.0
	End Object
	Begin Object Class=CovGoal_MovementDistance Name=CovGoal_MovDist3
		BestCoverDist=1024.0f
		MinCoverDist=768.0f
		MaxCoverDist=2048.0f
	End Object
	Begin Object name=AtCov_Away0
		CoverGoalConstraints.Remove(CovGoal_MovDist0)
		CoverGoalConstraints.Add(CovGoal_MovDist3)
	End Object
}
