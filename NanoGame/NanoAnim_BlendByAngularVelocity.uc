
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoAnim_BlendByAngularVelocity extends AnimNodeBlend
	native(Anim);

var()	bool	bUseBaseVelocity;
var()	bool	bInvertWhenMovingBackwards;
var()	float	AngVelAimOffsetChangeSpeedAwayFromCenter;
var()	float	AngVelAimOffsetChangeSpeedTowardCenter;
var()	float	AngVelAimOffsetScale;
var()	float	AIScale;

var		transient	INT	LastYaw;

var		transient float		YawVelHistory[10];
var		transient int		YawVelSlot;

cpptext
{
	virtual void TickAnim( FLOAT DeltaSeconds );
	virtual void GetBoneAtoms(FBoneAtomArray& Atoms, const TArray<BYTE>& DesiredBones, FBoneAtom& RootMotionDelta, INT& bHasRootMotion, FCurveKeyArray& CurveKeys);
	virtual void OnBecomeRelevant();
	virtual void OnCeaseRelevant();
	virtual void SetBlendTarget( FLOAT BlendTarget, FLOAT BlendTime );
}

defaultproperties
{
	AIScale=1.f
	AngVelAimOffsetChangeSpeedAwayFromCenter=1.42f
	AngVelAimOffsetChangeSpeedTowardCenter=1.42f
	AngVelAimOffsetScale=0.000058f
	bInvertWhenMovingBackwards=TRUE

	Children(0)=(Name="Left")
	Children(1)=(Name="Right")

	bFixNumChildren=TRUE
	bSkipBlendWhenNotRendered=TRUE

	CategoryDesc = "BlendBy"

	Child2Weight=0.5f
	Child2WeightTarget=0.5f
}
