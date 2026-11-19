/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_MoveToSquadLeader extends AICommand
	within TGAI;

/** GoW global macros */

/** Squad position we are moving to */
var Actor	SquadPosition;
/** Ideal location once squad position reached */
var Vector	IdealPosition;
/** Trying to move to the final squad position */
var bool	bFinalMove;

var AIReactCond_SquadPositionChanged PositionChangedReaction;

/** Simple constructor that pushes a new instance of the command for the AI */
static function bool MoveToSquadLeader( TGAI AI )
{
	local AICmd_MoveToSquadLeader Cmd;
	local Controller Leader;

	if (AI != None)
	{
		Leader = AI.GetSquadLeader();
		if (Leader != None && Leader != AI)
		{
			Cmd = new(AI) class'AICmd_MoveToSquadLeader';
			if( Cmd != None )
			{
				AI.PushCommand( Cmd );
				return TRUE;
			}
		}
	}

	return FALSE;
}

/** Build debug string */
event String GetDumpString()
{
	return Super.GetDumpString()@GetSquadLeader()@SquadPosition;
}

function bool UpdateSquadPosition()
{
	local Actor NewSquadPos;

	NewSquadPos = GetSquadPosition();
	if( NewSquadPos != None &&
		NewSquadPos != SquadPosition )
	{
		SquadPosition = NewSquadPos;
		GetIdealSquadPosition( IdealPosition );

		return TRUE;
	}

	return FALSE;
}

function NotifyNeedRepath()
{
	AICommand(ChildCommand).NotifyNeedRepath();
	bFinalMove=FALSE;
}


// will return TRUE if this pawn is far behind the squad/player and needs to catch up
function bool NeedsToCatchUp()
{
	local TGPC PC;
	local float DistPlayerToSquadPosSq, DistToSquadPosSq, DistToPlayerSq;

	DistToSquadPosSq = VSizeSq(SquadPosition.Location - Pawn.Location);
	if(DistToSquadPosSq > EnemyDistance_Medium*EnemyDistance_Medium)
	{
		// if we're close to our squad leader, don't run
		if(VSizeSq(GetSquadLeader().Pawn.Location - pawn.Location) < EnemyDistance_Medium * EnemyDistance_Medium)
		{
			return false;
		}
		if(Squad.bPlayerSquad)
		{
			// make sure that if we have a player in our squad that we don't roadie run if we're right by that player
			// (player matters, squad leader doesn't)
			foreach Squad.Allmembers(class'TGPC',PC)
			{
				if(PC != none && PC.Pawn != none)
				{
					DistPlayerToSquadPosSq = VSizeSq(SquadPosition.Location - PC.Pawn.Location);
					DistToPlayerSq = VSizeSq(PC.Pawn.Location - Pawn.Location);
					// if we're sufficiently close to the player, or we're ahead of the player don't roadie run
					if( DistToPlayerSq < EnemyDistance_Medium*EnemyDistance_Medium ||
						DistToSquadPosSq < DistPlayerToSquadPosSq)
					{
						return false;
					}
				}
			}
		}
		return true;
	}

	return false;

}


