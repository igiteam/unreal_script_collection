/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_Mantle_Base extends NanoSpecialMove
	native(SpecialMoves);

// TODO: comment these

var array<name>	WalkAnimNames, FallAnimNames;
var int			LastWalkAnimIdx, LastFallAnimIdx;
var float		LowCheckDistance;
var float		HighCheckDistance;
var float		MinHeight;
var float		MaxHeight;
var float		RequiredMinDistFromGround;
var array<EPhysics>	RequiredPhysics;
var vector		PostMantleVelocity;
var bool		bRestorePreMantleVelocity;
var bool		bForceCenterView;
var bool		bRequireClearance;
var float		MinRequiredSpeed;
var float		MaxSpeed;
var bool		bAllowJump;
var bool		bResetOnLanding;
var bool		bThirdPerson;
var array<Name>	CheckForMantleOnEnd;
var array<Name>	CheckForMantleContinuous;
var float		MaxVelocityZ;
var EMantleType	MantleType;
var bool		bImmediateLanding;
var bool		bRequireLandingClearance;
var transient bool		bDisabled;
var transient bool		bQueuedJump;
var float		MinAnimRate;
var float		MaxAnimRate;
var bool		bDebug;
var bool		bCanBeUsedByAI;
var bool        bCheckForPathInEditor;
var float		ClearanceDistance;
var Name		PostMantleFallSetName;
var bool		bManuallyTriggered;
var bool		bForcePostMantleVelocity;
var float		BlendInTime;
var float		BlendOutTime;
var EDirection	InputDirection;
var float		BufferDistance;
var bool		bAllowSlopes;
var float		ClothBlend;

var() Vector	WallNorm;
var() Actor		LedgeActor;
var() Name		AnimName;

/** How long it takes to move the camera to the desired rot. */
var() float CameraInterpTime;

cpptext
{
	/** Helper function for mantle traces */
	void MantleTraceHelper(FCheckResult& RealHit, const BYTE MantleType, const FVector TraceEnd, const FVector TraceStart, const FVector TraceExtent);
}



/** See if we have a ledge to mantle up on */
simulated native final function bool MantleLedgeCheck( Pawn P, vector PawnDir, out Vector out_WallNorm, out Actor out_LedgeActor, optional bool bFollowUpCheck, optional out Vector out_EndLocation );

protected function bool InternalCanDoSpecialMove()
{
	local EDirection InputDir;
	local NanoPC PC;

	if( `TimeSinceEx(MyNP,MyNP.LastLandingTime) < 0.25f || MyNP.bIsPlatformJumping )
	{
		return FALSE;
	}

	if( MantleType != MANTLE_BigStep )
	{
		PC = NanoPC(MyNP.Controller);
		if( PC != None && !MyNP.bIsDashing && MyNP.Physics == PHYS_Walking && !PC.IsButtonPressed(GB_A) )
		{
			return FALSE;
		}

		if( MyNP.CurrNanoState == ENS_Dense )
		{
			return FALSE;
		}
	}
	
	InputDir = DIR_Up;
	if( !MantleLedgeCheck( PawnOwner, GetDirectionVector(InputDir), WallNorm, LedgeActor, FALSE ) )
	{
		return FALSE;
	}

	return Super.InternalCanDoSpecialMove();
}

function bool CanOverrideMoveWith( Name NextMove )
{
	if( CheckForMantleContinuous.Find(NextMove) >= 0 || CheckForMantleOnEnd.Find(NextMove) >= 0 )
	{
		return TRUE;
	}

	return Super.CanOverrideMoveWith( NextMove );
}

final simulated function vector GetDirectionVector( EDirection InDir, optional bool bUpIsForward = TRUE )
{
	local vector X, Y, Z;

	MyNP.GetAxes( MyNP.Rotation, X, Y, Z );
	switch( InDir )
	{
		case DIR_Up:
			return bUpIsForward ? X : vect(0,0,1);
		case DIR_Left:
			return -Y;
		case DIR_Right:
			return Y;
	}

	return Vector(MyNP.Rotation);
}

function InitSpecialMoveFlags( out int out_Flags )
{
	out_Flags = 0;
	if( MyNP.Physics == PHYS_Walking )
	{
		out_Flags += (LastWalkAnimIdx << 16);
	}
	else
	{
		out_Flags = 1;
		out_Flags += (LastFallAnimIdx << 16);
	}
}

function ExtractSpecialMoveFlags( int Flags )
{
	local int AnimIdx;

	AnimIdx = (Flags >> 16);
	if( (Flags & 1) == 0 )
	{
		AnimName = WalkAnimNames[AnimIdx];
		LastWalkAnimIdx = (AnimIdx + 1) % WalkAnimNames.Length;
	}
	else
	{
		AnimName = FallAnimNames[AnimIdx];
		LastFallAnimIdx = (AnimIdx + 1) % FallAnimNames.Length;
	}
}

function SpecialMoveStarted( bool bForced, Name PrevMove )
{
	local NSM_Mantle_Base PrevSM;
	local bool bChainedMantle;

	Super.SpecialMoveStarted( bForced, PrevMove );

	PrevSM = NSM_Mantle_Base(MyNP.GetSpecialMoveByName(PrevMove));
	if( PrevSM != None )
	{
		bQueuedJump = PrevSM.bQueuedJump;
	}
	bChainedMantle = ((PrevSM!=None) || MyNP.bFallingFromMantle);

	ExtractSpecialMoveFlags( MyNP.SpecialMoveFlags );
	StartMantleUp( LedgeActor, AnimName, FALSE, bChainedMantle );
}

function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	local NSM_Mantle_Base NextSM;

	Super.SpecialMoveEnded( PrevMove, NextMove );

	if( MyNP.IsTimerActive( 'EndMantleUp', self ) )
	{
		NextSM = NSM_Mantle_Base(MyNP.GetSpecialMoveByName(NextMove));
		EndMantleUp((NextSM!=None)) ;
	}
}

simulated function bool IsJumpQueued()
{
	local NanoPC PC;
	local float PollTime, MantleStartTime;

	if( bQueuedJump )
	{
		return TRUE;
	}

	PC = NanoPC(MyNP.Controller);
	if( PC != None )
	{
		PollTime = PC.MainPlayerInput.PollInputBuffer(GB_A);
		MantleStartTime = `TimeSinceEx(MyNP,MyNP.LastMantleTime+0.1f);
		if( PollTime >= 0.f && PollTime < MantleStartTime )
		{
			return TRUE;
		}
	}

	return FALSE;
}

