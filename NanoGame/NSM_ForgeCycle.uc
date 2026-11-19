/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_ForgeCycle extends NanoSpecialMove
	config(Pawn);

var() protected const config float CycleDuration;

/** TRUE to cycle infinitely and rely on calling code to end the special move.  Passed in via special move flags. */
var protected transient bool bEndManually;

function SpecialMoveStarted( bool bForced, Name PrevMove )
{
	Super.SpecialMoveStarted( bForced, PrevMove );
	ExtractSpecialMoveFlags( MyNP.SpecialMoveFlags );

	PlayStartAnimation();
}

function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	Super.SpecialMoveEnded( PrevMove, NextMove );

	MyNP.FullBodySlot.StopCustomAnim(0.25f);

	MyNP.ClearTimer( nameof(PlayCycleAnimation),    self );
	MyNP.ClearTimer( nameof(PlayCompleteAnimation), self );
	MyNP.ClearTimer( nameof(FinishSpecialMove),     self );
}

simulated function PlayStartAnimation()
{
	local float AnimTime;
	AnimTime = MyNP.FullBodySlot.PlayCustomAnim( 'NW_Forge_Create_Start', GetSpeedModifier(), 0.f, -1.f, FALSE, TRUE );
	MyNP.SetTimer( AnimTime, FALSE, nameof(PlayCycleAnimation), self );
}

simulated function PlayCycleAnimation()
{
	MyNP.FullBodySlot.PlayCustomAnim( 'NW_Forge_Create_Cycle', GetSpeedModifier(), 0.f, -1.f, TRUE, TRUE );

	if (!bEndManually)
	{
		MyNP.SetTimer( CycleDuration, FALSE, nameof(PlayCompleteAnimation), self );
	}
}

simulated function PlayCompleteAnimation()
{
	local float AnimTime;
	AnimTime = MyNP.FullBodySlot.PlayCustomAnim( 'NW_Forge_Create_End', GetSpeedModifier(), 0.f, -1.f, FALSE, TRUE );
	MyNP.SetTimer( AnimTime, FALSE, nameof(FinishSpecialMove), self );
}

simulated function FinishSpecialMove()
{
	MyNP.EndSpecialMove();
}


function ExtractSpecialMoveFlags( int Flags )
{
	// 0 flags means end automatically
	bEndManually = (Flags != 0);
}

// don't stop us if we are moving
function SetMovementLock_ZeroOutMovementVariables();

function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	if( MyNP.bSlowVelocityDueToForging == TRUE )
	{
		// only slow down if we are going faster than 400
		if( VSize(MyNP.Velocity) > 400.0f )
		{
			MyNP.Velocity *= MyNP.SlowVelocityDueToForgingAmount;
		}
	}
}



defaultproperties
{
	bDisableMovement=TRUE
}
