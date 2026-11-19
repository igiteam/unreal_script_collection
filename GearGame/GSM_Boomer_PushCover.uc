
/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class GSM_Boomer_PushCover extends GSM_PushCover
	config(Pawn);

/**
* Returns true if the PawnOwner is taking cover on a movable object
*/
protected function bool InternalCanDoSpecialMove()
{
	return( GetMovableInterpActor() != None );
}

protected function InterpActor_MovableCover GetMovableInterpActor()
{
	local GearAI_Boomer BoomerAI;
	BoomerAI = (PawnOwner != None) ? GearAI_Boomer(PawnOwner.Controller) : None;
	return (BoomerAI != None) ? InterpActor_MovableCover(BoomerAI.MovableCoverToPush) : None;
}

defaultproperties
{
	BS_ManipulateCover=(Stance=((Slot=BS_FullBody,AnimName="FL_Cov_Walk_Fwd")))		/// AR_Charge_Boomer?

	Action={(
		ActionName=PushObject,
		IconAnimationSpeed=0.0f,
		ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=330,V=314,UL=45,VL=32),
										  (Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=376,V=314,UL=45,VL=32))),
							(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=75,V=432,UL=85,VL=63)))	),
		)}
}
