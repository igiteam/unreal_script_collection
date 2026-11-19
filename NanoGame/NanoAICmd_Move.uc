/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoAICmd_Move extends NanoAICmd;

var transient vector MoveLocation;
var transient Actor MoveActor;
var transient Actor InternalMoveTarget;
var transient bool bFaceFocus;
var transient float PausedExpirationTimer;

var transient SeqAct_AIMoveToActor MoveAction;

var transient float MaxMoveTime;

static final function MoveTo(GameAIController AI, optional vector NewMoveLocation, optional Actor NewMoveActor, optional float InMaxMoveTime, optional bool NewbFaceFocus = TRUE)
{
	local NanoAICmd_Move MoveCmd;
	if (AI != None)
	{
		MoveCmd = new(AI) class'NanoAICmd_Move';
		if (MoveCmd != None)
		{
			// copy destination
			MoveCmd.MoveLocation = NewMoveLocation;
			MoveCmd.MoveActor = NewMoveActor;
			if (NewMoveActor != None && IsZero(NewMoveLocation))
			{
				MoveCmd.MoveLocation = NewMoveActor.Location;
			}
			MoveCmd.bFaceFocus = NewbFaceFocus;
			// push the command
			AI.PushCommand(MoveCmd);
			if (InMaxMoveTime > 0.f)
			{
				MoveCmd.MaxMoveTime = InMaxMoveTime;
				AI.SetTimer(MoveCmd.MaxMoveTime,FALSE,nameof(MoveCmd.MoveExpired),MoveCmd);
			}
		}
	}
}

static final function KismetMoveTo(GameAIController AI, SeqAct_AIMoveToActor Action)
{
	local NanoAICmd_Move MoveCmd;
	local Actor DestActor;
	if (AI != None)
	{
		DestActor = Action.PickDestination(AI.Pawn);
		if( DestActor != None )
		{
			if( Route(DestActor) != None )
			{
				class'NanoAICmd_MoveToRoute'.static.MoveToRoute( NanoAI(AI), Route(DestActor),, Action.bInterruptable );
			}
			else
			{
				MoveCmd = new(AI) class'NanoAICmd_Move';
				if (MoveCmd != None)
				{
					MoveCmd.MoveAction = Action;
					MoveCmd.MoveActor  = DestActor;
					AI.PushCommand(MoveCmd);
				}
			}
		}
	}
}

