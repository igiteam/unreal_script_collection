/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Flank extends AICommand
	within GearAI
	native(AI);


/** polys on the direct route to enemy. We add cost to these when looking for a flank path so that
 * the AI will prefer going a different route
 */
//var native const editconst array<pointer> AvoidPolys{struct FNavMeshPolyBase};

/** array of poly centers which will be converetd into polygons at each step */
var array<vector> AvoidPolyCtrs;

/** creates the avoid list using the current RouteCache in the AI's NavigationHandle */
native final function CreateAvoidList();
/** adds TransientCost to all entries in the avoid list */
native final function AddCostToAvoidList();

auto state TryToFlank
{
	/** @return whether an enemy is exposed to the AI (flanked, not simply popping up from cover) */
	final function bool IsEnemyExposed()
	{
		local Pawn			P;
		local bool			bTryToClose;
		local GearWeapon	MyGearWeapon;

		MyGearWeapon = GearWeapon(Pawn.Weapon);
		// try to get into best effective range of weapon unless being shot at
		if( MyGearWeapon == None || !MyGearWeapon.bSniping )
		{
			bTryToClose = !IsUnderHeavyFire();
		}

		foreach Squad.AllEnemies(class'Pawn', P)
		{
			// trace directly to center; if we can hit that, enemy is pretty well exposed to us
			if ( (!bTryToClose || IsMediumRange(P.Location)) &&
				FastTrace(P.Location, Pawn.GetWeaponStartTraceLocation()) )
			{
				`AILog(P @ "is exposed to me");
				return TRUE;
			}
		}

		return FALSE;
	}

	/** this is where we do the actual pathfinding after adding the avoid costs and such */
	final function bool GenerateAlternatePath()
	{
		class'NavMeshPath_AvoidFireFromCover'.static.AvoidFireFromCover( NavigationHandle );
		class'NavMeshGoal_At'.static.AtActor(NavigationHandle, Enemy, 0.0, false);
		return NavigationHandle.FindPath();
	}

Begin:
	`AILog("Attempting to flank enemy" @ Enemy);
	// we need a valid enemy for this command
	if (!HasValidEnemy())
	{
		`AILog("No enemy");
		GotoState('DelayFailure');
	}
	// construct the avoid list from the direct route to the enemy
	if( !GeneratePathTo(Enemy) )
	{
		// failed to find path
		`AILog("No path");
		GotoState('DelayFailure');
	}
 	Sleep(0.0); // sleep a tick to spread out work
	CreateAvoidList();
	Sleep(0.0); // and again
FlankStart:
	if (!HasValidEnemy())
	{
		`AILog("Lost enemy");
		Status = 'Failure';
		PopCommand(self);
	}
	AddCostToAvoidList();
	if (!GenerateAlternatePath())
	{
		`AILog("Couldn't find alternate path to enemy");
		Status = 'Failure';
		PopCommand(self);
	}
	// roadie run unless can see enemy or almost at enemy
	bShouldRoadieRun = GetDifficultyLevel() > DL_Casual && NavigationHandle.GetPathCacheLength() > 5 && !IsUnderHeavyFire() &&
				!LineOfSightTo((FireTarget != None) ? FireTarget : Enemy);
	// go in steps so we can re-evaluate our situation
	if (NavigationHandle.GetPathCacheLength() > 3)
	{
		NavigationHandle.PathCache_RemoveIndex(3, NavigationHandle.GetPathCacheLength() - 3);
	}
	Vect2BP(NavigationHandle.FinalDestination, NavigationHandle.PathCache_GetGoalPoint());
	SetMoveGoal(Enemy,, true,, true, false);
	CheckInterruptCombatTransitions();
	if (IsEnemyExposed())
	{
		`AILog("Successfully flanked enemy");
		if (!IsUnderHeavyFire() && GetNearEnemyDistance(Pawn.Location) > EnemyDistance_Melee)
		{
			`AILog("- shoot at enemy from here");
			FireFromOpen(-1);
		}
		Status = 'Success';
		PopCommand(self);
	}
	Goto('FlankStart');
}
