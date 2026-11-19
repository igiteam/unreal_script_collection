/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_Melee_GrabVictim extends NanoSpecialMove;

var transient   Name	    VictimGrabSuccessStartAnim;
var transient   Name	    VictimGrabSuccessLoopAnim;
var transient   Name	    VictimGrabReleaseAnim;
var transient   Name	    VictimGrabEscapeAnim;



/**
 * Can this special move override InMove if it is currently playing?
 */
function bool CanOverrideSpecialMove( Name InMove )
{
	if( ( InMove == 'NSM_Melee_HitReaction' )
		)
	{
		return FALSE;
	}

	return TRUE;
}



function SpecialMoveStarted( bool bForced, Name PrevMove )
{
	local Vector RelLoc;

	Super.SpecialMoveStarted( bForced, PrevMove );

	MyNP.StopFiring();
	MyNP.ZeroMovementVariables();
	
	MyNP.SetPhysics( PHYS_None );
	MyNP.SetRotation( MyNP.InteractionPawn.Rotation );
	MyNP.SetDesiredRotation( MyNP.InteractionPawn.Rotation );
	MyNP.SetHardAttach( TRUE );
	MyNP.SetBase( MyNP.InteractionPawn,, MyNP.InteractionPawn.Mesh, 'b_MF_Attach' );

	RelLoc = MyNP.Location - MyNP.Mesh.GetBoneLocation( 'b_MF_Root' );
	MyNP.SetRelativeLocation( RelLoc );
	
	PlayGrabbedAnimation();
}

function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	MyNP.ClearTimer( nameof(PlayGrabbedLoopAnimation), self );
	MyNP.ClearTimer( nameof(FinishSpecialMove), self );

	MyNP.FullBodySlot.StopCustomAnim( 0.25f );
	MyNP.Mesh.RootMotionMode = MyNP.default.Mesh.RootMotionMode;
	MyNP.FullBodySlot.SetRootBoneAxisOption( RBA_Discard, RBA_Discard, RBA_Discard );

	MyNP.LastGrabbedTime = MyNP.WorldInfo.TimeSeconds;

	Super.SpecialMoveEnded( PrevMove, NextMove );
}

function FinishSpecialMove()
{
	MyNP.EndSpecialMove();
}

simulated function PlayGrabbedAnimation()
{
	local float AnimTime;

	MyNP.RunningFullBodySlot.StopCustomAnim(0.1f);
	MyNP.FullBodySlot.SetRootBoneAxisOption( RBA_Discard, RBA_Discard, RBA_Discard );

	AnimTime = MyNP.FullBodySlot.PlayCustomAnim( VictimGrabSuccessStartAnim, GetSpeedModifier(), 0.1, -1.f, FALSE, TRUE );
	MyNP.Mesh.RootMotionMode = MyNP.default.Mesh.RootMotionMode;
	MyNP.FullBodySlot.SetRootBoneAxisOption( RBA_Discard, RBA_Discard, RBA_Discard );

	MyNP.SetTimer( AnimTime, FALSE, nameof(PlayGrabbedLoopAnimation), self );
}

simulated function PlayGrabbedLoopAnimation()
{
	MyNP.FullBodySlot.PlayCustomAnim( VictimGrabSuccessLoopAnim, GetSpeedModifier(), 0.f, -1.f, TRUE, TRUE );
	MyNP.Mesh.RootMotionMode = MyNP.default.Mesh.RootMotionMode;
	MyNP.FullBodySlot.SetRootBoneAxisOption( RBA_Discard, RBA_Discard, RBA_Discard );
}

simulated function PlayGrabbedRelease()
{
	local float AnimTime;
	
	MyNP.SetHardAttach( MyNP.default.bHardAttach );
	MyNP.SetPhysics( PHYS_Walking );
	MyNP.SetBase( None );

	MyNP.RunningFullBodySlot.StopCustomAnim(0.1f);
	MyNP.FullBodySlot.SetRootBoneAxisOption( RBA_Discard, RBA_Discard, RBA_Discard );

	AnimTime = MyNP.FullBodySlot.PlayCustomAnim( VictimGrabEscapeAnim, GetSpeedModifier(), 0.1, -1.f, FALSE, TRUE );

	if( AnimTime <= 0.f )
	{
		`log( `location@"ERROR: got invalid anim time" );
		// Failsafe to make sure timers don't break;
		AnimTime = 0.1;
	}

	MyNP.Mesh.RootMotionMode = RMM_Accel;
	MyNP.FullBodySlot.SetRootBoneAxisOption( RBA_Translate, RBA_Translate, RBA_Translate );

	MyNP.SetTimer( AnimTime, FALSE, nameof(FinishSpecialMove), self );

	NanoGRI(MyNP.WorldInfo.GRI).ResetFOV();
}

defaultproperties
{
	VictimGrabSuccessStartAnim="Hit_Grab_Behind_Success_Start"
	VictimGrabSuccessLoopAnim="Hit_Grab_Behind_Success_Loop"
	VictimGrabReleaseAnim="Hit_Grab_Behind_Escape"
	VictimGrabEscapeAnim="Hit_Grab_Behind_Escape"
}