/** Start the mantle procedure */
simulated function StartMantleUp( Actor MantledObstacle, Name MantleAnimName, optional bool bAutoQueueJump, optional bool bChainedMantle )
{
	local NanoPC PC;
	local Rotator ViewRot;
	local vector ViewLoc;
	local float AnimTime, EffectiveAnimRate, InterpRate;
	local NanoSkill_Dash DashSkill;

	//`log(WorldInfo.TimeSeconds@`location@`showvar(CurrentMantleIndex)@`showvar(bAutoQueueJump));
	if( bChainedMantle )
	{
		InterpRate = MyNP.LastMantleAnimRate;
	}
	else
	{
		DashSkill = MyNP.GetSkill(class'NanoSkill_Dash');
		if( DashSkill != None )
		{
			InterpRate = VSize2D(MyNP.Velocity) / DashSkill.GetMaxSpeed(MyNP);
		}
		MyNP.LastMantleTime = MyNP.WorldInfo.TimeSeconds;
	}

	// make sure we always have a valid interp rate
	InterpRate = FMax(0.1,InterpRate);
	EffectiveAnimRate = Lerp(MinAnimRate,MaxAnimRate,InterpRate) * GetSpeedModifier();
	MyNP.LastMantleAnimRate = InterpRate;
	MyNP.bHandspringJump = FALSE;
	MyNP.bIsPlatformJumping = FALSE;
	bQueuedJump = bAutoQueueJump && bAllowJump;
	MyNP.MantleState = MantleType;

	// Turn off collision before moving pawn into position
	MyNP.bCollideWorld = FALSE;
	MyNP.SetCollision(TRUE,FALSE,FALSE);
	MyNP.bIgnoreForces = TRUE;
	
	// Rotate to face into the wall
	PC = NanoPC(MyNP.Controller);
	if( bForceCenterView && !MyNP.InFreeCam() )
	{
		WallNorm.Z = 0.0;
		WallNorm = Normal(WallNorm);
		MyNP.SetRotation( rotator(-WallNorm) );
		MyNP.SetDesiredRotation( MyNP.Rotation, TRUE );
		if( PC != None && MyNP.IsLocallyControlled() )
		{
			PC.GetPlayerViewPoint(ViewLoc, ViewRot);
			ViewRot.Yaw = MyNP.Rotation.Yaw;
			ViewRot.Pitch = -7000;
//			PC.InterpViewRotation( ViewRot, CameraInterpTime);
		}
	}
	// disable repeats of this mantle if it resets on landing
	if( bResetOnLanding )
	{
		bDisabled = TRUE;
	}

	// and copy the pre mantle velocity
	MyNP.PreMantleVelocity = MyNP.Velocity;
	if( PC == None )
	{
		// AI always move slower
		EffectiveAnimRate *= 0.85f;
	}

	// Turn off all collision for now and attach
	MyNP.SetPhysics(PHYS_None);

	//`log(`location@`showvar(EffectiveAnimRate));
	// Use root motion anim to climb up
	AnimTime = MyNP.FullBodySlot.PlayCustomAnim( MantleAnimName, EffectiveAnimRate, BlendInTime, -1.f, FALSE, TRUE );
	MyNP.FullBodySlot.SetRootBoneAxisOption(RBA_Translate, RBA_Translate, RBA_Translate);
	MyNP.Mesh.RootMotionMode = RMM_Translate;

	// Set how much cloth we want blended in
	MyNP.DesiredClothBlend = ClothBlend;

	MyNP.SetTimer( GetMantleDuration(AnimTime),FALSE,nameof(EndMantleUp),self);

	MyNP.FireMantleKismetEvents( MantledObstacle, WallNorm );

	if( bChainedMantle )
	{
		StartBufferJumpButton();
	}
	else
	{
		MyNP.SetTimer( 0.1f, FALSE, nameof(StartBufferJumpButton), self );
	}
}

