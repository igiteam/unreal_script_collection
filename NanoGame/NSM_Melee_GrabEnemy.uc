/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_Melee_GrabEnemy extends NSM_InteractionLeader_Base
	config(Pawn);

var config      Vector2D    GrabDurationRange;
var transient   float		GrabTimeRemaining;
var transient   float		GrabStartTime;

var transient   Name	    AttackerGrabSuccessStartAnim;
var transient   Name	    AttackerGrabSuccessLoopAnim;
var transient   Name	    AttackerGrabReleaseAnim;
var transient   Name	    AttackerGrabEscapeAnim;

var transient   bool		bWasVictimAttempingEscape;
var transient   bool		bDidEscapeRotation;
var transient   bool		bBreakFreeEscape;

/** We need to know whether or not the victim broke free from the grab for our safe guard to not fire all the time. **/
var transient bool bSuccessFullyBrokeFree;

/** How long until the player is allowed to have their X mashing affect the grab **/
var config float MinDurationOfGrab;

protected function bool InternalCanDoSpecialMove()
{
	return TRUE;
}

function StartInteraction()
{
	local float AnimTime;
	local NanoGRI GRI;

	bBreakFreeEscape = FALSE;
	bDidEscapeRotation = FALSE;
	GrabTimeRemaining = RandRange( GrabDurationRange.X, GrabDurationRange.Y );
	GrabStartTime = MyNP.WorldInfo.TimeSeconds;

	MyNP.ZeroMovementVariables();
	MyNP.Controller.Focus = None;
	
	MyNP.FullBodySlot.SetRootBoneAxisOption( RBA_Discard, RBA_Discard, RBA_Discard );
	AnimTime = MyNP.FullBodySlot.PlayCustomAnim( AttackerGrabSuccessStartAnim, GetSpeedModifier(), 0.f, -1.f, FALSE, TRUE );
	if( AnimTime <= 0.f )
	{
		`log( `location@"ERROR: got invalid anim time" );
		// Failsafe to make sure timers don't break;
		AnimTime = 0.1;
	}

	// Setup root motion
	MyNP.Mesh.RootMotionMode = RMM_Accel;
	MyNP.FullBodySlot.SetRootBoneAxisOption( RBA_Translate, RBA_Translate, RBA_Translate );

	MyNP.SetTimer( AnimTime, FALSE, nameof(PlayGrabSuccessLoopAnimation), self );

	GRI = NanoGRI(MyNP.WorldInfo.GRI);
	if( GRI != None )
	{
		GRI.GetMusicManager().HandleMusicEvent( EME_PlayerIsHeldByTrooper );
		GRI.AttemptToPlayLine( EDLine_Combat_MeleeCircle_HoldPlayer, MyNP );	
		GRI.AIBlackboard.HandleCombatEvent( NCAT_PlayerWasGrabbed, NanoAIBase(MyNP.Controller) );
	}
}

function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	MyNP.ClearTimer( nameof(GotoRagdollAfterRelease), self );
	MyNP.ClearTimer( nameof(FinishGrabAttack), self );
	MyNP.ClearTimer( nameof(PlayPlayerEscapedFromGrabAndIsReadyToKillAgain), self );

	if( Follower != None )
	{
		Follower.EndSpecialMove();
	}
	
	Super.SpecialMoveEnded( PrevMove, NextMove );
}


function PlayGrabSuccessLoopAnimation()
{
	MyNP.ClearTimer( nameof(PlayGrabSuccessLoopAnimation), self );
	MyNP.ZeroMovementVariables();

	MyNP.FullBodySlot.SetRootBoneAxisOption( RBA_Discard, RBA_Discard, RBA_Discard );
	MyNP.FullBodySlot.PlayCustomAnim( AttackerGrabSuccessLoopAnim, GetSpeedModifier(), 0.f, -1.f, TRUE, TRUE );

	// Setup root motion
	MyNP.Mesh.RootMotionMode = MyNP.default.Mesh.RootMotionMode;
	MyNP.FullBodySlot.SetRootBoneAxisOption( RBA_Discard, RBA_Discard, RBA_Discard );
}

function PlayGrabReleaseAnimation( bool bBrokeFree )
{
	local float AnimTime, BlendInTime;

	// Ignore root motion for other slot anim so blend doesn't cause a pop
	MyNP.FullBodySlot.SetRootBoneAxisOption( RBA_Discard, RBA_Discard, RBA_Discard );

	MyNP.bRecoveringFromMeleeAttack = TRUE;
	MyNP.bJuggled = TRUE;

	// Play anim and return duration
	BlendInTime = 0.1f;
	AnimTime = MyNP.FullBodySlot.PlayCustomAnim( (bBrokeFree ? AttackerGrabEscapeAnim : AttackerGrabReleaseAnim), GetSpeedModifier(), BlendInTime, -1.f, FALSE, TRUE );
	if( AnimTime <= 0.f )
	{
		`log( `location@"ERROR: got invalid anim time" );
		// Failsafe to make sure timers don't break;
		AnimTime = 0.1;
	}

	// Setup root motion
	MyNP.Mesh.RootMotionMode = RMM_Accel;
	MyNP.FullBodySlot.SetRootBoneAxisOption( RBA_Translate, RBA_Translate, RBA_Translate );

	// Both escape animations are throws, so always play the dialogue line
	NanoGRI(MyNP.WorldInfo.GRI).AttemptToPlayLine(EDLine_Combat_MeleeCircle_ThrownByPlayer, MyNP);
	
	MyNP.SetTimer( AnimTime * 0.9f, FALSE, nameof(GotoRagdollAfterRelease), self );
	MyNP.SetTimer( AnimTime, FALSE, nameof(FinishGrabAttack), self );
	MyNP.SetTimer( AnimTime, FALSE, nameof(PlayPlayerEscapedFromGrabAndIsReadyToKillAgain), self );
}

