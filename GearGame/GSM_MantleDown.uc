
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_MantleDown extends GSM_BaseVariableFall
	native(SpecialMoves);

/** Min distance required to be able to mantle down */
var() float MinMantleHeight;

/** Max distance possible to mantle down */
var() float MaxMantleHeight;

/** Animation Travel Distance (forward X) to mantle down */
var() float ForwardDistance;

/** Animation Roadie Run Travel Distance (forward X) to mantle down */
var() float DropDownForwardDistance;

/** Mantle up animation */
var()	GearPawn.BodyStance	BS_MantleDown;
var()   GearPawn.BodyStance BS_MantleDropDown;
var()   GearPawn.BodyStance BS_MantleDropDownFall;
var()   GearPawn.BodyStance BS_MantleDropDownStumble;

/** TRUE if this mantledown came from RoadieRun**/
var transient bool TransitionFromRoadieRun;
var transient ESpecialMove NextTransitionMove;

var transient float AccumulatedFallingTime;
/** Falling Transition Wait time  **/
var() float FallingTimeThreshold;

// C++ functions
cpptext
{
	virtual void TickSpecialMove(FLOAT DeltaTime);
}

native simulated function vector GetInitialJumpVelocity();
native simulated function vector GetInitialFallVelocity();

protected function bool InternalCanDoSpecialMove()
{
	if( PawnOwner.CoverType != CT_None ||
		(PawnOwner.IsDoingASpecialMove() && !PawnOwner.IsDoingMove2IdleTransition() && !PawnOwner.IsDoingSpecialMove(SM_RoadieRun) && !PawnOwner.IsDoingSpecialMove(SM_RoadieRunStab)) )
	{
		return FALSE;
	}

	if(  PawnOwner.IsHumanControlled() )
	{
		if ((PawnOwner.IsDoingSpecialMove(SM_RoadieRun) || PawnOwner.IsDoingSpecialMove(SM_RoadieRunStab)) && !PawnOwner.CanPerformMantleDown(MinMantleHeight, MaxMantleHeight, DropDownForwardDistance, PawnOwner.Rotation))
		{
			return FALSE;
		}
		else if (!PawnOwner.CanPerformMantleDown(MinMantleHeight, MaxMantleHeight, ForwardDistance, PawnOwner.Rotation))
		{
			return FALSE;
		}
	}

	// don't let them jump down eholes
	if( GearSpawner(PawnOwner.Base) != None )
	{
		return FALSE;
	}

	return TRUE;
}

/**
 * Event called when Impact with world has happened or has been anticipated.
 * (This is when PawnOwner is within PreImpactDistance units from impact point)
 */
event Landed(float DistanceToImpact, float TimeToImpact)
{
//	`log("NotifyLanded-ClampedActor("@PawnOwner.ClampedBase@"), Velocity("@PawnOwner.Velocity );
	PlayLand();
}

simulated function PlayJump()
{
	Super.PlayJump();

	PawnOwner.BS_SetRootBoneAxisOptions(BS_Jump, RBA_Translate, RBA_Translate, RBA_Discard);
	PawnOwner.Mesh.RootMotionMode = RMM_Accel;
	PawnOwner.Velocity = GetInitialJumpVelocity();

	// Default mantle down has diagonal movement, I need to add scale to move further
  	if (TransitionFromRoadieRun == FALSE)
  	{
		// mantle down needs animation change - root should move forward and down, not diagonal
		// until that's fixed, I need this scale for smooth transition
  		PawnOwner.Mesh.RootMotionAccelScale = vect(2, 2, 1);
  	}
}

simulated function PlayLand()
{
	if (MoveType == EMT_Land)
	{
		return;
	}

	if (TransitionFromRoadieRun == FALSE)
	{
		PawnOwner.EndSpecialMove();
		return;
	}

	//PCOwner.ConsoleCommand("Pause");

	Super.PlayLand();

	// Turn on Root motion on animation node
	PawnOwner.BS_SetRootBoneAxisOptions(BS_Land, RBA_Translate, RBA_Translate, RBA_Translate);
	// Turn on Root motion on mesh.
	PawnOwner.Mesh.RootMotionMode = RMM_Accel;
}


