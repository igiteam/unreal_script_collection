/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 *
 * TM-specific version of SeqAct_PlayCameraAnim to work with TM-specific camera method.
 */

class TMSeqAct_PlayCameraAnim extends SequenceAction;

/** The anim to play */
var() CameraAnim	AnimToPlay;

/** Time to interpolate in from zero, for smooth starts. */
var()	float		BlendInTime;

/** Time to interpolate out to zero, for smooth finishes. */
var()	float		BlendOutTime;

/** Rate to play.  1.0 is normal. */
var()	float		Rate;

/** Scalar for intensity.  1.0 is normal. */
var()	float		IntensityScale;

/**
 * Return the version number for this class.  Child classes should increment this method by calling Super then adding
 * a individual class version to the result.  When a class is first created, the number should be 0; each time one of the
 * link arrays is modified (VariableLinks, OutputLinks, InputLinks, etc.), the number that is added to the result of
 * Super.GetObjClassVersion() should be incremented by 1.
 *
 * @return	the version number for this specific class.
 */
static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