function FinishGrabAttack()
{
	MyNP.EndSpecialMove();
}

function GotoRagdollAfterRelease()
{
	MyNP.Knockdown( 1.f + FRand() * 2.f );
	MyNP.LastGrabAttemptTime = MyNP.WorldInfo.TimeSeconds;
}

function PlayPlayerEscapedFromGrabAndIsReadyToKillAgain()
{
	NanoGRI(MyNP.WorldInfo.GRI).GetMusicManager().HandleMusicEvent( EME_PlayerStartsAttackingWithSword );
}

function SetEscapeRotation()
{
	local NanoPC PC;
	local Vector	FindLoc;
	local Rotator	FindRot, ThrowRot;
	local Actor TargetedActor;

	ThrowRot = Follower.Rotation;

	PC = NanoPC(Follower.Controller);
	if( PC != None && (Abs(PC.PlayerInput.RawJoyUp) > 0.2f || Abs(PC.PlayerInput.RawJoyRight) > 0.2f) )
	{
		// Setup search loc/rot
		PC.GetActorEyesViewPoint(FindLoc,FindRot);
		FindLoc = Follower.Location;
		FindRot = Rotator((vect(0,0,1) * PC.PlayerInput.RawJoyUp + vect(0,1,0) * PC.PlayerInput.RawJoyRight) >> FindRot);

		// Try to select in a "foward" cone - forward determined first by input
		TargetedActor = PC.SelectTarget_Worker( PC.MeleeStickRateTarget, 512.f, 0.5f, FindLoc, FindRot );
		
		ThrowRot = FindRot;
		if( TargetedActor != None )
		{
			ThrowRot = Rotator(TargetedActor.Location-Follower.Location);
		}
	}

//	FlushPersistentDebugLines();
//	DrawDebugLine( FindLoc, FindLoc + Vector(FindRot) * 128.f, 255, 0, 0, TRUE );
//	DrawDebugLine( FindLoc + vect(0,0,10), FindLoc + vect(0,0,10) + Vector(ThrowRot) * 128.f, 0, 255, 0, TRUE );
//	`log( `showvar(TargetedActor)@`showvar(Instigator)@`showvar(Follower) );

	ThrowRot = Normalize(ThrowRot);
	ThrowRot.Pitch = 0;
	ThrowRot.Roll = 0;
	Follower.SetDesiredRotation( ThrowRot, TRUE, TRUE, 0.1f );
	MyNP.SetDesiredRotation( ThrowRot, TRUE, TRUE, 0.1f );
	MyNP.Controller.SetFocalPoint( MyNP.Location + Vector(ThrowRot) * 512.f );
}

function ReleaseFromGrab( bool bBrokeFree )
{
	local NSM_Melee_GrabVictim GV;

	GV = NSM_Melee_GrabVictim(Follower.ActiveSpecialMove);
	if( GV != None )
	{
		GV.PlayGrabbedRelease();
		Follower = None;
	}
	
	PlayGrabReleaseAnimation( bBrokeFree );
}

simulated function Tick( float DeltaTime )
{
	local NanoPC VictimPC;
	local float	TimeScale;
	
	Super.Tick( DeltaTime );

	TimeScale = 1.f;
	if( Follower != None && `TimeSinceEx( MyNP, GrabStartTime ) > MinDurationOfGrab )
	{
		VictimPC = NanoPC(Follower.Controller);
		if( VictimPC != None && !bDidEscapeRotation )
		{
			if( VictimPC.IsButtonActive( GB_X ) )
			{
				GrabTimeRemaining = -1.f;
				bBreakFreeEscape = TRUE;

				bWasVictimAttempingEscape = TRUE;
			}
			else
			{
				bWasVictimAttempingEscape = FALSE;
			}
		}

		GrabTimeRemaining -= DeltaTime * TimeScale;
		if( GrabTimeRemaining <= 0.f )
		{
			if( !bDidEscapeRotation )
			{
				bDidEscapeRotation = TRUE;
				if( bBreakFreeEscape )
				{
					SetEscapeRotation();						
					GrabTimeRemaining = 0.f;
					bSuccessFullyBrokeFree = TRUE;
				}
				else
				{
					GrabTimeRemaining = -1.f;
				}
			}
			else if( GrabTimeRemaining < -0.1f )
			{
				bBreakFreeEscape = TRUE;
				ReleaseFromGrab( bBreakFreeEscape );
				bSuccessFullyBrokeFree = TRUE;
			}
		}
	}

	// if the grab victim somehow no longer the GrabVictim (e.g. died)
	if( ( bSuccessFullyBrokeFree == FALSE )
		&& ( ( Follower == None ) || ( NSM_Melee_GrabVictim(Follower.ActiveSpecialMove) == None ) )
		)
	{
		`log( `location @ "Follower is no longer doing NSM_Melee_GrabVictim.  Ending SpecialMove Now!" );
		MyNP.EndSpecialMove();
	}

}

defaultproperties
{
	FollowerSpecialMoveName="NSM_Melee_GrabVictim"

	AttackerGrabSuccessStartAnim="Grab_Behind_Success_Start"
	AttackerGrabSuccessLoopAnim="Grab_Behind_Success_Loop"
	AttackerGrabReleaseAnim="Grab_Behind_Escape"
	AttackerGrabEscapeAnim="Grab_Behind_Escape"

	InteractionType=PAWNINTER_Grab
}
