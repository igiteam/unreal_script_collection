/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Base_CoverAI_vsBerserker extends AICommand_Base_Combat
	within GearAI_Cover;

var Vector DesiredMoveLocation;

/** We want to always stay at least this far from the Berserker */
var float BerserkerDangerRange;

function Pushed()
{
	Super.Pushed();

	// turn on flank reactions
	Reactionmanager.UnSuppressReactionsByType( class'AIReactCond_Flanked', FALSE );

	GotoState( 'InCombat' );
}

function Popped()
{
	Super.Popped();

	// make sure we are no longer targeting (might have got left on by other actions when holding a shield)
	if( MyGearPawn != None )
	{
		MyGearPawn.SetTargetingMode( FALSE );
	}

	// turn off flank reactions
	Reactionmanager.SuppressReactionsByType( class'AIReactCond_Flanked', FALSE );
}

/** Mostly the same as normal CheckReviveOrExecute(), but prevents AI from reviving teammates that are right next to the berserker */
function bool ShouldAllowRevive(GearPawn PawnToRevive)
{
	return (PawnToRevive.IsHumanControlled() || 
			VSizeSq(PawnToRevive.Location - Enemy.Location) > BerserkerDangerRange*BerserkerDangerRange );
}


state InCombat
{
	function bool ShouldMoveRelativeToBerserker()
	{
		local Vector BerserkerFaceDir, VectBerserkerToPawn, ClosestPointToLine, HitLocation, HitNormal;
		local GearPawn_LocustBerserkerLambentBase LambentBerserker; 
		local float DistToLine, Dist;

		// We want to be in front of the Lambent Berserker to damage it.
		// We can damage the normal Berserker from any side
		LambentBerserker = GearPawn_LocustBerserkerLambentBase(Enemy);
		if( LambentBerserker == None )
		{
			return FALSE;
		}

		BerserkerFaceDir = Vector(LambentBerserker.Rotation);
		BerserkerFaceDir.Z = 0;
		BerserkerFaceDir = Normal(BerserkerFaceDir);
		VectBerserkerToPawn = (Pawn.Location - LambentBerserker.Location);
		VectBerserkerToPawn.Z = 0.f;

		Dist = VSize2D(VectBerserkerToPawn);
		if( Dist < EnemyDistance_Long )
		{
			DistToLine = PointDistToSegment( Pawn.Location, LambentBerserker.Location, LambentBerserker.Location + BerserkerFaceDir * EnemyDistance_Long, ClosestPointToLine );
// 			FlushPersistentDebugLines();
// 			DrawDebugLine( Pawn.Location, ClosestPointToLine, 255, 0, 0, true );
// 			DrawDebugBox( ClosestPointToLine, vect(5,5,5), 255, 0, 0, true );
			if( DistToLine > 512.f )
			{
				DesiredMoveLocation = ClosestPointToLine;
				DesiredMoveLocation.Z = Pawn.Location.Z;

// 				DrawDebugLine( Pawn.Location, DesiredMoveLocation, 0, 255, 0, true );
// 				DrawDebugBox( DesiredMoveLocation, vect(5,5,5), 0, 255, 0, true );

				// If our destination is too close to the berserker, pick a farther destination
				if( VSizeSq(DesiredMoveLocation - Enemy.Location) < BerserkerDangerRange*BerserkerDangerRange )
				{
					DesiredMoveLocation = LambentBerserker.Location + BerserkerFaceDir * EnemyDistance_Medium * 0.9;
					DesiredMoveLocation.Z = Pawn.Location.Z;
// 					DrawDebugLine( Pawn.Location, DesiredMoveLocation, 0, 0, 255, true );
// 					DrawDebugBox( DesiredMoveLocation, vect(5,5,5), 0, 0, 255, true );
				}

				// If there is an obstacle blocking us, try to get as close as we can to our DesiredMoveLocation
				if( !NavigationHandle.ObstacleLineCheck( Pawn.Location, DesiredMoveLocation, Pawn.GetCollisionExtent() * 0.75f, HitLocation, HitNormal ) )
				{
					DesiredMoveLocation = HitLocation;
// 					DrawDebugLine( Pawn.Location, DesiredMoveLocation, 255, 0, 255, true );
// 					DrawDebugBox( DesiredMoveLocation, vect(5,5,5), 255, 0, 255, true );

					// Bail if that location is too close to the berserker
					if( VSizeSq(DesiredMoveLocation - Enemy.Location) < BerserkerDangerRange*BerserkerDangerRange )
					{
						return FALSE;
					}
				}

// 				DrawDebugLine( Pawn.Location, DesiredMoveLocation, 255, 255, 255, true );
// 				DrawDebugBox( DesiredMoveLocation, vect(5,5,5), 255, 255, 255, true );

				return TRUE;
			}
		}

		return FALSE;
	}

	/** Returns true if we should move closer to the Berserker */
	function bool ShouldMoveToBerserker()
	{
		local float DistSq;

		if( !ShouldMoveToSquad( TRUE, Enemy.Location ) )
		{
			if( !IsPawnVisibleViaTrace( Enemy ) )
			{
				return TRUE;
			}

			DistSq = VSizeSq(Pawn.Location - Enemy.Location);
			if( DistSq > EnemyDistance_Medium * EnemyDistance_Medium * 3.0f )
			{
				return TRUE;
			}
		}

		return FALSE;
	}

	function bool ShouldFireAtBerserker()
	{
		local GearPawn_LocustBerserkerLambentBase LB;
		local Vector VectToEnemy;
		local float DotP;

		LB = GearPawn_LocustBerserkerLambentBase(Enemy);
		if( LB != None && LB.bHasOpenedChest )
		{
			VectToEnemy = LB.Location - Pawn.Location;
			DotP = VectToEnemy DOT Vector(Enemy.Rotation);
			if( DotP <= -0.7f )
			{
				return TRUE;
			}
		}

		return FALSE;
	}

Begin:
	//debug
	`AILog( "BEGIN TAG"@Enemy, 'State' );

	CheckReviveOrExecute(1200.0);
	CheckInterruptCombatTransitions();

	// make sure we can acquire an enemy
	if( !SelectTarget() )
	{
		Sleep(0.5f);
		Goto('End');
	}
	
	// check to see if we should move to our squad
	if( ShouldMoveToSquad() )
	{
		//debug
		`AILog( "MOVETOSQUAD TAG", 'State' );
		MoveToSquadPosition();
	}
	else if( VSizeSq(Pawn.Location - Enemy.Location) < BerserkerDangerRange*BerserkerDangerRange )
	{
		//debug
		`AILog( "MOVEAWAYFROMBERSERKER TAG", 'State' );
		class'NavMeshPath_AlongLine'.static.AlongLine(NavigationHandle, Normal(Pawn.Location - Enemy.Location));
		class'NavMeshGoal_AwayFromPosition'.static.FleeFrom(NavigationHandle, Enemy.Location, EnemyDistance_Short);
 		if (NavigationHandle.FindPath())
		{
			SetMovePoint(NavigationHandle.PathCache_GetGoalPoint(), Enemy, true,, true, true,,false);
		}
		else
		{
			//debug
			`AILog("Failed to find path away from Berserker");
			Goto('FireFromOpen');
		}
	}
	else if( ShouldMoveToBerserker() )
	{
		//debug
		`AILog( "MOVETOBERSERKER TAG", 'State' );
		SetEnemyMoveGoal( TRUE, EnemyDistance_Medium * 0.9f,, ShouldFireAtBerserker() );
	}
	else if( ShouldMoveRelativeToBerserker() )
	{
		//debug
		`AILog( "MOVERELATIVETOBERSERKER TAG", 'State' );
		SetMovePoint( DesiredMoveLocation, Enemy, TRUE,,, ShouldFireAtBerserker() );
	}
	else
	{
FireFromOpen:
		//debug
		`AILog( "FIREFROMOPEN TAG"@ShouldFireAtBerserker(), 'State' );

		Pawn.ZeroMovementVariables();

		if( ShouldFireAtBerserker() )
		{
			FireFromOpen();
		}
		else
		{
			bFailedToFireFromOpen = TRUE;
		}
	
		if( bFailedToFireFromOpen )
		{
			//debug
			`AILog( "Failed to fire from open" );

			Sleep( 0.25f );
			// go to the end and loop all the way back to the beginning so we'll try move to squad and such
			Goto('End');
		}
	}

End:
	//debug
	`AILog( "END TAG", 'State' );

	CheckCombatTransition();
	Goto('Begin');
}
	
defaultproperties
{
	BerserkerDangerRange=512.f
}
