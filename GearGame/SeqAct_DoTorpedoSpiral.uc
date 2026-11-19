/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_DoTorpedoSpiral extends SequenceAction;

/** Maximum offset to deviate from matinee path */
var() Vector2D MaxOffsetRange;
/** Speed at which to deviate from matinee path */
var() float OffsetSpeed;
/** Speed at which to rotate about the matinee path */
var() Vector2D RotSpeedRange;

defaultproperties
{
	ObjName="Torpedo Spiral"
	ObjCategory="Gear"

	MaxOffsetRange=(X=100.f, Y=400.f)
	OffsetSpeed=0.2f
	RotSpeedRange=(X=10000, Y=50000)

	InputLinks(0)=(LinkDesc="Start")
	InputLinks(1)=(LinkDesc="Stop")
}