simulated function StartBufferJumpButton()
{
	local NanoPC PC;

	MyNP.ClearTimer( nameof(StartBufferJumpButton), self );

	PC = NanoPC(MyNP.Controller);
	if( PC != None )
	{
		PC.MainPlayerInput.FilterInputBuffer( GB_A, TRUE );
	}
}

simulated function float GetMantleDuration( float AnimTime )
{
	return FMax( 0.1, AnimTime );
}

simulated function EndMantleUp( optional bool bChainMantle )
{
	local vector Extent, Loc;
	local int CheckIdx, Flags;
	local bool bJumpIsQueued;
	local Name Mantle;
	local NSM_Mantle_Base ChkMantle;
	local NanoPC PC;

	if( MyNP.MantleState == MANTLE_None )
	{
		return;
	}

	if( bForceCenterView )
	{
		MyNP.LockDesiredRotation( FALSE );
	}

	MyNP.ResetRunSyncGroup();
	//`log(`location@`showvar(bQueuedJump));
	// clean up and reset collision
	MyNP.ClearTimer(nameof(EndMantleUp),self);

	MyNP.MantleState = MANTLE_EndingMantle;

	MyNP.Mesh.RootMotionMode = RMM_Ignore;
	MyNP.FullBodySlot.SetRootBoneAxisOption(RBA_Discard,RBA_Discard,RBA_Discard);
	MyNP.FullBodySlot.StopCustomAnim(BlendOutTime);

	// Put cloth back to 100%
	MyNP.DesiredClothBlend = 1.0;

	MyNP.bCollideWorld = TRUE;
	MyNP.bIgnoreForces = FALSE;
	MyNP.SetCollision(TRUE,TRUE,FALSE);
	// make sure the player is in a valid spot
	Extent = MyNP.GetCollisionExtent();
	Loc = MyNP.Location;
	if( MyNP.FindSpot( Extent, Loc ) && Loc != MyNP.Location)
	{
		MyNP.MeshTranslationOffset += MyNP.Location - Loc;
		MyNP.Mesh.SetTranslation(MyNP.Mesh.default.Translation + MyNP.MeshTranslationOffset);
		//`log(`location@"moving to"@Loc@"from"@MyNP.Location@"offset:"@MyNP.MeshTranslationOffset);
		MyNP.SetLocation( Loc );
	}

	bJumpIsQueued = IsJumpQueued();

	if( MyNP.IsLocallyControlled() )
	{
		// Check for a followup animation immediately
		if( MyNP.ShouldCheckForMantles(NanoPC(MyNP.Controller),TRUE) )
		{
			foreach CheckForMantleOnEnd(Mantle)
			{
				ChkMantle = NSM_Mantle_Base(MyNP.GetSpecialMoveByName(Mantle));
				if( ChkMantle == None )
				{
					continue;
				}

				if( ChkMantle.CanDoSpecialMove( TRUE ) )
				{
					ChkMantle.InitSpecialMoveFlags( Flags );
					MyNP.DoSpecialMove( Mantle,,,, Flags );
					return;
				}
			}
		}
	}


	if( bImmediateLanding )
	{
		MyNP.SetPhysics( PHYS_Walking );
		// reset currently disabled mantles since we've 'landed'
		for( CheckIdx = 0; CheckIdx < MyNP.Mantles.Length; CheckIdx++ )
		{
			ChkMantle = NSM_Mantle_Base(MyNP.GetSpecialMoveByName(MyNP.Mantles[CheckIdx]));
			if( ChkMantle.bResetOnLanding )
			{
				ChkMantle.bDisabled = FALSE;
			}
		}
	}
	else
	{
		if( PostMantleFallSetName != 'None' )
		{
			MyNP.BlendFallNode.CopyAnimsFromSetByName(PostMantleFallSetName);
			MyNP.BlendFallNode.bResetFall = TRUE;
			MyNP.BlendFallNode.ChangeFallState(FBT_Up);
		}
		MyNP.SetPhysics( PHYS_Falling );
		MyNP.SetBase( None );
	}

	if( (bJumpIsQueued && bAllowJump) || MyNP.bHandspringJump )
	{
		HandleJumpAfterMantle();
	}
	else
	{
		if( bRestorePreMantleVelocity )
		{
			MyNP.Velocity = MyNP.PreMantleVelocity;
		}

		MyNP.MantleState = MANTLE_None;
		MyNP.bFallingFromMantle = TRUE;
	}

	MyNP.bHandspringJump = FALSE;
	MyNP.MantleDir = vect(0,0,0);

	//`log(`location@`showvar(MyNP.Velocity));

	// check for a normal jump
	if( !bAllowJump || !bJumpIsQueued || bForcePostMantleVelocity )
	{
		// temp scaling of the wall run boost based on the entry speed
		if( MantleType == MANTLE_WallRun )
		{
			PostMantleVelocity.Z = default.PostMantleVelocity.Z * FClamp(VSize2D(MyNP.PreMantleVelocity)/MyNP.GetSkill(class'NanoSkill_Dash').GetMaxSpeed(MyNP),0.75,2.f);
			MyNP.BlendFallNode.CopyAnimsFromSetByName('WallRunJump');
			MyNP.BlendFallNode.bResetFall = TRUE;
			MyNP.BlendFallNode.ChangeFallState(FBT_Up);
		}
		else
		{
			MyNP.bJumpSetIsDirty = TRUE;
		}
		// one time boost to nudge her forward, since we lose velocity once turning RM off
		MyNP.Velocity += PostMantleVelocity >> MyNP.Rotation;
	}
	
	MyNP.EndSpecialMove();

	PC = NanoPC(MyNP.Controller);
	if( PC != None && MyNP.MantleState == MANTLE_None )
	{
		PC.MainPlayerInput.FilterInputBuffer( GB_A, FALSE, TRUE );

		// finished mantle, nothing else going on, so level the camera
//		PC.LevelViewRotation(0.5f);
	}
}

