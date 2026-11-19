/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_MoveToEnemy extends AICommand
	within GearAI;


var Actor Find;
var vector NextMoveLocation;
var float	Radius;
var bool    bWasFiring;
/** number of times remaining we can fail the MoveToGoal before we give up */
var int MoveTriesRemaining;

/** if this is TRUE, we will move all the way to the enemy instead of just to the first goal */
var() bool bCompleteMove;
/** how close to get to the enemy (only valid of bCompleteMove is TRUE) */
var float GoalDistance;
/** if enemy gets this far from us we should abandon the move */
var float AbandonDistance;
/** Last location of enemy... if they've moved too much, redo pathing */
var BasedPosition LastEnemyLocation;

/** are we allowed to fire during this move? */
var bool bAllowedToFire;

/** if the enemy moves more than this distance away from where it was when we pathed, repath */
var float RepathDistance;

/** override for movement focus */
var Actor OverrideFocus;


/** Simple constructor that pushes a new instance of the command for the AI */
static function bool MoveToEnemy( GearAI AI,
									bool bInCompleteMove,
									float InGoalDistance,
									float InAbandonDistance,
									optional bool bInAllowedToFire=true,
									optional actor InFocusOverride=none)
{
	local AICmd_MoveToEnemy Cmd;

	if( AI != None && AI.Pawn != None )
	{
		Cmd = new(AI) class'AICmd_MoveToEnemy';
		if( Cmd != None )
		{
			Cmd.bCompleteMove = bInCompleteMove;
			Cmd.GoalDistance = InGoalDistance;
			Cmd.AbandonDistance = InAbandonDistance;
			Cmd.bAllowedToFire = bInAllowedToFire;
			Cmd.OverrideFocus = InFocusOverride;
			AI.PushCommand( Cmd );
			return TRUE;
		}
	}

	return FALSE;
}

/** Build debug string */
event String GetDumpString()
{
	return Super.GetDumpString()@Enemy@GoalDistance@bCompleteMove;
}

function Pushed()
{
	Super.Pushed();
	bWasFiring = (bWeaponCanFire && bFire == 1);
	GotoState('Moving');
}

function Popped()
{
	Super.Popped();

	ClearTimer( 'CheckReachedEnemy', self );
	ClearTimer( nameof(CheckEnemyMoved), self );
	ClearTimer(nameof(self.DirectMoveTimeout),self);


	// Mark failure to move
	bFailedToMoveToEnemy = (Status != 'Success');
}

function Resumed(name OldCommandName)
{
	Super.Resumed(OldCommandName);

	if (!bCompleteMove)
	{
		Status = ChildStatus;
		PopCommand(self);
	}
}

