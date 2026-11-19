/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAICmd_PinnedByPawn extends NanoAICmd within NanoAI
	config(AI);

var NanoPawn Attacker;
var Name	 StartPinnedAnim, LoopPinnedAnim;

/** Sound to play when the trooper is pinned */
var SoundCue    PinnedSound;

static final function Pinned( NanoAI AI, NanoPawn InAttacker, Name InStartAnim, Name InLoopAnim )
{
	local NanoAICmd_PinnedByPawn Cmd;

	if( AI != None && AI.Pawn != None && AI.Pawn.Health > 0 )
	{
		Cmd = new(AI) class'NanoAICmd_PinnedByPawn';
		if( Cmd != None )
		{
			// Abort any other commands that the AI may be doing.  They're pinned, and about to be dead.
			AI.AbortCommand( None, class'GameAICommand' );

			Cmd.Attacker = InAttacker;
			Cmd.StartPinnedAnim = InStartAnim;
			Cmd.LoopPinnedAnim = InLoopAnim;
			AI.PushCommand( Cmd );
		}
	}
}

function Pushed()
{
	local NanoPawn NP;
	local Rotator R;

	Super.Pushed();

	NP = NanoPawn(Pawn);
	if( NP != None )
	{
		NP.StopFiring();
		NP.ZeroMovementVariables();

		NP.bStunned = TRUE;

 		R.Yaw = Attacker.Rotation.Yaw + 32768;
 		NP.SetDesiredRotation( Normalize(R), TRUE, FALSE, 0.0f );
	}
	Focus = None;

	PlayPinnedStartAnim( NP );

	if( PinnedSound != None )
	{
		NP.PlaySound(PinnedSound);
	}

	// add stimulus for the AI.  We just tackled a foe and are going throw and kill them!
	NanoGRI(WorldInfo.GRI).AddStimuliInARadiusAroundEvent( 1524, Attacker, Attacker.Location, TRUE, FALSE, TRUE, TRUE );

	UnregisterAsActiveAttacker();
}

function Popped()
{
	local NanoPawn NP;

	Super.Popped();

	NP = NanoPawn(Pawn);
	if( NP != None )
	{
		NP.bStunned = FALSE;
		NP.bJuggled = FALSE;
		ResetPawnInfo( NP );
	}

	ClearTimer( nameof(PlayPinnedLoopAnim), self );
	ClearTimer( nameof(CheckForPinnedFinish), self );
}

function Resumed( Name OldCommandName )
{
	Super.Resumed( OldCommandName );

	Status = 'Success';
	PopCommand( self );
}

function ResetPawnInfo( NanoPawn NP )
{
	NP.Mesh.RootMotionMode = NP.default.Mesh.RootMotionMode;
	NP.FullBodySlot.SetRootBoneAxisOption( RBA_Discard, RBA_Discard, RBA_Discard );
	NP.FullBodySlot.StopCustomAnim( 0.1f );

	NP.LockDesiredRotation( FALSE );
}

function PlayPinnedStartAnim( NanoPawn NP )
{
	local float AnimTime;

	// Stop running animations
	NP.RunningFullBodySlot.StopCustomAnim(0.f);
	NP.FallingFullBodySlot.StopCustomAnim(0.f);
	NP.FullBodySlot.SetRootBoneAxisOption( RBA_Discard, RBA_Discard, RBA_Discard );

	// Play start animation
	AnimTime = NP.FullBodySlot.PlayCustomAnim( StartPinnedAnim, 1.f, 0.f, -1.f, FALSE, TRUE );
	// Setup root motion
	NP.Mesh.RootMotionMode = RMM_Accel;
	NP.FullBodySlot.SetRootBoneAxisOption( RBA_Translate, RBA_Translate, RBA_Translate );

	// Set timer for loop 
	SetTimer( 0.9f * AnimTime, FALSE, nameof(PlayPinnedLoopAnim), self );
}

function PlayPinnedLoopAnim()
{
	local NanoPawn NP;

	NP = NanoPawn(Pawn);
	if( NP != None )
	{
		// Play loop animation
		NP.FullBodySlot.PlayCustomAnim( LoopPinnedAnim, 1.f, 0.f, -1.f, TRUE, TRUE );
	}

	// kill them for the demo, and since we're attached to a rigid body, don't update the location for the rigid body, otherwise we'll flip around
	NP.Mesh.bSyncActorLocationToRootRigidBody = FALSE;
  	NP.LastHitBy = Attacker.Controller;
  	//NP.KillPawn();

	// Set timer to check if pin is complete
	SetTimer( 0.25f, TRUE, nameof(CheckForPinnedFinish), self );
}

function CheckForPinnedFinish()
{
	local NanoPawn NP;

	NP = NanoPawn(Pawn);

	if( NP != None && NP.InteractionPawn == None )
	{
		ClearTimer( nameof(CheckForPinnedFinish), self );
		ResetPawnInfo( NP );
		NP.bJuggled = TRUE;
		NP.Knockdown( 1.f + FRand() * 2.f );
	}
	else if( NP == None )
	{
		Status = 'Success';
		PopCommand( self );
	}
}

defaultproperties
{
	bForceTransition=TRUE
	PinnedSound=SoundCue'Foley_Body.MetaCorps.Death_CrushedByJumpingPlayer_Cue' 
}
