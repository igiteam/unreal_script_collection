/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Attack_Serapede_Charge extends AICommand_Base_Combat
	within GearAI_Serapede;


static function Charge(GearAI_Serapede AI, Pawn ChargeEnemy)
{
	local AICmd_Attack_Serapede_Charge Cmd;
	if (AI != None)
	{
		Cmd = new(AI) class'AICmd_Attack_Serapede_Charge';
		if (Cmd != None)
		{
			AI.SetEnemy(ChargeEnemy);
			AI.PushCommand(Cmd);
		}
	}
	//DrawDebugLine(AI.MyGearPawn.Location, NewMoveLocation, 255, 0, 0, true);
}

function Pushed()
{
	Super.Pushed();
	GotoState('DoCharge');
}

function Popped()
{
	Super.Popped();
}


state DoCharge
{
	simulated function BeginState( Name PreviousStateName )
	{
		Super.BeginState( PreviousStateName );
	}

Begin:
	Serapede.PlayChargingEnemy();
	

	if(!HasValidEnemy())
	{
		`AILog("no valid enenmy, popping");
		AbortCommand(self);
	}
	else if(VSizeSq(Enemy.Location-Pawn.Location) > EnemyDistance_Melee*EnemyDistance_Melee)
	{
		`AILog("not in range of enemy, moving closer");
		SetEnemyMoveGoal(true);	
	}
	else
	{
		`AILog("IN range, waiting..");
		Sleep(0.1f);
	}

	Goto('Begin');
}


defaultproperties
{
}
