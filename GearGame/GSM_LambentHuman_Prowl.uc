/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_LambentHuman_Prowl extends GearSpecialMove;

/** Reference to our Lambent Human owner */
var transient GearPawn_LambentHumanBase LambentHuman;

/** Number of times CrawlLoop has been played */
var transient int LoopCounter;

var float CrawlDistance;

var GearPawn.BodyStance	CrawlLoop;
var GearPawn.BodyStance	CrawlEnd;

enum ECrawlPhase
{
	ECP_Start,
	ECP_Loop,
	ECP_End,
};

var transient ECrawlPhase CrawlPhase;

protected function bool InternalCanDoSpecialMove()
{
	local int LoopCnt;
	local GearAI AI;
	local Vector StartTrace, EndTrace, Extent;

	if( !PawnOwner.IsHumanControlled() )
	{
		LoopCnt = Rand(2);

		AI = GearAI(PawnOwner.Controller);
		if( AI == None || AI.NavigationHandle == None )
		{
			return FALSE;
		}

		StartTrace = PawnOwner.Location;
		EndTrace = StartTrace + (Vector(PawnOwner.Rotation) * (CrawlDistance * (1 + LoopCnt)));
		Extent = PawnOwner.GetCollisionExtent() * vect(1,1,0.5f);

// 		PawnOwner.FlushPersistentDebugLines();
// 		PawnOwner.DrawDebugBox( StartTrace, Extent, 255, 0, 0, TRUE );
// 		PawnOwner.DrawDebugBox( EndTrace, Extent, 0, 255, 0, TRUE );
// 		PawnOwner.DrawDebugLine( StartTrace, EndTrace, 255, 0, 0, TRUE );

		if( !AI.NavigationHandle.ObstacleLineCheck( StartTrace, EndTrace , Extent ) )
		{
			return FALSE;
		}
	}

	LambentHuman.SpecialMoveFlags = LoopCnt;
	return TRUE;
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced,PrevMove);

	LambentHuman = GearPawn_LambentHumanBase(PawnOwner);
	LambentHuman.NumCrawlLoops = 1 + LambentHuman.SpecialMoveFlags;

	
	LoopCounter = 0;

	// Set up crawl loop anim and root motion
	PawnOwner.Mesh.RootMotionMode = RMM_Accel;
	PawnOwner.BS_Play(CrawlLoop, (SpeedModifier*LambentHuman.PawnSpeedModifier), 0.5f/(SpeedModifier*LambentHuman.PawnSpeedModifier), 0, FALSE, TRUE );
	PawnOwner.BS_SetRootBoneAxisOptions(CrawlLoop, RBA_Translate, RBA_Translate, RBA_Translate);
	PawnOwner.BS_SetAnimEndNotify(CrawlLoop, TRUE);
	PawnOwner.BS_SetEarlyAnimEndNotify(CrawlLoop, FALSE);
	CrawlPhase = ECP_Loop;

	LambentHuman.bCrawling = TRUE;
	LambentHuman.bCrawler  = TRUE;
	LambentHuman.SetPhysics( PHYS_NavMeshWalking );
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);

	// Turn off Root motion on animation node
	PawnOwner.BS_SetRootBoneAxisOptions(CrawlLoop, RBA_Discard, RBA_Discard, RBA_Discard);
	PawnOwner.BS_SetRootBoneAxisOptions(CrawlEnd, RBA_Discard, RBA_Discard, RBA_Discard);
	PawnOwner.Mesh.RootMotionMode = RMM_Ignore;

	if( LambentHuman.Health > 0 )
	{
		LambentHuman.bCrawling = FALSE;
		LambentHuman.bCrawler  = FALSE;
		LambentHuman.SetMovementPhysics();

		// Finish and get up
		PawnOwner.BS_Play(CrawlEnd, (SpeedModifier*LambentHuman.PawnSpeedModifier), 0.2f/(SpeedModifier*LambentHuman.PawnSpeedModifier), 0.5f/(SpeedModifier*LambentHuman.PawnSpeedModifier), FALSE, TRUE );
		PawnOwner.BS_SetAnimEndNotify(CrawlEnd, FALSE);
		PawnOwner.BS_SetEarlyAnimEndNotify(CrawlEnd, TRUE);
	}
}

/** Notification called when body stance animation finished playing */
simulated function BS_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	if( CrawlPhase == ECP_Loop && PawnOwner.BS_SeqNodeBelongsTo(SeqNode, CrawlLoop) )
	{
		PawnOwner.BS_SetAnimEndNotify(CrawlLoop, FALSE);
		++LoopCounter;
		if( LambentHuman != None && LoopCounter < LambentHuman.NumCrawlLoops )
		{
			// Continue crawling loop
			PawnOwner.BS_Play(CrawlLoop, (SpeedModifier*LambentHuman.PawnSpeedModifier), 0, 0, FALSE, TRUE );
			PawnOwner.BS_SetRootBoneAxisOptions(CrawlLoop, RBA_Translate, RBA_Translate, RBA_Translate);
			PawnOwner.BS_SetAnimEndNotify(CrawlLoop, TRUE);
			PawnOwner.BS_SetEarlyAnimEndNotify(CrawlLoop, FALSE);
			return;
		}
	}
	
	PawnOwner.EndSpecialMove();
}

defaultproperties
{
	CrawlPhase=ECP_Start
	CrawlDistance=256.f

	CrawlLoop=(Stance=((Slot=BS_FullBody,AnimName="crawl")))
	CrawlEnd=(Stance=((Slot=BS_FullBody,AnimName="crawl2idle")))

	bShouldAbortWeaponReload=TRUE
	bCanFireWeapon=FALSE
	bBreakFromCover=TRUE

	bDoMeshFloorConform=FALSE
	bDoIKFloorConform=FALSE
	bDoFootPlacement=FALSE

//	bLockPawnRotation=TRUE
}