function CheckReachedEnemy()
{
	local float DistToEnemySq, DistEnemyMovedSq;
	local Vector Extent;
	local bool bWithinDist;
	local vector HitLoc;
	local float EnemyObsMeshHitThreshSq;

	// only abort if we don't have a child, or our child is a move command.. otherwise let it slide
	if( ChildCommand == None || 
		((ChildCommand.IsA('AICmd_MoveToGoal_Mesh') || ChildCommand.IsA('GameAICmd_Hover_MoveToGoal_Mesh')) && 
			ChildCommand.ChildCommand == None) )
	{
		if (Enemy != None)
		{
			DistToEnemySq = VSizeSq(Enemy.Location-Pawn.Location);
			Extent = Pawn.GetCollisionExtent();

			EnemyObsMeshHitThreshSq = Extent.X+12;
			EnemyObsMeshHitThreshSq *= EnemyObsMeshHitThreshSq;
		//	`log( GetFuncName()@VSize(Enemy.Location-Pawn.Location)@"--"@GoalDistance@"--"@AbandonDistance);

			bWithinDist = GoalDistance > 0.f && DistToEnemySq <= GoalDistance*GoalDistance;
			if(bWithinDist && 
				(
				class'NavigationHandle'.static.ObstacleLineCheck( Pawn.Location, Enemy.Location, Extent,HitLoc ) ||
				VSizeSq2D(HitLoc-Enemy.Location) < EnemyObsMeshHitThreshSq
				)
			  )
			{
				//debug
				`AILog( "Move got us within goal dist..." );

				AbortCommand( self );
			}
			else if( AbandonDistance > 0.f && DistToEnemySq >= AbandonDistance*AbandonDistance )
			{
				//debug
				`AILog( "Move took us outside abandon dist..." );

				AbortCommand( self );
			}
			else if (GearAI_TDM(Outer) == None && ChildCommand != none)
			{
				DistEnemyMovedSq = VSizeSq(BP2Vect(LastEnemyLocation)-Enemy.Location);
				if( DistEnemyMovedSq > 1024.f*1024.f || !FastTrace(Enemy.Location,BP2Vect(LastEnemyLocation)) )
				{
					//debug
					`AILog( "Enemy moved too far from pathed location... pop child command and redo pathing" );
					ChildCommand.Status = 'Success';
					AbortCommand( ChildCommand );
				}
			}
		}
		else
		{
			`AILog("Enemy became invalid, aborting");
			AbortCommand(self);
		}
	}
}

function CheckEnemyMoved()
{
	local float DistSq;

	if(Find != none)
	{
		DistSq = VSizeSq(Find.Location - BP2Vect(LastEnemyLocation));
		if(DistSq > RepathDistance*RepathDistance && !IsValidDirectMoveGoal(Find))
		{
			if(ChildCommand!=none)
			{
				MoveTriesRemaining=default.MoveTriesRemaining+1;
				AbortCommand(ChildCommand);
			}
		}
	}
}

function DirectMoveTimeout()
{
	`AILog("Was moving directly to enemy, but it took too long and we were bCompleteMove=FALSE, aborting");
	AbortCommand(self);
}

state Moving `DEBUGSTATE
{
Begin:
	`AILog("BEGIN TAG"@GetSTatename());
	// UnMark failure to move
	bFailedToMoveToEnemy = FALSE;

	if (!HasValidEnemy())
	{
		SelectEnemy();
	}
	FireTarget = Enemy;
	if( HasValidEnemy() && AllowedToMove() && MoveIsInterruptable() )
	{
		`AILog("Found valid enemy");
		bReachedMoveGoal = FALSE;

		Radius = Pawn.GetCollisionRadius() + Enemy.GetCollisionRadius() + Pawn.MeleeRange + 1.0;
		// If enemy is on a cart, path find to the cart
		Find = Enemy;
		if( GearInterActorAttachableBase(Enemy.Base) != None )
		{
			Find = Enemy.Base;
			Radius = 0.f;
		}
		Radius = FMax(0.f, GoalDistance - Radius); // subtract because collision radius already considered by ReachedDestination()


Loop:
		// If enemy directly reachable
		`AILog("Going to next path to "$find);

		Vect2BP(LastEnemyLocation,Find.Location);

		if( IsValidDirectMoveGoal( Find ) )
		{
			`AILog("Calling SetMoveGoal to" @ Radius @ bAllowedToFire);
			SetTimer(0.5, true, nameof(CheckEnemyMoved), self);
			SetTimer(0.5, true, nameof(CheckReachedEnemy), self);
			
			if(!bCompleteMove)
			{
				SetTimer( GetMoveTimeOutDuration(Find.GetDestination(Outer),AllowedToDoLeadInLeadOutWalk()), FALSE, nameof(self.DirectMoveTimeout), self );
			}

			SetMoveGoal(Find, None, true, Radius,,,, bAllowedToFire);

			if (ChildStatus != 'Success')
			{
				if( --MoveTriesRemaining <= 0)
				{
					`AILog("Child was fail or aborted, and we're out of move tries.. failing");
					GotoState('DelayFailure');
				}
				else
				{
					Goto('Loop');
				}
			}

			ClearTimer(nameof(self.DirectMoveTimeout),self);
			ClearTimer('CheckReachedEnemy', self);
			ClearTimer(nameof(CheckEnemyMoved), self);

			`AILog("Finished moving to enemy");
			Status = 'Success';
			PopCommand(self);
		}
		else
		{
			// Try to find path to enemy
			// If no path available

			if (!GeneratePathTo(Find,, true))
			{
				// Update failed path time
				SetFailedPathToEnemy( Enemy );
				`LogPathFailure(Enemy,"Failed to path to enemy! (GeneratePath returned false)");
				GotoState( 'DelayFailure' );
			}
			else if ( !NavigationHandle.GetNextMoveLocation(NextMoveLocation, Pawn.GetCollisionRadius()))
			{
								// Update failed path time
				SetFailedPathToEnemy( Enemy );
				`LogPathFailure(Enemy,"Failed to path to enemy! (GetNextMoveLocation returned false)");
				GotoState( 'DelayFailure' );

			}
			else
			{
				//debug
				`AILog( "Found path toward enemy..."@Find@bCompleteMove@Pawn.Anchor@CombatZoneList.Length, 'Move' );

				SetTimer(0.5, true, nameof(CheckReachedEnemy), self);
				SetTimer(0.5, true, nameof(CheckEnemyMoved), self);
				if(!bCompleteMove)
				{
					SetMovePoint(NextMoveLocation, OverrideFocus, true,, true, bAllowedToFire);
				}
				else
				{
					SetMoveGoal(Find, OverrideFocus, true,, true,,, bAllowedToFire);
				}
				ClearTimer(nameof(CheckReachedEnemy), self);
				ClearTimer(nameof(CheckEnemyMoved), self);


				if (ChildStatus != 'Success' && --MoveTriesRemaining <= 0)
				{
					`AILog("Move to enemy failed, and we're out of move attempts.. failing enemy move");
					GotoState('DelayFailure');
				}
				if(bWasFiring)
				{
					StartFiring();
				}
				Sleep(0.0);
				if (!HasValidEnemy())
				{
					`AILog("Lost enemy or enemy became invalid, aborting");
					AbortCommand(self);
				}
				Goto('Loop');
			}
		}
	}
	else
	{
		`AILog("No valid enemy, or not allowed to move.. bailing ValidEnemy?:"@HasValidEnemy()@"Allowed to move?"@AllowedToMove()@"Move Interruptable?"@MoveIsInterruptable());
		GotoState( 'DelayFailure' );
	}
}

defaultproperties
{
	MoveTriesRemaining=3
	RepathDistance=1024.0
}
