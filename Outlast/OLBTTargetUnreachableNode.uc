/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTTargetUnreachableNode extends OLBTPlayAnimNode
	native(AI);

var() float IgnoreTime;

defaultproperties
{
	TaskType=class'OLBTTargetUnreachableTask'
}
