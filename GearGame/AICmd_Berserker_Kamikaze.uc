/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Berserker_Kamikaze extends AIcmd_Base_UtilActionSelector
	within GearAI_BerserkerBase;

var transient INT Tries;

/**
 * this function will be called to evaluate whether or not this command should be activated 
 * @param ActivationData - the meta data packet for this command activation history, etc..
 * @return - float indicating the utility value of activation this action right now (-1 means not suitable to activate)
 */
static function float EvaluateActivation(GearAI AI, UtilBasedAICmdMetaDataPacket ActivationData)
{
	local GearPawn EnemyGP;

	EnemyGP = GearPawn(AI.Enemy);
	// If we have an enemy and that enemy is within reach
	if (EnemyGP != None &&
		(EnemyGP.Health > 0 ||
		 ((AI.Squad == None ||
		   !AI.Squad.IsTryingToExecute(EnemyGP)) &&
		  AI.CanExecutePawn(EnemyGP))) &&
		class'GearAI_BerserkerBase'.static.ChargeLocationReachable(AI, EnemyGP.Location))
	{
		// Randomness added so that she'll jump sometimes even when she could've charged
		return 1.0f - (FRand() * 0.15f);
	}

	return -1.0f;
}

/** Overloaded to go to the state we need it in */
function Pushed()
{
	Super.Pushed();
	SetChargeLocation(Enemy, Enemy.Location);
	GotoState('InCombat');
}

auto state InCombat
{
	function BeginState( Name PreviousStateName )
	{
		super.BeginState( PreviousStateName );
		if( MyGearPawn != None )
		{
			MyGearPawn.DoSpecialMove(SM_Berserker_Alert,TRUE);
		}
	}

	function ContinuedState()
	{
		super.ContinuedState();
		if( MyGearPawn != None )
		{
			MyGearPawn.DoSpecialMove(SM_Berserker_Alert,TRUE);
		}
	}

	function EndState( Name NextStateName )
	{
		super.EndState( NextStateName );
		if( MyGearPawn != None )
		{
			MyGearPawn.EndSpecialMove();
		}

		CheckCombatTransition();
	}

	function MoveToChargeLocation()
	{
		//debug
 		`AILog( GetFuncName()@ChargeLocation@ChargeActor@ChargePivot );
	
		// path to charge pivot
		if(!NavigationHandle.PointReachable(ChargePivot))
		{
			if(!GeneratePathToLocation(ChargePivot))
			{
				`AILog(GetFuncName()@"MoveToChargeLocation could not path to charge location.. :(");
				return;
			}
			// clip off parts of the path that can be directly charged through
			AdjustPathCacheForCharge(ChargePivot);
			//Pawn.DrawDebugLine(Pawn.Location,ChargePivot,255,0,0,TRUE);

			FireTarget = None;
			if(NavigationHandle.GetPathCacheLength() > 0)
			{
				`AILog(GetFuncName()@"Clipped path for charging, moving to "@NavigationHandle.PathCache_GetGoalPoint());
				SetMovePoint( NavigationHandle.PathCache_GetGoalPoint() );
			}
			else
			{
				SetMovePoint(ChargePivot);
			}
		}
		else
		{
			SetMovePoint(ChargePivot);
		}

	}

Begin:
	Tries = 0;

Retry:
	//debug
	`AILog( "BEGIN TAG"@bDirectCharge, 'State' );

	// If charge target directly reachable
	if( bDirectCharge || class'GearAI_BerserkerBase'.static.ChargeLocationReachable(Outer, ChargePivot ) )
	{
		// CHARGE!!!
		Tries = 0;
		LastKamikazeTarget = Enemy;
		class'AICmd_Attack_BerserkerCharge'.static.InitCommand(Outer);
	}
	else
	{
		// Otherwise, move along path to a point that target is reachable
		MoveToChargeLocation();

		// If reached point on path
		if( bReachedMoveGoal )
		{
			// debug
			`AILog( "Reached move goal, check for charge again" );

			Sleep(0.1);

			// Try to charge again
			if( Tries < 3 )
			{
				Tries++;
				Goto( 'Retry' );
			}
		}
		else
		{
			//debug
			`AILog( "Failed to path toward charge target"@ChargeActor@ChargeLocation@Pawn.Anchor );
		}
	}

	// if nothing happened
	PopCommand(self);
}
