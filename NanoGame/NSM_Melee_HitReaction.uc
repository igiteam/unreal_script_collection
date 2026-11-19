/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_Melee_HitReaction extends NSM_PlaySingleAnim_Base;

var transient HitReactionInfo HRI;

/** Whether or not we can end the move early when we are mashing buttons or moving left stick **/
var transient bool bCanEndMoveEarlyWithInput;


function GetHitReactionStruct( out HitReactionInfo out_HRI )
{
	out_HRI = MyNP.HitReaction;
}

/**
 * Can this special move override InMove if it is currently playing?
 */
function bool CanOverrideSpecialMove( Name InMove )
{
	return TRUE;
}

/**
 * We want to have hit reactions be overrideable by other hit reactions.  So if you do a leg sweep you get the leg sweet anim
 * even if the foe is already doing a knockback anim.
 */
function bool CanOverrideMoveWith( Name NewMove )
{
	if( NewMove == 'NSM_Melee_HitReaction' )
	{
		return TRUE;
	}

	if( NewMove == 'NSM_StunnedAndDazed_AI' )
	{
		return TRUE;
	}

	if( NewMove == 'NSM_DBNO' )
	{
		return TRUE;
	}

	return Super.CanOverrideMoveWith( NewMove );
}


function float GetSpeedModifier()
{
	return Super.GetSpeedModifier() * HRI.PlayRate;
}

function SpecialMoveStarted( bool bForced, Name PrevMove )
{
	local Vector KnockbackVel;
	local float JuggleMag, JuggleZ;
	local Vector JuggleDir;

	GetHitReactionStruct( HRI );

	MyNP.bStunned = TRUE;
	MyNP.bPlayingHitReaction = TRUE;
	MyNP.StopFiring();
	MyNP.ZeroMovementVariables();

	MyNP.TimeOfStun = MyNP.WorldInfo.TimeSeconds;
	MyNP.SetDesiredRotation( MyNP.Rotation, TRUE );
	MyNP.Controller.Focus = None;

	AnimName = HRI.AnimName;
	AnimPosition = HRI.Position;
	BlendInTime = 0.0f;
	BlendOutTime = 0.25f;


	//// Root Motion Settings

	// see if we have an overridden root motion curve
	if( HRI.OverrideRootMotionCurveType != RMCT_None )
	{
		`log( "RootMotionOverride: Using" @ `showvar(HRI.OverrideRootMotionCurveType) );
		SetRootMotionCurveOverrideOnPawn( HRI.OverrideRootMotionCurveType );
	}

	RBA_X = HRI.RootBoneOption[0];
	RBA_Y = HRI.RootBoneOption[1];
	RBA_Z = HRI.RootBoneOption[2];
	RMM = HRI.RootMotionMode;

	//`log( GetFuncName() @ `showvar(AnimName) @ `showvar(HRI.RootMotionScale) );

	RootMotionScaleFactor = HRI.RootMotionScale;

	if( HRI.PhysicsOnStart != PHYS_Unused )
	{
		MyNP.SetPhysics( HRI.PhysicsOnStart );
	}

	KnockbackVel = HRI.VelocityOnStart;
	if( !IsZero( KnockbackVel ) )
	{
		KnockbackVel = KnockbackVel >> Rotator(MyNP.Location - HRI.Attacker.Location);
		JuggleMag = VSize2D(KnockbackVel);
		JuggleZ = KnockbackVel.Z;
		JuggleDir = KnockbackVel;
		JuggleDir.Z = 0;
		JuggleDir = Normal(JuggleDir);

		// Use juggle mechanic for knock back so that it auto aims juggle victim towards targets
		MyNP.ResolveJuggleVars( HRI.Attacker.Controller, JuggleMag, JuggleZ, JuggleDir, TRUE );
		MyNP.ApplyJuggle( JuggleMag, JuggleZ, JuggleDir, NanoPawn(HRI.Attacker) );
	}

	// Stop running animations
	MyNP.RunningFullBodySlot.StopCustomAnim(BlendInTime);
	MyNP.FallingFullBodySlot.StopCustomAnim(BlendInTime);

	Super.SpecialMoveStarted( bForced, PrevMove );


	// if we have a looping anim set
	if( HRI.AnimNameLoop != '' )
	{
		// so this needs to be play the start anim
		// blend to looping
		// loop for N seconds
		// blend to end
		PlayAnimationStart();
	}
	// play the normal hit reaction anim
	else
	{
		PlayAnimation();
	}

}


