/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTStopPatrolNode extends OLBTNode
	native(AI);

var() bool bAbort;

defaultproperties
{
	TaskType=class'OLBTStopPatrolTask'
}