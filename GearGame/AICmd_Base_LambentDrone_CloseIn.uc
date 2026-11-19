/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Base_LambentDrone_CloseIn extends AICommand_Base_Combat
	within GearAI_LambentDrone;

var AIReactCond_EnemyCloseAndVisible EnemyCloseNuff;

var transient float NextScreamTime;
var transient float OldGroundSpeed;

function Pushed()
{
	Super.Pushed();
	bTurtle=true;

	EnemyCloseNuff = new(outer) class'AIReactCond_EnemyCloseAndVisible';
	EnemyCloseNuff.DistanceThreshold = ClosingDistance;
	EnemyCloseNuff.OutputFunction = EnemyCloseEnough;
	EnemyCloseNuff.AutoSubscribeChannels.AddItem('Hearing');
	EnemyCloseNuff.bAlwaysNotify=true;
	EnemyCloseNuff.Initialize();

	OldGroundSpeed = Pawn.GroundSpeed;
	Pawn.GroundSpeed*=ClosingSpeedModifier;

}

function Popped()
{
	Super.Popped();
	if( EnemyCloseNuff != none)
	{
		EnemyCloseNuff.UnsubscribeAll();
		EnemyCloseNuff = none;
	}

	if( Pawn != None )
	{
		Pawn.GroundSpeed = OldGroundSpeed;
	}
	else
	{
		`warn("AICmd_Base_LambentDrone_CloseIn popped with Pawn == None");
		ScriptTrace();
	}
}

function EnemyCloseEnough(Actor EventInstigator, AIReactChannel Channel)
{
	`AILog("we have an enemy close enough now, bailing from our close-in");
	AbortCommand(self);
}

auto state InCombat
{
Begin:
	//debug
	`AILog( "BEGIN TAG", 'State' );
	StartFiring();
	SetEnemyMoveGoal();
	if(!HasAnyEnemies())
	{
		`AILog("Have no enemies to close on! aborting");
		AbortCommand(self);
	}
	Sleep(1.f);
	Goto('Begin');
}


defaultproperties
{
}
