/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_Dash_AthleticIdle extends NanoSpecialMove;

enum EDashIdleState
{
	DAI_None,
	DAI_Start,
	DAI_Idle,
	DAI_End,
};
var EDashIdleState IdleState;
var float IdleLoopDuration;

protected function bool InternalCanDoSpecialMove()
{
	local NanoPC PC;

	if( MyNP.CurrNanoState != ENS_Normal || MyNP.Physics != PHYS_Walking )
	{
		return FALSE;
	}

	PC = NanoPC(MyNP.Controller);
	if( PC != None && (Abs(PC.PlayerInput.RawJoyUp) > 0.2f || Abs(PC.PlayerInput.RawJoyRight) > 0.2f) )
	{
		return FALSE;
	}

	return TRUE;
}

function SpecialMoveStarted( bool bForced, Name PrevMove )
{
	Super.SpecialMoveStarted( bForced, PrevMove );
	ExtractSpecialMoveFlags( MyNP.SpecialMoveFlags );

	MyNP.HolsterCurrentWeapon();	
	PlayIdleAnim();
}

function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	Super.SpecialMoveEnded( PrevMove, NextMove );

	MyNP.FullBodySlot.StopCustomAnim(0.25f);

	MyNP.ClearTimer( nameof(LoopIdleAnim), self );
	MyNP.ClearTimer( nameof(EndIdleAnim), self );
	MyNP.ClearTimer( nameof(FinishSpecialMove), self );
	IdleState = DAI_None;
}

function PlayIdleAnim()
{
	local float AnimTime;	
	AnimTime = MyNP.FullBodySlot.PlayCustomAnim( 'NW_Idle_Athletic_Start', GetSpeedModifier(), 0.25, -1.f, FALSE, TRUE );
	MyNP.SetTimer( AnimTime, FALSE, nameof(LoopIdleAnim), self );
	IdleState = DAI_Start;
}

function LoopIdleAnim()
{
	local NanoPC PC;
	MyNP.FullBodySlot.PlayCustomAnim( 'NW_Idle_Athletic_Loop', GetSpeedModifier(), 0.f, -1.f, TRUE, TRUE );

	PC = NanoPC(MyNP.Controller);
	if( PC == None || !PC.MainPlayerInput.bHoldSprint )
	{
		MyNP.SetTimer( IdleLoopDuration, FALSE, nameof(EndIdleAnim), self );
	}
	IdleState = DAI_Idle;
}

function EndIdleAnim()
{
	local float AnimTime;	
	AnimTime = MyNP.FullBodySlot.PlayCustomAnim( 'NW_Idle_Athletic_End', GetSpeedModifier(), 0.25, -1.f, FALSE, TRUE );
	MyNP.SetTimer( AnimTime, FALSE, nameof(FinishSpecialMove), self );
	IdleState = DAI_End;
}

function FinishSpecialMove()
{
	MyNP.EndSpecialMove();
}

function Tick( float DeltaTime )
{
	local NanoPC PC;

	Super.Tick( DeltaTime );

	PC = NanoPC(MyNP.Controller);
	if( PC != None )
	{
		if( !InternalCanDoSpecialMove() )
		{
			FinishSpecialMove();
		}
		else if( PC.MainPlayerInput.bHoldSprint )
		{
			if( !MyNP.bWantsToDash && IdleState == DAI_Idle )
			{
				EndIdleAnim();
			}
		}
	}
}   

defaultproperties
{
	IdleLoopDuration=0.5f
	bUpdatePlayerDesiredRotation=TRUE
}
