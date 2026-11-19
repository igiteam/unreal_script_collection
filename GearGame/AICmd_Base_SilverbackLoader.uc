/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Base_SilverbackLoader extends AICmd_Base_Silverback
	within GearAI_Cover;

/** The silverback loader we are using */
var GearPawn_SilverbackLoaderBase SilverbackLoader;

/** @return false, since the loader doesn't have rockets */
simulated function bool ShouldTryRocket()
{
	return false;
}

function bool CheckForCrateAction()
{
	local float GoalDist;

	// If we have a crate action, start executing it
	if( SilverbackCrateAction != None )
	{
		// Check if we have a crate picked up and we need to drop it
		if( SilverbackLoader.PickedUpCrate != None && SilverbackCrateAction.bShouldDropCrate )
		{
			// If we are far from the drop point, move closer
			GoalDist = SilverbackLoader.GetCollisionRadius() + 50.f;
			if( SilverbackCrateAction.DropLocation != None && VSizeSq2D(SilverbackCrateAction.DropLocation.Location - SilverbackLoader.Location) > GoalDist*GoalDist )
			{
				SetMoveGoal(SilverbackCrateAction.DropLocation, SilverbackCrateAction.DropLocation, false,,,,false);
			}
			// If we are near the drop point, or don't have one specified, drop the crate
			else
			{
				SilverbackLoader.ServerDoSpecialMove(GSM_SilverbackLoaderDropCrate, TRUE);
			}
		}
		else if( SilverbackCrateAction.Crate != None )
		{
			// If we are near the crate, try to pick it up
			GoalDist = SilverbackLoader.GetCollisionRadius() + SilverbackCrateAction.Crate.CollisionComponent.Bounds.SphereRadius + 100.f;
			if( VSizeSq2D(SilverbackCrateAction.Crate.Location - SilverbackLoader.Location) <= GoalDist*GoalDist )
			{
				SilverbackLoader.TouchingCrate = SilverbackCrateAction.Crate;
				SetDesiredRotation(rotator(SilverbackCrateAction.Crate.Location - SilverbackLoader.Location));
				SilverbackLoader.ServerAttemptCratePickup();
			}
			// Else move closer to the crate
			else
			{
				SetMoveGoal(SilverbackCrateAction.Crate, SilverbackCrateAction.Crate, false,,,, true, false);
			}
		}
		return true;
	}

	return false;
}

function Resumed( Name OldCommandName )
{
	CheckForCrateAction();
	Super.Resumed( OldCommandName );
}

state InCombat
{
	function BeginState( Name PreviousStateName )
	{
		SilverbackLoader = GearPawn_SilverbackLoaderBase(Pawn);
		Super.BeginState( PreviousStateName );
		Outer.SetTimer(1.0f, true, 'CheckForCrates', self);
	}

	function EndState(Name NextStateName)
	{
		Super.EndState(NextStateName);
		Outer.ClearTimer('CheckForCrates');
	}

	function bool ShouldDeploy()
	{
		return FALSE;
	}

Begin:
	//debug
	`AILog( "BEGIN TAG", 'State' );

	if( CheckForCrateAction() )
	{
		Sleep(1.0f);
		Goto('Begin');
	}

	// check to see if we should move to our squad
	if( ShouldMoveToSquad() )
	{
MoveToSquad:
		//debug
		`AILog( "MOVETOSQUAD TAG", 'State' );
		MoveToSquadPosition();
		Sleep( 0.25f );
	}

	// select the best enemy
	SelectEnemy();
	FireTarget = Enemy;

	if (!HasValidEnemy() || !bAllowCombatTransitions )
	{
		//debug
		`AILog("No enemy");

		Sleep(1.f);
		Goto('Begin');
	}

	// Move away from enemy
	if( !MoveAwayFromEnemy() )
	{
		//debug
		`AILog("Failed to move away from enemy");
		Sleep(1.0f);
	}

	Goto('Begin');
}

defaultproperties
{
	
}
