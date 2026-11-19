/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Base_Silverback extends AICommand_Base_Combat
	within GearAI_Cover;

/** React condition for ejecting from the Silverback */
var AIReactCond_HealthThresh EjectReaction;
/** Minimum distance to enemy for considering rockets */
var() float MinRocketDist;
/** Base chance of using a rocket instead of the minigun when firing */
var() float RocketUseChance;
/** Minimum amount of time between firing rockets */
var() float MinTimeBetweenRockets;
/** Threshold above which enemy is considered to have high health */
var() float TargetHighHealthThreshold;
/** Last time we fired a rocket */
var transient float LastRocketTime;

/** Max number of rockets to fire per deployment */
var() int MaxRocketsPerDeployment;
/** Counter for number of rockets fired this deployment */
var transient int NumRocketsFiredThisDeployment;

/** Minimum amount of time to remain in Deployed state */
var() float MinDeploymentDuration;
/** Minimum amount of time between deployments */
var() float MinUnDeploymentDuration;
/** Time that we entered the Deployed state */
var transient float DeploymentTime;
/** Time that we last exited Deployed state */
var transient float UndeploymentTime;

function Pushed()
{
	local Vector EntryPoint;
	local float GoalDist;

	Super.Pushed();

	if( CurrentSilverback != None )
	{
		if( !MyGearPawn.IsA('GearPawn_SilverbackBase') )
		{
			EntryPoint = CurrentSilverback.GetEntryPoint();
			GoalDist = 2.0f * MyGearPawn.CylinderComponent.CollisionRadius;

			// Move to the target first
			if( VSizeSq( MyGearPawn.Location - EntryPoint ) < GoalDist * GoalDist &&
				CurrentSilverback.TryToDrive(MyGearPawn) )
			{
				bShouldRoadieRun = true;
				GotoState( 'InCombat' );
			}
			else
			{
				SetMovePoint(EntryPoint, CurrentSilverback);
			}
		}
	}
	else
	{
		GotoState( 'InCombat' );
	}
}

function Resumed( Name OldCommandName )
{
	local Vector EntryPoint;
	local float GoalDist;

	Super.Resumed(OldCommandName);

	if (!MyGearPawn.IsA('GearPawn_SilverbackBase'))
	{
		// If we reached the target successfully
		if (CurrentSilverback != None)
		{
			EntryPoint = CurrentSilverback.GetEntryPoint();
			GoalDist = 2.0f * MyGearPawn.CylinderComponent.CollisionRadius;

			// Move to the target first
			if (VSize(MyGearPawn.Location - EntryPoint) < GoalDist)
			{
				if (CurrentSilverback.TryToDrive(MyGearPawn))
				{
					GotoState('InCombat');
				}
				else
				{
					// Couldn't enter, so fail the command
					Status = 'Failure';
					PopCommand(self);
				}
			}
			else if (ChildStatus == 'Success')
			{
				SetMovePoint(EntryPoint, CurrentSilverback);
			}
			else
			{
				// Otherwise, didn't get there so fail the command
				Status = 'Failure';
				PopCommand(self);
			}
		}
		else
		{
			// silverback was lost/destroyed
			Status = 'Failure';
			PopCommand(self);
		}
	}
	else
	{
		GotoState('InCombat');
	}
}

function Popped()
{
	bShouldRoadieRun = default.bShouldRoadieRun;
	Super.Popped();
	StopFiring();

	EjectReaction.UnsubscribeAll();
	EjectReaction = None;

	CurrentSilverback = None;
}

function bool AllowTransitionTo(class<GameAICommand> AttemptCommand )
{
	return FALSE;
}

function bool ShouldIgnoreTimeTransitions()
{
	return TRUE;
}

function rotator GetAdjustedAimFor(Weapon W, vector StartFireLoc)
{
	local rotator AimRot;

	AimRot = Super.GetAdjustedAimFor(W, StartFireLoc);
	if( CurrentSilverback != None && IsInState('Deployed') )
	{
		AimRot.Yaw = Pawn.Rotation.Yaw + 16384 * MyGearPawn.AimOffsetPct.X;
	}
	return AimRot;
}

function CheckMelee()
{
	local Pawn MeleeTarget;

	if ( !IsInState('Deployed') &&
		HasEnemyWithinDistance(EnemyDistance_Melee, MeleeTarget, true)  &&		// Actually has an enemy in range
		HasEnemyWithinDistance(EnemyDistance_Melee, MeleeTarget, false) )		// Thinks an enemy is in range
	{
		class'AICmd_Attack_Melee'.static.Melee(Outer, MeleeTarget);
	}
}

