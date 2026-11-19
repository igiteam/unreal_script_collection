
/**
 * Base Special Move to play a single animation, and end itself once it's done playing. 
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NSM_PlaySingleAnim_Base extends NanoSpecialMove
	native(SpecialMoves)
	abstract;

var() transient AnimNodeSlot  CachedSlot;

/** Animation to play */
var() Name	AnimName;
var() float AnimPosition;
var() float	BlendInTime;
var() float	BlendOutTime;

var() float StartTime;
var() float EndTime;

/** Whether or not to play the anim looping or not **/
var bool bLooping;



var() transient ERootBoneAxis RBA_X;
var() transient ERootBoneAxis RBA_Y;
var() transient ERootBoneAxis RBA_Z;

var() transient ERootMotionMode RMM;

var() bool bAutoPlayAnimation;
var() bool bUpperBodyAnim;



function SpecialMoveStarted( bool bForced, Name PrevMove )
{
	Super.SpecialMoveStarted( bForced, PrevMove );

	CachedSlot = GetAnimSlot();

	// Play animation
	if( bAutoPlayAnimation )
	{
		PlayAnimation();
	}
}

function Name GetAnimName()
{
	return AnimName;
}

function AnimNodeSlot GetAnimSlot()
{
	local AnimNodeSlot Retval;

	if( bUpperBodyAnim )
	{
		Retval = MyNP.TopHalfSlot;
	}

	Retval = MyNP.FullBodySlot;

`if(`notdefined(FINAL_RELEASE))
	if( Retval == None )
	{
		`warn( GetFuncName() @ "No valid AnimSlots!!!" );
	}
`endif


	return Retval;

}

/**
 * @return float the length of the animation being played
 **/
function float PlayAnimation()
{
	local AnimNodeSequence Seq;
	local float AnimTime;
	local float AnimRate;

	AnimRate = GetSpeedModifier();

	// Ignore root motion for other slot anim so blend doesn't cause a pop
	CachedSlot.SetRootBoneAxisOption( RBA_Discard, RBA_Discard, RBA_Discard );

	AnimTime = CachedSlot.PlayCustomAnim( GetAnimName(), AnimRate, 0.1f, -1.f, bLooping, TRUE, StartTime, EndTime );
	AnimTime -= (AnimPosition * AnimRate);
	AnimTime = FMax( AnimTime, 0.1f );

	Seq = CachedSlot.GetCustomAnimNodeSeq();
	Seq.SetPosition( AnimPosition, TRUE );
	
	// Setup root motion
	MyNP.Mesh.RootMotionMode = RMM;
	CachedSlot.SetRootBoneAxisOption( RBA_X, RBA_Y, RBA_Z );


	// determine when we should end the move
	// if we are looping then just run until we are interrupted
	if( bLooping == FALSE  )
	{
		MyNP.SetTimer( AnimTime, FALSE, nameof(EndThisSpecialMove), self );
	}

	return AnimTime;
}

function EndThisSpecialMove()
{
	MyNP.EndSpecialMove();
}

function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	// Clear timer if it's been set.
	MyNP.ClearTimer(nameof(self.EndThisSpecialMove), self);

	ResetPawnInfo();

	Super.SpecialMoveEnded( PrevMove, NextMove );
}

function ResetPawnInfo()
{
	if( MyNP.Health <= 0 )
	{
		return;
	}

	MyNP.Mesh.RootMotionMode = MyNP.default.Mesh.RootMotionMode;
	if( CachedSlot != None )
	{
		CachedSlot.SetRootBoneAxisOption( RBA_Discard, RBA_Discard, RBA_Discard );
		CachedSlot.StopCustomAnim( BlendOutTime );
	}

	MyNP.LockDesiredRotation( FALSE );

	MyNP.SetHardAttach( MyNP.default.bHardAttach );
	MyNP.SetPhysics( PHYS_Walking );
	MyNP.SetBase( None );
}


function bool MessageEvent( Name EventName, Object Sender )
{
	return FALSE;
}


/**
 * Here we can set an override of the root motion data.  This allows us to prototype with different types of curves
 * really easily.
 *
 **/
function SetRootMotionCurveOverrideOnPawn( ERootMotionCurveType InCurveType )
{
	local name AnimNameToExtractFrom;

	// ??? need to add R versions of these also?

	switch( InCurveType )
	{
	case RMCT_FastThenSlow:
		AnimNameToExtractFrom = 'Hit_L_A_Start';
		break;
	case RMCT_MoreSteadyMovementBack:
		AnimNameToExtractFrom = 'Hit_L_B_Start';
		break;
	case RMCT_SlowThenFast:
		AnimNameToExtractFrom = 'Hit_L_C_Start';
		break;
	case RMCT_FastToSlowToFastToSlow:
		AnimNameToExtractFrom = 'Hit_L_D_Start';
		break;
	default:
		`warn( "Not a valid ERootMotionCurveType" @ `showvar(InCurveType) );
		return;
	}

	MyNP.ExtractRootMotionCurve( AnimNameToExtractFrom, (1.0f / 30.f), MyNP.RootMotionInterpCurve, FALSE ); //TRUE );
	MyNP.RootMotionInterpCurrentTime = 0.0f;
	MyNP.RootMotionInterpCurveLastValue = vect(0,0,0);
	MyNP.bRootMotionFromInterpCurve = TRUE;

	// might not need these?  
	MyNP.Mesh.RootMotionMode = RMM_Accel;
	MyNP.FullBodySlot.SetRootBoneAxisOption( RBA_Translate, RBA_Translate, RBA_Translate );
}


defaultproperties
{
	BlendInTime=0.2f
	BlendOutTime=0.2f

	bAutoPlayAnimation=TRUE
	bLooping=FALSE
}
