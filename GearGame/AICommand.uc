/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class AICommand extends GameAICommand within GearAI
	config(AI)
	native(AI)
	DependsOn(GearPawn);

/** Extra reference to the AI this command is being used by */
var GearAI		AIOwner;
var GearAI_Cover	CoverOwner;

var AICommand CachedGearChildCommand;	

/** whether this command is one in which the AI fires its weapon without moving */
var const bool bIsStationaryFiringCommand;

/** Is the AI allowed to fire their weapon currently? */
var protected bool bAllowedToFireWeapon;

function PrePushed(GameAIController AI)
{
	Super.PrePushed(AI);
	AIOwner	= Outer;
	CoverOwner	= GearAI_Cover(Outer);
}
function PostPopped()
{
	AIOwner = none;
	CoverOwner = none;
}

function Paused(GameAICommand NewCommand)
{
	Super.Paused(NewCommand);
	CachedGearChildCommand = AICommand(NewCommand);
}

function Resumed( Name OldCommandName )
{
	super.Resumed(OldCommandName);
	CachedGearChildCommand = none;
}

function Popped()
{
	Super.Popped();
	CachedGearChildCommand = none;
}


/** Checks to see if we're allowed to fire our weapon in this command, passing through to children until blocked. */
function bool IsAllowedToFireWeapon()
{
	return (bAllowedToFireWeapon && (CachedGearChildCommand == None || CachedGearChildCommand.IsAllowedToFireWeapon()));
}

function bool ShouldSelectTarget()
{
	if( CachedGearChildCommand != None )
	{
		return CachedGearChildCommand.ShouldSelectTarget();
	}
	return TRUE;
}

event DrawDebug( HUD H, Name Category )
{
	if( ChildCommand != None )
	{
		ChildCommand.DrawDebug( H,Category );
	}
}

function AdjustEnemyRating(out float out_Rating, Pawn EnemyPawn)
{
	if (CachedGearChildCommand != None)
	{
		CachedGearChildCommand.AdjustEnemyRating(out_Rating, EnemyPawn);
	}
}

function bool ShouldAllowRevive(GearPawn PawnToRevive)
{
	return true;
}

// AI Notification Functions
function bool NotifyCoverClaimViolation( Controller NewClaim, CoverLink Link, int SlotIdx )
{
	if( CachedGearChildCommand != None )
	{
		return CachedGearChildCommand.NotifyCoverClaimViolation( NewClaim, Link, SlotIdx );
	}
	return FALSE;
}

function bool MoveUnreachable( Vector AttemptedDest, Actor AttemptedTarget )
{
	if( CachedGearChildCommand != None )
	{
		return CachedGearChildCommand.MoveUnreachable( AttemptedDest, AttemptedTarget );
	}
	return FALSE;
}

function bool HandlePathObstruction( Actor BlockedBy )
{
	if( CachedGearChildCommand != None )
	{
		return CachedGearChildCommand.HandlePathObstruction( BlockedBy );
	}
	return FALSE;
}

function bool NotifyEnemyBecameVisible( Pawn VisibleEnemy )
{
	if( CachedGearChildCommand != None )
	{
		return CachedGearChildCommand.NotifyEnemyBecameVisible( VisibleEnemy );
	}
	return FALSE;
}

function Rotator GetAdjustedAimFor( Weapon W, vector StartFireLoc )
{
	// by default, call the controller's default version
	if( CachedGearChildCommand != None )
	{
		return CachedGearChildCommand.GetAdjustedAimFor(W,StartFireLoc);
	}
	return DefaultGetAdjustedAimFor(W,StartFireLoc);
}

function bool ShouldIgnoreTimeTransitions()
{
	if(CachedGearChildCommand != none)
	{
		return CachedGearChildCommand.ShouldIgnoreTimeTransitions();
	}

	return FALSE;
}

function NotifyNeedRepath()
{
	if(CachedGearChildCommand != none)
	{
		CachedGearChildCommand.NotifyNeedRepath();
	}
}

function bool AllowPushOfDefaultCommandForSpecialMove(ESpecialMove SM)
{
	return TRUE;
}

defaultproperties
{
	bAllowedToFireWeapon=TRUE
}
