/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearGameSP_Arcade extends GearGameSP_Base
	abstract;

/** how much to remove from the team's multiplier for each point of damage received */
var config float MultiplierLossPerDamage;
/** how much to remove from the team's multiplier for each second a player is DBNO */
var config float MultiplierLossDBNOPerSec;
/** percent of current multiplier to lose when a player dies */
var config float MultiplierLossDeathPct;

function ReduceDamage(out int Damage, Pawn Injured, Controller InstigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType, Actor DamageCauser)
{
	local int ReducedDamage;
	local vector ReducedMomentum;

	Super.ReduceDamage(Damage, Injured, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);

	if (PlayerController(Injured.Controller) != None)
	{
		//@FIXME: @hack: AdjustPawnDamage() should be before WorldInfo.Game.ReduceDamage(), but it's being abused too much to move it
		ReducedDamage = Damage;
		ReducedMomentum = Momentum;
		if (GearPawn(Injured) != None)
		{
			GearPawn(Injured).AdjustPawnDamage(ReducedDamage, InstigatedBy.Pawn, HitLocation, ReducedMomentum, class<GearDamageType>(DamageType), DamageCauser);
		}

		GearGRI_SP_Arcade(GameReplicationInfo).ModifyMultiplier(MultiplierLossPerDamage * ReducedDamage);
	}
}

event CheckpointLoadComplete()
{
	Super.CheckpointLoadComplete();

	GearGRI_SP_Arcade(GameReplicationInfo).ResetMultiplier();
}

function bool ShouldDeathCauseFailure(GearPC DeadPC)
{
	local GearPC OtherPC;

	if (bInSoloSplit)
	{
		return true;
	}
	else
	{
		// try to find someone else alive
		// if we're in a split, the player must be in the same squad
		foreach WorldInfo.AllControllers(class'GearPC', OtherPC)
		{
			// special case for the rattruck level: fail if anyone dies since there is no good way to resurrect them during this sequence
			if (OtherPC.Pawn != None && Vehicle_RatTruck_Base(OtherPC.Pawn.Base) != None)
			{
				return true;
			}
			else if( OtherPC != DeadPC && 
					 OtherPC.Pawn != None && 
					 (GearPawn(OtherPC.Pawn) == None || !GearPawn(OtherPC.Pawn).IsDBNO()) &&
					 (!bInCoopSplit || !bGapSquadSplit || OtherPC.Squad == DeadPC.Squad) )
			{
				return false;
			}
		}

		return true;
	}
}

/** resurrect all human players who have died but didn't cause game failure (because we usually require all to die to end Arcade games in failure) */
final function ResurrectDeadPlayers()
{
	local GearPC PC;

	foreach WorldInfo.AllControllers(class'GearPC', PC)
	{
		if (PC.IsInState('Dead') || (PC.IsSpectating() && !PC.IsInState('PlayerWaiting')))
		{
			Super(GearGame).RestartPlayer(PC);
		}
	}
}

/** resurrect player who is leaving so the AI can take over */
final function ResurrectExitingPlayer(GearPC PC)
{
	if (PC.IsInState('Dead') || (PC.IsSpectating() && !PC.IsInState('PlayerWaiting')))
	{
		Super(GearGame).RestartPlayer(PC);

		if (GearPawn(PC.Pawn) != None)
		{
			// force them DBNO to minimize cheating implications
			GearPawn(PC.Pawn).EnterDBNO(None, class'GearDamageType', vect(0,0,1));
		}
	}
}

function NotifyDBNO(Controller InstigatedBy, Controller Victim, Pawn DownedPawn)
{
	local GearPRI PRI;

	Super.NotifyDBNO(InstigatedBy, Victim, DownedPawn);

	if (DownedPawn != None && DownedPawn.GetTeamNum() == 0)
	{
		// in Arcade you lose points for going DBNO so you can't boost your team score by reviving teammates
		PRI = GearPRI(DownedPawn.PlayerReplicationInfo);
		if (PRI != None)
		{
			PRI.ModifyScore(-PRI.PointsFor_Revives, eEXP_Revives);
		}
	}
}

