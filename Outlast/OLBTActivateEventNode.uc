/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTActivateEventNode extends OLBTNode
	native(AI);

var() name EventName;

defaultproperties
{
	TaskType=class'OLBTActivateEventTask'
}
