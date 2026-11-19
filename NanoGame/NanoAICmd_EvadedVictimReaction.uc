/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAICmd_EvadedVictimReaction extends NanoAICmd within NanoAI
	config(AI);
	
var NanoPawn Attacker;
var Name	 AnimName;
var bool	 bUseRagdollRecovery;

static final function EvadeVictim( NanoAI AI, NanoPawn InAttacker, Name InAnim )
{
	local NanoAICmd_EvadedVictimReaction Cmd;

	if( AI != None && AI.Pawn != None && AI.Pawn.Health > 0 )
	{
		Cmd = new(AI) class'NanoAICmd_EvadedVictimReaction';
		if( Cmd != None )
		{
			Cmd.Attacker = InAttacker;
			Cmd.AnimName = InAnim;
			AI.PushCommand( Cmd );
		}
	}
}

function Pushed()
{
	local NanoPawn NP;
	local Vector RelLoc;

	Super.Pushed();
	
	NP = NanoPawn(Pawn);
	if( NP != None )
	{
		NP.bStunned = TRUE;
		NP.bJuggled = TRUE;

		NP.StopFiring();
		NP.ZeroMovementVariables();
		
		NP.SetPhysics( PHYS_None );
		NP.SetDesiredRotation( Attacker.Rotation, TRUE );
//		NP.SetCollision( TRUE, FALSE, bIgnoreEncroachers );
		NP.SetHardAttach( TRUE );
		NP.SetBase( NP.InteractionPawn,, NP.InteractionPawn.Mesh, 'b_MF_Attach' );

		RelLoc = NP.Location - NP.Mesh.GetBoneLocation( 'b_MF_Root' );
		NP.SetRelativeLocation( RelLoc );
		
		PlayEvadeVictimAnimation( NP );
	}
}

function Popped()
{
	local NanoPawn NP;

	Super.Popped();

	NP = NanoPawn(Pawn);
	if( NP != None )
	{
		NP.bStunned = FALSE;
		ResetPawnInfo( NP );
	}
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

	NP.SetHardAttach( default.bHardAttach );
	NP.SetPhysics( PHYS_Walking );
	NP.SetBase( None );
}

function PlayEvadeVictimAnimation( NanoPawn NP )
{
	local float AnimTime;

	NP.RunningFullBodySlot.StopCustomAnim(0.1f);
	NP.FullBodySlot.SetRootBoneAxisOption( RBA_Discard, RBA_Discard, RBA_Discard );

	AnimTime = NP.FullBodySlot.PlayCustomAnim( AnimName, 1.f, 0.1, -1.f, FALSE, TRUE );
	NP.Mesh.RootMotionMode = NP.default.Mesh.RootMotionMode;
	NP.FullBodySlot.SetRootBoneAxisOption( RBA_Discard, RBA_Discard, RBA_Discard );

	SetTimer( AnimTime, FALSE, nameof(ReleaseEvadeVictim), self );
}

function ReleaseEvadeVictim()
{
	local NanoPawn NP;

	ClearTimer( nameof(ReleaseEvadeVictim), self );

	NP = NanoPawn(Pawn);
	if( NP != None )
	{
		ResetPawnInfo( NP );
	}

	if( NP != None && bUseRagdollRecovery )
	{
		NP.Knockdown( 1.f + FRand() * 2.f );
	}
	else
	{
		Status = 'Success';
		PopCommand( self );
	}
}

defaultproperties
{
	bUseRagdollRecovery=TRUE
}
