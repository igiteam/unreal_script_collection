
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Base_CorpserLarvaUnderground extends AICommand_Base_Combat
	within GearAI_CorpserLarvaUnderground;

/** Keep track of underground stabs */
var transient INT NumMeleeAttacksUnderground;
/** Enforce Minimum time between charges */
var transient Float LastChargeTime;

function Pushed()
{
	Super.Pushed();
	
	Corpser.ResetEncroachers();

	GoToRoamingState();
}

function Resumed( Name OldCommandName )
{
	Super.Resumed( OldCommandName );

	Corpser.ResetEncroachers();
}


/** Takes into account if we should be underground or not. */
function GoToRoamingState()
{
	if( Corpser.bIsUnderground )
	{
		GotoState('UndergroundRoam');
	}
	else
	{
		GotoState('AboveGroundRoam');
	}
}

function bool GenerateRoamPath( Actor Goal )
{
	local vector Direction, GoalPoint;

	Direction = Normal(Enemy.Location - Pawn.Location);
	GoalPoint = Enemy.Location + Direction * EnemyDistance_Medium;
	class'NavMeshPath_Toward'.static.TowardPoint( NavigationHandle, GoalPoint );
// 	class'NavMeshPath_WithinTraversalDist'.static.DontExceedMaxDist(NavigationHandle, EnemyDistance_Long, FALSE);
	
	// real one with soft distances
	class'NavMeshPath_WithinDistanceEnvelope'.static.StayWithinEnvelopeToLoc(NavigationHandle, Goal.Location, EnemyDistance_Medium, (EnemyDistance_Medium + EnemyDistance_Short)/2.f, TRUE, -1024.f, FALSE);
	class'NavMeshGoal_PolyEncompassesAI'.static.MakeSureAIFits(NavigationHandle);
	class'NavMeshGoal_Null'.static.GoUntilBust( NavigationHandle, 1024 );

	return NavigationHandle.FindPath( Goal );
}

function bool RoamTowardEnemy()
{
	if( CanMove() && GenerateRoamPath(Enemy) )
	{
		SetMovePoint(NavigationHandle.PathCache_GetGoalPoint(),,,,TRUE);
		return true;
	}

	return false;
}

