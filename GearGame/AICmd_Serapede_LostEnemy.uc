//=============================================================================
// Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
//=============================================================================

class AICmd_Serapede_LostEnemy extends AICmd_Base_Serapede
	within GearAI_Serapede;

var AIReactCond_GenericCallDelegate SawEnemyReaction;

function Pushed()
{
	Super(AICommand).Pushed();
	Serapede.PlayShockSound();	
	SetupSawEnemyReaction();

	GotoState('GotoLKP');
}

function Paused(GameAICommand NewCommand)
{
	Super(AICommand).Paused(NewCommand);
	Serapede.SetRearUp(false);
}

function Resumed( Name OldCommandName )
{
	Super(AICommand).Resumed(OldCommandName);
}

function Popped()
{
	Super(AICommand).Popped();
	Serapede.SetRearUp(false);
	CleanupReaction();
}

function SetupSawEnemyReaction()
{
	SawEnemyReaction = new(outer) class'AIReactCond_GenericCallDelegate';
	SawEnemyReaction.AutoSubscribeChannels[0] = 'Sight';
	SawEnemyReaction.AutoSubscribeChannels[1] = 'Hearing';
	SawEnemyReaction.AutoSubscribeChannels[2] = 'Force';
	SawEnemyReaction.OutputFunction = SawEnemy;
	SawEnemyReaction.bAlwaysNotify=true;
	SawEnemyReaction.Initialize();
}

function CleanupReaction()
{
	SawEnemyReaction.UnsubscribeAll();
	SawEnemyReaction=none;
}

function SawEnemy(Actor EventInstigator, AIReactChannel OrigChannel)
{
	`AILog("SawEnemy: "@EventInstigator@"going back to chase");
	//do not pop out here if he's looking around, it looks bad when this guy keeps rearing up/down
	// if he's looking around, wait, it will transfer if enemy exists after rear down
	if (!IsInState('LookAround'))
	{
		PopCommand(self);
	}
}

// we don't want them to look around when there are enemies around. 
// do more checks before really sending to look around
// there is parent version of this, and both works different because this is another command
// this is where enemy is lost, so if you have enemy, you should pop out
function TryLookAround()
{
	// if enemy is visible, do not look around
	if ( IsEnemyVisible(Enemy) )
	{
		PopCommand(self);
	}
	// if any visible enemy around, try to find new target as hime
	else if ( IsAnyEnemyVisible() )
	{
		// select new target
		SetEnemy(none);
		SelectEnemy();
		PopCommand(self);
	}
	else
	{
		GotoState('LookAround');
	}
}

state GotoLKP `DEBUGSTATE
{

	function BeginState(Name PreviousStateName)
	{
		Super.BeginState(PreviousStateName);

	}

	function EndState(Name NextStateName)
	{
		Super.EndState(NextStateName);
	}
Begin:

	`AILog("lost track of enemy, going to last seen position.");
	SetMovePoint(GetEnemyLocation(,LT_InterpVisibility)+vect(0,0,-70),,,256);
	if(ChildStatus!='Success')
	{
		Sleep(0.5);
		// if failed, just pop out
		PopCommand(self);
	}

	TryLookAround();
};

state LookAround
{
	function GotoNextState()
	{
		`AILog("Did not find any enemies.. picking a new one");
		// if has visible enemy, just pop out
		if( HasValidEnemy() && IsEnemyVisible(Enemy) )
		{
			PopCommand(self);
		}
		else
		{
			// otherwise, find new target
			SetEnemy(none);
			PopCommand(self);
		}
	}
}

defaultproperties
{
}



