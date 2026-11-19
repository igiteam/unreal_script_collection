/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearCamMod_ScreenShake extends CameraModifier_CameraShake
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

defaultproperties
{
	TargetingAlpha=0.5f
}