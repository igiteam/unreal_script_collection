/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTPlayAkEventNode extends OLBTNode
	native(AI);

var() AkEvent Event;

defaultproperties
{
	TaskType=class'OLBTPlayAkEventTask'
}
