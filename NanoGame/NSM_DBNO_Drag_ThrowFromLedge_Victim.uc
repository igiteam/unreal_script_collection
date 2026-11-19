/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_DBNO_Drag_ThrowFromLedge_Victim extends NSM_DBNO_InteractionVictimBase;


/**
 * Can a new special move override this one before it is finished?
 * This is only if CanDoSpecialMove() == TRUE && !bForce when starting it.
 */
function bool CanOverrideMoveWith( Name NewMove )
{
	//`log( GetFuncName() @ `showvar(NewMove) );

	return FALSE;
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



function SpecialMoveStarted( bool bForced, Name PrevMove )
{
	local Vector RelLoc;

	Super(NanoSpecialMove).SpecialMoveStarted( bForced, PrevMove );

	MyNP.StopFiring();
	MyNP.ZeroMovementVariables();

	MyNP.SetPhysics( PHYS_None );
	MyNP.SetRotation( MyNP.InteractionPawn.Rotation - rot(0,0,0) );
	MyNP.SetDesiredRotation( MyNP.InteractionPawn.Rotation - rot(0,0,0));
	MyNP.SetHardAttach( TRUE );
	MyNP.SetBase( MyNP.InteractionPawn,, MyNP.InteractionPawn.Mesh, 'b_MF_Attach' );

	RelLoc = MyNP.Location - MyNP.Mesh.GetBoneLocation( 'b_MF_Root' );
	MyNP.SetRelativeLocation( RelLoc );

	PlayGrabbedAnimation();
}




// we don't want to play any of the "ending" animations and other code when we end the special move so go back to DBNO if we end this
function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	//`log( "DIE DIE DIE DIE DIE FROM THROW" );
	// gore explode him?
	MyNP.Died( MyNP.ControllerWhoPutMeDBNO, class'NDT_DBNO_Death', MyNP.Location );
}


simulated function PlayGrabbedRelease()
{
	local float AnimTime;


	`log( "ENDING VICTIM BASEE" );
	ScriptTrace();


	MyNP.SetHardAttach( MyNP.default.bHardAttach );
	MyNP.SetPhysics( PHYS_Walking );
	MyNP.SetBase( None );

	MyNP.RunningFullBodySlot.StopCustomAnim(0.1f);
	MyNP.FullBodySlot.SetRootBoneAxisOption( RBA_Translate, RBA_Translate, RBA_Translate );
	MyNP.Mesh.RootMotionMode = RMM_Translate;

	AnimTime = MyNP.FullBodySlot.PlayCustomAnim( VictimGrabEscapeAnim, GetSpeedModifier(), 0.1, -1.f, FALSE, TRUE );

	if( AnimTime <= 0.f )
	{
		`log( `location@"ERROR: got invalid anim time" );
		// Failsafe to make sure timers don't break;
		AnimTime = 0.1;
	}


	MyNP.Mesh.RootMotionMode = RMM_Translate;
	MyNP.FullBodySlot.SetRootBoneAxisOption( RBA_Translate, RBA_Translate, RBA_Translate );

	MyNP.SetTimer( AnimTime, FALSE, nameof(FinishSpecialMove), self );

	NanoGRI(MyNP.WorldInfo.GRI).ResetFOV();
}



defaultproperties
{
	VictimGrabSuccessStartAnim="DBNO_DragToEdge_Start"
	VictimGrabSuccessLoopAnim="DBNO_DragToEdge_Loop"
	VictimGrabReleaseAnim="DBNO_DragToEdge_End"
	VictimGrabEscapeAnim="DBNO_DragToEdge_End"
}
