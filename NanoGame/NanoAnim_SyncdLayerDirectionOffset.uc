
/**
 * NanoAnim_SyncdLayerDirectionOffset
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoAnim_SyncdLayerDirectionOffset extends AnimNodeSequence
	native(Anim);

/** Offset to apply to the backward animation. */
var() float BackwardOffsetPct;

/** Which owner should we use */
var()	NanoAnim_MovementNode.EOwnerType	OwnerType;

/** Internal */
var				float	DirAngle;
var             float   TargetAngle;
var	transient	vector	MoveDir;
var transient	INT		LastYaw;
var transient   FLOAT   BackwardWeight;
/** Cached pointer to NanoPawnOwner */
var transient NanoPawn	NanoPawnOwner;

var() EDirectionInterpType  DirectionInterpType;
var() FLOAT                 CircularInterpSpeed, LinearInterpSpeed;

/** When moving the slider, keep nodes with same property in sync. */
var(Editor)	bool	bSynchronizeNodesInEditor;

cpptext
{
	// AnimNode interface
	virtual	void TickAnim(FLOAT DeltaSeconds);
	virtual void GetBoneAtoms(FBoneAtomArray& Atoms, const TArray<BYTE>& DesiredBones, FBoneAtom& RootMotionDelta, INT& bHasRootMotion, FCurveKeyArray& CurveKeys);

	virtual INT GetNumSliders() const { return 1; }
	virtual FLOAT GetSliderPosition(INT SliderIndex, INT ValueIndex);
	virtual void HandleSliderMove(INT SliderIndex, INT ValueIndex, FLOAT NewSliderValue);
	virtual FString GetSliderDrawValue(INT SliderIndex);
}


defaultproperties
{
	bSynchronizeNodesInEditor=TRUE
	DirectionInterpType=EDIT_Linear
	CircularInterpSpeed=180.f
	LinearInterpSpeed=10.f
}
