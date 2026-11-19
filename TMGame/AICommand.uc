/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */
class AICommand extends GameAICommand within TGAI
    native(TGAI)
    config(TGAI)
	DependsOn(TGPawn);

var TGAI_Cover	CoverOwner;

/** Is the AI allowed to fire their weapon currently? */
var protected bool bAllowedToFireWeapon;

function PrePushed(GameAIController AI)
{
	CoverOwner = TGAI_Cover(AI);
}

/** Notification when this command has popped */
function Popped()
{
	CoverOwner = none;
}

/** Checks to see if we're allowed to fire our weapon in this command, passing through to children until blocked. */
function bool IsAllowedToFireWeapon()
{
	return (bAllowedToFireWeapon && (AICommand(ChildCommand) == None || AICommand(ChildCommand).IsAllowedToFireWeapon()));
}

function bool ShouldSelectTarget()
{
	if( AICommand(ChildCommand) != None )
	{
		return AICommand(ChildCommand).ShouldSelectTarget();
	}
	return TRUE;
}

event DrawDebug(HUD H, Name Category)
{
	if( ChildCommand != None )
	{
		ChildCommand.DrawDebug(H, Category);
	}
}

function AdjustEnemyRating(out float out_Rating, Pawn EnemyPawn)
{
	if (AICommand(ChildCommand) != None)
	{
		AICommand(ChildCommand).AdjustEnemyRating(out_Rating, EnemyPawn);
	}
}

// AI Notification Functions
function bool NotifyCoverClaimViolation( Controller NewClaim, CoverLink Link, int SlotIdx )
{
	if( AICommand(ChildCommand) != None )
	{
		return AICommand(ChildCommand).NotifyCoverClaimViolation( NewClaim, Link, SlotIdx );
	}
	return FALSE;
}

function bool MoveUnreachable( Vector AttemptedDest, Actor AttemptedTarget )
{
	if( AICommand(ChildCommand) != None )
	{
		return AICommand(ChildCommand).MoveUnreachable( AttemptedDest, AttemptedTarget );
	}
	return FALSE;
}

function bool HandlePathObstruction( Actor BlockedBy )
{
	if( AICommand(ChildCommand) != None )
	{
		return AICommand(ChildCommand).HandlePathObstruction( BlockedBy );
	}
	return FALSE;
}

function bool NotifyEnemyBecameVisible( Pawn VisibleEnemy )
{
	if( AICommand(ChildCommand) != None )
	{
		return AICommand(ChildCommand).NotifyEnemyBecameVisible( VisibleEnemy );
	}
	return FALSE;
}

function Rotator GetAdjustedAimFor( Weapon W, vector StartFireLoc )
{
	// by default, call the controller's default version
	if( AICommand(ChildCommand) != None )
	{
		return AICommand(ChildCommand).GetAdjustedAimFor(W,StartFireLoc);
	}
	return DefaultGetAdjustedAimFor(W,StartFireLoc);
}

function bool ShouldIgnoreTimeTransitions()
{
	if(AICommand(ChildCommand) != None)
	{
		return AICommand(ChildCommand).ShouldIgnoreTimeTransitions();
	}

	return FALSE;
}

function NotifyNeedRepath()
{
	if(AICommand(ChildCommand) != none)
	{
		AICommand(ChildCommand).NotifyNeedRepath();
	}
}

function bool AllowPushOfDefaultCommandForSpecialMove(ESpecialMove SM)
{
	return TRUE;
}

