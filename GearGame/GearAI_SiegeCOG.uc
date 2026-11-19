/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * base class for the AI for COG in Siege 
 */
class GearAI_SiegeCOG extends GearAI_Cover;

/** whether this AI can trigger fortifications that require a button press */
var bool bCanActivateFortifications;

/** set when our inventory includes the HOD; used to modify enemy rating */
var bool bHasHOD;

function NotifyAddInventory(Inventory NewItem)
{
	if (GearWeap_HODBase(NewItem) != None)
	{
		bHasHOD = true;
	}
	Super.NotifyAddInventory(NewItem);
}

function float GetBaseEnemyRating(Pawn EnemyP, float Distance)
{
	local float Result;

	// add additional rating based on the health of the target, so larger enemies can be used as "tanks"
	Result = Super.GetBaseEnemyRating(EnemyP, Distance) + FClamp((EnemyP.HealthMax - 500) / 2000.0, 0.0, 1.0);
	// additionally, if we have the HOD prioritize targets that it can hit
	if (bHasHOD && Result > 0.0 && GearGRI(WorldInfo.GRI).HODBeamManager.IsAValidHODTarget(EnemyP.Location))
	{
		Result += 1.0;
	}

	return Result;
}

function ReceiveChargeTargetWarning(Pawn Shooter)
{
	// if we're looking in that direction and skilled enough, try to evade
	if ((Enemy == Shooter || vector(Pawn.Rotation) dot Normal(Shooter.Location - Pawn.Location) > 0.7) && CanEvade(true))
	{
		DoEvade(GetBestEvadeDir(Shooter.Location, Shooter), true);
	}
}

function bool WantsInfiniteAmmoFor(GearWeapon Wpn)
{
	return true;
}

/** @return whether we have a grenade with ammo that we can plant */
final function bool CanPlantGrenade()
{
	local GearWeap_GrenadeBase Grenade;

	Grenade = GearWeap_GrenadeBase(Pawn.FindInventoryType(class'GearWeap_GrenadeBase', true));
	return (Grenade != None && WorldInfo.TimeSeconds - LastGrenadeTime > Grenade.AI_TimeTweenGrenade && Grenade.HasAnyAmmo());
}

function int GetNumBurstsToFireWhileMoving()
{
	return -1;
}

