
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_CorpserLarva_DanceOutro extends GSM_BasePlaySingleAnim;

/**
 * Can this special move override InMove if it is currently playing?
 */
function bool CanOverrideSpecialMove(ESpecialMove InMove)
{
	return InMove == GSM_CorpserLarva_DanceIntro;
}

defaultproperties
{
	BS_Animation=(Stance=((Slot=BS_FullBody,AnimName="hit_react_outro")))
	BlendOutTime=0.33f

	bLockPawnRotation=TRUE
	bDisableMovement=TRUE
	
	DefaultAICommand=class'AICmd_Base_PushedBySpecialMove'
	bDisableAI=TRUE
}
