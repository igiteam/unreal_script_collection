/**
* Activated when a Trigger_DoorInteraction is used.
* Originator: the usable actor that was used
* Instigator: The pawn associated with the player did the using
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class SeqEvt_DoorOpen extends SeqEvt_Interaction;

/** use "open" interact icon instead of the default "kick" icon */
var() bool bUseOpenIcon;
/** info for that icon */
var ActionInfo OpenInteractAction;

/** Whether DisabledGUDEvent should be triggered if a player uses the door trigger while we're disabled */
var() bool bPlayDisabledGUD;
/** The GUD to play when a player uses the engage trigger and we're disabled */
var() EGUDEventID DisabledGUDEvent;

simulated event RegisterEvent()
{
	if (bUseOpenIcon)
	{
		InteractAction = OpenInteractAction;
	}
}

simulated function bool CanDoInteraction(GearPC PC)
{
	return (Super.CanDoInteraction(PC) &&
			PC.MyGearPawn.DoorTrigger != None &&
			PC.MyGearPawn.bInsideDoorTrigger &&
			(PC.Role < ROLE_Authority || CheckActivate(PC.MyGearPawn.DoorTrigger,PC.Pawn,TRUE)));
}

/**
 * Return the version number for this class.  Child classes should increment this method by calling Super then adding
 * a individual class version to the result.  When a class is first created, the number should be 0; each time one of the
 * link arrays is modified (VariableLinks, OutputLinks, InputLinks, etc.), the number that is added to the result of
 * Super.GetObjClassVersion() should be incremented by 1.
 *
 * @return	the version number for this specific class.
 */
static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

defaultproperties
{
	ObjName="DoorOpen"

	// support being pushed open or kicked
	OutputLinks(0)=(LinkDesc="Kicked")

	bPlayDisabledGUD=FALSE
	DisabledGUDEvent=GUDEvent_CoopDoorDisabled

	InteractAction={(
				ActionName=DoorOpen,
				ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=330,V=314,UL=45,VL=32))), // A Button
									(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=287,V=140,UL=91,VL=98)))	),
				)}
	OpenInteractAction={(
				ActionName=DoorOpen,
				ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=330,V=314,UL=45,VL=32))), // A Button
									(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=215,V=141,UL=71,VL=97)))	),
				)}
}
