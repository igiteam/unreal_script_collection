/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
 
 class AICmd_Attack_Sentry_Evade extends AICommand_SpecialMove
	within GearAI_SecurityBotFlying;
	
/** Location the Sentry should charge to */
var vector MoveLocation;
/** Air speed before the charge command started */
var float SavedAirSpeed;
var float SavedAccelRate;

static function Evade(GearAI_SecurityBotFlying AI, optional vector NewMoveLocation)
{
	local AICmd_Attack_Sentry_Evade Cmd;
	if (AI != None)
	{
		Cmd = new(AI) class'AICmd_Attack_Sentry_Evade';
		if (Cmd != None)
		{
			Cmd.MoveLocation = NewMoveLocation;
			AI.PushCommand(Cmd);
		}
	}
}

function Pushed()
{
	Super.Pushed();
	SavedAirSpeed = Pawn.AirSpeed;
	SavedAccelRate = Pawn.AccelRate;
	Pawn.AirSpeed = 1500;
	Pawn.AccelRate = 2000.f;
	GotoState('Command_SpecialMove');
}

function Popped()
{
	Super.Popped();
	Pawn.AirSpeed = SavedAirSpeed;
	Pawn.AccelRate = SavedAccelRate;
}

state Command_SpecialMove
{
	function ESpecialMove GetSpecialMove()
	{
		return SM_StumbleBackOutOfCover;
	}

Begin:

//debug
	`AILog( "--"@GetStateName()$":"$class@"-- BEGIN TAG", 'State' );

	if( !SetupSpecialMove() )
	{
		//debug
		`AILog( "Setup Special Move failed" );

		Goto( 'Abort' );
	}

	Sleep(GetPreSpecialMoveSleepTime());

	bForceReady = FALSE;
	SetTimer( GetFailSafeReadyTime(), FALSE, nameof(FailSafeReadyTriggered), self );
	while( !IsReady() && !bForceReady )
	{
		//debug
		`AILog( "Waiting for ready", 'Loop' );

		Sleep(0.1f);
	}
	ClearTimer( nameof(FailSafeReadyTriggered), self );

	if( ExecuteSpecialMove() )
	{
		GearPawn_SecurityBotFlyingBase(MyGearPawn).OnCharge();
		MoveToDirectNonPathPos(MoveLocation, Enemy, 64.f);

		SetTimer( TimeOutDelaySeconds, FALSE, nameof(self.SpecialMoveTimeOut), self );
		do
		{
			//debug
			`AILog( "Waiting for SM to end", 'Loop' );

			Sleep( 0.1f );
		} until( IsSpecialMoveComplete() );

		//debug
		`AILog( "Special move ended" );

		TerminationTime = WorldInfo.TimeSeconds + GetPostSpecialMoveSleepTime();
		while( TerminationTime > WorldInfo.TimeSeconds )
		{
			//debug
			`AILog( "Waiting for SM delay to end", 'Loop' );

			Sleep( 0.1f );
		}

		Status = 'Success';
	}
	else
	{
Abort:
		OnFailedToDoSpecialMove();
		Status = 'Failure';
		Sleep(0.5f);
	}

	PopCommand( self );
}

defaultproperties
{
}