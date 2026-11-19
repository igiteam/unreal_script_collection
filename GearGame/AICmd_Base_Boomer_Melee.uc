/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Base_Boomer_Melee extends AICommand_Base_Combat
	within GearAI_Boomer_Melee;


/** Used to detect transition to roadie run. */
var bool bLastShouldRoadieRun;

function Pushed()
{
	Super.Pushed();

	GotoState( 'InCombat' );
}

function Resumed( Name OldCommandName )
{
	Super.Resumed( OldCommandName );
	bShouldRoadieRun = FALSE;
}

function Popped()
{
	Super.Popped();

	bShouldRoadieRun = FALSE;
}

final function float GetChargeAbortDistance()
{
	if( bShouldRoadieRun )
	{
		return EnemyDistance_Short * 1.1f;
	}

	return 0.f;
}

auto state InCombat
{
Begin:
	// Select Enemy
	if( !SelectEnemy() )
	{
		//debug
		`AILog( "Failed to select an enemy -- delay failure" );

		GotoState( 'DelayFailure' );
	}

	// make sure stale value doesn't cause AI to think it reached enemy when it didn't
	Pawn.DestinationOffset = 0.0;

	//debug
	`AILog( "BEGIN TAG"@IsMeleeRange(Enemy.Location)@Pawn.ReachedDestination(Enemy)@CanEngageMelee()@VSize(Enemy.Location-Pawn.Location) );


	// If close enough to melee enemy
	if ((IsMeleeRange(Enemy.Location) && IsValidMeleeTarget(GearPawn(Enemy))) || Pawn.ReachedDestination(Enemy))
	{
		Focus = GearPawn(Enemy);
		
		if( CanEngageMelee() )
		{
			DoMeleeAttack();
		}
		else
		{
			Sleep(0.1f);
		}
	}
	else
	{
		bShouldRoadieRun = ShouldCharge();		
		if (bShouldRoadieRun && !bLastShouldRoadieRun)
		{
			MyGearPawn.TelegraphCharge();
		}
		bLastShouldRoadieRun = bShouldRoadieRun;

		SetEnemyMoveGoal(TRUE,0.0f,GetChargeAbortDistance(),FALSE,TRUE);
	}

	// Goto TOP!
	Goto( 'Begin' );
}