function bool HandleBump(Actor Other, Vector HitNormal)
{
	if (Other == MoveActor)
	{
		`AILog("Bumped into move actor");
		Status = 'Success';
		PopCommand(self);
		if (Pawn != None)
		{
			Pawn.Acceleration = vect(0,0,0);
		}
		return TRUE;
	}
	return FALSE;
}

function MoveExpired()
{
	`AILog(`location);
	if (Pawn != None)
	{
		Pawn.Acceleration = vect(0,0,0);
	}
	Status = 'Failure';
	AbortCommand(self);
}

function Paused(GameAICommand NewCommand)
{
	if (NanoAICmd_Move(NewCommand) == None)
	{
		PausedExpirationTimer = GetTimerCount(nameof(MoveExpired),self);
		ClearTimer(nameof(MoveExpired),self);
	}
	Super.Paused(NewCommand);
}

function Resumed(Name OldCommandName)
{
	if (PausedExpirationTimer > 0.f)
	{
		SetTimer(PausedExpirationTimer,FALSE,nameof(MoveExpired),self);
		PausedExpirationTimer = 0.f;
	}
	Super.Resumed(OldCommandName);
}

function Popped()
{
	`AILog(`location@`showvar(Status));
	if (Status != 'Success' && Pawn != None)
	{
		Pawn.Acceleration = vect(0,0,0);
		if (MoveAction != None)
		{
			MoveAction.ActivateOutputLink(1);
		}
	}
	else
	{
		if (MoveAction != None)
		{
			MoveAction.ActivateOutputLink(0);
		}
	}

	Pawn.bCanJump = Pawn.default.bCanJump;
	ClearTimer(nameof(MoveExpired),self);
}

function Pushed()
{
	`AILog(`location@`showvar(MoveActor)@`showvar(MoveLocation));
	//DrawDebugCoordinateSystem( MoveLocation, rot(0,0,0), 50.0f, TRUE );
	if (MoveActor != None)
	{
		GotoState('MoveTowardActor');
	}
	else
	{
		GotoState('MoveTowardLocation');
	}
}

state BaseMove
{
}

state MoveTowardLocation extends BaseMove
{
Begin:
	bAIBroken = FALSE;

	if (!bFaceFocus)
	{
		Focus = None;
		SetFocalPoint(MoveLocation);
	}

	if (Pawn.ReachedPoint(MoveLocation,Pawn.Anchor))
	{
		`AILog("Reached point");
		Status = 'Success';
		PopCommand(self);
	}
	else
	if ( NavigationHandle.PointReachable(MoveLocation))
	{
		GameAIOwner.MoveTo(MoveLocation,Focus);
	}
	else
	{

		// this really might need to be changed to allow for partial paths
		// as some of the paths in nano can be reallly long

		`AILog("Searching for path to point");
		if( GeneratePathToLocation( MoveLocation ) )
		{
			`AILog("Moving to"@`showvar(InternalMoveTarget));
			class'NanoAICmd_Move_Mesh'.static.MoveToPoint(GameAIOwner,MoveLocation,TRUE,,MaxMoveTime);
		}
		else
		{
			// we failed so let's debug on and try to path again!
			//NavigationHandle.bDebugConstraintsAndGoalEvals = TRUE;
			//NavigationHandle.bUltraVerbosePathDebugging = TRUE;

			//GeneratePathToLocation( MoveLocation );

			//`AILog("should be paused now");

			if( NavigationHandle.AnchorPylon == None )
			{
				bAIBroken = TRUE;
			}
			
			`AILog("Failed to find path to move location, aborting" @ `showvar(MoveLocation) );
			Status = 'Failure';
			AbortCommand(self);
		}
	}
	Goto('Begin');
}

state MoveTowardActor extends BaseMove
{
Begin:
	`AILog(`showvar(MoveActor));
	bAIBroken = FALSE;
	if (!bFaceFocus)
	{
		Focus = None;
	}

	if (MoveActor == None || Pawn.ReachedDestination(MoveActor))
	{
		// if invalid destination then consider an abort
		if (MoveActor == None)
		{
			`AILog( "Invalid move actor?!" );
			Status = 'Failure';
			AbortCommand(self);
		}
		else
		{
			`AILog("Reached actor");
			Status = 'Success';
			PopCommand(self);
		}
	}
	
	if( NavigationHandle.ActorReachable(MoveActor))
	{
		`AILog("Direct move"@VSize2D(MoveActor.Location - Pawn.Location)@`showvar(Focus));
		if (Pawn(MoveActor) != None)
		{
			MoveToward(MoveActor,Focus,Pawn(MoveActor).GetCollisionRadius() * 2.5);
		}
		else
		{
			MoveToward(MoveActor,Focus);
		}
	}
	else
	{
		//NavigationHandle.bDebugConstraintsAndGoalEvals = TRUE;
		if( GeneratePathToActor( MoveActor ) )
		{
			`AILog("- following path to"@`showvar(InternalMoveTarget)@`showvar(MoveActor));
			// disable jumping off ledges while pathing, AI should move through explicit edges
			Pawn.bCanJump = FALSE;
			class'NanoAICmd_Move_Mesh'.static.MoveToPoint(GameAIOwner,MoveActor.Location,TRUE,,MaxMoveTime);
			Pawn.bCanJump = Pawn.default.bCanJump;
		}
		else
		{
			`AILog("- no path to"@`showvar(MoveActor));
			MoveActor = None;
			if (!IsZero(MoveLocation))
			{
				GotoState('MoveTowardLocation');
			}
			else
			{
				if( NavigationHandle.AnchorPylon == None )
				{
					bAIBroken = TRUE;
				}
				Status = 'Failure';
				AbortCommand(self);
			}
		}
	}
	Goto('Begin');
}

defaultproperties
{
	bAllowNewSameClassInstance=TRUE
}
