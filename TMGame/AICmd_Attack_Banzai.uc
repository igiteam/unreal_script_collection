/**
* Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
*/

class AICmd_Attack_Banzai extends AICommand_Base_Combat
	within TGAI;

/** GoW global macros */

function static EveryoneAttack(WorldInfo WI, int TeamThatShouldAttack=1)
{
	local TGAI GAI;

	if(WI == none)
	{
		;
		return;
	}
	foreach WI.AllControllers(class'TGAI',GAI)
	{
		if(GAI != none && GAI.Pawn.GetTeamNum() == TeamThatShouldAttack)
		{
			if (GAI.CombatMood != AICM_Aggressive)
			{
				GAI.SetCombatMood(AICM_Aggressive);
			}

			// start up immediately if AI is out of range right now
			if (GAI.GetNearEnemyDistance(GAI.Pawn.Location) > GAI.EnemyDistance_Short)
			{
				;
				GAI.BanzaiAttack();
			}
		}
	}
}
static function bool Attack( TGAI AI )
{
	AI.InvalidateCover();
	AI.ClearMovementInfo(FALSE);
	AI.AutoAcquireEnemy();
	// ONLY add retriggers when this is added for the first time
	AddReTriggerReactions(AI);
	return Super.InitCommand(AI);
}

static function bool InitCommand(GameAIController TheAI)
{
    local TGAI AI;

    AI = TGAI(TheAI);
	if (AI.MyTGPawn != None && AI.MyTGPawn.CurrentLink != None)
	{
		AI.InvalidateCover();
		return false;
	}

	// don't push when ignoring notifies as the AI will get stuck with that command on the stack
	// and be unable to detect when the enemy actually gets in range
	if ( !AI.IgnoreNotifies() &&
		(AI.CommandList == None || (AI.CommandList.AllowTransitionTo(default.Class) && AICommand(AI.CommandList).IsAllowedToFireWeapon())) )
	{
		AI.ReactionManager.SuppressChannel('BanzaiOutOfRange');
		AI.ClearMovementInfo(FALSE);
		AI.AutoAcquireEnemy();

		return Super.InitCommand(AI);
	}
	else
	{
		return false;
	}
}

function Pushed()
{
	Super.Pushed();

	ReactionManager.SuppressChannel('BanzaiOutOfRange');
	GotoState( 'InCombat' );
}

function Popped()
{
	Super.Popped();
	StopFiring();

	ReactionManager.UnSuppressChannel('BanzaiOutOfRange');
	outer.CheckCombatTransition();
}


static final function AddReTriggerReactions(TGAI AI)
{
	local AIReactCond_GenericPushCommand CommandPusher;
	local AIReactCond_EnemyOutOfRange OutOfRangeConduit;

	if(!AI.bHasBanzaiReTriggers)
	{
		OutOfRangeConduit = new(AI) class'AIReactCond_EnemyOutOfRange';
		OutOfRangeConduit.Range = AI.EnemyDistance_Short;
		OutOfRangeConduit.OutputChannelName = 'BanzaiOutOfRange';
		OutOfRangeConduit.Initialize();

		CommandPusher = new(AI) class'AIReactCond_GenericPushCommand';
		CommandPusher.AutoSubscribeChannels.AddItem('BanzaiOutOfRange');
		CommandPusher.CommandClass = class'AICmd_Attack_Banzai';
		CommandPusher.Initialize();
		AI.bHasBanzaiReTriggers=true;
	}


}

/** called when we fail to charge because there's no path */
protected final function NotifyFailedPathToEnemy()
{
	local TGGameHorde_Base Game;
	local NavigationPoint NewStart;

	if (!Pawn.PlayerCanSeeMe() && (Enemy == None || !LineOfSightTo(Enemy)))
	{
		// if not Horde, so no enemy count giving away a suicide, just die
		Game = TGGameHorde_Base(WorldInfo.Game);
		if (Game == None)
		{
			;
			Pawn.Suicide();
		}
		else
		{
			// teleport to a new playerstart
			NewStart = Game.FindPlayerStart(None, 1);
			if (NewStart != None)
			{
				;
				Pawn.SetLocation(NewStart.Location);
				Pawn.SetRotation(NewStart.Rotation);
			}
		}
	}
}

state InCombat
{
Begin:
	if (!SelectEnemy())
	{
		AutoAcquireEnemy();
		;
	}
	else
	{
		StartFiring();
		bShouldRoadieRun = true;
		SetEnemyMoveGoal(true, FMin(VSize(Enemy.Location - Pawn.Location) * 0.75, EnemyDistance_Short));
		if ( ChildStatus == 'Success' )
		{
			if ( HasValidEnemy() && IsShortRange(Enemy.Location) &&
				Abs(Enemy.Location.Z - Pawn.Location.Z) < 256.0 && LineOfSightTo(Enemy) )
			{
				GotoState('DelaySuccess');
			}
		}
		else if (HasValidEnemy())
		{
			// try a bigger range
			Sleep(0.0); // so we make sure not to pathfind multiple times in a frame
			bShouldRoadieRun = true;
			SetEnemyMoveGoal(true, FMin(VSize(Enemy.Location - Pawn.Location) * 0.75, EnemyDistance_Medium));
			if ( ChildStatus == 'Success' )
			{
				if ( HasValidEnemy() && IsMediumRange(Enemy.Location) &&
					Abs(Enemy.Location.Z - Pawn.Location.Z) < 256.0 && LineOfSightTo(Enemy) )
				{
					GotoState('DelaySuccess');
				}
			}
			else
			{
				NotifyFailedPathToEnemy();
			}
		}
	}
	Sleep(1.0);
	Goto('Begin');
}


