/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_Trooper_IdleBreak_StandBy extends NSM_Trooper_IdleBreak;

defaultproperties
{
	WaitingToAttackAnimList.Add( "Interact_A" )
	WaitingToAttackAnimList.Add( "Baton_Idle_Ready_B" )  	// adding in list more than once to increase chance of playing
}
