//=============================================================================
// ACTION_PlayAnim.uc
//
// Script action to play/loop a specfied animation on the controlled pawn.
//=============================================================================

class ACTION_PlayAnim extends SASScriptAction;

//-----------------------------------------------------------------------------
// Member Vars

var(Action)	name		mBaseAnim;			// Anim to play
var(Action)	float		mBlendInTime;		// Anim blend in time
var(Action) float		mBlendOutTime;		// Anim blend out time
var(Action) float		mBlendAlpha;		// Anim blend alpha
var(Action) float		mAnimRate;			// Anim playback rate
var(Action) int			mChannel;			// Anim blend channel
var(Action)	name		mStartBone;			// Name of the bone from which the blending is to take effect
var(Action) float		mStartFrame;		// Anim offset frame to start at
var(Action) byte		mAnimIterations;	// Number of animation loops
var(Action) bool		mbLoopAnim;			// Loops indefinately if true
var(Action) bool		mbRootMotionPhys;	// Use root motion physics


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// DoAction
//
// Start animation on aController's pawn
function bool DoAction(
	SASScriptInterface	aInterface )
{
	if ( aInterface.mAIController == None )
	{
		return true;
	}

	aInterface.mScriptAnimIterations = mAnimIterations;
	if ( PlayBaseAnim( aInterface, true ) )
	{
		aInterface.mScriptAnimAction = self;
	}

	return true;	
}


///////////////////////////////////////////////////////////////////////////////
// RepeatAction
//
// If anim is looping or has iterations left then replays animation.
// Returns true if animation is replayed.
function bool RepeatAction(
	SASScriptInterface	aInterface )
{
	return PlayBaseAnim( aInterface, false );
}


///////////////////////////////////////////////////////////////////////////////
// PawnPlayBaseAnim
//
function bool PlayBaseAnim(
	SASScriptInterface	aInterface,
	bool				abFirstPlay )	// True if first time called
{
	if ( (aInterface.mAIController == None) || (mBaseAnim == 'None') )
	{
		return false;
	}
	
	// Take control of animation playing from the possessed pawn
	aInterface.mAIController.bControlAnimations = true;

	if ( mbRootMotionPhys )
	{
		//aInterface.mAIController.Pawn.LockRootMotion(1);
		aInterface.mAIController.Pawn.SetPhysics( PHYS_RootMotion );
		//aInterface.mAIController.Pawn.SetCollision ( false, false, false );
		//aInterface.mAIController.Pawn.bCollideWorld = false;
	}

	if (abFirstPlay)
	{
		//AnimBlendParams (mChannel, mBlendAlpha, mBlendInTime, mBlendOutTime, mStartBone, true);
		//aController.Pawn.PlayAnim (mBaseAnim, mAnimRate, 0.0, mChannel);
		aInterface.mAIController.Pawn.PlayAnim( mBaseAnim, mAnimRate, mBlendInTime );
	}
	else if ( mbLoopAnim || (aInterface.mScriptAnimIterations > 0) )
	{
		aInterface.mAIController.Pawn.LoopAnim( mBaseAnim, mAnimRate, 0.0, mChannel );
		if ( aInterface.mScriptAnimIterations > 0 )
		{
			aInterface.mScriptAnimIterations--;
		}
	}
	else
	{
		return false;
	}
		
	if (mStartFrame > 0.0)
	{
		aInterface.mAIController.Pawn.SetAnimFrame( mStartFrame, 0, 1 );
	}
				
	return true;
}


///////////////////////////////////////////////////////////////////////////////
// GetActionString
//
function string GetActionString()
{
	return mActionString@mBaseAnim;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mBlendInTime=0.2000000
    mBlendOutTime=0.2000000
    mBlendAlpha=1.0000000
    mAnimRate=1.0000000
    mActionString="Play Animation"
}