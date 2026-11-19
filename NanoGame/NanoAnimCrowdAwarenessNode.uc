/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAnimCrowdAwarenessNode extends NanoAnimBlendList
	native(Anim);
	
cpptext
{
	/** 
	 * We override this function to force "load" / init all of the children anims that this node uses.  
	 * The code to determine which anim to play occurs and then the anim is chosen to play.  But it was never init'd.
	 * So to get around that, we just init them all at the start.
	 **/
	virtual void CallDeferredInitAnim();

	virtual UBOOL ShouldCheckForAwarness( ANanoPawn* NP );
	virtual void TickAnim(FLOAT DeltaSeconds);
	virtual void OnChildAnimEnd(UAnimNodeSequence* Child, FLOAT PlayedTime, FLOAT ExcessTime);
	virtual void SetActiveChild( INT ChildIndex, FLOAT BlendTime );

	FLOAT GetPrepPlayRate( UAnimNodeSequence* PrepSeq, FLOAT VelSize, FLOAT DistFromImpact, FLOAT VelDotAgent );

	inline INT GetActiveChildId() { return (ActiveChildIndex-ActiveBaseChildIndex); }
}

var()	float			MinVelDotAgent;

/** Max distance the crowd agent can be for this node to considered it. */
var() float MaxDistForInteractionToOccur;

/** Any agents that are further away than this distance on the Z axis will not be considered by this node **/
var() float HeightDifferenceToIgnoreInteractionWith;


var		transient byte			ActiveBaseChildIndex;
/** Agent we are currently responding to */
var	transient GameCrowdAgent	ActiveAgent;

defaultproperties
{
	Children(0)=(Name="Source")
	Children(1)=(Name="Left Prepare")
	Children(2)=(Name="Left Impact")
	Children(3)=(Name="Right Prepare")
	Children(4)=(Name="Right Impact")

	bFixNumChildren=TRUE


	MinVelDotAgent=0.8f
	MaxDistForInteractionToOccur=150
	HeightDifferenceToIgnoreInteractionWith=100
} 
