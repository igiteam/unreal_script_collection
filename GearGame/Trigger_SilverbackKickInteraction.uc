
/**
* A trigger that streamlines the door interaction process.
* Touching and Untouching this trigger will allow code to handle the input
* and animation work needed to open the door.
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/

class Trigger_SilverbackKickInteraction extends Trigger_DoorInteraction
	placeable;

defaultproperties
{
	SupportedEvents.Add(class'SeqEvt_SilverbackKicked')
	SupportedEvents.Remove(class'SeqEvt_DoorOpen')

	TimeForDoorOpen=0.5f
}
