/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_AIAssignDefensePoint extends SequenceAction;

var() array<Actor> DefensePoints;

defaultproperties
{
	ObjName="Assign Defense Point"
	ObjCategory="AI"

	VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Defense Points",PropertyName=DefensePoints)
}
