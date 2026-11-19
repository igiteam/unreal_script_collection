/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTSetBehaviorStateNode extends OLBTNode
	dependson(OLBot)
	native(AI);

var() EAIBehaviorState BehaviorState;

defaultproperties
{
	TaskType=class'OLBTSetBehaviorStateTask'

	BehaviorState=AIBS_Idle
}