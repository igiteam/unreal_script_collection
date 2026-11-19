/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTOptionalNode extends OLBTCompositeNode
	native(AI);

defaultproperties
{
	TaskType=class'OLBTOptionalTask'

	Children(0)=(Name="Child 1")
	Children(1)=(Name="Child 2")
	bFixNumChildren=false
}