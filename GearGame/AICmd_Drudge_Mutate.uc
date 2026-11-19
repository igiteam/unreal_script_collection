/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Drudge_Mutate extends AICommand_SpecialMove
	within GearAI_LambentDrudge;

const MAX_MUTATION = 7;

var int TransformRequestFlag;

/** Simple constructor that pushes a new instance of the command for the AI */
static function bool Mutate( GearAI_LambentDrudge AI, optional INT TransformFlag )
{
	local AICmd_Drudge_Mutate Cmd;

	if( AI != None )
	{
		Cmd = new(AI) class'AICmd_Drudge_Mutate';
		if( Cmd != None )
		{
			Cmd.TransformRequestFlag = TransformFlag;
			AI.PushCommand( Cmd );
			return TRUE;
		}
	}

	return FALSE;
}

function bool AllowTransitionTo(class<GameAICommand> AttemptCommand )
{
	return FALSE;
}
function bool ShouldIgnoreTimeTransitions()
{
	return TRUE;
}

protected function bool InternalCanDoSpecialMove()
{
	local GearPawn_LambentDroneMutatable Drudge;
	Drudge = GearPawn_LambentDroneMutatable(Pawn);

	// Check if any mutations are possible
	if( Drudge != None )
	{
		return ( Drudge.CanMutateHead() || Drudge.CanMutateArms() || Drudge.CanMutateLegs() );
	}

	return FALSE;
}

/** GoW global macros */
function Pushed()
{
	local GearPawn_LambentDroneMutatable Drudge;

	Drudge = GearPawn_LambentDroneMutatable(MyGearPawn);

	Super.Pushed();

	InvalidateCover();

	bWantsLedgeCheck = TRUE;
	ReactionManager.SuppressAll();

	if (TransformRequestFlag == 0)
	{
		TransformRequestFlag = Drudge.ChooseMutations();
	}

	// which mutate
	if( TransformRequestFlag == 0 )
	{
		AbortCommand(self);
		BeginChargeAttack();
	}
	else
	{
		Status = 'Success';
		if( Drudge.IsLegMutation(TransformRequestFlag) )
		{
			AdjustRotationForMutation();
			GotoState( 'Command_SpecialMove' );
		}
		else if( Enemy != None )
		{
			GotoState( 'FaceEnemy' );
		}
		else
		{
			GotoState( 'Command_SpecialMove' );
		}

		Status = 'Success';
	}
}

function Popped()
{
	Super.Popped();
	bWantsLedgeCheck = FALSE;
	ReactionManager.UnSuppressAll();
	// Allow normal rotation again
	if (Pawn!=none)
	{
		Pawn.LockDesiredRotation(FALSE);
	}

	if( Status == 'Success' )
	{
		//LastSuccessfulKnockdownTime=WorldInfo.TimeSeconds;
		// do something?
		Mutated(TransformRequestFlag);
		InvalidateCover();
		AbortCommand(CommandList);
		BeginCombatCommand(class'AICmd_Base_LambentDrudge');
	}
}

function AdjustRotationForMutation()
{
	local vector TraceStartLoc, TraceEndLoc;

	TraceStartLoc = MyGearPawn.Location;
	TraceEndLoc = TraceStartLoc + 300.f * Vector(Rotation);

	//FlushPersistentDebugLines();

//	DrawDebugLine(TraceStartLoc, TraceEndLoc, 255, 0, 0, TRUE);
	if( NavigationHandle.ObstacleLineCheck(TraceStartLoc, TraceEndLoc, vect(20,20,20)) )
	{
		SetDesiredRotation(Rotation, true);
		return;
	}

	TraceEndLoc = TraceStartLoc + 300.f * Vector(Rotation + rot(0,-16384,0));
//	DrawDebugLine(TraceStartLoc, TraceEndLoc, 255, 0, 0, TRUE);
	if( NavigationHandle.ObstacleLineCheck(TraceStartLoc, TraceEndLoc, vect(20,20,20)) )
	{
		SetDesiredRotation(Rotation + rot(0,-16384,0), true, false, 0.5f);
		return;
	}

	TraceEndLoc = TraceStartLoc + 300.f * Vector(Rotation + rot(0,16384,0));
//	DrawDebugLine(TraceStartLoc, TraceEndLoc, 255, 0, 0, TRUE);
	if( NavigationHandle.ObstacleLineCheck(TraceStartLoc, TraceEndLoc, vect(20,20,20)) )
	{
		SetDesiredRotation(Rotation + rot(0,16384,0), true, false, 0.5f);
		return;
	}

	TraceEndLoc = TraceStartLoc + 300.f * Vector(Rotation + rot(0,32768,0));
//	DrawDebugLine(TraceStartLoc, TraceEndLoc, 255, 0, 0, TRUE);
	if( NavigationHandle.ObstacleLineCheck(TraceStartLoc, TraceEndLoc, vect(20,20,20)) )
	{
		SetDesiredRotation(Rotation + rot(0,32768,0), true, false, 0.5f);
		return;
	}
}

// SM state somehow faces to the other direction. I'm overriding it 
state FaceEnemy
{
Begin:
	SetDesiredRotation(Rotator(Enemy.Location - Pawn.Location));

	while(Pawn.ReachedDesiredRotation() == FALSE)
	{
		FinishRotation();
	}

	GotoState( 'Command_SpecialMove' );
};

state Command_SpecialMove
{
	function ESpecialMove GetSpecialMove()
	{
		return GSM_Drudge_Mutate;
	}

	function INT GetSpecialMoveFlags(ESpecialMove InSpecialMove)
	{
		if (InSpecialMove == GSM_Drudge_Mutate)
		{
			return TransformRequestFlag;
		}

		return 0;
	}

	function bool ShouldFinishRotation() { return TRUE; }

	function float GetPreSpecialMoveSleepTime()
	{
		local float delay;
		delay =RandRange(0,0.65); 
		//`log(delay);
		return delay;
	}
}

defaultproperties
{
	bShouldCheckSpecialMove=true
}
