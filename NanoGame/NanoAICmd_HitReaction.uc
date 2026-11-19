/** 
 * AI Command that handles melee hit reaction trooper
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoAICmd_HitReaction extends NanoAICmd within NanoAI
	config(AI);

var() HitReactionInfo Reaction;

static final function HitReaction( NanoAI AI, out HitReactionInfo InReaction )
{
	local NanoAICmd_HitReaction Cmd;

	if( AI != None && AI.Pawn != None && AI.Pawn.Health > 0 )
	{
		Cmd = new(AI) default.class;
		if( Cmd != None )
		{
			Cmd.Reaction = InReaction;
			AI.PushCommand( Cmd );
		}
	}
}

function Pushed()
{
	local NanoPawn NP;
	local float AnimTime;
	local AnimNodeSequence VictimSeq;

	Super.Pushed();

	//`log(`location);
	NP = NanoPawn(Pawn);
	if( NP != None && NP.FullBodySlot != None )
	{
		NP.StopFiring();
		NP.ZeroMovementVariables();

		// Stop running animations
		NP.RunningFullBodySlot.StopCustomAnim(Reaction.BlendInTime);
		NP.FallingFullBodySlot.StopCustomAnim(Reaction.BlendInTime);

		// Play custom animation
		AnimTime = NP.FullBodySlot.PlayCustomAnim( Reaction.AnimName, Reaction.PlayRate, Reaction.BlendInTime, -1.f, FALSE, TRUE );
		AnimTime -= Reaction.Position + Reaction.EndPositionOffset + Reaction.BlendOutTime;
		AnimTime = FMax(0.1f,AnimTime);

		NP.Mesh.RootMotionMode = Reaction.RootMotionMode;
		NP.FullBodySlot.SetRootBoneAxisOption( Reaction.RootBoneOption[0], Reaction.RootBoneOption[1], Reaction.RootBoneOption[2] );

		// Set position to match attackers position
		VictimSeq = NP.FullBodySlot.GetCustomAnimNodeSeq();
		VictimSeq.SetPosition( Reaction.Position, TRUE );

		// Set timer to finish the reaction and blend out
		SetTimer( AnimTime, FALSE, nameof(StopHitReaction), self );

		NP.bStunned = TRUE;
		NP.bPlayingHitReaction = TRUE;
		NP.TimeOfStun = WorldInfo.TimeSeconds;
		NP.SetDesiredRotation( NP.Rotation, TRUE );
		Focus = None;

		if( Reaction.bAI_MeleeDisengage )
		{
			UnregisterAsActiveAttacker();
		}
	}
	else
	{
		Status = 'Failure';
		PopCommand( self );
	}
}

function Popped()
{
	local NanoPawn NP;
	
	//`log(`location);
	Super.Popped();
	
	NP = NanoPawn(Pawn);
	if( NP != None )
	{
		NP.bStunned = FALSE;
		if( NP.bPlayingHitReaction )
		{
			NP.FinishedHitReaction( Reaction.BlendOutTime );
		}
		NP.LockDesiredRotation( FALSE );
		Focus = FireTarget;
	}
}

function StopHitReaction()
{
	local NanoPawn NP;

	NP = NanoPawn(Pawn);
	if( NP != None && NP.Health > 0 )
	{
		NP.FinishedHitReaction( Reaction.BlendOutTime );
	}

	if( Reaction.bAI_MeleeDisengage )
	{
		Status = 'Success_MeleeDisengage';
	}
	else
	{
		Status = 'Success';
	}
	SetTimer( 0.1f, FALSE, nameof(DelayPopCommand), self );
}

function DelayPopCommand()
{
	PopCommand( self );
}

defaultproperties
{
	bReplaceActiveSameClassInstance=TRUE
}