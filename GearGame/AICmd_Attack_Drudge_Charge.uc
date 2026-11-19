/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Attack_Drudge_Charge extends AICommand_Base_Combat
	within GearAI_LambentDrone
	config(AI);

/** GoW global macros */

var() config float ExplosionRadius;
var transient float StartChargeTime;

function bool CheckTransition( out class<AICommand> out_NewCommand, out String out_Reason )
{
	return FALSE;
}

function bool AllowTransitionTo( class<GameAICommand> AttemptCommand )
{
	return FALSE;
}

function Pushed()
{
	local Actor Target;

	Super.Pushed();

	InvalidateCover();

	if( ChargeTarget != None )
	{
		Target = ChargeTarget;
	}
	else
	{
		// selecte new enemy - refresh if anybody else is closer
		SelectEnemy();
		if( Enemy == None )
		{
			GotoState('DelayFailure');
			return;
		}
		Target = Enemy;
	}

	// boost health back
	if( MyGearPawn.WorldInfo.NetMode != NM_Client )
	{
		if( bUnlimitedHealthCharge )
		{
			MyGearPawn.bUnlimitedHealth = true;
		}
		else
		{
			MyGearPawn.Health = GearPawn_LambentDroneBase(MyGearPawn).BeginChargeHealth;
		}
	}
 
	if( MaxChargingTime < 0.1f )
	{
		MaxChargingTime = RandRange(2.0,2.5); 
	}

	SetDesiredRotation(Rotator(Target.Location - Pawn.Location));
	bWantsLedgeCheck = TRUE;
	ReactionManager.SuppressAll();
	GotoState( 'Charge' );
}

function Popped()
{
	Super.Popped();
	bWantsLedgeCheck = FALSE;
	MyGearPawn.GroundSpeed=MyGearPawn.DefaultGroundSpeed;

	// Allow normal rotation again
	if (Pawn!=none)
	{
		Pawn.LockDesiredRotation(FALSE);
	}
	ClearTimer(nameof(Explode),self);
}

function Explode()
{
	// explode now
	BeginCombatCommand(class'AICmd_Attack_Drudge_Explode', "Party Time", TRUE);
	PopCommand(self);
}

state Charge
{

	function float GetMaxPossibleDist()
	{
		local float Max;
		Max = 2.75f*MaxChargingTime*class'GSM_LambentDrone_Charge'.default.MaxSpeed;
		`AILog(GetFUncName()@`showvar(Max));
		return Max;
	}

	function bool IsTargetChargeAble(Actor CheckTarget)
	{
		local float DirectDistToEnemySq,MaxDist;

		MaxDist = GetMaxPossibleDist();
		DirectDistToEnemySq = VSizeSq(CheckTarget.Location - MyGearPawn.Location);
	
		if ( DirectDistToEnemySq < MaxDist*MaxDist && (NavigationHandle.ActorReachable( CheckTarget ) || GeneratePathTo(CheckTarget, ExplosionRadius)) )
		{
			// if we couldn't possible get anywhere close to the enemy before blowing up, don't bother
			if( NavigationHandle.CalculatePathDistance(CheckTarget.Location) < MaxDist)
			{	
				return true;
			}
		}

		return false;
	}

	function Pawn FindChargeAbleEnemy()
	{
		local Pawn PE;

		`AILog(GetFuncName());

		// first check our current enemy
		if( Enemy != None )
		{
			if( IsTargetChargeAble(Enemy) )
			{
				`AILOg("Charging My old enemy:"@Enemy);
				return Enemy;
			}
		}

		// otherwise find someone else who is in charge range
		foreach Squad.AllEnemies(class'Pawn', PE)
		{
			if(PE != Enemy && IsTargetChargeAble(PE))
			{
				`AILog("Charging new enemy:"@PE);
				return PE;
			}
		}

		return none;
		
	}

Begin:
	if( ChargeTarget == None || !IsTargetChargeAble(ChargeTarget) )
	{
		ChargeTarget = None;
		SetEnemy(FindChargeAbleEnemy());
		SetDesiredRotation(Rotator(Enemy.Location - Pawn.Location));
		FinishRotation();
	}

	// throw out weapon first before running
	Pawn.ThrowActiveWeapon();

	// do PreCharge
	MyGearPawn.DoSpecialMove(GSM_Drudge_PreCharge, TRUE);

	// Wait until pre charge animation is done
	while( MyGearPawn.IsDoingSpecialMove(GSM_Drudge_PreCharge) )
	{
		Sleep(0.1f);
	}

	bShouldRoadieRun = TRUE;
	StartChargeTime = WorldInfo.TimeSeconds;
	SetTimer(MaxChargingTime,false,nameof(Explode),self);

MoveToEnemy:

	if ( `TimeSince(StartChargeTime) <  MaxChargingTime )
	{
		if( ChargeTarget != None )
		{
			TargetAquisitionTime=WorldInfo.TimeSeconds+100;
			SetMoveGoal(ChargeTarget, ChargeTarget, false, EnemyDistance_Melee,,,,false);

			if( ChargeTarget != none && VSizeSq(ChargeTarget.Location - MyGearPawn.Location) > (ExplosionRadius+100) * (ExplosionRadius+100))
			{
				Goto('MoveToEnemy');
			}
		}
		else if( Enemy != None && IsEnemyWithinCombatZone(Enemy) )
		{
			TargetAquisitionTime=WorldInfo.TimeSeconds+100;
			if(Enemy != none)
			{
				SetEnemyMoveGoal(TRUE, ExplosionRadius);	

				if(ChildStatus != 'Success')
				{
					Sleep(0.5);
				}

				if(Enemy != none && VSizeSq(Enemy.Location - MyGearPawn.Location) > (ExplosionRadius+100) * (ExplosionRadius+100))
				{
					Goto('MoveToEnemy');
				}
			}		
			else
			{
				`AILog(GetFuncName()@"No enemies are chargeable!");
			}
		}
	}
	Explode();
}


defaultproperties
{
}