/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/

class AIcmd_Base_SecurityBotFlying extends AICommand_Base_Combat
	within GearAI_SecurityBotFlying;

var Vector AttackLocation;

var GearPawn_LocustTempestBase TempestToAvoid;


function Pushed()
{
	Super.Pushed();
	GotoState('InCombat');
}

/** Make sure collision is restored if we get popped */
function Popped()
{
	Super.Popped();

	if (!Bot.bCollideActors && !Bot.bBlockActors)
	{
		`AILog("Restoring collision because we're leaving the AI command");
		Bot.SetCollision(TRUE, TRUE);
	}
}

/**
 * Make sure collision is on if we get paused
 * 
 * @param NewCommand - the new AI command
 */
function Paused(GameAICommand NewCommand)
{
	Super.Paused(NewCommand);

	if (!Bot.bCollideActors && !Bot.bBlockActors)
	{
		`AILog("Restoring collision because we're pausing the AI command");
		Bot.SetCollision(TRUE, TRUE);
	}
}

function Resumed( Name OldCommandName )
{
	Super.Resumed(OldCommandName);

	if( !IsFiringWeapon() )
	{
		DelayedStartFire();
	}
}

function bool TempestTooClose()
{
	// After 5 seconds, just turn collision on
	if (`TimeSince(Bot.SpawnTime) > 5.0)
	{
		return FALSE;
	}

	foreach WorldInfo.AllPawns(class'GearPawn_LocustTempestBase', TempestToAvoid, Bot.Location, 1000)
	{
		return true;
	}
	return false;
}

function vector ComputerTempestAvoidPosition()
{
	local vector AvoidanceVector;

	AvoidanceVector = Bot.Location - TempestToAvoid.Location;
	AvoidanceVector.Z = 0;
	AvoidanceVector = Normal(AvoidanceVector);
	AvoidanceVector = AvoidanceVector*200;
	return AvoidanceVector + Bot.Location;
}

state LostLOS
{

	function bool NotifyEnemyBecameVisible( Pawn VisibleEnemy )
	{
		GotoState('InCombat');
		return true;
	}

	/**
	 * Make sure collision is on if this state gets nuked
	 * 
	 * @param NextStateName - the name of the next state
	 */
	function EndState(Name NextStateName)
	{
		Super.EndState(NextStateName);
		
		if (!Bot.bCollideActors && !Bot.bBlockActors)
		{
			`AILog("Restoring collision because we're leaving the state");
			Bot.SetCollision(TRUE, TRUE);
		}
	}

Begin:
	if (TempestTooClose())
	{
		`AILog("Clearing collision due to tempest too close");
		Bot.SetCollision(FALSE, FALSE);
		MoveToDirectNonPathPos(ComputerTempestAvoidPosition());
		
		`AILog("Restoring collision");
		Bot.SetCollision(TRUE, TRUE);
		Goto('Begin');
	}
	MoveToDirectNonPathPos(Pawn.location);
	StopFiring();
	// wait around while we still have an enemy
	while(HasValidEnemy()&&!IsEnemyVisible(Enemy))
	{
		Sleep(0.5);
	}
	if(!HasValidEnemy())
	{
		GotoState('DelaySuccess');
	}
	else
	{
		GotoState('InCombat');
	}
	
};

