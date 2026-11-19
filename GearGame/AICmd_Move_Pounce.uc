/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Move_Pounce extends AICommand_SpecialMove
	within GearAI;

/** Start and End for the leap */
var vector LeapStart;
var vector LeapEnd;

/** Flags to forward to the special move */
var int SpecialMoveFlags;

/** Simple constructor that pushes a new instance of the command for the AI */
static function bool Pounce( GearAI AI )
{
	local AICmd_Move_Pounce Cmd;

	if( AI != None )
	{
		Cmd = new(AI) class'AICmd_Move_Pounce';
		if( Cmd != None )
		{
			AI.PushCommand( Cmd );
			return TRUE;
		}
	}

	return FALSE;
}

function Pushed()
{
	Super.Pushed();
	GotoState( 'Command_SpecialMove' );
}

function Resumed( Name OldCommandName )
{
	Super.Resumed( OldCommandName );

	// If we reached the target successfully
	if( ChildStatus == 'Success' && Enemy != None )
	{	
		GotoState( 'Command_SpecialMove' );
	}
	else
	{
		// Otherwise, didn't get there so fail the command
		Status = 'Failure';
		PopCommand( self );
	}
}

function Popped()
{
	Super.Popped();

	bReevaluatePath = TRUE;

	// Allow normal rotation again
	if( Pawn != None )
	{
		UnlockAI();
	}
}

function vector CalcPounceVelocity()
{
	local vector JumpVelocity;
	local float JumpSpeed;

	LeapStart = MyGearPawn.Location;
	if( NavigationHandle.GetNextMoveLocation(LeapEnd, MyGearPawn.GetCollisionRadius()) )
	{
		if( VSizeSq(LeapEnd - LeapStart) > MyGearPawn.MaxPounceDistXY * MyGearPawn.MaxPounceDistXY )
		{
			LeapEnd = LeapStart + Normal(LeapEnd - LeapStart) * MyGearPawn.MaxPounceDistXY;
		}

// 		DrawDebugSphere(LeapStart, 20.f, 10, 0, 255, 0, TRUE);
//		DrawDebugSphere(LeapEnd, 20.f, 10, 255, 0, 0, TRUE);

		JumpSpeed = Sqrt(MyGearPawn.GroundSpeed * MyGearPawn.GroundSpeed + MyGearPawn.PounceZ * MyGearPawn.PounceZ);
		if( SuggestTossVelocity(JumpVelocity, LeapEnd, LeapStart, JumpSpeed, 0.0f, 0.0f) )
		{
			JumpVelocity.Z = FClamp(JumpVelocity.Z, MyGearPawn.MinJumpSpeedZ, MyGearPawn.PounceZ);
//			DrawDebugLine(LeapStart, LeapStart + JumpVelocity, 0, 0, 255, TRUE);
			return JumpVelocity;
		}
	}

	return vect(0,0,0);
}

state Command_SpecialMove
{
	function bool ExecuteSpecialMove()
	{
		local bool RetVal;
		local vector PounceVelocity;
		local GSM_LambentHuman_Pounce LeapMove;

		PounceVelocity = CalcPounceVelocity();
		if( VSizeSq(PounceVelocity) < 1.0f )
		{
			return false;
		}

		// Set SpecialMoveFlags. 
		// 0 for leap down, 1 for leap up
		if( LeapEnd.Z > LeapStart.Z )
		{
			SpecialMoveFlags = 1;
		}
		else
		{
			SpecialMoveFlags = 0;
		}

		RetVal = Super.ExecuteSpecialMove();
		if( RetVal )
		{
			SetDesiredRotation(Rotator(LeapEnd - LeapStart), TRUE);
			LockdownAI();
			LeapMove = GSM_LambentHuman_Pounce(MyGearPawn.SpecialMoves[SpecialMove]);
			if( LeapMove != None )
			{
				LeapMove.JumpVelocity = PounceVelocity;
			}
			else
			{
				MyGearPawn.Velocity = PounceVelocity;
			}
		}
		return RetVal;
	}

	function ESpecialMove GetSpecialMove()
	{
		return GSM_Former_Pounce;
	}

	function INT GetSpecialMoveFlags(ESpecialMove InSpecialMove)
	{
		if( InSpecialMove == GSM_Former_Pounce )
		{
			return SpecialMoveFlags;
		}
		return Super.GetSpecialMoveFlags(InSpecialMove);
	}

	function bool ShouldFinishRotation() { return TRUE; }
	function bool ShouldFinishPostRotation() { return TRUE; }
}
