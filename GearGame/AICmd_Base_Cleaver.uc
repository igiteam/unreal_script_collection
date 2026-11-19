/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/* This Cmd is for generic cleaver-holding attackers. Will select target and run at them */

class AICmd_Base_Cleaver extends AICommand_Base_Combat
	within GearAI;

function Pushed()
{	
	Super.Pushed();

	bPreferMelee = TRUE;

	GotoState( 'InCombat' );
}

function Popped()
{
	Super.Popped();

	bPreferMelee = FALSE;
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
		
		// Claim all fire tickets so no one shoots while I'm in melee
		ClaimFireTicket( TRUE );

		// Attempt to melee them
		if( CanEngageMelee() )
		{
			DoMeleeAttack();
		}
		else
		{
			Sleep(0.1f);
		}

		// Release tickets
		ReleaseFireTicket();
	}
	else
	{
		bShouldRoadieRun = TRUE;

		`AILog("Not in weapon's melee range, move to enemy..."@VSize(MyGearPawn.Location - Enemy.Location)@MyGearPawn.GetAIMeleeAttackRange(), 'Combat');

		SetEnemyMoveGoal(TRUE,Enemy.GetCollisionRadius()*2,0,FALSE,TRUE);
	}

	// Goto TOP!
	Goto( 'Begin' );
}