state InCombat
{
	/**
	 * Make sure collision is on if this state gets nuked
	 * 
	 * @param NextStateName - the name of the next state
	 */
	function EndState(Name NextStateName)
	{
		Super.EndState(NextStateName);
		
		if (!Bot.bCollideActors && !Bot.bBlockActors)
		{
			`AILog("Restoring collision because we're leaving the state");
			Bot.SetCollision(TRUE, TRUE);
		}
	}

	function bool GetCirclePos( out Vector out_CirclePos )
	{
		local Vector GoPos, CircleOffset, CHeight;
		local Rotator CRot;
		local bool bFound;
		local Vector HitLocation, HitNormal;
		local Actor HitActor;
		local Vector2D HeightMinMax;
		local float HeightDelta;
		local int CircleDir;

		CircleDir = FRand() < 0.5f ? 1 : -1;
		CircleOffset = Normal(Pawn.Location - Enemy.Location) * RandRange( CirclingRadius.X, CirclingRadius.Y );
		CircleOffset.Z = 0;

		CRot.Yaw = CirclingStep;
		GoPos = Enemy.Location + (CircleOffset >> (CRot * CircleDir));
		bFound = NavigationHandle.PointReachable(GoPos);
		if( !bFound )
		{
			GoPos = Enemy.Location + (CircleOffset << (CRot * CircleDir));
			bFound = NavigationHandle.PointReachable(GoPos);
		}

		if( bFound )
		{
			HeightMinMax = CirclingHeight;

			CHeight.Z = CirclingHeight.Y;
			HitActor = Trace( HitLocation, HitNormal, GoPos + CHeight, GoPos, FALSE, Pawn.GetCollisionExtent() );

			if( HitActor != None )
			{
				HeightDelta = (HitLocation.Z - GoPos.Z) - 4.f;

				if( HeightDelta < HeightMinMax.X )
				{
					HeightMinMax.X = HeightDelta;
					HeightMinMax.Y = HeightDelta;
				}
				else
				{
					HeightMinMax.Y = FMin( HeightMinMax.Y, HeightDelta );
				}
			}

			CHeight.Z = FMax( RandRange( HeightMinMax.X, HeightMinMax.Y ), 0.f );
			GoPos.Z += CHeight.Z;

			out_CirclePos = GoPos;
		}
		
		return bFound;
	}

	function bool GetLateralPos( out Vector out_LateralPos )
	{
		local Vector VectToEnemy, X, Y, Z;
		local Vector GoPos;
		local bool bFound;
		
		VectToEnemy = Normal( Enemy.Location - Pawn.Location );
		GetAxes( Rotator(VectToEnemy), X, Y, Z );

		GoPos = Pawn.Location + Y * RandRange( 128.f, 512.f );
		bFound = NavigationHandle.PointReachable( GoPos );
		if( !bFound )
		{
			GoPos = Pawn.Location - Y * RandRange( 128.f, 512.f );
			bFound = NavigationHandle.PointReachable( GoPos );
		}

		if( bFound )
		{
			out_LateralPos = GoPos;
		}

		return bFound;
	}

	function bool GetNextAttackLocation( out Vector out_AttackLocation )
	{
		local Vector CirclePos;
		local Vector LateralPos;

		// Sometimes just sit still
		if( FRand() < 0.75f )
		{
			if( GetCirclePos(CirclePos) )
			{
				if( IsWithinCombatZone( CirclePos ) )
				{
					out_AttackLocation = CirclePos;
					return TRUE;
				}
			}

			if( GetLateralPos( LateralPos ) ) 
			{
				if( IsWithinCombatZone( LateralPos ) )
				{
					out_AttackLocation = LateralPos;
					return TRUE;
				}
			}
		}

		return FALSE;
	}

	function ChargeEnemy()
	{
		local Vector VectToTarg, ChargeLocation;

		Focus = None;
		StopFiring();

		// Update controller destination
		VectToTarg		 = Enemy.Location - Pawn.Location;
		VectToTarg.Z	 = 0;
		ChargeLocation	 = Pawn.Location + VectToTarg + 400.f * Normal(VectToTarg);

		class'AICmd_Attack_Sentry_Charge'.static.Charge(Outer, ChargeLocation);
	}
	
	function vector ComputeLaunchPosition()
	{
		local vector LaunchPosition;
		
		LaunchPosition = Bot.Location + vect(100, 0, 200);
		
		return LaunchPosition;
	}

Begin:

	if (TempestTooClose())
	{
		`AILog("Clearing collision due to tempest too close");
		Bot.SetCollision(FALSE, FALSE);
		MoveToDirectNonPathPos(ComputerTempestAvoidPosition());
		
		`AILog("Restoring collision");
		Bot.SetCollision(TRUE, TRUE);
		Goto('Begin');
	}
	
	if( !SelectEnemy() )
	{
		`AILog("Could not select enemy!");
		GotoState('DelayFailure');
	}

	Focus = Enemy;
	FinishRotation();
	Sleep(EnemyAcquiredGracePeriod);
	`AILog("sleeping"@EnemyAcquiredGracePeriod);
	
	if( !IsFiringWeapon() )
	{
		DelayedStartFire();
	}

	while( HasValidEnemy() && !IsReloading() )
	{
		if( !IsFiringWeapon() )
		{
			DelayedStartFire();
		}
		// if we're too far away, get closer
		if( !HasEnemyWithinDistance(EnemyDistance_Medium, Enemy, FALSE) && IsEnemyWithinCombatZone(Enemy) )
		{
			class'AICmd_Hover_MoveToGoal_Mesh'.static.HoverToGoal(Outer,Enemy,EnemyDistance_Medium,HoveringHeight);
		}

		// circle around
		if( GetNextAttackLocation( AttackLocation ) )
		{
			MoveToDirectNonPathPos( AttackLocation, Enemy, 100.f );
			Sleep(0.01);
		}
		else
		{
			Sleep( 0.5f );
		}
	}

	if( HasValidEnemy() )
	{
		ChargeEnemy();
	}
	else if( !IsEnemyVisible(Enemy) )
	{
		GotoState('LostLOS');
	}

	Goto('Begin');

};

defaultproperties
{
}


