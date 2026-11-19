
/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class GSM_PushCover extends GSM_ManipulateCover
	config(Pawn);

/**
* Returns true if the PawnOwner is taking cover on a movable object
*/
protected function bool InternalCanDoSpecialMove()
{
	local InterpActor_MovableCover InterpActMoveCover;
	
	// Early out if this cover is no longer pushable
	InterpActMoveCover = GetMovableInterpActor();
	if (InterpActMoveCover != None && !InterpActMoveCover.bIsMovable)
	{
		return false;
	}

	return( PawnOwner.IsInCover() && CoverLink_Movable(PawnOwner.CurrentLink) != None && CoverLink_Movable(PawnOwner.CurrentLink).bAllowPush );
}

defaultproperties
{
	BS_ManipulateCover=(Stance=((Slot=BS_FullBody,AnimName="AR_Cov_Mid_Push")))

	Action={(
		ActionName=PushObject,
		IconAnimationSpeed=0.0f,
		ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=330,V=314,UL=45,VL=32),
										  (Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=376,V=314,UL=45,VL=32))),
							(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=75,V=432,UL=85,VL=63)))	),
		)}
}
