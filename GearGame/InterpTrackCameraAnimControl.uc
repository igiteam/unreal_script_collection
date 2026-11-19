/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class InterpTrackCameraAnimControl extends InterpTrackFloatBase
	native;

/** The camera anim to play */
var() CameraAnim CameraAnimToPlay;

/** Space in which to play the camera anim */
var()	ECameraAnimPlaySpace	PlaySpace;

/** Actor to use to specify the space for CAPS_UserDefined */
var()	Actor					UserDefinedSpaceActor;

/** How long it should take to blend in this camera anim */
var() float BlendInTime;

/** How long it should take to blend out this camera anim */
var() float BlendOutTime;

cpptext
{
	/**
	 * Start the camera anim and move it if needed
	 * 
	 * @param NewPosition - the new timeline position of the camera anim
	 * 
	 * @param TrInst - the interpolation track instance
	 * 
	 * @param bJump - if the interpolation had a non-linear jump in it
	 */
	virtual void UpdateTrack(FLOAT NewPosition, UInterpTrackInst* TrInst, UBOOL bJump);
}

defaultproperties
{
	TrackInstClass=class'GearGame.InterpTrackInstCameraAnimControl'
	TrackTitle="Camera Anim Control"
}