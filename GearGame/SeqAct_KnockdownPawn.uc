/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_KnockdownPawn extends SequenceAction;

var() float LinearVelocityScale;
var() float AngularVelocityScale;
var() bool bStayKnockedDown;

defaultproperties
{
	ObjName="Knockdown Pawn"
	ObjCategory="Physics"

	InputLinks(0)=(LinkDesc="Knockdown")
	InputLinks(1)=(LinkDesc="Recover")

	LinearVelocityScale=1.f
	AngularVelocityScale=1.f
}