function float PlayAnimation()
{
	local float AnimTime;

	AnimTime = Super.PlayAnimation();

	// so here we duplicate the check from the NSM_PlaySingleAnim_Base and then
	// if we are going to be stunned after we move up the stunned anim to have it start the new special move
	// before the hit reaction ends
	if( bLooping == FALSE  )
	{
		if( HRI.bPostHitReactionStunned == TRUE )
		{
			MyNP.SetTimer( (AnimTime * 0.5f), FALSE, nameof(EndThisSpecialMove), self );
		}
	}

	return AnimTime;
}



function float PlayAnimationStart()
{
	local AnimNodeSequence Seq;
	local float AnimTime;
	local float AnimRate;

	//`log( "PlayAnimationStartPlayAnimationStartPlayAnimationStartPlayAnimationStart" );

	AnimRate = GetSpeedModifier();

	// Ignore root motion for other slot anim so blend doesn't cause a pop
	CachedSlot.SetRootBoneAxisOption( RBA_Discard, RBA_Discard, RBA_Discard );

	AnimTime = CachedSlot.PlayCustomAnim( HRI.AnimNameStart, AnimRate, 0.1f, -1.f, FALSE, TRUE, StartTime, EndTime );
	AnimTime -= (AnimPosition * AnimRate);
	AnimTime = FMax( AnimTime, 0.1f );

	Seq = CachedSlot.GetCustomAnimNodeSeq();
	Seq.SetPosition( AnimPosition, TRUE );

	// Setup root motion
	MyNP.Mesh.RootMotionMode = RMM;
	CachedSlot.SetRootBoneAxisOption( RBA_X, RBA_Y, RBA_Z );

	MyNP.SetTimer( AnimTime, FALSE, nameof(PlayAnimationLooping), self );
	
	return AnimTime;
}


function float PlayAnimationLooping()
{
	local AnimNodeSequence Seq;
	local float AnimTime;
	local float AnimRate;

	//`log( "PlayAnimationLoopingPlayAnimationLoopingPlayAnimationLoopingPlayAnimationLoopingPlayAnimationLoopingPlayAnimationLooping" );

	AnimRate = GetSpeedModifier();

	// Ignore root motion for other slot anim so blend doesn't cause a pop
	CachedSlot.SetRootBoneAxisOption( RBA_Discard, RBA_Discard, RBA_Discard );

	AnimTime = CachedSlot.PlayCustomAnim( HRI.AnimNameLoop, AnimRate, 0.1f, -1.f, bLooping, TRUE, StartTime, EndTime );
	AnimTime -= (AnimPosition * AnimRate);
	AnimTime = FMax( AnimTime, 0.1f );

	Seq = CachedSlot.GetCustomAnimNodeSeq();
	Seq.SetPosition( AnimPosition, TRUE );

	// Setup root motion
	MyNP.Mesh.RootMotionMode = RMM;
	CachedSlot.SetRootBoneAxisOption( RBA_X, RBA_Y, RBA_Z );

	// hack
	MyNP.SetTimer( HRI.AnimLoopTime, FALSE, nameof(PlayAnimationEnd), self );

	return AnimTime;
}


