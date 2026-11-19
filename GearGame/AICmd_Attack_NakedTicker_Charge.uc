/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Attack_NakedTicker_Charge extends AICmd_Attack_Ticker_Charge
	within GearAI_Ticker;

static function bool InitCommandUserActor(GameAIController AI, Actor UserActor)
{
	local AICmd_Attack_Ticker_Charge Cmd;
	local GearAI_Ticker ChigAI;
	ChigAI = GearAI_Ticker(AI);
	if(ChigAI != none && UserActor != none)
	{
		Cmd = new(ChigAI) class'AICmd_Attack_NakedTicker_Charge';
		if(Cmd != none)
		{
			Cmd.ChargeActor = UserActor;
			AI.PushCommand(Cmd);
			return TRUE;
		}
	}

	return FALSE;
}

function Pushed()
{
	ReactionManager.SuppressChannel('NewEnemy');
	ReactionManager.SuppressChannel('SurpriseEnemyLoc');
	Super.Pushed();
}

function Popped()
{
	Super.Popped();
	ReactionManager.UnsuppressChannel('NewEnemy');
	ReactionManager.UnsuppressChannel('SurpriseEnemyLoc');
}

state Charge
{
Begin:
	SetEnemyMoveGoal(true, EnemyDistance_Melee);
	if(ChildStatus == 'Failure')
	{
		AbortCommand(self);
	}
	else if( Enemy != None )
	{
		if( IsShortRange(GetEnemyLocation()) )
		{
			DoMeleeAttack();
		}
		else
		{
			Goto('Begin');
		}
		PopCommand(self);
	}
}


defaultproperties
{
}