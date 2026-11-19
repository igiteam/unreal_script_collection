/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTDebugLogNode extends OLBTNode
	native(AI);

var() string DebugString;
var() EStatus DebugReturnValue;

defaultproperties
{
	TaskType=class'OLBTDebugLogTask'
	DebugReturnValue=Status_Success
}