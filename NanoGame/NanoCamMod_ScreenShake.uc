/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoCamMod_ScreenShake extends CameraModifier_CameraShake
	native
	config(Camera);


/** Alpha to use while targeting. */
var()	protected float				TargetingAlpha;

cpptext
{
protected:
	virtual FLOAT GetShakeScale(FCameraShakeInstance const& ShakeInst) const;
public:
};

/** */
native function float GetTargetAlpha( Camera Camera );

defaultproperties
{
	TargetingAlpha=0.5f
}