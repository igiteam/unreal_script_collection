/**
 * Frustrated scream AI command for the Armored Kantus
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class AICmd_Kantus_FrustratedScream extends AICmd_Attack_KantusKnockDownScream
	within GearAI_Kantus;

state Command_SpecialMove
{
	/**
	 * Make the Kantus do the frustrated scream special move
	 * 
	 * @return the special move to perform
	 */
	function ESpecialMove GetSpecialMove()
	{
		return GSM_Kantus_FrustratedScream;
	}
}
