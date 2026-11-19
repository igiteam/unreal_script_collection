/**
 * Copyright 2012 Red Barrels Inc. All Rights Reserved.
 */
class OLSeqCond_PlayerSpeed extends SequenceCondition
	native(Sequence);

var() float MaxSpeedForIdle;
var() float MaxSpeedForWalk;
var() float MaxSpeedForRun;

var() float SpecificThreshold;

var bool bResult;

cpptext
{
	void Activated();
};

defaultproperties
{
	ObjName="PlayerSpeed"
	ObjCategory="Outlast"

	SpecificThreshold=-1
	MaxSpeedForIdle=5.0
	MaxSpeedForWalk=225
	MaxSpeedForRun=400

	InputLinks(0)=(LinkDesc="In")
	OutputLinks(0)=(LinkDesc="Idle")
	OutputLinks(1)=(LinkDesc="Walk")
	OutputLinks(2)=(LinkDesc="Run")	
	OutputLinks(3)=(LinkDesc="Sprint")	
	OutputLinks(4)=(LinkDesc="Below Threshold")	
	OutputLinks(5)=(LinkDesc="Above Threshold")	
	VariableLinks.Empty
}