simulated function HandleJumpAfterMantle()
{
	// check early for a special (vault) jump
	if( NanoPlayerInput(PlayerController(MyNP.Controller).PlayerInput).AttemptJump() )
	{
		if( MyNP.bHandspringJump )
		{
			//`log("flipping from mantle");
			MyNP.MantleState = MANTLE_FlipJump;
			MyNP.BlendFallNode.CopyAnimsFromSetByName('FlipJump');
			MyNP.BlendFallNode.bResetFall = TRUE;
			MyNP.BlendFallNode.ChangeFallState( FBT_Up );
			MyNP.SetTimer( 0.5f, FALSE, nameof(MyNP.UpdateJumpAnimSet) );
		}
		else
		{
			//`log("jumping from mantle!");
			MyNP.MantleState = MANTLE_Jump;
			if( MantleType == MANTLE_WallRun )
			{
				MyNP.BlendFallNode.CopyAnimsFromSetByName('WallRunJump');
				MyNP.BlendFallNode.bResetFall = TRUE;
				MyNP.BlendFallNode.ChangeFallState(FBT_Up);
			}
		}
	}
}


simulated function CheckHandspringTransition()
{
	if( IsJumpQueued() && MantleType == MANTLE_Ledge )
	{
		MyNP.SetTimer( 0.0001, FALSE, nameof(self.TransitionToHandspring), self );
	}
}

simulated function TransitionToHandspring()
{
	local NanoPC PC;

	MyNP.bHandspringJump = TRUE;
	EndMantleUp(FALSE);

	PC = NanoPC(MyNP.Controller);
	if( PC != None )
	{
		PC.MainPlayerInput.FilterInputBuffer( GB_A, FALSE, TRUE );
	}
}

simulated function RootMotionExtracted(SkeletalMeshComponent SkelComp, out BoneAtom ExtractedRootMotionDelta)
{
	//@todo - at some point refactor this into a matrix on the component to be applied before normal rotation translation
	if( InputDirection == DIR_Up && !IsZero(MyNP.MantleDir) )
	{
		//`log(`location@`showvar(MyNP.MantleDir)@`showvar(MyNP.Rotation));
		ExtractedRootMotionDelta.Translation = (vect(0,0,1) * ExtractedRootMotionDelta.Translation) + (((vect(1,1,0) * ExtractedRootMotionDelta.Translation) << MyNP.Rotation) >> Rotator(MyNP.MantleDir));
	}
}


defaultproperties
{
	bCanBeUsedByAI=TRUE
	bCheckForPathInEditor=TRUE
	CameraInterpTime=0.35f
	bDebug=FALSE
}