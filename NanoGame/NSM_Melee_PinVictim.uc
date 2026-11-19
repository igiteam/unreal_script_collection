/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_Melee_PinVictim extends NanoSpecialMove;

var Name PinnedVictimStartAnim, PinnedVictimLoopAnim;
/** Sound to play when the trooper is pinned */
var SoundCue    PinnedSound;

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
	local Rotator R;

	Super.SpecialMoveStarted( bForced, PrevMove );

	MyNP.StopFiring();
	MyNP.ZeroMovementVariables();

	MyNP.DropShield(); // if we were pinned drop shield!

	MyNP.bStunned = TRUE;

 	R.Yaw = MyNP.InteractionPawn.Rotation.Yaw + 32768;
 	MyNP.SetDesiredRotation( Normalize(R), TRUE, FALSE, 0.0f );
	
	if( PinnedSound != None )
	{
		MyNP.PlaySound(PinnedSound);
	}

	// add stimulus for the AI.  We just tackled a foe and are going throw and kill them!
	NanoGRI(MyNP.WorldInfo.GRI).AddStimuliInARadiusAroundEvent( 1524, MyNP.InteractionPawn, MyNP.InteractionPawn.Location, TRUE, FALSE, TRUE, TRUE );

	if( MyAI != None )
	{
		MyAI.UnregisterAsActiveAttacker();
		MyAI.Focus = None;
	}

	PlayPinnedStartAnim();
}

function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	MyNP.ClearTimer( nameof(PlayPinnedLoopAnim), self );

	MyNP.bStunned = FALSE;
	MyNP.bJuggled = FALSE;
	MyNP.Mesh.RootMotionMode = MyNP.default.Mesh.RootMotionMode;
	MyNP.FullBodySlot.SetRootBoneAxisOption( RBA_Discard, RBA_Discard, RBA_Discard );
	MyNP.FullBodySlot.StopCustomAnim( 0.1f );

	MyNP.LockDesiredRotation( FALSE );
	MyNP.SetHardAttach( MyNP.default.bHardAttach );
	
	MyNP.bJuggled = TRUE;
	MyNP.Knockdown( 1.f + FRand() * 2.f );

	Super.SpecialMoveEnded( PrevMove, NextMove );
}

function PlayPinnedStartAnim()
{
	local float AnimTime;

	// Stop running animations
	MyNP.RunningFullBodySlot.StopCustomAnim(0.f);
	MyNP.FallingFullBodySlot.StopCustomAnim(0.f);
	MyNP.FullBodySlot.SetRootBoneAxisOption( RBA_Discard, RBA_Discard, RBA_Discard );

	// Play start animation
	AnimTime = MyNP.FullBodySlot.PlayCustomAnim( PinnedVictimStartAnim, GetSpeedModifier(), 0.f, -1.f, FALSE, TRUE );
	// Setup root motion
	MyNP.Mesh.RootMotionMode = RMM_Accel;
	MyNP.FullBodySlot.SetRootBoneAxisOption( RBA_Translate, RBA_Translate, RBA_Translate );

	// Set timer for loop 
	MyNP.SetTimer( 0.9f * AnimTime, FALSE, nameof(PlayPinnedLoopAnim), self );
}

function PlayPinnedLoopAnim()
{
	// Play loop animation
	MyNP.FullBodySlot.PlayCustomAnim( PinnedVictimLoopAnim, GetSpeedModifier(), 0.f, -1.f, TRUE, TRUE );

	// kill them for the demo, and since we're attached to a rigid body, don't update the location for the rigid body, otherwise we'll flip around
	MyNP.Mesh.bSyncActorLocationToRootRigidBody = FALSE;
  	MyNP.LastHitBy = MyNP.InteractionPawn.Controller;
  	//NP.KillPawn();
}

function bool MessageEvent( Name EventName, Object Sender )
{
	return TRUE;
}

defaultproperties
{
	PinnedVictimStartAnim=Hit_LandOnHead_Start
	PinnedVictimLoopAnim=Hit_LandOnHead_Loop

	PinnedSound=SoundCue'Foley_Body.MetaCorps.Death_CrushedByJumpingPlayer_Cue' 
}
