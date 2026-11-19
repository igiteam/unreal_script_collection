/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class AICmd_Chicken_Attack extends AICommand
	within GearAI_Chicken;

static function bool Attack( GearAI_Chicken AI )
{
	local AICmd_Chicken_Attack Cmd;

	if( AI != None )
	{
		Cmd = new(AI) Default.Class;
		if( Cmd != None )
		{
			AI.PushCommand(Cmd);
			return TRUE;
		}
	}

	return FALSE;
}

function Pushed()
{
	Super.Pushed();
	GotoState('AttackEnemy');
}

state AttackEnemy `DEBUGSTATE
{
Begin:
	if( !IsMediumRange( GetEnemyLocation() ) )
	{
		SetEnemyMoveGoal( TRUE, EnemyDistance_Medium, EnemyDistance_Long, TRUE );
	}
	StartFiring();
	Sleep( 1.5f + FRand() * 1.5f );

	StopFiring();
	Sleep( 0.5f + FRand() * 1.f );

	Goto( 'Begin' );
}

defaultproperties
{
	bReplaceActiveSameClassInstance=TRUE
}
