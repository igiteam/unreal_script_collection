/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTGetNextInvestigationPointNode extends OLBTCompositeNode
	native(AI);

defaultproperties
{
	TaskType=class'OLBTGetNextInvestigationPointTask'

	Children(0)=(Name="Normal")
	Children(1)=(Name="Locker")
	Children(2)=(Name="Bed")
	bFixNumChildren=true
}
