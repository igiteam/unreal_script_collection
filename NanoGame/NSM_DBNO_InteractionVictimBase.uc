/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_DBNO_InteractionVictimBase extends NanoSpecialMove
	abstract;

var transient   Name	    VictimGrabSuccessStartAnim;
var transient   Name	    VictimGrabSuccessLoopAnim;
var transient   Name	    VictimGrabReleaseAnim;
var transient   Name	    VictimGrabEscapeAnim;

/** Whether or not we should kill the pawn at the end of the special move **/
var bool bShouldKillOnEndOfSpecialMove;


function bool CanChainMove( Name NextMove )
{
	if( ( MyNP.IsInState( 'DBNO' ) ) && ( NextMove == 'NSM_DBNO' ) )
	{
		return TRUE;
	}

	return Super.CanChainMove( NextMove );
}


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
	MyNP.SetRotation( MyNP.InteractionPawn.Rotation - rot(0,32768,0) );
	MyNP.SetDesiredRotation( MyNP.InteractionPawn.Rotation - rot(0,32768,0));
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

	`log( "VICTIM MOVE ENDED" );
	ScriptTrace();

	Super.SpecialMoveEnded( PrevMove, NextMove );
}

function FinishSpecialMove()
{
	MyNP.EndSpecialMove();

	if( bShouldKillOnEndOfSpecialMove == TRUE )
	{
		MyNP.Died( MyNP.ControllerWhoPutMeDBNO, MyNP.DamageTypeThatPutMeDBNO, MyNP.Location );
	}

}

simulated function PlayGrabbedAnimation()
{
	//local float AnimTime;

	MyNP.RunningFullBodySlot.StopCustomAnim(0.1f);
	MyNP.FullBodySlot.SetRootBoneAxisOption( RBA_Discard, RBA_Discard, RBA_Discard );

	//AnimTime = 
	MyNP.FullBodySlot.PlayCustomAnim( VictimGrabSuccessStartAnim, GetSpeedModifier(), 0.1, -1.f, FALSE, TRUE );
	MyNP.Mesh.RootMotionMode = MyNP.default.Mesh.RootMotionMode;
	MyNP.FullBodySlot.SetRootBoneAxisOption( RBA_Discard, RBA_Discard, RBA_Discard );

	MyNP.SetTimer( 0.1f, FALSE, nameof(PlayGrabbedLoopAnimation), self );
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

}
