/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Attack_Ticker_Melee extends AICommand_SpecialMove
	within GearAI_NakedTicker;

static function bool Melee( GearAI_NakedTicker AI, optional Actor InTarget )
{
	local AICmd_Attack_Ticker_Melee Cmd;

	if( AI != None )
	{
		Cmd = new(AI) default.class;
		if( Cmd != None )
		{
			if(InTarget != none)
			{
				AI.FireTarget = InTarget;
			}
			else
			{
				AI.FireTarget = AI.Enemy;
			}
			AI.PushCommand( Cmd );
			return TRUE;
		}
	}

	return FALSE;
}

function Pushed()
{
	Super.Pushed();

	ReactionManager.SuppressChannel('NewEnemy');
	ReactionManager.SuppressChannel('SurpriseEnemyLoc');
	bWantsLedgeCheck = TRUE;
	GotoState( 'Command_SpecialMove' );
}

function Popped()
{
	Super.Popped();
	bWantsLedgeCheck = FALSE;
	ReactionManager.UnsuppressChannel('NewEnemy');
	ReactionManager.UnsuppressChannel('SurpriseEnemyLoc');
}

function bool ShouldSelectTarget()
{
	// don't allow changing target in the middle of a melee attack on the current one
	return false;
}

state Command_SpecialMove
{
	function BeginState( Name PreviousStateName )
	{
		Super.BeginState( PreviousStateName );
		SetDesiredRotation(Rotator(FireTarget.Location - Pawn.Location));
		LockdownAI();
	}

	function ESpecialMove GetSpecialMove()
	{
		return GSM_SwipeAttack;
	}

	function bool ShouldFinishRotation() { return TRUE; }
}

defaultproperties
{
}
