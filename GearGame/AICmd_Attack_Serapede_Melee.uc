/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Attack_Serapede_Melee extends AICommand_SpecialMove
	within GearAI_Serapede;

var Actor MeleeTarget;

/** Simple constructor that pushes a new instance of the command for the AI */
static function bool Melee(GearAI_Serapede AI, optional Actor InTarget)
{
	local AICmd_Attack_Serapede_Melee Cmd;

	if (AI != None)
	{
		Cmd = new(AI) default.class;
		if (InTarget != None)
		{
			Cmd.MeleeTarget = InTarget;
		}
		else
		{
			Cmd.MeleeTarget = AI.Enemy;
		}
		AI.PushCommand(Cmd);
		return true;
	}

	return false;
}

function Pushed()
{
	Super.Pushed();
	GotoState('Command_SpecialMove');
}

state Command_SpecialMove
{
	function BeginState( Name PreviousStateName )
	{
		local vector Dir;
		Super.BeginState( PreviousStateName );

		Dir = MeleeTarget.Location - Pawn.Location;
		Dir.Z = 0;
		SetDesiredRotation(rotator(Dir));

		bDoingMeleeAttack = true;
	}

	function FinishedSpecialMove()
	{
		bDoingMeleeAttack = false;
		Super.FinishedSpecialMove();
	}

	function ESpecialMove GetSpecialMove()
	{
		return SM_Serapede_Attack;
	}

	function bool IsSpecialMoveComplete()
	{
		// our MoveToward() calls will overwrite bPreparingMove so don't check it
		return (MyGearPawn == None || MyGearPawn.SpecialMove == SM_None);
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

	if (ShouldFinishRotation() && !Pawn.ReachedDesiredRotation())
	{
		FinishRotation();
	}

	while( !IsReady() )
	{
		//debug
		`AILog( "Waiting for ready", 'Loop' );

		Sleep(0.1f);
	}

	if( ExecuteSpecialMove() )
	{
		bPreparingMove=false;

		SetTimer( TimeOutDelaySeconds, FALSE, nameof(self.SpecialMoveTimeOut), self );
		do
		{
			//debug
			`AILog( "Waiting for SM to end", 'Loop' );

			MoveToward(MeleeTarget);

			Sleep(0.1);
		} until( IsSpecialMoveComplete() );

		//debug
		`AILog( "Special move ended" );

		if( ShouldFinishPostRotation() )
		{
			FinishRotation();
		}

		FinishedSpecialMove();

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
		//debug
		`AILog( "Failed to do special move" );

		Status = 'Failure';
		Sleep(0.5f);
	}

	PopCommand( self );
}

defaultproperties
{
}