function MoveToNearestCoverIdle()
{
	local CoverInfo CovNearBase;
	local GearFortification TestFort, BaseFort;
	local float Dist, BestDist;
	local GearGRI_Horde GRI;

	`AILog(GetFuncName() @ Squad);

	bReachedMoveGoal = false;
	bReachedCover = false;

	// find closest fortification to us
	GRI = GearGRI_Horde(WorldInfo.GRI);
	BestDist = 10000000.0;
	foreach GRI.Fortifications(TestFort)
	{
		Dist = VSize(TestFort.Location - Pawn.Location);
		if (Dist < BestDist)
		{
			BaseFort = TestFort;
			BestDist = Dist;
		}
	}

	if (BaseFort != None && EvaluateCover(SearchType_Near, BaseFort, CovNearBase))
	{
		SetCoverGoal(CovNearBase);
	}
	else
	{
		Super.MoveToNearestCoverIdle();
	}
}

/** checks if we should return to base, e.g. got too far away chasing an enemy that is no longer relevant */
final function bool ShouldReturnToBase()
{
	local int i;
	local GearGRI_Horde GRI;

	// no if seen enemies recently
	for (i = 0; i < LocalEnemyList.length; i++)
	{
		if (LocalEnemyList[i].Pawn != None && LocalEnemyList[i].Pawn.Controller != None && WorldInfo.TimeSeconds - LocalEnemyList[i].LastVisibleTime < 10.0)
		{
			return false;
		}
	}

	// no if near a fortification, or there are no fortifications to be near
	GRI = GearGRI_Horde(WorldInfo.GRI);
	if (GRI.Fortifications.length == 0)
	{
		return false;
	}
	else
	{
		for (i = 0; i < GRI.Fortifications.length; i++)
		{
			if (VSize(GRI.Fortifications[i].Location - Pawn.Location) < 1024.0)
			{
				return false;
			}
		}
	}

	return true;
}

// Siege AI never goes stale
function SetEnableDeleteWhenStale(bool bAmIExpendable);
function ConditionalDeleteWhenStale();

state Action_Idle
{
Begin:
	//debug
	`AILog("BEGIN TAG" @ PrintTetherInfo() @ ShouldMoveToSquad(), 'State');

	// Select our weapon
	if (SelectWeapon())
	{
		`AILog("Selected weapon");
		Sleep(0.25);
	}

	// check to see if someone needs reviving
	CheckReviveOrExecute(768.0);

	// If we have enemies
	if (HasAnyEnemies())
	{
		// Try to notice one which will put us into combat
		CheckNoticedEnemy();
		Sleep(1.0);
	}
	// otherwise if we have no enemies but do have a squad
	else if (ShouldMoveToSquad())
	{
MoveToSquad:
		//debug
		`AILog("Moving to squad...");

		// then move to the squad
		MoveToSquadPosition();

		// If no tether actor to clear
		if (bFailedToMoveToEnemy)
		{
			// Sleep to prevent recursive craziness
			Sleep(2.0);
		}

		// If we shouldn't keep the tether
		if (!bKeepTether)
		{
			// Clear the tether so that we always update to a new one
			ClearTether();
		}
		bKeepTether = FALSE;

		// check to see if we should immediately move again
		if (!HasAnyEnemies() && ShouldMoveToSquad())
		{
			//debug
			`AILog("Continuing move to squad");
			Sleep(0.1);

			Goto('MoveToSquad');
		}
		else
		{
			`AILog("Not continuing move to squad?" @ HasAnyEnemies() @ ShouldMoveToSquad());
		}
		Sleep(0.25);
	}
	else if (CanPlantGrenade())
	{
		class'AICmd_Attack_PlantGrenade'.static.PlantGrenade(self, 512, 1250);
		LastGrenadeTime = WorldInfo.TimeSeconds;
		Sleep(1.0);
	}
	else if (bIdleMoveToNearestEnemy)
	{
		MoveToNearestEnemy();
		Sleep(1.0);
	}
	else if (!HasValidCover() || !IsAtCover() || ShouldReturnToBase())
	{
		MoveToNearestCoverIdle();
		Sleep(1.0);
	}
	else
	{
		`AILog("Shouldn't move to squad, sleeping" @ PrintTetherInfo() @ MoveAction);
		Sleep(1.0);
	}
	Goto('Begin');
}

state Dead
{
	function CheckCombatTransition();
}

defaultproperties
{
	bUseFireTickets=false
	bIgnoreSquadPosition=true
	DefaultCommand=class'AICmd_Base_CoverAI_Siege'
	MaxFireFromCoverBursts=-1
	bDestroyOnPawnDeath=false //@warning: relies on GearGameSiege doing the destruction on round end

	Begin Object Class=CovGoal_TeammateProximity Name=CovGoal_TeammateProx1
		DesiredMinDist=512.0
	End Object
	Begin Object Name=AtCov_Towards0
		CoverGoalConstraints.Remove(CovGoal_TeammateProx0)
		CoverGoalConstraints.Add(CovGoal_TeammateProx1)
	End Object
	Begin Object Name=AtCov_Away0
		CoverGoalConstraints.Remove(CovGoal_TeammateProx0)
		CoverGoalConstraints.Add(CovGoal_TeammateProx1)
	End object
	Begin Object Name=AtCov_Near0
		CoverGoalConstraints.Remove(CovGoal_TeammateProx0)
		CoverGoalConstraints.Add(CovGoal_TeammateProx1)
	End Object
	Begin Object Name=AtCov_Squad0
		CoverGoalConstraints.Remove(CovGoal_TeammateProx0)
		CoverGoalConstraints.Add(CovGoal_TeammateProx1)
	End Object
	Begin Object Name=AtCov_Ambush0
		CoverGoalConstraints.Remove(CovGoal_TeammateProx0)
		CoverGoalConstraints.Add(CovGoal_TeammateProx1)
	End Object

	Begin Object class=AIReactCond_Targeted Name=SiegeCOGTargetedReaction
		ShooterRangeThreshold=2048.0
		bOnlyInstantHitWeapon=true
	End Object
	DefaultReactConditions.Add(SiegeCOGTargetedReaction)
}
