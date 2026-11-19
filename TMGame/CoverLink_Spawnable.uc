
/* 
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */
class CoverLink_Spawnable extends CoverLink_Dynamic;

event Destroyed()
{
	local int SlotIdx;
	// destroy any slot markers
	for (SlotIdx = 0; SlotIdx < Slots.Length; SlotIdx++)
	{
		if (Slots[SlotIdx].SlotMarker != None)
		{
			Slots[SlotIdx].SlotMarker.Destroy();
		}
	}
}

