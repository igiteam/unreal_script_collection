/**
 * AI Matinee Mode logic - mostly just don't do anything else
 * This initiates GSM_Engage_Matinee, which actually handles the initial movement
 * to be at correct rotation/location
 * This makes sure AI does not try to do anything else during the time.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 **/

class AICmd_MatineeMode extends AICommand
	within GearAI;

/** vars not working yet */
//var bool bDamageInterruptable;
//var AIReactCond_DmgThreshold DmgThreshReaction;

var vector Destination;

/** Simple constructor that pushes a new instance of the command for the AI */
static function bool GotoCinematic( GearAI AI, bool InDamageInterruptable )
{
	local AICmd_MatineeMode Cmd;

	if( AI != None )
	{
		Cmd = new(AI) class'AICmd_MatineeMode';
		if( Cmd != None )
		{
			//Cmd.bDamageInterruptable = InDamageInterruptable;
			AI.PushCommand( Cmd );
			return TRUE;
		}
	}

	return FALSE;
}

function Pushed()
{
	Super.Pushed();

	InvalidateCover();
	StopFiring();
	Focus = None;

	bIgnoreStepAside=TRUE;

	// make sure the damage channel is unsuppressed
	ReactionManager.SuppressAllChannels();

	// This code didn't work. I need to look at it when I come back
	/*if (bDamageInterruptable)
	{
		// setup a new reaction to wait for 100 damage incoming
		DmgThreshReaction = new(outer) class'AIReactCond_DmgThreshold';
		DmgThreshReaction.OutputFunction = HitDamageThresh;
		DmgThreshReaction.DamageThreshold = 1;
		DmgThreshReaction.Initialize();
		ReactionManager.UnsuppressChannel('Damage');
	}*/

	GotoState( 'InCinematic' );
}

function Popped()
{
	Super.Popped();

/*	DmgThreshReaction.UnsubscribeAll();
	DmgThreshReaction = none;
*/
	bIgnoreStepAside=FALSE;
	ReactionManager.UnSuppressAllChannels();

	AIOwner.MyGearPawn.EndSpecialMove(SM_Engage_Matinee);

	if( Pawn != None )
	{
		Pawn.ZeroMovementVariables();
	}
}

function HitDamageThresh(Actor EventInstigator, AIReactChannel OrigChannel)
{
	AbortCommand(self);
}

function bool AllowTransitionTo( class<GameAICommand> AttemptCommand )
{
	return FALSE;
}

function bool IgnoreNotifies()
{
	return TRUE;
}

function bool ShouldIgnoreTimeTransitions()
{
	return TRUE;
}

// right now nothing else to do, need to clean up when I come back to work on this.
state InCinematic `DEBUGSTATE
{
	function CheckReached()
	{
		if (Reached())
		{
			ClearMovementInfo();
			ClearTimer('CheckReached', self);			
		}
	}
	function bool Reached()
	{
		if (MyGearPawn.EngageMatineeMode_Actor!=none)
		{
			return (VSizeSq2D(MyGearPawn.EngageMatineeMode_Actor.Location - MyGearPawn.Location) < 100.f);
		}

		return TRUE;
	}

	function bool GetClosestPoint( vector DestPos, out vector NewPoint )
	{
		local array<vector> ValidPos;

		// don't do it if flying - it doesn't use nav mesh
		if ( MyGearPawn.Physics != PHYS_Flying )
		{
			AIOwner.NavigationHandle.GetValidPositionsForBox(DestPos, 20.f, vect(20, 20, 20), FALSE, ValidPos, 1);
			if ( ValidPos.Length > 0 )
			{
				NewPoint = ValidPos[0];
				return TRUE;
			}
		}

		return FALSE;
	}
Begin:
	//debug
	`AIlog( "BEGIN TAG" @ MyGearPawn.IsDBNO(), 'State' );

	//if (Reached() == FALSE)
//	{
//		SetTimer(0.2f, TRUE, 'CheckReached', self);
		if ( GetClosestPoint(MyGearPawn.EngageMatineeMode_Actor.Location, Destination) )
		{
			SetMovePoint(Destination, MyGearPawn.EngageMatineeMode_Actor, FALSE, 30.f, FALSE, FALSE);
		}
	//	ClearTimer('CheckReached', self);			
//	}
	
	if ( MyGearPawn.EngageMatineeMode_Actor!=none && MyGearPawn.ReachTestForMatinee(MyGearPawn.EngageMatineeMode_Actor)==FALSE )
	{
		MyGearPawn.DoSpecialMove(SM_Engage_Matinee, TRUE);
	}
}

defaultproperties
{
	bAllowedToFireWeapon=FALSE
}
