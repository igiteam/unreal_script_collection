/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTRepeatNode extends OLBTCompositeNode
	native(AI);

var() int NumRepetitions;

defaultproperties
{
	TaskType=class'OLBTRepeatTask'

	Children(0)=(Name="Child")
	bFixNumChildren=true

	NumRepetitions=1
}
