/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Move_Leap extends AICommand_SpecialMove
	within GearAI;

/** GoW global macros */

/** Start and End for the leap */
var JumpPoint	LeapStart;
var Actor LeapEnd;
var vector CachedVelocity;

/** Simple constructor that pushes a new instance of the command for the AI */
static function bool Leap( GearAI AI, JumpPoint Start, Actor End, vector InCachedVelocity )
{
	local AICmd_Move_Leap Cmd;

	if( AI		!= None && 
		Start	!= None &&
		End		!= None )
	{
		Cmd = new(AI) class'AICmd_Move_Leap';
		if( Cmd != None )
		{
			Cmd.LeapStart	= Start;
			Cmd.LeapEnd		= End;
			Cmd.CachedVelocity = InCachedVelocity;

			AI.PushCommand( Cmd );
			return TRUE;
		}
	}

	return FALSE;
}

/** Build debug string */
event String GetDumpString()
{
	return Super.GetDumpString()@"Start:"@LeapStart@"End:"@LeapEnd;
}

function Pushed()
{
	Super.Pushed();

	GotoState( 'Command_SpecialMove' );
}

function Popped()
{
	Super.Popped();

	bReevaluatePath = TRUE;
}

state Command_SpecialMove
{
	function BeginState( Name PreviousStateName )
	{
		Super.BeginState( PreviousStateName );

		SetDesiredRotation(rotator(LeapEnd.Location - Pawn.Location));
	}

	function bool DoLeap()
	{
		local Vector JumpVel;

		JumpVel = CachedVelocity;
		if( LeapEnd.Location.Z > LeapStart.Location.Z )
		{
			JumpVel.Z *= 1.07f;
		}

		//debug
		`AILog( GetFuncName()@CachedVelocity@"--"@JumpVel );

		Pawn.Velocity = JumpVel;
		Pawn.SetPhysics( PHYS_Falling );
		return TRUE;
	}

Begin:
	
	if( DoLeap() )
	{
		do
		{
			Sleep( 0.25f );
		} until( Pawn.Physics != PHYS_Falling );

		Status = 'Success';
		PopCommand( self );
		Stop;
	}
	
	GotoState( 'DelayFailure' );
}


defaultproperties
{
}