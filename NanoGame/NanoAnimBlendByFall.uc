/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAnimBlendByFall extends NanoAnimBlendList
	native(Anim);

enum EBlendFallTypes
{
	FBT_Up,
	FBT_Down,
	FBT_Arc,
	FBT_PreLand,
	FBT_Land,
	FBT_None
};

struct native FallAnimSet
{
	var() Name	SetName;

	var() Name	UpAnim;
	var() Name	DownAnim;
	var() Name	LongDownAnim;
	var() Name  ArcAnim;
	var() Name	PreLandAnim;
	var() Name	LandAnim;
	var() Name	HardLandAnim;
	var() Name	LongLandAnim;
	var() float	LandBlendDelay;
	var() bool	bSetLandBlendDelayFromAnim;
	var() bool	bLoopDownAnim;
	var() float TimeTilLongDownAnim;
	var() float VelocityForArcAnim;
};
var()	array<FallAnimSet>	Sets;
var		int					ActiveSetIndex;
var()	int					DebugActiveSetIndex;

/** The current state this node believes the pawn to be in */
var const EBlendFallTypes 	FallState;

/** Set to reset the jump cycle on the next frame */
var	transient bool bResetFall;

/** Currently transitioned to LongDownAnim? */
var protected transient bool bUsingLongFall;

var transient Name LandOverrideAnim;

cpptext
{
	virtual void InitAnim( USkeletalMeshComponent* meshComp, UAnimNodeBlendBase* Parent );
	virtual	void TickAnim(FLOAT DeltaSeconds);
	virtual void SetActiveChild( INT ChildIndex, FLOAT BlendTime );
	virtual void OnChildAnimEnd(UAnimNodeSequence* Child, FLOAT PlayedTime, FLOAT ExcessTime);
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);
	virtual void RenameChildConnectors();

	virtual void CopyAnimsFromSetByIndex( INT SetIndex );
	virtual void OnCeaseRelevant();
}

native function ChangeFallState(EBlendFallTypes NewState);
native function CopyAnimsFromSetByName( Name NewSetName );

defaultproperties
{
	FallState=FBT_None
	
	Children(0)=(Name="Up",Weight=1.0)
	Children(1)=(Name="Down")
	Children(2)=(Name="Arc")
	Children(3)=(Name="Pre-Land")
	Children(4)=(Name="Land")
	bFixNumChildren=true

	Sets(0)=(SetName=Default)
	ActiveSetIndex=-1
}
