/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_SetTimeDilation extends SequenceAction;

/** New time dilation to set globally */
var() float GlobalTimeDilation;
/** New time dilation to set on target */
var() float TargetTimeDilation;

event Activated()
{
	Super.Activated();
	GetWorldInfo().TimeDilation = GlobalTimeDilation;
}

defaultproperties
{
	ObjName="Set Time Dilation"
	ObjCategory="Gear"

	GlobalTimeDilation=1.0f
	TargetTimeDilation=1.0f
}
