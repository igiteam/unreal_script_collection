
/**
 * Activated when a Trigger_SilverbackKickInteraction is used.
 * Originator: the usable actor that was used
 * Instigator: The pawn associated with the player did the using
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class SeqEvt_SilverbackKicked extends SeqEvt_DoorOpen;

simulated function bool CanDoInteraction(GearPC PC)
{
	return (PC.MyGearPawn != None && PC.MyGearPawn.IsA('GearPawn_SilverbackBase') && Super.CanDoInteraction(PC) );
}

defaultproperties
{
	ObjName="SilverbackKicked"

	// support being pushed open or kicked
	OutputLinks(0)=(LinkDesc="Kicked")

	InteractAction={(
				ActionName=DoorOpen,
				ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.HUD.HUD_ActionIcons2',U=83,V=0,UL=45,VL=32))), // b button
									(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=287,V=140,UL=91,VL=98)))	),
				)}
}
