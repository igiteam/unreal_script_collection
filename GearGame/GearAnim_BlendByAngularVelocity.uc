
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearAnim_BlendByAngularVelocity extends AnimNodeBlend
	native(Anim);

var()	bool	bUseBaseVelocity;
var()	bool	bInvertWhenMovingBackwards;
var()	float	AngVelAimOffsetChangeSpeed;
var()	float	AngVelAimOffsetScale;
var()	float	AIScale;

var		transient	INT	LastYaw;

var		transient float		YawVelHistory[10];
var		transient int		YawVelSlot;

cpptext
{
	virtual void TickAnim(FLOAT DeltaSeconds);
};

defaultproperties
{
	AIScale=1.f
	AngVelAimOffsetChangeSpeed=1.42f
	AngVelAimOffsetScale=0.000058f
	bInvertWhenMovingBackwards=TRUE

	Children(0)=(Name="Left")
	Children(1)=(Name="Right")

	CategoryDesc = "BlendBy"
}