/** Tells us if Corpser needs to be teleported or not */
function bool ShouldAttemptTeleport()
{
	// if we just teleported, no
	// Take into account TimeBetweenUndergroundAttacks, because that's what the Corpser sleeps after being teleported to another location.
	if( `TimeSince(LastTeleportTime) < (Corpser.TimeBetweenUndergroundAttacks + 1.f) )
	{
		`AILog(self@GetFuncName() @ "no, just teleported." @ `TimeSince(LastTeleportTime));
		return FALSE;
	}

	// If our last attack failed...
	if( Corpser.NumUndergroundAttackAttempts > 0 && !Corpser.bUndergroundChargeReachedTarget && !Corpser.bUndergroundChargeTimedOut )
	{
		`AILog(self@GetFuncName() @ "yes, failed last attack" @ Corpser.NumUndergroundAttackAttempts @ Corpser.bUndergroundChargeReachedTarget @ Corpser.bUndergroundChargeTimedOut);
		return TRUE;
	}

	return FALSE;
}



/** Checks if Corpser is ok to attack enemy */
function bool UndergroundCanAttackEnemy()
{
	// If we have no enemy, we can't attack :(
	if( Enemy == None )
	{
		`AILog(self@GetFuncName() @ "no enemy");
		return FALSE;
	}

	// If our enemy is too far away, don't even try
	if( VSize(Corpser.Location - Enemy.Location) > EnemyDistance_Long )
	{
		`AILog(self@GetFuncName() @ "enemy too far" @ VSize(Corpser.Location - Enemy.Location) @ "units VS" @ EnemyDistance_Long);
		return FALSE;
	}

	// If we tried to attack an enemy and failed...
	if( ShouldAttemptTeleport() )
	{
		`AILog(self@GetFuncName() @ "no, needs to teleport");
		return FALSE;
	}

	return TRUE;
}

/** 
 *  Returns TRUE if we can consider destructibles to attack.
 **/
function bool CanConsiderDestructibles()
{
	// There must be at least one in this level...
	return GearGRI(WorldInfo.GRI).Destructibles.Length > 0;
}

/** 
 *  Setup Corpser to attack a destructible object. 
 *  See if one can be found, with a proper location for the Corpser.
 *  Teleports Corpser there and set ups reference to it, if successful. 
 **/
function bool SetupToAttackDestructible()
{
	local vector Destination;
	local GearDestructibleObject Destructible;

	if( !FindDestructibleToAttack(Destination, Destructible) )
	{
		`AILog(self@GetFuncName() @ "Could not find destructible to attack!!");
		return FALSE;
	}

	GearPawn_LocustCorpserLarvaUndergroundBase(Pawn).TargetDestructible = Destructible;
	// If we failed to hit the player, then teleport corpser to help
	// If we tried to attack an enemy and failed...
	if( ShouldAttemptTeleport() )
	{
		TeleportCorpser(Destination, Rotator(Destructible.Location-Pawn.Location));
	}
	return TRUE;
}

/** 
 *  Returns TRUE if we can consider fortifications to attack.
 **/
function bool CanConsiderFortifications()
{
	local GearGRI_Horde HordeGRI;

	// Right now only available in Horde. Make sure there is at least one around...
	HordeGRI = GearGRI_Horde(WorldInfo.GRI);
	if( HordeGRI != None && HordeGRI.Fortifications.Length > 0 )
	{
		return TRUE;
	}

	return FALSE;
}

/** 
 *  Setup Corpser to attack a fortification object. 
 *  See if one can be found, with a proper location for the Corpser.
 *  Teleports Corpser there and set ups reference to it, if successful. 
 **/
function bool SetupToAttackFortification()
{
	local vector Destination;
	local GearFortification Fortification;

	if( !FindFortificationToAttack(Destination, Fortification) )
	{
		`AILog(self@GetFuncName() @ "Could not find Fortification to attack!!");
		return FALSE;
	}

	GearPawn_LocustCorpserLarvaUndergroundBase(Pawn).TargetFortification = Fortification;
	// If we failed to hit the player, then teleport corpser to help
	if( ShouldAttemptTeleport() )
	{
		TeleportCorpser(Destination, Rotator(Fortification.Location-Pawn.Location));
	}
	return TRUE;
}

/** Try to attack either a destructible object or a fortification
 *  returns TRUE if successful
 **/
function bool AttackDestructibleOrFortification()
{
	if( CanConsiderFortifications() )
	{
		if( SetupToAttackFortification() )
		{
			GotoState('AttackingFortification');
			return TRUE;
		}
		else
		{
			`AILog(self@"FAILED to attack a Fortification.");
		}
	}
	// See if we can attack a destructible object near our enemies
	else if( CanConsiderDestructibles() )
	{
		if( SetupToAttackDestructible() )
		{
			GotoState('AttackingDestructible');
			return TRUE;
		}
		else
		{
			`AILog(self@"FAILED to attack a destructible.");
		}
	}

	return FALSE;
}

/** Roam and find an enemy to attack */
state UndergroundRoam
{
	function BeginState(Name PreviousStateName)
	{
		// Introduce artificial delay, so we don't start charging right away
		LastChargeTime = WorldInfo.TimeSeconds;
		Super.BeginState(PreviousStateName);
	}

	function Resumed( Name OldCommandName )
	{
		Super.Resumed(OldCommandName);

		if( Corpser.bIsUnderground )
		{
			`AILog(self@"resumed, and still underground, add a little artificial delay.");
			LastChargeTime = WorldInfo.TimeSeconds;
			GotoState('UndergroundRoam');
		}
	}

Begin:
	// Don't attack too quickly, want some time in between charges.
	if( `TimeSince(LastChargeTime) < Corpser.TimeBetweenUndergroundAttacks )
	{
		Corpser.PlayPreTunnelingSound();
		Sleep(Corpser.TimeBetweenUndergroundAttacks - `TimeSince(LastChargeTime));
	}
	FindSpotNumTries = -1;

