/**
 * Copyright 2012 Red Barrels Inc. All Rights Reserved.
 */
class OLSeqAct_AIInvestigatePoint extends SequenceAction;

var() Actor Point;
var() bool bStartChasing;

defaultproperties
{
	ObjName="Investigate Point"
	ObjCategory="AI"

	VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Point",PropertyName=Point)
}
