/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTSequenceNode extends OLBTCompositeNode
	native(AI);

defaultproperties
{
	TaskType=class'OLBTSequenceTask'

	Children(0)=(Name="Child 1")
	Children(1)=(Name="Child 2")
	bFixNumChildren=false
}
