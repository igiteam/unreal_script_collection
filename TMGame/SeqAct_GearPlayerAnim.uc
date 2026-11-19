
/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class SeqAct_GearPlayerAnim extends SequenceAction
	native(TGSequence);

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

enum EPlayMode
{
	AnimPM_Rate,
	AnimPM_Duration,
};

var()	bool		bPlayUpperBodyOnly;
var()	EPlayMode	PlayMode;

var()	name	AnimName;
var()	float	StartTime;
var()	float	Duration;
var()	float	Rate;
var()	float	BlendInTime;
var()	float	BlendOutTime;
var()	bool	bLooping;
var()	bool	bOverride;

var()   Actor   DirActor;

/**
 * if TRUE, animation uses Root Motion
 * So additionally, we're setting up the character for that.
 */
var()	bool	bUseRootMotion;

var     bool    bFinished;
enum EFinishMode
{
	AnimFM_Cancel,
	AnimFM_Finish
};
var EFinishMode FinishMode;

enum EEndPose
{
	AnimEP_None,
	AnimEP_Stand,
	AnimEP_Crouch,
	AnimEP_Prone
};
var() EEndPose end_pose;

enum EEndMovement
{
	AnimEM_None,
	AnimEM_Stop,
	AnimEM_Walk,
	AnimEM_Run
};
var() EEndMovement end_movement;