/** @return whether we should consider shooting a rocket; checks for last time we did so, random scaling, etc */
simulated function bool ShouldTryRocket()
{
	local GearPawn EnemyPawn;
	local vector EnemyLocation;
	local float RocketChanceScale;
	local float DmgRadius, Dist;
	local bool bAttackingKidnapper;

	EnemyLocation = GetEnemyLocation();

	if ( NumRocketsFiredThisDeployment < MaxRocketsPerDeployment && Outer.Enemy != None &&
		VSize(Outer.Pawn.Location - EnemyLocation) > MinRocketDist &&
		WorldInfo.TimeSeconds - LastRocketTime > MinTimeBetweenRockets )
	{
		// always fire rocket on deployment finish if target is still valid
		if (NumRocketsFiredThisDeployment == 0)
		{
			return true;
		}
		else
		{
			RocketChanceScale = 0.3;

			if( Outer.Enemy.Health > TargetHighHealthThreshold )
			{
				RocketChanceScale += 0.4;
			}
			bAttackingKidnapper = (GearPawn(Outer.Enemy) != None && GearPawn(Outer.Enemy).IsAKidnapper());

			// Count the number of enemies in range
			DmgRadius = 512.0; //WeaponProjectiles[0].default.ExploDamageRadius;
			foreach Outer.Squad.AllEnemies(class'GearPawn', EnemyPawn, Outer)
			{
				if (EnemyPawn != Outer.Enemy && !EnemyPawn.IsAHostage())
				{
					Dist = VSize(Outer.GetEnemyLocation(EnemyPawn) - EnemyLocation);
					if (Dist < DmgRadius * 0.6)
					{
						// Check if the enemy in range is a kidnapper
						bAttackingKidnapper = bAttackingKidnapper || EnemyPawn.IsAKidnapper();

						// High-health targets increase our desire to use a rocket
						if( EnemyPawn.Health > TargetHighHealthThreshold )
						{
							RocketChanceScale += 0.4;
						}
						else
						{
							RocketChanceScale += 0.25;
						}
					}
				}
			}

			if (bAttackingKidnapper)
			{
				RocketChanceScale += 0.4;
			}

			return (FRand() < RocketChanceScale * RocketUseChance);
		}
	}
	else
	{
		return false;
	}
}

function EjectFromSilverback(Actor EventInstigator, AIReactChannel OrigChannel)
{
	`AILog("Eject from silverback");
	StopUsingSilverback(CurrentSilverback);
}

state InCombat
{
	function BeginState( Name PreviousStateName )
	{
		Super.BeginState( PreviousStateName );

		// Push a damage threshold reaction to leave the Silverback before it explodes
		EjectReaction = new(outer) class'AIReactCond_HealthThresh';
		EjectReaction.HealthThreshold = CurrentSilverback.DefaultHealth * 0.1f;
		EjectReaction.OutputFunction = EjectFromSilverback;
		EjectReaction.Initialize();
		ReactionManager.UnsuppressChannel('Damage');

		Outer.SetTimer(1.5f, true, 'CheckMelee', self);
	}

	function EndState(Name NextStateName)
	{
		Super.EndState(NextStateName);
		ClearTimer('CheckMelee');
	}

	function bool ShouldDeploy()
	{
		local vector EnemyLoc;
		local Pawn P;

		EnemyLoc = GetEnemyLocation();
		if ( `TimeSince(UndeploymentTime) > MinUnDeploymentDuration &&
			!IsShortRange(EnemyLoc) && vector(Pawn.Rotation) dot Normal(EnemyLoc - Pawn.Location) > 0.7 && // ~45 degrees
			(FailedPathToEnemyRecently(Enemy) || CanFireAt(Enemy, Pawn.GetWeaponStartTraceLocation())) )
		{
			// use rockets if there are multiple enemies
			foreach Squad.AllEnemies(class'Pawn', P, Outer)
			{
				if (P != Enemy && VSize(GetEnemyLocation(P) - EnemyLoc) < 768.0)
				{
					return true;
				}
			}
		}

		return FALSE;
	}

	function bool MoveAwayFromEnemy()
	{
		local Vector EnemyLoc;

		EnemyLoc = GetEnemyLocation();

		class'NavMeshPath_WithinDistanceEnvelope'.static.StayWithinEnvelopeToLoc(NavigationHandle,Pawn.Location,EnemyDistance_Medium,EnemyDistance_Short,false,0.f,true);
		class'NavMeshGoal_AwayFromPosition'.static.FleeFrom(NavigationHandle, EnemyLoc, EnemyDistance_Medium);
		if (NavigationHandle.FindPath())
		{
			SetMovePoint(NavigationHandle.PathCache_GetGoalPoint(),, true, 100.f, true, true, true);
			return true;
		}

		return false;
	}

