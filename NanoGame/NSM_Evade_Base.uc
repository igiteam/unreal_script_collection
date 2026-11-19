/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_Evade_Base extends NSM_InteractionLeader_Base;

var() Name	AnimName;
var() float	BlendInTime;
var() float	BlendOutTime;

var() ERootBoneAxis RBA_X;
var() ERootBoneAxis RBA_Y;
var() ERootBoneAxis RBA_Z;

var() ERootMotionMode RMM;

/** 
 * How far through the animation before we slow down the play rate. 
 * This allows us to have a Fast start of the anim and then at some point slow it down a bit.  So you get the nice ZzzziiiiiiiiiiiiP type of evade
**/
var config float PercentageThroughEvadeToSlowDown;
var transient float TimeToDoSlowDown;

/** The rate at which we play the slowed down anim. **/
var config float SlowDownRate;

function SpecialMoveStarted( bool bForced, Name PrevMove )
{
	local NanoWeap_Melee Weap;

	Weap = NanoWeap_Melee(MyNP.Weapon);
	if( Weap != None )
	{
		Weap.GotoState('Active');
	}

	Super.SpecialMoveStarted( bForced, PrevMove );
}

function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	MyNP.ClearTimer( nameof(FinishedDodge), self );

	MyNP.bDodging = FALSE;

	// may have grabbed something before the dodge finished, don't want to touch rm options at this point
	if( MyNP.MantleState == MANTLE_None && MyNP.CurrentTurbine == None )
	{
		MyNP.Mesh.RootMotionMode = MyNP.default.Mesh.RootMotionMode;
		MyNP.FullBodySlot.SetRootBoneAxisOption( RBA_Discard, RBA_Discard, RBA_Discard );
		MyNP.FullBodySlot.StopCustomAnim( 0.35f );
	}

	Super.SpecialMoveEnded( PrevMove, NextMove );

	MyNP.bRootMotionFromInterpCurve = FALSE;
}

function bool IsReadyToStartInteraction()
{
	return (Follower == None || (Follower != None && Follower.IsDoingSpecialMove(FollowerSpecialMoveName)));
}

simulated function FinishedDodge()
{
	MyNP.Landed( MyNP.Floor, MyNP.Base );
	MyNP.EndSpecialMove( Handle );
}

/**
 * Begins the interaction.
 */
function StartInteraction()
{
	// Start playing grab animation
	PlayEvade( GetSpeedModifier(), BlendInTime, BlendOutTime );

	MyNP.bDodging = TRUE;
	MyNP.bRecoveringFromDodge = FALSE;
	MyNP.LastJumpTime = MyNP.WorldInfo.TimeSeconds;
}

function PlayEvade( float PlayRate, float InBlendInTime, float InBlendOutTime )
{
	local float AnimTime;
	local float DurationOfNormalPlaying;
	local float DurationOfSlowPlaying;

	// Ignore root motion for other slot anim so blend doesn't cause a pop
	MyNP.FullBodySlot.SetRootBoneAxisOption( RBA_Discard, RBA_Discard, RBA_Discard );

	AnimTime = MyNP.FullBodySlot.PlayCustomAnim( AnimName, PlayRate, InBlendInTime, InBlendOutTime, FALSE, TRUE );
	AnimTime = FMax( AnimTime, 0.1f );

	// start the slow down here
	TimeToDoSlowDown = PawnOwner.WorldInfo.TimeSeconds + (AnimTime * PercentageThroughEvadeToSlowDown);


	// need to figure out the real anim time as we are going to do a slow down of the anim rate
	DurationOfSlowPlaying = AnimTime - (AnimTime * PercentageThroughEvadeToSlowDown);
	DurationOfNormalPlaying = AnimTime - DurationOfSlowPlaying;

	//`log( `showvar(AnimTime) @ `showvar(TimeToDoSlowDown) @ `showvar(DurationOfSlowPlaying) @ `showvar(DurationOfNormalPlaying) );

	DurationOfSlowPlaying = DurationOfSlowPlaying * (1.0f/SlowDownRate);

	AnimTime = DurationOfNormalPlaying + DurationOfSlowPlaying;

	//`log( `showvar(AnimTime) @ `showvar(DurationOfNormalPlaying) @ `showvar(DurationOfSlowPlaying) );

	MyNP.SetTimer( AnimTime, FALSE, nameof(FinishedDodge), self );




/*
	// Setup root motion
	MyNP.ExtractRootMotionCurve( AnimName, (1.f / 30.f), MyNP.RootMotionInterpCurve, FALSE ); //TRUE );
	MyNP.RootMotionInterpCurrentTime = 0.f;
	MyNP.RootMotionInterpCurveLastValue = vect(0,0,0);
	MyNP.bRootMotionFromInterpCurve = TRUE;
*/
	MyNP.Mesh.RootMotionMode = RMM;
	MyNP.FullBodySlot.SetRootBoneAxisOption( RBA_X, RBA_Y, RBA_Z );



}

simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	// here we need to modify the anim rate based on some other curve! (well in this case a curve with a single point in it)
	if( TimeToDoSlowDown < PawnOwner.WorldInfo.TimeSeconds )
	{
		//`log( "slooowwing down the anim" );
		MyNP.FullBodySlot.GetCustomAnimNodeSeq().Rate = SlowDownRate;
	}


	if( PawnOwner.Physics == PHYS_Falling )
	{
		MyNP.EndSpecialMove();
	}
}

defaultproperties
{
	BlendInTime=0.2f
	BlendOutTime=0.1f

	bRelativeToRootBone=TRUE
}