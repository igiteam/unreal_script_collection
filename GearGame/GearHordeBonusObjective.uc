/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
/** defines a bonus objective for Horde that the players get a reward for completing, but is not required to win the game */
class GearHordeBonusObjective extends Object
	abstract
	config(Game);

/** objective text displayed on the players' HUD */
var localized string ObjectiveText;
/** how many air drop pickups to create on success */
var config int RewardDrops;
/** how much cash to give the players (total, not per player) */
var config int RewardCash;

/** whether the Horde spawning logic may spawn squads of enemies while this objective is active */
var bool bAllowSquads;

/** reference to GameInfo that created this objective */
var GearGameHorde_Base Game;

/** called to initialize the objective after instancing it */
function Init()
{
	local ObjectiveInfo ObjInfo;

	Game = GearGameHorde_Base(Outer);

	// tell the players about this objective
	GetObjectiveInfo(ObjInfo);
	SendObjectiveUpdate(ObjInfo);
}

/** @return whether or not this objective is valid for the current game state */
static function bool CanBeSelected(GearGameHorde_Base InGame)
{
	return true;
}

/** retrieves objective info for player HUD display */
function GetObjectiveInfo(out ObjectiveInfo ObjInfo)
{
	ObjInfo.ObjectiveName = 'HordeBonus';
	ObjInfo.ObjectiveDesc = PathName(Class) $ ".ObjectiveText";
	ObjInfo.bShowInList = true;
	ObjInfo.bNotifyPlayer = true;
}

/** @return how close this objective is to being completed (0 - not at all, 1 - complete) */
function float GetCompletionPercentage();

/** sends the given objective info to all players on the friendly team */
function SendObjectiveUpdate(const out ObjectiveInfo ObjInfo)
{
	local int i;
	local GearPC PC;

	for (i = 0; i < Game.Teams[0].TeamMembers.length; i++)
	{
		PC = GearPC(Game.Teams[0].TeamMembers[i]);
		if (PC != None)
		{
			PC.ObjectiveMgr.AddObjectiveInfo(ObjInfo);
		}
	}
}

/** called to complete the objective and give players their reward */
function CompleteObjective()
{
	local int i, InsertIndex, Count, RewardPerPlayer;
	local GearHordePC PC;
	local ObjectiveInfo ObjInfo;
	local NavigationPoint N;
	local array<NavigationPoint> SpawnLocs;
	local vector HitLocation, HitNormal, TraceEnd;
	local bool bValidPoint;

	GetObjectiveInfo(ObjInfo);
	ObjInfo.bCompleted = true;

	// award score and notify players the objective has been finished
	RewardPerPlayer = RewardCash / Game.Teams[0].TeamMembers.length;
	for (i = 0; i < Game.Teams[0].TeamMembers.length; i++)
	{
		Game.Teams[0].TeamMembers[i].PlayerReplicationInfo.Score += RewardPerPlayer;
		PC = GearHordePC(Game.Teams[0].TeamMembers[i]);
		if (PC != None)
		{
			PC.ObjectiveMgr.AddObjectiveInfo(ObjInfo);
			PC.ClientCompletedBonus(RewardPerPlayer, false);
		}
	}

	// spawn drops
 	Count = 0;
	foreach Game.WorldInfo.AllNavigationPoints(class'NavigationPoint', N)
	{
		if (Game.HordeGRI.FortificationFlags.length == 0)
		{
			bValidPoint = true;
		}
		else
		{
			bValidPoint = false;
			for (i = 0; i < Game.HordeGRI.FortificationFlags.length; i++)
			{
				if (VSize(Game.HordeGRI.FortificationFlags[i].Location - N.Location) < 512.0)
				{
					bValidPoint = true;
					break;
				}
			}
		}
		if (bValidPoint)
		{
			Count++;
			if (Count <= RewardDrops || FRand() < 1.0 / Count)
			{
				SpawnLocs[InsertIndex] = N;
				InsertIndex = (InsertIndex + 1) % RewardDrops;
			}
		}
	}
	for (i = 0; i < SpawnLocs.length; i++)
	{
		TraceEnd = SpawnLocs[i].Location + vect(0,0,2000);
		if (Game.Trace(HitLocation, HitNormal, TraceEnd, SpawnLocs[i].Location, true, vect(100,100,50)) == None)
		{
			HitLocation = TraceEnd;
		}
		Game.Spawn(Game.AirDropClass,,, HitLocation, RotRand());
	}

	Game.ActiveBonusObjective = None;
}

function FailObjective()
{
	local ObjectiveInfo ObjInfo;
	local int RewardPerPlayer, i;
	local GearHordePC PC;

	GetObjectiveInfo(ObjInfo);
	ObjInfo.bFailed = true;

	// award partial score bonus (but no drops) and notify players the objective has been finished
	RewardPerPlayer = RewardCash / Game.Teams[0].TeamMembers.length * GetCompletionPercentage();
	for (i = 0; i < Game.Teams[0].TeamMembers.length; i++)
	{
		Game.Teams[0].TeamMembers[i].PlayerReplicationInfo.Score += RewardPerPlayer;
		PC = GearHordePC(Game.Teams[0].TeamMembers[i]);
		if (PC != None)
		{
			PC.ObjectiveMgr.AddObjectiveInfo(ObjInfo);
			PC.ClientCompletedBonus(RewardPerPlayer, true);
		}
	}

	Game.ActiveBonusObjective = None;
}

/** handler of any kill event (player or enemy) */
function ProcessKill(Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> DamageType);
/** handler for damage taken by any Pawn */
function ProcessDamage(int Damage, Pawn Injured, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, Actor DamageCauser);

/** called every game second */
function Timer();

/** gives an opportunity for the objective to modify the minimum count of an enemy type, for example to make sure
 * there are sufficient enemies to satisfy this objective
 */
function ModifyMinCount(EAITypes EnemyType, out int MinCount);

/** notification that the wave has ended */
function NotifyWaveEnded()
{
	// default behavior is that you must complete whatever it is within a single wave
	FailObjective();
}

defaultproperties
{
	bAllowSquads=true
}
