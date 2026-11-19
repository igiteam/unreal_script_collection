
/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class GearAnim_BlendByAngularVelocity extends AnimNodeBlend
	native(TGAnim);

var()	bool	bUseBaseVelocity;
var()	bool	bInvertWhenMovingBackwards;
var()	float	AngVelAimOffsetChangeSpeed;
var()	float	AngVelAimOffsetScale;
var()	float	AIScale;

var		transient	INT	LastYaw;

var		transient float		YawVelHistory[10];
var		transient int		YawVelSlot;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

