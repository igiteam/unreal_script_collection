/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_ReaverJumpOff extends SequenceAction;

/** Jump velocity for the pawn. Ignored if a Landing Point is given */
var() vector JumpVelocity;
/** If true, JumpVelocity should be relative to Reaver rotation */
var() bool bRelativeVelocity;
/** Pawn that dismounted */
var GearPawn DismountingPawn;
/** Location that pawn should try to land */
var Actor LandingPoint;

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}

defaultproperties
{
	ObjName="Jump Off Reaver"
	ObjCategory="Gear"

	VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Dismounting Pawn",bWriteable=true,PropertyName=DismountingPawn)
	VariableLinks(2)=(ExpectedType=class'SeqVar_Object',LinkDesc="Landing Point",PropertyName=LandingPoint)

	bRelativeVelocity=true
}