/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_Dash_Slide extends NanoSpecialMove
	native(SpecialMoves);
	
var NanoSkill_Dash DashSkill;

/** Velocity at the time of dash stop, for trailing velocity @see ApplyVelocityBraking */
var transient float FalloffTime, FalloffDuration;
var transient vector FalloffVelocity;
var transient bool bSlideDirectionChange;

var protected SoundCue SlideToAStopCue;

function SpecialMoveStarted( bool bForced, Name PrevMove )
{
	MyNP.bSliding = TRUE;

	Super.SpecialMoveStarted( bForced, PrevMove );

	ExtractSpecialMoveFlags( MyNP.SpecialMoveFlags );

	bSlideDirectionChange = FALSE;
	DashSkill = MyNP.GetSkill(class'NanoSkill_Dash');
	PlaySlideAnimation( GetSlideAnimation( bForced ) );	
}

function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	MyNP.bSliding = FALSE;

	Super.SpecialMoveEnded( PrevMove, NextMove );

	MyNP.FullBodySlot.StopCustomAnim(0.25f);
	MyNP.Mesh.RootMotionMode = RMM_Ignore;
	MyNP.Mesh.RootMotionRotationMode = RMRM_Ignore;
	MyNP.FullBodySlot.SetRootBoneAxisOption(RBA_Discard,RBA_Discard,RBA_Discard);
	MyNP.FullBodySlot.SetRootBoneRotationOption(RRO_Discard,RRO_Discard,RRO_Discard);
}

function Name GetSlideAnimation( bool bForceLongSlide )
{
	local float SlideSize;
	local float TotalDashTime;

	SlideSize = VSize2D(MyNP.Velocity);
	TotalDashTime = `TimeSinceEx(MyNP,DashSkill.LastActivateTime);

	if( bForceLongSlide || (SlideSize > MyNP.default.GroundSpeed * 1.75f && TotalDashTime > 2.f) )
	{
		return 'NW_Sprint_Fwd_Stop_Long';
	}
	else if( SlideSize > MyNP.default.GroundSpeed * 1.5f )
	{
		return 'NW_Sprint_Fwd_Stop_Medium';
	}
	return 'NW_Sprint_Fwd_Stop_Short';
}

function PlaySlideAnimation( Name SlideAnimName )
{
	FalloffVelocity = MyNP.Velocity;
	FalloffDuration = MyNP.FullBodySlot.PlayCustomAnim(SlideAnimName, GetSpeedModifier(), 0.25, -1.f, FALSE, TRUE);
	FalloffTime     = FalloffDuration;

	MyNP.FullBodySlot.SetRootBoneAxisOption(RBA_Discard,RBA_Discard,RBA_Discard);
	MyNP.FullBodySlot.SetRootBoneRotationOption(RRO_Discard,RRO_Discard,RRO_Discard);

	PlayerController(MyNP.Controller).PlaySound( SlideToAStopCue );
	MyNP.SetTimer( FalloffDuration, FALSE, nameof(FinishedSlideAnimation), self );
	if( !bSlideDirectionChange )
	{
		MyNP.SetTimer(0.25f,FALSE,nameof(DelayedSlideUpdate), self);
	}
}

function FinishedSlideAnimation()
{
	local NanoPC PC;
	local float SettleTime;

	PC = NanoPC(MyNP.Controller);
	if( PC != None && bSlideDirectionChange )
	{
		if( Abs(PC.MainPlayerInput.RawJoyUp) < 0.2f && Abs(PC.MainPlayerInput.RawJoyRight) < 0.2f )
		{
			SettleTime = MyNP.FullBodySlot.PlayCustomAnim('NW_Sprint_Fwd_Turn_180_End', GetSpeedModifier(), 0.25, -1.f, FALSE, TRUE);
			SettleTime = FMax(0.1f, SettleTime);
			MyNP.SetTimer( SettleTime, FALSE, nameof(FinishSettleAnimation), self );
			return;
		}
		else if( MyNP.CanDash() )
		{
			MyNP.ForceDashStart();
		}
	}

	MyNP.EndSpecialMove();
}

function FinishSettleAnimation()
{
	MyNP.EndSpecialMove();
}

simulated function DelayedSlideUpdate()
{
	local float SlideDotRot;
	local Rotator CamRot;
	local NanoPC PC;
	local Vector StickDir, CamLoc;

	PC = NanoPC(MyNP.Controller);
	if( PC != None )
	{
		PC.GetActorEyesViewPoint( CamLoc, CamRot );
		StickDir.X = PC.MainPlayerInput.RawJoyUp;
		StickDir.Y = PC.MainPlayerInput.RawJoyRight;
		StickDir = Normal(StickDir >> CamRot);
	}

	SlideDotRot = Normal(MyNP.Velocity) DOT StickDir;
	if( SlideDotRot < 0.f )
	{
		bSlideDirectionChange = TRUE;
		PlaySlideAnimation( 'NW_Sprint_Fwd_Turn_180_Start' );
        MyNP.FullBodySlot.SetRootBoneRotationOption(RRO_Extract,RRO_Extract,RRO_Extract);
		MyNP.Mesh.RootMotionRotationMode = RMRM_RotateActor;
	}
}

defaultproperties
{
	SlideToAStopCue=SoundCue'Foley_Footsteps.Stone.Footstep_Stone_Slide_Cue'
}