function DoMove()
{
	local bool bFail, bSuccess;
	local bool bSquadCover;
	local float DistToLeader, Dist;
	local CoverInfo CovToLeader;
	local vector Extent;
	local Actor HitActor;
	local vector HitLocation, HitNormal, Start, End;
	local bool bIdealPosReachable;

	;
	// If our position has been changed - no longer doing final move
	if( UpdateSquadPosition() )
	{
		//debug
		;

		bFinalMove = FALSE;
	}
	if (!Pawn.ValidAnchor())
	{
		Pawn.SetAnchor(Pawn.GetBestAnchor(Pawn, Pawn.Location, true, false, Dist));
		if (Pawn.Anchor == None)
		{
			;
			Pawn.FindAnchorFailedTime = WorldInfo.TimeSeconds;
			Status = 'Failure';
			PopCommand(self);
			return;
		}
	}

	bSquadCover = CoverOwner != None && IsAlert();
	if( bSquadCover )
	{
		//debug
		;

		if( !ShouldMoveToSquad(TRUE) )
		{
			bSquadCover = TRUE;
			bSuccess = TRUE;
		}
		else
		{
			// if we're really far away from the squad position run there first
			TetherDistance = 512.f;
			if( VSizeSq(SquadPosition.Location - Pawn.Location) < EnemyDistance_Medium*EnemyDistance_Medium &&
				CoverOwner.EvaluateCover( SearchType_Near, SquadPosition, CovToLeader,, CoverOwner.AtCover_Squad,GetTetherToLeaderDist() ) )
			{
				bSquadCover = TRUE;
				;
				if( CovToLeader == CoverOwner.Cover )
				{
					;
					bSuccess = TRUE;
				}
				else
				{
					bFinalMove=TRUE;
					UpdateShouldRoadieRun();
					CoverOwner.SetCoverGoal( CovToLeader );
				}
			}
			else
			{
				bSquadCover = FALSE;
			}

			if( !bSquadCover && CoverOwner.IsAtCover() && GetSquadPosition() != none)
			{
				DistToLeader = VSize(Pawn.Anchor.Location - GetSquadPosition().Location);

				//debug
				;

				if( DistToLeader < GetTetherToLeaderDist() && (!HasRestrictedCoverLinks() || AtSlotFromRestrictedLink()) )
				{
					bSquadCover = TRUE;
					bSuccess = TRUE;
				}
			}
		}
	}

	if( !bSquadCover )
	{
		// If already doing final move - fail, we didn't make it
		if ( !bFinalMove )
		{
			//debug
			;

			Extent = Pawn.GetCollisionExtent();
			Extent.Z = Extent.X;
			// if our ideal squad position doesn't overlap another one, and
			// if the ideal position is reachable from the position's nav point, path to it direct, or
			// If ideal position is directly reachable
			if( !DoesIdealSquadPosOverlapAnother() )
			{
				//debug
				;

				if(! PointReachable( IdealPosition ) )
				{
					Start = IdealPosition;
					End = IdealPosition + vect(0,0,-128);
					// if not reachable trace down to to try and snap the ideal position to
					HitActor = Trace(HitLocation,HitNormal, End,Start,FALSE);
					if(HitActor != none)
					{
						IdealPosition = HitLocation + (vect(0,0,1) * Pawn.GetCollisionHeight() * 0.5);

						// if it's still unreachable, then too bad go to nav
						if(PointReachable( IdealPosition) )
						{
							bIdealPosReachable = true;
						}
					}
				}
				else
				{
					bIdealPosReachable = true;
				}
			}


			if(bIdealPosReachable)
			{
				bFinalMove = TRUE;
				MyTGPawn.hod.MoveToPoint(IdealPosition);
				SetMovePoint( IdealPosition,, TRUE, Extent.X);
			}
			// if we already reached tether, we can't get any closer
			else if( !ShouldMoveToSquad(TRUE) )
			{
				//debug
				;

				bSuccess = TRUE;
			}
			// Otherwise, move to tether location
			else
			{
				MyTGPawn.hod.MoveToActor(SquadPosition);
				if( !SetTether( SquadPosition, Pawn.GetCollisionRadius(), TRUE,, TRUE ) )
				{
					bFail = TRUE;
				}
				else
				{
					UpdateShouldRoadieRun();
				}

			}
		}
		else
		{
			bSuccess = TRUE;
		}
	}

	if( bFail )
	{
		//debug
		;

		Status = 'Failure';
		PopCommand(self);
	}
	else
	if( bSuccess )
	{
		Status = 'Success';
		PopCommand( self );
	}

}

function UpdateShouldRoadieRun()
{
	local bool bNeedsCatchup;

	if (MyTGPawn != None && !bPreparingMove)
	{
		bNeedsCatchup = NeedsToCatchUp();

		if(!bShouldRoadieRun && !bNeedsCatchup && MyTGPawn.IsDoingSpecialMove(SM_RoadieRun))
		{
			;
			DictateSpecialMove(SM_None);
		}
		else if((bShouldRoadieRun || bNeedsCatchup) && MyTGPawn.IsDoingSpecialMove(SM_None) && !IsZero(MyTGPawn.Acceleration))
		{
			;
			DictateSpecialMove(SM_RoadieRun);
		}
	}
}

function Pushed()
{
	Super.Pushed();

	//debug
	;

	bMovingToSquadLeader = TRUE;
	bFailedToMoveToEnemy = FALSE;

	LastSquadLeaderPosition = GetSquadLeaderLocation();

	// keep track of when our squad position changes
	PositionChangedReaction = class'AIReactCond_SquadPositionChanged'.static.AbortMoveWhenSquadPositionChanges(outer,GetSquadPosition());
	if(PositionChangedReaction == none)
	{
		;
	}

	// start a timer to update whether or not we should roadie run
	SetTimer(1.0f,TRUE,nameof(UpdateShouldRoadieRun),self);

	DoMove();
}

function Popped()
{
	Super.Popped();

	ClearTimer(nameof(UpdateShouldRoadieRun),self);

	bMovingToSquadLeader = FALSE;
	UpdateShouldRoadieRun();
	TetherActor = None;

	if( Status != 'Success' )
	{
		// then mark as failure so that we don't immediately try again
		bFailedToMoveToEnemy = TRUE;
		// make sure we don't think we're valid
		LastSquadLeaderPosition = vect(0,0,0);
	}

	if(PositionChangedReaction != none)
	{
		PositionChangedReaction.UnsubscribeAll();
		PositionChangedReaction = none;
	}

	// probably just reached new cover, try to attack from it
	SetAcquireCover( ACT_None );
}

function Resumed( Name OldCommandName )
{
	Super.Resumed( OldCommandName );

	if( ChildStatus == 'Success' )
	{
		DoMove();
	}
	else
	{
		Status = 'Failure';
		PopCommand( self );
	}
}



