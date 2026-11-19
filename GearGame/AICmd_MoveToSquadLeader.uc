/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_MoveToSquadLeader extends AICommand
	within GearAI;

/** Squad position we are moving to */
var Vector	SquadPosition;
/** Ideal location once squad position reached */
var Vector	IdealPosition;
/** Trying to move to the final squad position */
var bool	bFinalMove;

var AIReactCond_SquadPositionChanged PositionChangedReaction;

/** Simple constructor that pushes a new instance of the command for the AI */
static function bool MoveToSquadLeader( GearAI AI )
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
	local Vector NewSquadPos;

	NewSquadPos = GetSquadPosition();
	if( !IsZero(NewSquadPos) &&
		NewSquadPos != SquadPosition )
	{
		SquadPosition = NewSquadPos;
		return TRUE;
	}

	return FALSE;
}

function NotifyNeedRepath()
{
	CachedGearChildCommand.NotifyNeedRepath();
	bFinalMove=FALSE;
}


// will return TRUE if this pawn is far behind the squad/player and needs to catch up
function bool NeedsToCatchUp()
{
	local GearPC PC;
	local float DistPlayerToSquadPosSq, DistToSquadPosSq, DistToPlayerSq;
	local Controller MyLeader;

	MyLeader = GetSquadLeader();
	if (Pawn == None || MyLeader == None || MyLeader.Pawn == None)
	{
		return false;
	}

	DistToSquadPosSq = VSizeSq(SquadPosition - Pawn.Location);
	if(DistToSquadPosSq > EnemyDistance_Medium*EnemyDistance_Medium)
	{
		// if we're close to our squad leader, don't run
		if (VSizeSq(MyLeader.Pawn.Location - Pawn.Location) < EnemyDistance_Medium * EnemyDistance_Medium)
		{
			return false;
		}
		if (Squad.bPlayerSquad)
		{
			// make sure that if we have a player in our squad that we don't roadie run if we're right by that player
			// (player matters, squad leader doesn't)
			foreach Squad.Allmembers(class'GearPC',PC)
			{
				if (PC != None && PC.Pawn != None)
				{
					DistPlayerToSquadPosSq = VSizeSq(SquadPosition - PC.Pawn.Location);
					DistToPlayerSq = VSizeSq(PC.Pawn.Location - Pawn.Location);
					// if we're sufficiently close to the player, or we're ahead of the player don't roadie run
					if ( DistToPlayerSq < EnemyDistance_Medium*EnemyDistance_Medium ||
						DistToSquadPosSq < DistPlayerToSquadPosSq )
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
	local float DistToLeader;//, Dist;
	local CoverInfo CovToLeader;
	local vector Extent;
	local int       BestCoverRatingThreshold;
	
	BestCoverRatingThreshold = 200;
	bFail=FALSE;

	`AILog(GetFuncName()@bFinalMove);
	// If our position has been changed - no longer doing final move
	if( UpdateSquadPosition() )
	{
		//debug
		`AILog( "Clear bFinalMove"@bFinalMove );

		bFinalMove = FALSE;
	}

	bSquadCover = CoverOwner != None && IsAlert();
	if( bSquadCover )
	{
		//debug
		`AILog( "Check for cover near squad..."@Pawn.Anchor@SquadPosition@CoverOwner.HasValidCover()@CoverOwner.IsAtCover()@((CoverOwner.Cover.Link != None) ? CoverOwner.Cover.Link.GetDebugString(CoverOwner.Cover.SlotIdx) : ""@ShouldMoveToSquad(TRUE)));

		if( !ShouldMoveToSquad(TRUE) )
		{
			bSquadCover = TRUE;
			bSuccess = TRUE;
		}
		else
		{
			// if we're really far away from the squad position run there first
			TetherDistance = 512.f;
			if( VSizeSq(SquadPosition - Pawn.Location) < EnemyDistance_Medium*EnemyDistance_Medium &&
				CoverOwner.EvaluateCover( SearchType_Near, None, CovToLeader, CoverOwner.Cover, BestCoverRatingThreshold, CoverOwner.AtCover_Squad,GetTetherToLeaderDist(), SquadPosition ) )
			{
				bSquadCover = TRUE;
				`AILog("-CovToLeader: "$CovToLeader.Link$"/"$CovToLeader.SlotIdx@"My cover:"@CoverOwner.Cover.Link$"/"$CoverOwner.Cover.SlotIdx@"SquadPosition:"@SquadPosition);
				if( CovToLeader == CoverOwner.Cover )
				{
					`AILog("Movtosquad bailing with success because cover search returned cover we're already at!");
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

			if( !bSquadCover && CoverOwner.IsAtCover() && !IsZero(GetSquadPosition()))
			{
				DistToLeader = VSize(Pawn.Location - GetSquadPosition());

				//debug
				`AILog( "Didn't find cover near squad... already in cover"@DistToLeader );

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
			`AILog( "Not final move yet..."@SquadPosition@ShouldMoveToSquad(TRUE) );

			Extent = Pawn.GetCollisionExtent();
			Extent.Z = Extent.X;

			// if we already reached tether, we can't get any closer
			if( !ShouldMoveToSquad(TRUE) )
			{
				//debug
				`AILog( "Got as close as possible to" @ IdealPosition );

				bSuccess = TRUE;
			}
			// Otherwise, move to tether location
			else
			{
				SetMovePoint( SquadPosition,, TRUE);
				UpdateShouldRoadieRun();
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
		`AILog( "- Failed to do move"@bFinalMove );

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

	if (MyGearPawn != None && !bPreparingMove)
	{
		bNeedsCatchup = NeedsToCatchUp();

		if( !bShouldRoadieRun && !bNeedsCatchup && MyGearPawn.IsDoingSpecialMove(SM_RoadieRun) && MovementMood != AIMM_Fast )
		{
			`AILog("shutting off roadie run SM cuz we dont' want to roadie run! "@bNeedsCatchup@bShouldRoadieRun);
			DictateSpecialMove(SM_None);
		}
		else if ( (bShouldRoadieRun || bNeedsCatchup) && MyGearPawn.IsDoingSpecialMove(SM_None) &&
			MyGearPawn.CanDoSpecialMove(SM_RoadieRun) && !IsZero(MyGearPawn.Acceleration) )
		{
			`AILog("going to roadie run because we're too far away"@bNeedsCatchup@bShouldRoadieRun);
			DictateSpecialMove(SM_RoadieRun);
		}
	}
}

function Pushed()
{
	local float MoveDelay;
	local Rotator Rot;
	local Controller MyLeader;
	local int PosIdx;

	MyLeader = GetSquadLeader();

	Super.Pushed();

	//debug
	`AILog("Moving to squad leader..."@GetSquadLeader() @ "(Position:" @ SquadPosition $ ")");

	bMovingToSquadLeader = TRUE;
	bFailedToMoveToEnemy = FALSE;

	LastSquadLeaderPosition = GetSquadLeaderLocation();

	// keep track of when our squad position changes
	PositionChangedReaction = class'AIReactCond_SquadPositionChanged'.static.AbortMoveWhenSquadPositionChanges(outer,GetSquadPosition());
	if(PositionChangedReaction == none)
	{
		`warn(self@"Could not spawn squad position changed reaction!");
	}

	// start a timer to update whether or not we should roadie run
	SetTimer(1.0f,TRUE,nameof(UpdateShouldRoadieRun),self);

	if( !WorldInfo.GRI.IsMultiplayerGame() && 
		!IsInCombat() && 
		(GearPawn(MyLeader.Pawn) == None || !GearPawn(MyLeader.Pawn).IsDoingSpecialMove(SM_RoadieRun)) &&
		`TimeSince(	LastMoveToSquadLeaderTime ) > 1.f )
	{
		MoveDelay = 0.5f + (FRand() * 3.5f);
		if( Squad != None && !bIgnoreSquadPosition )
		{
			PosIdx = Squad.Formation.Positions.Find( 'AI', Outer );
			if( PosIdx >= 0 )
			{
				MoveDelay = 0.5f + (1.25f * PosIdx) + (FRand() * 1.f);
			}
		}
	}

	if( MoveDelay > 0.f )
	{
		Focus = None;
		Rot.Yaw = Rotator(LastSquadLeaderPosition - Pawn.Location).Yaw;
		Pawn.SetDesiredRotation( Rot );
		SetTimer( MoveDelay, FALSE, nameof(DoMove), self );
	}
	else
	{
		DoMove();
	}
}

function Popped()
{
	Super.Popped();

	ClearTimer(nameof(UpdateShouldRoadieRun),self);
	ClearTimer(nameof(DoMove), self);

	bMovingToSquadLeader = FALSE;
	LastMoveToSquadLeaderTime = WorldInfo.TimeSeconds;
	UpdateShouldRoadieRun();
	ClearTether();

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

function Paused( GameAICommand NewCommand )
{
	Super.Paused( NewCommand );

	ClearTimer(nameof(UpdateShouldRoadieRun),self);
	ClearTimer(nameof(DoMove), self);
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



defaultproperties
{
}
