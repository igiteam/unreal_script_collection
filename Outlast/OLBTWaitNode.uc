/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTWaitNode extends OLBTNode
	native(AI);

var() float WaitTime;

defaultproperties
{
	TaskType=class'OLBTWaitTask'

	WaitTime=1.f
}
