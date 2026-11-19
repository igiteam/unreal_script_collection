/**
 * Copyright 2012 Red Barrels Inc. All Rights Reserved.
 */
class OLSeqCond_DetailMode extends SequenceCondition
	native(Sequence);

var bool bResult;

cpptext
{
	void Activated();
};

defaultproperties
{
	ObjName="Detail Mode"
	ObjCategory="Outlast"

	InputLinks(0)=(LinkDesc="In")
	OutputLinks(0)=(LinkDesc="Low")
	OutputLinks(1)=(LinkDesc="Medium")
	OutputLinks(2)=(LinkDesc="High")	
}