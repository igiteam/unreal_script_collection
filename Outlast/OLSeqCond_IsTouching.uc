/**
 * Copyright 2012 Red Barrels Inc. All Rights Reserved.
 */
class OLSeqCond_IsTouching extends SequenceCondition
	native(Sequence);

/** Result of comparison is written to this variable */
var bool bResult;

cpptext
{
	void Activated();
};

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

defaultproperties
{
	ObjName="Is Touching"
	ObjCategory="Outlast"

	InputLinks(0)=(LinkDesc="In")
	OutputLinks(0)=(LinkDesc="True")
	OutputLinks(1)=(LinkDesc="False")

	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Actor 1",bWriteable=false,MinVars=1,MaxVars=1)
	VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Actor 2",bWriteable=false,MinVars=1,MaxVars=1)
	VariableLinks(2)=(ExpectedType=class'SeqVar_Bool',LinkDesc="Result",bWriteable=true,PropertyName=bResult)
}