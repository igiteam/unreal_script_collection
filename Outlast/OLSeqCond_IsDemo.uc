/**
 * Copyright 2012 Red Barrels Inc. All Rights Reserved.
 */
class OLSeqCond_IsDemo extends SequenceCondition
	native(Sequence);

var bool bResult;

cpptext
{
	void Activated();
};

defaultproperties
{
	ObjName="Is Demo?"
	ObjCategory="Outlast"

	InputLinks(0)=(LinkDesc="In")
	OutputLinks(0)=(LinkDesc="Normal")
	OutputLinks(1)=(LinkDesc="Demo")	
}