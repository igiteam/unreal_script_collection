/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAnimObstacleAwarenessNode extends NanoAnimBlendList
	native(Anim);
	
cpptext
{
	virtual UBOOL ShouldCheckForAwarness( ANanoPawn* NP );

	virtual void TickAnim(FLOAT DeltaSeconds);
	virtual void OnChildAnimEnd(UAnimNodeSequence* Child, FLOAT PlayedTime, FLOAT ExcessTime);
	virtual void SetActiveChild( INT ChildIndex, FLOAT BlendTime );
	void AbortContact();

	UBOOL IsWallWithinRange( ANanoPawn* NP, FCheckResult& Hit, FVector& StartTrace, FVector& TraceDir, INT CheckBaseChildIndex, UAnimNodeSequence** PrepSeqPtr, FLOAT& out_DistFromImpact );
	FLOAT GetPrepPlayRate( UAnimNodeSequence* PrepSeq, FLOAT VelSize, FLOAT DistFromImpact, FLOAT VelDotRot );

	inline INT GetActiveChildId() { return (ActiveChildIndex-ActiveBaseChildIndex); }
}

var()	float	MinRotDotNormal;
var()	float	SlowVelSize;
var		byte	ActiveBaseChildIndex;	

defaultproperties
{
	Children(0)=(Name="Source")
	Children(1)=(Name="Fwd Fast Prepare")
	Children(2)=(Name="Fwd Fast Impact")
	Children(3)=(Name="Fwd Fast Idle")
	Children(4)=(Name="Fwd Slow Prepare")
	Children(5)=(Name="Fwd Slow Impact")
	Children(6)=(Name="Fwd Slow Idle")
	Children(7)=(Name="Right Prepare")
	Children(8)=(Name="Right Impact")
	Children(9)=(Name="Right Idle")
	Children(10)=(Name="Left Prepare")
	Children(11)=(Name="Left Impact")
	Children(12)=(Name="Left Idle")

	bFixNumChildren=TRUE
} 