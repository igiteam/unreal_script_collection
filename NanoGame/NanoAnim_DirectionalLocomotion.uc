/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAnim_DirectionalLocomotion extends AnimNodeBlendDirectional
	native(Anim)
	hidecategories(Object);


cpptext
{
	virtual void InitAnim( USkeletalMeshComponent* meshComp, UAnimNodeBlendBase* Parent );
	virtual void OnChildAnimEnd(UAnimNodeSequence* Child, FLOAT PlayedTime, FLOAT ExcessTime);
	virtual void OnBecomeRelevant();
	virtual void OnCeaseRelevant();
	virtual FString GetNodeTitle();

	virtual UBOOL SelectNextLocomotionOption( UBOOL bForce = FALSE );
	virtual void  SetActiveOptionIndex( INT Idx );

	virtual void GetChildBoneAtoms( INT ChildIdx, FBoneAtomArray& Atoms, const TArray<BYTE>& DesiredBones, FBoneAtom& RootMotionDelta, INT& bHasRootMotion, FCurveKeyArray& CurveKeys );
}

struct native LocomotionSequenceAnimItem
{
	var() Name        AnimName;
	var() float       AnimRate;

	/** Total root motion delta of the animation - used to scale to match Min/Max Range */
	var() editconst const float RootMotionDelta;
	var const float RootMotionScale;
	
	structdefaultproperties
	{
		AnimRate=1.f
		RootMotionScale=1.f
	}
};

struct native LocomotionSequenceOptionInfo
{
	/** Name of option so it can be looked up */
	var()   Name            OptionName;

	/** Animation variables */
	var()   array<LocomotionSequenceAnimItem>   Anims;
	var()   ERootBoneAxis                       RootBoneOption[3];
	var()   ERootMotionMode                     RootMotionMode;
	
	/** Min/Max of distance needed cover to make this option available */
	var()   float           MinRange;
	var()   float           MaxRange;
	/** Whether we should scale root motion to fit into the range */
	var()   bool            bScaleRootMotion;

    /** This is how far this root motion will move you without any scaling **/
	var() float RootMotionMoveDistance;

    /** This what property this root motion should look for to see if the .ini are wanting some max value which may be higher/lower than what the root motion will gives us **/
	var() name PropertyNameToCompareTo;

	structdefaultproperties
	{
		RootBoneOption[0]=RBA_Default
		RootBoneOption[1]=RBA_Default
		RootBoneOption[2]=RBA_Default
		RootMotionMode=RMM_Ignore
	}
};
var() array<LocomotionSequenceOptionInfo> LocomotionOptions;
var() transient int	ActiveOptionIndex;

/** Prevents multiple updates in a single frame */
var transient const float LastUpdateTime;

native function bool SelectLocomotionOptionByName( Name InName );

	
	
defaultproperties
{
}