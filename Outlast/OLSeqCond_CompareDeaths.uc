/**
 * Copyright 2012 Red Barrels Inc. All Rights Reserved.
 */
class OLSeqCond_CompareDeaths extends SequenceCondition
	native(Sequence);

cpptext
{
	void Activated();
}

var() int Value;

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

defaultproperties
{
	ObjName="Compare Deaths"
	ObjCategory="Outlast"

	InputLinks(0)=(LinkDesc="In")
	OutputLinks(0)=(LinkDesc="Deaths <= Value")
	OutputLinks(1)=(LinkDesc="Deaths > Value")
	OutputLinks(2)=(LinkDesc="Deaths == Value")
	OutputLinks(3)=(LinkDesc="Deaths < Value")
	OutputLinks(4)=(LinkDesc="Deaths >= Value")

	VariableLinks(0)=(ExpectedType=class'SeqVar_Int',LinkDesc="Value",PropertyName=Value)
}