Retry:
	FindSpotNumTries++;
	// Sleep if we just teleported
	if( `TimeSince(LastTeleportTime) < 1.f )
	{
		Corpser.PlayPreTunnelingSound();
		Sleep(Corpser.TimeBetweenUndergroundAttacks - `TimeSince(LastTeleportTime));
	}

	// Select enemy to attack
	if( !SelectEnemy() || !IsEnemyVisible(Enemy) )
	{
		`AILog(self@"Could not select enemy! force auto acquire");
		// Force finding an enemy
		AutoAcquireEnemy();
	}

	// Prioritize attacking enemies
	if( UndergroundCanAttackEnemy() )
	{
		// If we fail too much, just emerge from ground.
		// or if we have exceeded the number of attacks we can make, then we have to find a spot to emerge.
		// Placed here, because Corpser targets an enemy when trying to emerge.
		if( Corpser.bAllowedToEmerge && FindSpotNumTries >= 4 )
		{
			`AILog(self@"tried too many times, just emerge." @ FindSpotNumTries);
			GotoState('FindSpotToEmerge');
		}
		else if( Corpser.bAllowedToEmerge && Corpser.NumUndergroundAttackAttempts >= Corpser.NumUndergroundAttacksBeforeEmerging && Corpser.bUndergroundChargeReachedTarget )
		{
			`AILog(self@"done required number of attack, just emerge" @ Corpser.NumUndergroundAttackAttempts);
			GotoState('FindSpotToEmerge');
		}
		else
		{
			// We've found an enemy, attack!!
			`AILog(self@"Found an enemy and we're at a good distance, so attack!");
			GotoState('UndergroundAttack');
		}
	}
	else
	{
		// Sleep a little bit before doing performance intensive check
		Sleep(0.1f);
		if( FindDestinationFromEnemy() )
		{
			// Just teleported, try again. Delay handled in Retry because just teleported.
			`AILog(self@ "Teleported to try to attack enemy, retry");
			Goto('Retry');
		}
		else 
		{
			// Sleep a little bit before doing performance intensive check
			Sleep(0.1f);
			if( !AttackDestructibleOrFortification() )
			{
				`AILog(self@"AttackDestructibleOrFortification FAILED");
			}
		}
	}

	`AILog(self@ "Wasn't successful... retry");
	Sleep(0.25f);
	Goto('Retry');
}

state AttackingDestructible
{
Begin:
	// Don't attack too quickly, want some time in between charges.
	if( `TimeSince(LastTeleportTime) < 1.f )
	{
		Corpser.PlayPreTunnelingSound();
		Sleep(Corpser.TimeBetweenUndergroundAttacks - `TimeSince(LastTeleportTime));
	}

	if( !Corpser.IsValidDestructibleTarget(Corpser.TargetDestructible) )
	{
		`AILog(self@"I'm supposed to attack a non valid destructible object! Roam again!");
		Sleep(0.1f);
		GotoState('UndergroundRoam');
	}

	Corpser.NumUndergroundAttackAttempts++;
	if( Corpser.ChargeAtDestructible() )
	{
		`AILog(self@"Starting charge... throwing projectile");
		while( Corpser.IsCharging() )
		{
			Sleep(0.25f);
		}
		// Track when we last charged, so we can prevent charging too often.
		LastChargeTime = WorldInfo.TimeSeconds;
		`AILog(self@"Charge ended.");

		Sleep(0.1f);
	}
	else
	{
		`AILog(self@"Couldn't charge :( State:" @  Corpser.GetStateName() );
		Sleep(0.1f);
	}

	// Go back to roaming
	GoToRoamingState();
}

state AttackingFortification
{
Begin:
	// Don't attack too quickly, want some time in between charges.
	if( `TimeSince(LastTeleportTime) < 1.f )
	{
		Corpser.PlayPreTunnelingSound();
		Sleep(Corpser.TimeBetweenUndergroundAttacks - `TimeSince(LastTeleportTime));
	}

	if( !Corpser.IsValidFortificationTarget(Corpser.TargetFortification) )
	{
		`AILog(self@"I'm supposed to attack non valid fortification target! Roam again!");
		Sleep(0.1f);
		GotoState('UndergroundRoam');
	}

	Corpser.NumUndergroundAttackAttempts++;
	if( Corpser.ChargeAtFortification() )
	{
		`AILog(self@"Starting charge... throwing projectile");
		while( Corpser.IsCharging() )
		{
			Sleep(0.25f);
		}
		// Track when we last charged, so we can prevent charging too often.
		LastChargeTime = WorldInfo.TimeSeconds;
		`AILog(self@"Charge ended.");

		Sleep(0.1f);
	}
	else
	{
		`AILog(self@"Couldn't charge :( State:" @  Corpser.GetStateName() );
		Sleep(0.1f);
	}

	// Go back to roaming
	GoToRoamingState();
}

state UndergroundAttack
{
Begin:
	if( Enemy == None )
	{
		`AILog(self@"I'm supposed to attack, but I don't have an enemy. Roam again!");
		Sleep(0.25f);
		GotoState('UndergroundRoam');
	}

	Corpser.NumUndergroundAttackAttempts++;
	if( Corpser.ChargeAtEnemy(Enemy) )
	{
		`AILog(self@"Starting charge... throwing projectile");
		while( Corpser.IsCharging() )
		{
			Sleep(0.25f);
		}
		// Track when we last charged, so we can prevent charging too often.
		LastChargeTime = WorldInfo.TimeSeconds;
		`AILog(self@"Charge ended.");

		Sleep(0.1f);
	}
	else
	{
		`AILog(self@"Couldn't charge :( State:" @  Corpser.GetStateName() );
		Sleep(0.1f);
	}

	// Go back to roaming
	GoToRoamingState();
}

state FindSpotToEmerge
{
Begin:
	if( Enemy == None )
	{
		`AILog(self@"I'm supposed to emerge, but I don't have an enemy. Roam again!");
		Sleep(0.25f);
		GotoState('UndergroundRoam');
	}

	Corpser.NumUndergroundAttackAttempts++;
	if( Corpser.ChargeEmergeAt(Enemy) )
	{
		`AILog(self@"Starting charge to emerge... throwing projectile");
		while( Corpser.IsCharging() )
		{
			Sleep(0.25f);
		}
		
		// Track when we last charged, so we can prevent charging too often.
		LastChargeTime = WorldInfo.TimeSeconds;
		`AILog(self@"Charge ended.");

		// If emerging was successful, go to above ground roaming
		if( !Corpser.bIsUnderground )
		{
			GotoState('AboveGroundRoam');
		}

		`AILog(self@"failed to find a spot to emerge :( try again...");
		Sleep(0.1f);
	}
	else
	{
		`AILog(self@"Couldn't charge :( State:" @  Corpser.GetStateName() );
		Sleep(0.1f);
	}

	// Go back to roaming
	GoToRoamingState();
}

state AboveGroundRoam
{
	function Resumed( Name OldCommandName )
	{
		Super.Resumed(OldCommandName);

		// We might have been resumed from going underground, so check if our flag has changed.
		if( Corpser.bIsUnderground )
		{
			`AILog(self@"is now underground, switch states");
			GotoState('UndergroundRoam');
		}
	}

Begin:
	if( !SelectEnemy() )
	{
		// Force finding an enemy
		AutoAcquireEnemy();
	}

	if( Enemy == None )
	{
		Sleep(0.25f);
		Goto('Begin');
	}

	// If close enough to melee enemy
	if( (IsMeleeRange(Enemy.Location) && FastTrace(Enemy.Location, Pawn.Location)) || Pawn.ReachedDestination(Enemy) )
	{
		// SWING!
		if( CanEngageMelee() )
		{
			DoMeleeAttack();
			Sleep(2.0f);
		}
		else
		{
			Sleep(0.1f);
		}
	}
	else if ( CanMove() )
	{
		SetEnemyMoveGoal(TRUE, EnemyDistance_Melee);
	}
	else
	{
		Sleep(0.25f);
	}

	// Goto TOP!
	Goto( 'Begin' );
}

defaultproperties
{
}
