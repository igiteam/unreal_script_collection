/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_LambentHuman_Emerge extends GearSpecialMove;

/** Reference to our Lambent Human owner */
var transient GearPawn_LambentHumanBase LambentHuman;

/** Number of times CrawlLoop has been played */
var transient int LoopCounter;

var GearPawn.BodyStance	CrawlStart;
var GearPawn.BodyStance	CrawlLoop;
var GearPawn.BodyStance	CrawlEnd;

enum ECrawlPhase
{
	ECP_Start,
	ECP_Loop,
	ECP_End,
};

var transient ECrawlPhase CrawlPhase;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced,PrevMove);

	LambentHuman = GearPawn_LambentHumanBase(PawnOwner);
	LambentHuman.bCrawling = TRUE;

	CrawlPhase = ECP_Start;
	LoopCounter = 0;

	// Unhide the creature
	PawnOwner.SetHidden(FALSE);

	// Start playing the crawl
	PawnOwner.BS_Play(CrawlStart, SpeedModifier, 0, 0.2f/SpeedModifier, FALSE, TRUE );
	PawnOwner.BS_SetAnimEndNotify(CrawlStart, TRUE);

	// Turn off collision, since this special move is used to have them crawl out through collision
	PawnOwner.SetCollision(TRUE, FALSE, FALSE);
	PawnOwner.bCollideWorld = FALSE;
}


function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);

	// Restore collision
	PawnOwner.SetCollision(PawnOwner.default.bCollideActors, PawnOwner.default.bBlockActors, PawnOwner.default.bIgnoreEncroachers);
	PawnOwner.bCollideWorld = TRUE;

	PawnOwner.FitCollision();

	// Turn off Root motion on animation node
	PawnOwner.BS_SetRootBoneAxisOptions(CrawlLoop, RBA_Discard, RBA_Discard, RBA_Discard);
	PawnOwner.BS_SetRootBoneAxisOptions(CrawlEnd, RBA_Discard, RBA_Discard, RBA_Discard);
	PawnOwner.Mesh.RootMotionMode = RMM_Ignore;

	if( PawnOwner.Health > 0 )
	{
		// Finish and get up
		PawnOwner.BS_Play(CrawlEnd, SpeedModifier, 0.2f/SpeedModifier, 0.5f/SpeedModifier, FALSE, TRUE );
		PawnOwner.BS_SetAnimEndNotify(CrawlEnd, FALSE);
		PawnOwner.BS_SetEarlyAnimEndNotify(CrawlEnd, TRUE);
	}
}

/** Notification called when body stance animation finished playing */
simulated function BS_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	// Check which movement phase we are in
	if( CrawlPhase == ECP_Start && PawnOwner.BS_SeqNodeBelongsTo(SeqNode, CrawlStart) )
	{
		PawnOwner.BS_SetAnimEndNotify(CrawlStart, FALSE);
		// If we have a looping crawl, play that. Otherwise, stand up
		if( LambentHuman != None && LambentHuman.NumCrawlLoops > 0 )
		{
			// Set up crawl loop anim and root motion
			PawnOwner.Mesh.RootMotionMode = RMM_Translate;
			PawnOwner.BS_Play(CrawlLoop, SpeedModifier, 0.2f/SpeedModifier, 0, FALSE, TRUE );
			PawnOwner.BS_SetRootBoneAxisOptions(CrawlLoop, RBA_Translate, RBA_Translate, RBA_Translate);
			PawnOwner.BS_SetAnimEndNotify(CrawlLoop, TRUE);
			PawnOwner.BS_SetEarlyAnimEndNotify(CrawlLoop, FALSE);
			CrawlPhase = ECP_Loop;

			return;
		}
	}
	else if( CrawlPhase == ECP_Loop && PawnOwner.BS_SeqNodeBelongsTo(SeqNode, CrawlLoop) )
	{
		PawnOwner.BS_SetAnimEndNotify(CrawlLoop, FALSE);
		++LoopCounter;
		if( LambentHuman != None && LoopCounter < LambentHuman.NumCrawlLoops )
		{
			// Continue crawling loop
			PawnOwner.BS_Play(CrawlLoop, SpeedModifier, 0, 0, FALSE, TRUE );
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

	CrawlStart=(Stance=((Slot=BS_FullBody,AnimName="crawl_out")))
	CrawlLoop=(Stance=((Slot=BS_FullBody,AnimName="crawl")))
	CrawlEnd=(Stance=((Slot=BS_FullBody,AnimName="crawl2idle")))

	bShouldAbortWeaponReload=TRUE
	bCanFireWeapon=FALSE
	bLockPawnRotation=TRUE
	bBreakFromCover=TRUE
	bDisableCollision=TRUE
	bDisablePhysics=TRUE
	bDisableAI=TRUE

	bDoMeshFloorConform=FALSE
	bDoIKFloorConform=FALSE
	bDoFootPlacement=FALSE
}
