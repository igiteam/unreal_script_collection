
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_Wretch_ChainsawVictim extends GSM_ChainsawVictim;

var BodyStance BS_ReactAnim;
function bool SetChainsawAnims(GearPawn GP, out GSM_ChainsawAttack.HeightAnims Anims, float BlendTime, EChainsawAnimType AnimType)
{
	PawnOwner.BS_Play(BS_ReactAnim,1.f,0.f,0.1f,TRUE);
	return false; 
}
defaultproperties
{
	BS_ReactAnim=(Stance=((Slot=BS_FullBody,AnimName="Chainsaw_Death")))
}