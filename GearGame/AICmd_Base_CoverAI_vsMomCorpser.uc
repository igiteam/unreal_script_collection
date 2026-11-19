/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Base_CoverAI_vsMomCorpser extends AICommand_Base_Combat
	within GearAI_Cover;

var Vector DesiredMoveLocation;

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


state InCombat
{
	function bool ShouldMoveRelativeToCorpser()
	{
		local Vector CorpserFaceDir, VectCorpserToPawn, ClosestPointToLine, LateralDir, HitLocation, HitNormal;
		local GearPawn_LocustMomCorpserBase Corpser; 
		local float DistToLine, Dist;

		Corpser = GearPawn_LocustMomCorpserBase(Enemy);
		if( Corpser == None )
		{
			return FALSE;
		}

		CorpserFaceDir = Vector(Corpser.Rotation);
		CorpserFaceDir.Z = 0;
		CorpserFaceDir = Normal(CorpserFaceDir);
		VectCorpserToPawn = (Pawn.Location - Corpser.Location);
		VectCorpserToPawn.Z = 0.f;

		Dist = VSize2D(VectCorpserToPawn);
		if( Dist < EnemyDistance_Medium )
		{
			DistToLine = PointDistToLine( Pawn.Location, CorpserFaceDir, Corpser.Location, ClosestPointToLine );
			if( DistToLine < 512.f )
			{
				LateralDir  = Normal((Pawn.Location - ClosestPointToLine) * vect(1,1,0));
				LateralDir *= 256.f * (1.f + FRand());
				DesiredMoveLocation = ClosestPointToLine + LateralDir;
				DesiredMoveLocation.Z = Pawn.Location.Z;

// 				FlushPersistentDebugLines();
// 				DrawDebugLine( Pawn.Location, ClosestPointToLine, 255, 0, 0, true );
// 				DrawDebugBox( ClosestPointToLine, vect(5,5,5), 255, 0, 0, true );
// 				DrawDebugLine( Pawn.Location, DesiredMoveLocation, 0, 255, 0, true );
// 				DrawDebugBox( DesiredMoveLocation, vect(5,5,5), 0, 255, 0, true );

				if( !NavigationHandle.ObstacleLineCheck( Pawn.Location, DesiredMoveLocation, Pawn.GetCollisionExtent() * 0.75f ) )
				{
					DesiredMoveLocation = ClosestPointToLine - LateralDir;
					DesiredMoveLocation.Z = Pawn.Location.Z;

// 					DrawDebugLine( Pawn.Location, DesiredMoveLocation, 0, 255, 255, true );
// 					DrawDebugBox( DesiredMoveLocation, vect(5,5,5), 0, 255, 255, true );
				}

				if( VSize2D(DesiredMoveLocation - Corpser.Location) < EnemyDistance_Short )
				{
					VectCorpserToPawn = Normal((DesiredMoveLocation - Corpser.Location) * vect(1,1,0) );
					DesiredMoveLocation = Corpser.Location + VectCorpserToPawn * EnemyDistance_Medium;

// 					DrawDebugLine( Pawn.Location, DesiredMoveLocation, 0, 0, 255, true );
// 					DrawDebugBox( DesiredMoveLocation, vect(5,5,5), 0, 0, 255, true );
				}

				if( !NavigationHandle.ObstacleLineCheck( Pawn.Location, DesiredMoveLocation, Pawn.GetCollisionExtent() * 0.75f, HitLocation, HitNormal ) )
				{
					DesiredMoveLocation = HitLocation;

// 					DrawDebugLine( Pawn.Location, DesiredMoveLocation, 255, 0, 255, true );
//					DrawDebugBox( DesiredMoveLocation, vect(5,5,5), 255, 0, 255, true );
				}

// 				DrawDebugLine( Pawn.Location, DesiredMoveLocation, 255, 255, 255, true );
// 				DrawDebugBox( DesiredMoveLocation, vect(5,5,5), 255, 255, 255, true );

				return TRUE;
			}
		}

		return FALSE;
	}

	function bool ShouldMoveToCorpser()
	{
		local float Dist;

		if( !ShouldMoveToSquad( TRUE, Enemy.Location ) )
		{
			if( !IsPawnVisibleViaTrace( Enemy ) )
			{
				return TRUE;
			}

			Dist = VSize(Pawn.Location - Enemy.Location);
			if( Dist > EnemyDistance_Medium * 1.5f )
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
	else if( ShouldMoveToCorpser() )
	{
		//debug
		`AILog( "MOVETOCORPSER TAG", 'State' );

		SetEnemyMoveGoal( TRUE, EnemyDistance_Medium * 0.9f );
	}
	else if( ShouldMoveRelativeToCorpser() )
	{
		//debug
		`AILog( "MOVERELATIVETOCORPSER TAG", 'State' );

		SetMovePoint( DesiredMoveLocation, Enemy );
	}
	else
	{
		//debug
		`AILog( "FIREFROMOPEN TAG", 'State' );


		FireFromOpen();
	
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

}