Begin:
	//debug
	`AILog( "BEGIN TAG", 'State' );

	// check to see if we should move to our squad
	if( ShouldMoveToSquad() )
	{
MoveToSquad:
		//debug
		`AILog( "MOVETOSQUAD TAG", 'State' );
		MoveToSquadPosition();
		Sleep( 0.25f );
	}

	// select the best enemy
	SelectEnemy();
	FireTarget = Enemy;

	if (!HasValidEnemy() || !bAllowCombatTransitions )
	{
		//debug
		`AILog("No enemy");

		Sleep(1.f);
		Goto('Begin');
	}

	// If enemy is not nearby and can fire at them
	if( ShouldDeploy() )
	{
		while( IsReloading() )
		{
			//debug
			`AILog("Waiting on reload",'Loop');

			Sleep(0.25f);
		}

		// Deploy
		GoToState('Deployed');
		Sleep( 0.25f );
	}
	// if the enemy is at a reasonable distance, fire from our current position
	else if (GetNearEnemyDistance(Pawn.Location) > EnemyDistance_Medium)
	{
		FireFromOpen();
		Sleep(0.25);
	}
	// Otherwise, move far away from them
	else
	{
		StartFiring();
		// Move away from enemy
		if( !MoveAwayFromEnemy() || bFailedToMoveToEnemy )
		{
			//debug
			`AILog("Failed to move to enemy");
			Sleep(1.0f);
		}
		StopFiring();
	}

	Goto('Begin');
}

state Deployed
{
	function BeginState( Name PreviousStateName )
	{
		local GearPawn_SilverbackArmedBase ArmedSilverback;

		`AILog("Deploying silverback");

		NumRocketsFiredThisDeployment = 0;
		DeploymentTime = WorldInfo.TimeSeconds;
		ArmedSilverback = GearPawn_SilverbackArmedBase(CurrentSilverback);
		if( ArmedSilverback != None )
		{
			ArmedSilverback.Deploy();
		}

		Super.BeginState( PreviousStateName );
	}

	function EndState( Name NextStateName )
	{
		local GearPawn_SilverbackArmedBase ArmedSilverback;

		`AILog("Undeploying silverback");
		UndeploymentTime = WorldInfo.TimeSeconds;
		ArmedSilverback = GearPawn_SilverbackArmedBase(CurrentSilverback);
		if( ArmedSilverback != None )
		{
			bAltFire = 0;
			ArmedSilverback.Undeploy();
		}
		Super.EndState( NextStateName );

	}

	function bool ShouldUndeploy()
	{
		local Pawn NearEnemy;
		local GearPawn_SilverbackArmedBase ArmedSilverback;

		ArmedSilverback = GearPawn_SilverbackArmedBase(CurrentSilverback);
		if( !HasEnemyWithinDistance(MinRocketDist, NearEnemy, TRUE) &&
			( `TimeSince(DeploymentTime) < MinDeploymentDuration ||
			  ( ArmedSilverback.DeployedLink != None && ArmedSilverback.DeployedLink.Claims.Length > 0 ) ||
			  ( CanFireAt(Enemy, Pawn.GetWeaponStartTraceLocation()) && NumRocketsFiredThisDeployment < MaxRocketsPerDeployment ) ) )
		{
			return FALSE;
		}

		return TRUE;
	}

Begin:
	//debug
	`AILog( "BEGIN TAG", 'State' );

	do
	{
		Sleep(0.1);
		if (!GearPawn_SilverbackArmedBase(Pawn).bWantsToBeDeployed)
		{
			GotoState('InCombat');
		}
	} until (GearPawn_SilverbackArmedBase(Pawn).IsDeployed());

	SelectEnemy();
 	if (ShouldTryRocket())
 	{
		bWeaponCanFire = true;
		bAltFire = 1;
		DesiredBurstsToFire = 1;
		LastRocketTime = WorldInfo.TimeSeconds;
		++NumRocketsFiredThisDeployment;
		StartFiring();
		Sleep(0.5);
		StopFiring();
 	}
	if (ShouldUndeploy())
	{
		Sleep(1.0f);
		GotoState('InCombat');
	}
	else
	{
		Goto('Begin');
	}
}

defaultproperties
{
	MinRocketDist=512.f
	RocketUseChance=1.0f
	MinTimeBetweenRockets=3.0
	TargetHighHealthThreshold=1200.f
	MinDeploymentDuration=5.0f
	MinUnDeploymentDuration=10.0f
	MaxRocketsPerDeployment=3
}
