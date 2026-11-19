/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Base_LambentDrudge extends AICommand_Base_Combat
	within GearAI_LambentDrudge;

/** GoW global macros */

/** Boomer has fired a shot from this location */
var bool bFiredFromHere;
var transient float LastTimeHeadFired;
var float AttackDistance;

function Pushed()
{
	Super.Pushed();

	Pawn.SetWalking(!bMutatedLegs);
	bTurtle=TRUE;
	GotoState( 'InCombat' );
}

function Resumed( Name OldCommandName )
{
	Super.Resumed( OldCommandName );

	Pawn.SetWalking(!bMutatedLegs);
	bShouldRoadieRun = FALSE;
}

function Popped()
{
	Super.Popped();

	bShouldRoadieRun = FALSE;
}

state InCombat
{
	function bool ShouldChangeCover()
	{
		return FALSE;
	}

	function BeginState(Name PreviousStateName)
	{
		InvalidateCover();
	}

	function bool ShouldFireFromHere()
	{
		local Vector EnemyLoc;

		// If we have a leg mutation, we are stuck in place
		if( Outer.bMutatedLegs )
		{
			return TRUE;
		}

		EnemyLoc = GetEnemyLocation();
		if( (!bFiredFromHere && IsMediumRange(EnemyLoc)) ||
			 IsShortRange(EnemyLoc) )
		{
			if( FailedPathToEnemyRecently(Enemy) || 
				CanFireAt(Enemy, Pawn.GetWeaponStartTraceLocation()) )
			{
				return TRUE;
			}
		}

		return FALSE;
	}

	function bool TurnOnHeadFire()
	{
		if ( bMutatedHead )
		{
			TryTurnOnHeadWormFire();

			if (DrudgePawn.bPlayHeadWormAnim)
			{
				LastTimeHeadFired = WorldInfo.TimeSeconds;
				return TRUE;
			}
		}

		return FALSE;
	}

	function TurnOffHeadFire()
	{
		if ( bMutatedHead )
		{
			// if head is mutated, it has been fired within last 15 seconds, pasue it
			// otherwise, give chance to fire since I don't want it to not fire for a while
			// FIXME: maybe in the future, we have angry fire - where it can't reach to target causing agony firing
			LastTimeHeadFired = WorldInfo.TimeSeconds;
			PauseHeadFire();
		}
	}

	function bool CanAttackHeadFire()
	{
		// if head is mutated and if within attack distance
		return (bMutatedHead && VSizeSq(Enemy.Location-Pawn.Location) < AttackDistance*AttackDistance);
	}

	function ShouldKeepMoving()
	{
		// if it can fire or if it hasn't been fired for a while, just let it fire
		if ( CanAttackHeadFire() ||  WorldInfo.TimeSeconds - LastTimeHeadFired > 15.f )
		{
			ClearMovementInfo();
			ClearTimer('ShouldKeepMoving', self);
			bFailedToMoveToEnemy = false;
		}
	}

Begin:
	//debug
	`AILog( "BEGIN TAG", 'State' );

	// select the best enemy
	SelectEnemy();
	FireTarget = Enemy;

	if (!HasValidEnemy())
	{
		//debug
		`AILog("No enemy");

		GearPawn_LambentDroneMutatable(Outer.Pawn).PlayFrustrationVocal();
		Sleep(1.f);
		Goto('Begin');
	}

	// If have not fired from here AND
	// Enemy is in medium and can fire at enemy
	if (bMutatedLegs)
	{
		if (CanEngageMelee())
		{
			// if it's outside of range return false;
			if (FireTarget!=none && VSizeSq(FireTarget.Location - Pawn.Location) < EnemyDistance_Melee*EnemyDistance_Melee)
			{
				DoMeleeAttack(Pawn(FireTarget));
			}
		}

		// Fire from open
		StartFiring(1);
		Sleep(1.f);
	}
	else
	{
		bFiredFromHere = FALSE;

		TurnOffHeadFire();

		// if it's more than 500 further, then try to move - otherwise just fire
		// don't go too close
		if (bMutatedHead && CanAttackHeadFire() == FALSE)
		{
			SetTimer(0.5f, TRUE, 'ShouldKeepMoving', self);
			// Move closer to them
			SetEnemyMoveGoal(FALSE, RandRange(500, 1000));
			ClearTimer('ShouldKeepMoving', self);
		}
		else if (!bMutatedHead && bMutatedArms)
		{
			SetEnemyMoveGoal(FALSE, RandRange(500, 1000));
		}

		// if i'm playing, just let it go a bit
		if ( TurnOnHeadFire() )
		{
			// while it's playing, let it go
			while (DrudgePawn.bPlayHeadWormAnim)
			{
				Sleep(0.2f);
			}
		}

		TurnOffHeadFire();

		// If failed to move to enemy, just fire weapon
		if( bFailedToMoveToEnemy )
		{
			//debug 
			`AILog("Failed to move to enemy... Try to step aside and fire");
			
			// if it's closer than fire distance, just let it fire - it's the best weapon he has
			// although it looks stupid firing at the wall, it's still intimidating
			if (bMutatedHead && CanAttackHeadFire() == FALSE)
			{
				GearPawn_LambentDroneMutatable(Outer.Pawn).PlayFrustrationVocal();

				SetTimer(0.5f, TRUE, 'ShouldKeepMoving', self);	
				StepAsideFor( Pawn );
				ClearTimer('ShouldKeepMoving', self);
			}

			Goto( 'Begin' );
		}

		// has it sleep just in case it skips all of the latent functions
		Sleep(0.2f);
	}

	Goto('Begin');
}

defaultproperties
{
	AttackDistance = 500
}