function float PlayAnimationEnd()
{
	local AnimNodeSequence Seq;
	local float AnimTime;
	local float AnimRate;

	//`log( "PlayAnimationEndPlayAnimationEndPlayAnimationEndPlayAnimationEndPlayAnimationEndPlayAnimationEnd" );

	AnimRate = GetSpeedModifier();

	// Ignore root motion for other slot anim so blend doesn't cause a pop
	CachedSlot.SetRootBoneAxisOption( RBA_Discard, RBA_Discard, RBA_Discard );

	AnimTime = CachedSlot.PlayCustomAnim( HRI.AnimNameEnd, AnimRate, 0.1f, 0.1f, FALSE, TRUE, StartTime, EndTime );
	AnimTime -= (AnimPosition * AnimRate);
	AnimTime = FMax( AnimTime, 0.1f );

	Seq = CachedSlot.GetCustomAnimNodeSeq();
	Seq.SetPosition( AnimPosition, TRUE );

	// Setup root motion
	MyNP.Mesh.RootMotionMode = RMM;
	CachedSlot.SetRootBoneAxisOption( RBA_X, RBA_Y, RBA_Z );

	MyNP.SetTimer( AnimTime, FALSE, nameof(EndThisSpecialMove), self );

	bCanEndMoveEarlyWithInput = TRUE;
	
	// If movement was disabled, toggle it back on
	if( bMovementDisabled == TRUE )
	{
		SetMovementLock( FALSE );
	}

	return AnimTime;
}


function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	bCanEndMoveEarlyWithInput = FALSE;

	MyNP.bPlayingHitReaction = FALSE;
	MyNP.bStunned = FALSE;
	MyNP.LockDesiredRotation( FALSE );

	Super.SpecialMoveEnded( PrevMove, NextMove );

	// clear timers for AnimLooping vars
	MyNP.ClearTimer( nameof(PlayAnimationLooping), self );
	MyNP.ClearTimer( nameof(PlayAnimationEnd), self );
	MyNP.ClearTimer( nameof(EndThisSpecialMove), self );


	// here we want to check to see if we should "chain" into the NSM specified by the HitReaction
	if( HRI.bPostHitReactionStunned == TRUE )
	{
		MyNP.DoSpecialMove( 'NSM_StunnedAndDazed_AI', TRUE );
	}	

	// turn off root motion override if we actually overode it
	if( HRI.OverrideRootMotionCurveType != RMCT_None )
	{
		MyNP.bRootMotionFromInterpCurve = FALSE;
	}
}

simulated function RootMotionExtracted(SkeletalMeshComponent SkelComp, out BoneAtom ExtractedRootMotionDelta)
{
	ExtractedRootMotionDelta.Translation *= HRI.RootMotionScale;
}


/** Gives the special move a chance to intercept and trap input.  Returns TRUE if the input should NOT be passed on */
function bool FilterButtonInput(Name ButtonName,bool bPressed,int ButtonIdx)
{
	if( bCanEndMoveEarlyWithInput == TRUE )
	{
		//`log( "FilterButtonInput Ending due to" @ `showvar(bCanEndMoveEarlyWithInput) );
		EndThisSpecialMove();
		return FALSE;
	}

	return FALSE;
}



function Tick( float DeltaTime )
{
	local bool bIsPlayerMovingLeftStick;
	local NanoPC PC;

	Super.Tick( DeltaTime );

	// check to see if we need to EndThisSpecial move due to stick movement
	if( bCanEndMoveEarlyWithInput == TRUE )
	{
		PC = NanoPC(MyNP.Controller);

		if( PC != None )
		{
			// check for left stick position
			// if it is "moved" then we end the move early
			bIsPlayerMovingLeftStick = (Abs(PC.PlayerInput.RawJoyUp) > 0.2f || Abs(PC.PlayerInput.RawJoyRight) > 0.2f);
			if( bIsPlayerMovingLeftStick == TRUE )
			{
				//`log( "FilterButtonInput Ending due to" @ `showvar(bIsPlayerMovingLeftStick) );
				EndThisSpecialMove();
			}
		}
	}

}





defaultproperties
{
	bAutoPlayAnimation=FALSE // we will take care of the logic of playing the normal anim or a looping anim start loop end group
	
	bDisableMovement=TRUE
}