/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */


class SeqEvt_ButtonPush extends SeqEvt_Interaction;

/** use "hand" interact icon instead of the default "button" icon */
var() bool bUseHandIcon;
/** info for that icon */
var ActionInfo HandInteractAction;

simulated event RegisterEvent()
{
	if (bUseHandIcon)
	{
		InteractAction = HandInteractAction;
	}
}

defaultproperties
{
	ObjName="Button Pushed"

	OutputLinks(0)=(LinkDesc="Pushed")

	InteractAction={(
			ActionName=ButtonPush,
	    ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=330,V=314,UL=45,VL=32))), // x button
								(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=360,V=0,UL=58,VL=55))),
								(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=343,V=437,UL=44,VL=59))) ),
			)}
	HandInteractAction={(
			ActionName=DiscoverIcon,
			ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=330,V=314,UL=45,VL=32))), // X Button
								(ActionIcons=((Texture=Texture2D'Warfare_HUD.HUD_InteractXhair',U=0,V=0,UL=32,VL=32)))	),
			)}
}
