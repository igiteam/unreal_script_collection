
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_LadderClimbUp extends GSM_LadderClimbDown;

simulated function GetLadderEntryPoint(out Vector Out_EntryLoc, out Rotator Out_EntryRot)
{
	PawnOwner.LadderTrigger.GetBottomEntryPoint(Out_EntryLoc, Out_EntryRot);
}

simulated function bool IsRightLadderTrigger()
{
	return !PawnOwner.LadderTrigger.IsTopOfLadder();
}

simulated function CheckOverrideAnim()
{
	local name NameChosen;
	if( LadderTrigger.ClimbUpAnim != '')
	{
		LadderTrigger.ClimbUpAnims.AddItem(LadderTrigger.ClimbUpAnim);
		LadderTrigger.ClimbUpAnim = '';
	}

	if( LadderTrigger.ClimbUpAnims.length > 0 )
	{
		NameChosen = LadderTrigger.ClimbUpAnims[rand(LadderTrigger.ClimbUpAnims.length)];
	}
	else
	{
		NameChosen = default.BS_Animation.Stance[0].AnimName;
	}
	BS_Animation.Stance[0].AnimName = NameChosen;
}

defaultproperties
{
	BS_Animation=(Stance=((Slot=BS_FullBody,AnimName="AR_Ladder_Up")))

	Action={(
	ActionName=ClimbUp,
	ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=330,V=314,UL=45,VL=32))), // X Button
						(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=170,V=379,UL=64,VL=94)))	),
	)}

	LadderCameraBoneAnims(0)=(AnimName="Camera_Ladder_Up")
}
