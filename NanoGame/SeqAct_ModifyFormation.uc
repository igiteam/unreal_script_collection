/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_ModifyFormation extends SequenceAction;

var() int DesiredRowSize;
var() bool bForceShields;
var() bool bAllowCombat;
var() float RowSpacing;
var() float ColSpacing;

defaultproperties
{
	ObjName="Modify Formation"
	ObjCategory="Nano"
	RowSpacing=256
	ColSpacing=256
}
