/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_BuildFortification extends SequenceAction;

/** player that should be considered the builder of the fortification */
var Object Builder;
/** upgrade level to build (zero based) */
var() int UpgradeLevel;

defaultproperties
{
	ObjName="Build Fortification"
	ObjCategory="Gear"
	VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Builder",PropertyName=Builder)
}
