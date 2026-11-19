/**
 * Base class for behavior of Jack
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class AICmd_Base_Jack extends AICommand_Base_Combat
	within GearAI_Jack;

function Pushed()
{
	Super.Pushed();
	Pawn.ZeroMovementVariables();

	GotoState('InCombat');
}

function Popped()
{
	Super.Popped();
	SetCloaking(false,,, 5.f);
}

function Resumed( Name OldCommandName )
{
	Super.Resumed( OldCommandName );

	Pawn.ZeroMovementVariables();
}

state InCombat
{
	function BeginState(name PreviousStateName)
	{
		Super.BeginState(PreviousStateName);
	}

	function EndState(name NextStateName)
	{
		Super.EndState(NextStateName);
	}

Begin: 
	//debug
	`AILog( "BEGIN TAG"@Jack.Weapon );

	PickIdleMoveLocation( TRUE );

	if( Jack.Weapon != None )
	{
		//debug
		`AILog( "Try to shoot..." );

		Pawn.ZeroMovementVariables();
		bFailedToFireFromOpen = TRUE;
		if( SelectTarget() && IsMediumRange(FireTarget.Location) )
		{
			FireFromOpen();
		}

		if( bFailedToFireFromOpen )
		{
			//debug
			`AILog( "Failed to shoot... force move to squad location" );

			PickIdleMoveLocation( TRUE, TRUE );
		}
		else
		{
			ReachedMoveGoal();
		}
	}
	else
	{
		SetCloaking(true,,, 5.f);
	}

	Sleep( 0.1f );
	Goto('Begin');
}

defaultproperties
{
}
