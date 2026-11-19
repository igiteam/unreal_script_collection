/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTAttackNode extends OLBTNode
	dependson(OLBot)
	native(AI);

var() AIAttackType Type;

defaultproperties
{
	TaskType=class'OLBTAttackTask'
}
