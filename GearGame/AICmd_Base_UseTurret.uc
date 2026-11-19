/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Base_UseTurret extends AICommand_Base_Combat
	within GearAI;

function bool AllowTransitionTo( class<GameAICommand> AttemptCommand )
{
	if( AttemptCommand == None )
	{
		return FALSE;
	}
	return Super.AllowTransitionTo( AttemptCommand );
}

function Pushed()
{
	Super.Pushed();
	ReactionManager.SuppressAllChannels();
	GotoState( 'InCombat' );
}

function Popped()
{
	Super.Popped();
	ReactionManager.UnSuppressAllChannels();
	StopFiring();
}

function bool HasValidTurret()
{
	return (CurrentTurret != None && CurrentTurret.Claim == Outer && (CurrentTurret.Driver == None || Pawn == CurrentTurret) );
}

final function bool IsAtTurret()
{
	return (CurrentTurret != None && Pawn == CurrentTurret);
}

state InCombat
{
	function BeginState( Name PreviousStateName )
	{
		Super.BeginState( PreviousStateName );

		// Reduce response time when on Troika
		Response_MinEnemySeenTime *= 0.5f;
		Response_MinEnemyHearTime *= 0.5f;

		InvalidateCover();
	}

	function EndState( Name NextStateName )
	{
		super.EndState( NextStateName );

		// Reset response time when leave Troika
		Response_MinEnemySeenTime /= 0.5f;
		Response_MinEnemyHearTime /= 0.5f;

		StopFiring();
	}

	function AdjustEnemyRating( out float out_Rating, Pawn EnemyPawn )
	{
		local Vector EnemyLoc;
		local Rotator RotToEnemy;

		if (CachedGearChildCommand != None)
		{
			CachedGearChildCommand.AdjustEnemyRating(out_Rating, Pawn);
			return;
		}

		if( CurrentTurret != None )
		{
			EnemyLoc = GetEnemyLocation( EnemyPawn );
			RotToEnemy = Rotator(EnemyLoc-CurrentTurret.GetPhysicalFireStartLoc( vect(0,0,0) ));
			if( CurrentTurret.TurretClampYaw( RotToEnemy ) )
			{
				// Severly cripple enemy selection if they are outside of the view
				out_Rating *= 0.01f;
			}
		}

		Super.AdjustEnemyRating( out_Rating, EnemyPawn );
	}
}

defaultproperties
{
}