/** Play Fall */
simulated function PlayFall()
{
	//`log(PawnOwner.WorldInfo.TimeSeconds @ GetFuncName() @ PawnOwner);

	if (MoveType == EMT_Fall)
	{
		return;
	}

	//PCOwner.ConsoleCommand("Pause");

 	AccumulatedFallingTime = 0.f;

	if (TransitionFromRoadieRun == FALSE)
	{
		PawnOwner.Mesh.RootMotionAccelScale = vect(1, 1, 1);
		PawnOwner.Mesh.RootMotionMode = PawnOwner.default.Mesh.RootMotionMode;
		// Stop current move
		StopCurrentMoveType();

		// Now we're falling.
		MoveType = EMT_Fall;

		// Set falling physics
		PawnOwner.SetPhysics(FallingPhysics);
		PawnOwner.SetBase( PawnOwner.ClampedBase );
		PawnOwner.Velocity = GetInitialFallVelocity();
		return;
	}

	//Super.PlayFall();

	StopCurrentMoveType();

	// Now we're falling.
	MoveType = EMT_Fall;

	// Set falling physics
	PawnOwner.SetPhysics(FallingPhysics);
	PawnOwner.SetBase( PawnOwner.ClampedBase );

	// Play middle, variable animation.
	PawnOwner.BS_Play(BS_Fall, SpeedModifier, 0.01f, 0.01f, IsFallLooping(), TRUE);

	PawnOwner.BS_SetRootBoneAxisOptions(BS_Jump, RBA_Translate, RBA_Translate, RBA_Discard);
	PawnOwner.Mesh.RootMotionMode = RMM_Accel;
	PawnOwner.Velocity = GetInitialFallVelocity();
}

function OnMirrorTransitionSafeNotify();

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced,PrevMove);

 	PawnOwner.Mesh.RootMotionAccelScale = vect(1,1, 1);
	if (PrevMove == SM_RoadieRun || PrevMove == SM_RoadieRunStab)
	{
		TransitionFromRoadieRun = TRUE;
		NextTransitionMove = PrevMove;
		BS_Jump = BS_MantleDropDown;
		BS_Fall = BS_MantleDropDownFall;
		BS_Land = BS_MantleDropDownStumble;
	}
	else
	{
		TransitionFromRoadieRun = FALSE;
		NextTransitionMove = SM_None;
		BS_Jump = BS_MantleDown;
	}

 	PlayJump();

	//PawnOwner.FlushPersistentDebugLines();
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	local GearPC			PC;

	Super.SpecialMoveEnded(PrevMove, NextMove);

 	// Turn off Root motion on mesh.
	PawnOwner.Mesh.RootMotionAccelScale = vect(1, 1, 1);
 	PawnOwner.Mesh.RootMotionMode = PawnOwner.Mesh.default.RootMotionMode;

	// check for a transition to roadie run
	PC = GearPC(PawnOwner.Controller);
	if( PC != None )
	{
		if ( PC.IsHoldingRoadieRunButton() )
		{
			if ( (PC.bUseAlternateControls || !PC.TryToRunToCover(TRUE,0.75f)) )
			{
				if (PC.CanDoSpecialMove(NextTransitionMove))
				{
					PC.DoSpecialMove(NextTransitionMove);
				}
			}
		}
	}
}

/**
 * On server only, possibly save chained move
 * @Return TRUE if move could be chained to this one
 */
function bool CanChainMove(ESpecialMove NextMove)
{
	return (NextMove == NextTransitionMove );
}

function bool CanDelayDBNO()
{
	return true;
}

defaultproperties
{
	MinMantleHeight=60.f	// match max step height
	MaxMantleHeight=150.f	// MaxStepHeight + MidLevelCoverHeight (96)

	BS_MantleDown=(Stance=((Slot=BS_FullBody,AnimName="AR_Mantle_Down")))
	BS_MantleDropDown=(Stance=((Slot=BS_FullBody,AnimName="AR_RoadieRun_Fwd_DropDown")))
	BS_MantleDropDownFall=(Stance=((Slot=BS_FullBody,AnimName="AR_RoadieRun_Fwd_DropDown_Fall")))
	BS_MantleDropDownStumble=(Stance=((Slot=BS_FullBody,AnimName="AR_RoadieRun_Fwd_DropDown_Stumble")))

	bCanFireWeapon=FALSE
	bLockPawnRotation=TRUE
	bBreakFromCover=TRUE
	bDisableCollision=FALSE
	bDisableMovement=TRUE
	bDisablePhysics=FALSE

	bDoMeshFloorConform=FALSE
	bDoIKFloorConform=FALSE
	bDoFootPlacement=FALSE

	JumpingPhysics=PHYS_Flying		// Collision is disabled, we don't want Pawn to fall through world

	Action={(
			 ActionName=MantleDown,
			 ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=212,V=314,UL=35,VL=43))), // A Button
								(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=422,V=314,UL=90,VL=106)))	),
			)}

	FallingTimeThreshold = 0.2

	ForwardDistance = 93.f
	DropDownForwardDistance = 145.f

	bDeferWeaponSwitch=TRUE
}