state MatchInProgress
{
	function NavigationPoint FindPlayerStart(Controller Player, optional byte InTeam, optional string IncomingName)
	{
		local float Dist, TotalDist, BestDist;
		local NavigationPoint Best;
		local Controller C;
		local bool bValid;
		local NavigationPoint N;
		local vector Extent, TestLocation;

		if (InTeam != 0 || GearPC(Player) == None || Player.IsInState('PlayerWaiting'))
		{
			return Global.FindPlayerStart(Player, InTeam, IncomingName);
		}
		else
		{
			Extent.X = GearPRI(Player.PlayerReplicationInfo).PawnClass.default.CylinderComponent.CollisionRadius;
			Extent.Y = Extent.X;
			Extent.Z = GearPRI(Player.PlayerReplicationInfo).PawnClass.default.CylinderComponent.CollisionHeight;
			BestDist = 10000000.0;
			foreach WorldInfo.AllNavigationPoints(class'NavigationPoint', N)
			{
				TestLocation = N.Location;
				TestLocation.Z += Extent.Z - N.CylinderComponent.CollisionHeight; // offset to get approx location of enemy standing on floor
				if (!N.bBlocked && class'NavigationHandle'.static.ObstaclePointCheck(TestLocation, Extent))
				{
					TotalDist = 0.0;
					bValid = true;
					foreach Teams[0].TeamMembers(C)
					{
						if (C.Pawn != None)
						{
							Dist = VSize(N.Location - C.Pawn.Location);
							if (Dist < C.Pawn.GetCollisionRadius() * 2.0)
							{
								bValid = false;
								break;
							}
							TotalDist += Dist;
						}
					}
					if (bValid && TotalDist < BestDist)
					{
						Best = N;
						BestDist = Dist;
					}
				}
			}

			return Best;
		}
	}

	function Pawn SpawnDefaultPawnFor(Controller NewPlayer, NavigationPoint StartSpot)
	{
		local class<Pawn> DefaultPlayerClass;
		local rotator StartRotation;
		local Pawn ResultPawn;

		DefaultPlayerClass = GetDefaultPlayerClass(NewPlayer);

		// don't allow pawn to be spawned with any pitch or roll
		StartRotation.Yaw = StartSpot.Rotation.Yaw;

		//@hack: we're spawning on arbitrary NavigationPoints, so push upward a bit to be absolutely sure we don't get stuck in the floor
		// 	(shouldn't the spawning code be doing that?)
		ResultPawn = Spawn(DefaultPlayerClass,,, StartSpot.Location + vect(0,0,50), StartRotation);
		if ( ResultPawn == None )
		{
			`log("Couldn't spawn player of type "$DefaultPlayerClass$" at "$StartSpot);
		}
		return ResultPawn;
	}

	function Timer()
	{
		local GearPawn GP;
		local Controller C;
		local bool bFoundEnemy;

		Super.Timer();

		foreach Teams[0].TeamMembers(C)
		{
			if (PlayerController(C) != None)
			{
				GP = GearPawn(C.Pawn);
				if (GP != None && GP.IsDBNO())
				{
					GearGRI_SP_Arcade(GameReplicationInfo).ModifyMultiplier(MultiplierLossDBNOPerSec);
				}
			}
		}

		// if combat has ended or a cinematic has started, revive humans that died
		if (!PlayerController(Teams[0].TeamMembers[0]).bCinematicMode)
		{
			foreach Teams[1].TeamMembers(C)
			{
				if (C.Pawn != None && !C.Pawn.IsInvisible())
				{
					bFoundEnemy = true;
					break;
				}
			}
			if (!bFoundEnemy)
			{
				foreach Teams[2].TeamMembers(C)
				{
					if (C.Pawn != None && !C.Pawn.IsInvisible())
					{
						bFoundEnemy = true;
						break;
					}
				}
			}
		}
		if (!bFoundEnemy)
		{
			ResurrectDeadPlayers();
		}
	}

	function ScoreKill(Controller Killer, Controller Other)
	{
		Super.ScoreKill(Killer, Other);

		if (PlayerController(Other) != None)
		{
			// lose current multiplier on death
			GearGRI_SP_Arcade(GameReplicationInfo).ModifyMultiplier((GearGRI_SP_Arcade(GameReplicationInfo).TeamMultiplier - 1.0) * MultiplierLossDeathPct);
		}
	}
}

defaultproperties
{
	GameReplicationInfoClass=class'GearGRI_SP_Arcade'

	OnlineStatsWriteClass=class'GearLeaderboardArcadeWrite';
}
