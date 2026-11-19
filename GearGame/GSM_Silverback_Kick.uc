/**
 * Play the Silverback kick animation
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Silverback_Kick extends GSM_BasePlaySingleAnim;

defaultproperties
{
	BS_Animation=(Stance=((Slot=BS_FullBody,AnimName="SB_Kick")))

	BlendOutTime=0.33f

	bLockPawnRotation=TRUE
	bDisableMovement=TRUE
	
	DefaultAICommand=class'AICmd_Base_PushedBySpecialMove'
	bDisableAI=TRUE
}
